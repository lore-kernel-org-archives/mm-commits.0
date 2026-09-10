Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F6C35F61A;
	Thu, 10 Sep 2026 04:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789014560; cv=none; b=AkEQcW1JeybV546/3fyojh0DMX8OtgeQQNUmDWU+0IQc5WzMcWSPZYLQj774e4dS8Y4lis3dPBZ+P750KWyQiLRM3sycBhXnRDM2du8JLqdv5wfMxnarpFOVUWI1g7JqumANfMnjLuKGHTNhnHat6ebZlaxdbYWjxzrwr3pQOcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789014560; c=relaxed/simple;
	bh=2+vOIt0yytESDJL4Blra6TLioW4IIj065XSruAn10/U=;
	h=Date:To:From:Subject:Message-Id; b=dN7Q0H2o3quqD1pnyK/Wf4Yh00hDi/skvmYc3owWloBUCZkDXAjlE2fe2qbs7F5uYD7/wFOG7I4kP110dc7vAkF9x1OuEax4IEUMiqfGYa7vuYTfqfI1bsxFx9j2+yozR0N88F/9pM9QTNEINVr+TWbKJtqcl0q0g4uyPudSAhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GrOJTzuU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GrOJTzuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074C11F000FF;
	Thu, 10 Sep 2026 04:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789014559;
	bh=NdvPYhzgore/aAiFI1Lu7mW61IY2e3Qg3ai2tHIziT8=;
	h=Date:To:From:Subject;
	b=GrOJTzuU2ZutYxWpgGjvJwJ1wMjSHny5n+HYoDXg2rxRFZc5kv0N8hW0Bha9V8Y88
	 3pRkBq1mJ9s8bn2SR3MdcHCrMmk8v91QN1eVYaPiLQoGS2Ok9yErkmct8gMDxcHUKt
	 6YwrvtBT6XYQX+kA37kCbtewENYQk35qpbxArUho=
Date: Wed, 09 Sep 2026 21:29:18 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-bootconfig-fix-integer-overflow-in-size-check.patch added to mm-hotfixes-unstable branch
Message-Id: <20260910042919.074C11F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/bootconfig: Fix integer overflow in size check
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
Subject: tools/bootconfig: Fix integer overflow in size check
Date: Thu, 10 Sep 2026 09:30:46 +0900

Sashiko reported that on 32-bit systems, if the size in the bootconfig
footer is corrupted such that adding BOOTCONFIG_FOOTER_SIZE wraps around
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

Link: https://lore.kernel.org/178900024679.183840.10345859264677533824.stgit@devnote2
Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260909161113.16C691F00A3A@smtp.kernel.org/
Assisted-by: Antigravity:gemini-3.8-flash
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/bootconfig/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/bootconfig/main.c~tools-bootconfig-fix-integer-overflow-in-size-check
+++ a/tools/bootconfig/main.c
@@ -218,7 +218,7 @@ static int load_xbc_from_initrd(int fd,
 	csum = le32toh(csum);
 
 	/* Wrong size error  */
-	if (stat.st_size < size + BOOTCONFIG_FOOTER_SIZE) {
+	if (size > stat.st_size - BOOTCONFIG_FOOTER_SIZE) {
 		pr_err("bootconfig size is too big\n");
 		return -E2BIG;
 	}
_

Patches currently in -mm which might be from mhiramat@kernel.org are

tools-bootconfig-fix-integer-overflow-in-size-check.patch
bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch

