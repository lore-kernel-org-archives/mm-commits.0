Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF21B67E;
	Thu, 10 Sep 2026 04:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789014664; cv=none; b=mmOlHLIxa66s/VRLRIbadQ9sisF6IZS0WE+D196Doxgc+WPrpFAiJ2D/WsTMHe8LbkE6rR5+Ys3/IB7nxIwfz07NmMf7lcfsQZUFsSQdFzrWBZfKJ3rZ0h+o5pyY2y2NJXG+7yjwKQDt5XvqzlfI7Q2+MNfLeYXORMgZIJVb/Qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789014664; c=relaxed/simple;
	bh=+IUlUhVPbB5bPdIENI1IaA+JanQ2ScGHwuytGpo+VFM=;
	h=Date:To:From:Subject:Message-Id; b=kksRhAG2QNM3peALusHeVCOlaJh2yiz3Ed/UCafjzm02Xj2mxxTKyFFVd0lEQLp9YesoknocJUlxizpcFciud/FAGgaB4/y7QjNFGEyYysk00umM4FPXKIiYHIwIzVvbUgHnVX2nIspeVLmV7Wn1jv2aIxyT8S0URDTLSOcWHUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u9u2lciA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u9u2lciA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282071F000FF;
	Thu, 10 Sep 2026 04:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789014662;
	bh=kgrqbjQyH2hL3LG2nigl2x7ld4aEkyLE/SbZwgV2F5E=;
	h=Date:To:From:Subject;
	b=u9u2lciA2+Xa8N/z1O154G3t0hISdWKIJslk6Gx/as7PB9Uvw9Sk2a5JL1skI5ij2
	 XnI6Qtke/FObYaAwPVwcKjZ0gXYsrbAVXyirmSHAaIif4oaEPnrWTgzblXKwMtWrQ6
	 FAboJ9iTsT7xnbDuBBjBN2yiM8iB6yxw0QOUxJag=
Date: Wed, 09 Sep 2026 21:31:01 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-bootconfig-fix-integer-overflow-in-size-check.patch added to mm-hotfixes-unstable branch
Message-Id: <20260910043102.282071F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/bootconfig: fix integer overflow in size check
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-bootconfig-fix-integer-overflow-in-size-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-bootconfig-fix-integer-overflow-in-size-check.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: tools/bootconfig: fix integer overflow in size check
Date: Thu, 10 Sep 2026 09:45:45 +0900

Sashiko reported that on 32-bit systems, if an attacker crafts size in the
bootconfig footer such that adding BOOTCONFIG_FOOTER_SIZE wraps around
(for instance, if size is 0xFFFFFFFF), the size check in
load_xbc_from_initrd() can be bypassed:

    if (stat.st_size < size + BOOTCONFIG_FOOTER_SIZE) {
        pr_err("bootconfig size is too big\n");
        return -E2BIG;
    }

This would lead to load_xbc_fd() being called with a negative size,
resulting in an undersized allocation, heap overflow on read, and
out-of-bounds write on the terminating null byte.

Avoid the integer overflow by checking whether size is greater than
stat.st_size - BOOTCONFIG_FOOTER_SIZE.  Since stat.st_size is already
verified to be at least BOOTCONFIG_FOOTER_SIZE earlier in the function,
this subtraction will never underflow.

Also reject size > XBC_DATA_MAX upfront in load_xbc_from_initrd() to avoid
allocating and reading oversized configurations into memory before
xbc_init() validation.

Link: https://lore.kernel.org/178900114498.187028.9558747732041210116.stgit@devnote2
Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260909161113.16C691F00A3A@smtp.kernel.org/
Assisted-by: Antigravity:gemini-3.8-flash
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/bootconfig/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/bootconfig/main.c~tools-bootconfig-fix-integer-overflow-in-size-check
+++ a/tools/bootconfig/main.c
@@ -218,7 +218,8 @@ static int load_xbc_from_initrd(int fd,
 	csum = le32toh(csum);
 
 	/* Wrong size error  */
-	if (stat.st_size < size + BOOTCONFIG_FOOTER_SIZE) {
+	if (size > XBC_DATA_MAX ||
+	    size > stat.st_size - BOOTCONFIG_FOOTER_SIZE) {
 		pr_err("bootconfig size is too big\n");
 		return -E2BIG;
 	}
_

Patches currently in -mm which might be from mhiramat@kernel.org are

tools-bootconfig-fix-integer-overflow-in-size-check.patch
bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch

