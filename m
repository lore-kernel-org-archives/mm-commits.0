Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA79457E6A;
	Thu, 10 Sep 2026 21:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789075461; cv=none; b=eJjNpJk5lvoffKuGP6xL71ys0UmsUnv7iG1qruPY7llwkG2VPi61dkNZj15HXgnkIwkd4+BlpciiVh7LnoD6kjxMfBb5Pm/pX3BflOQyl4XjXq+9Ux837836HRBKGdw70gz8mcC+J4xi5Dctbo995qsnggGVkZvOAzI283nUf3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789075461; c=relaxed/simple;
	bh=JWwyaCO3impz3Lhe0zofb9RKkTcW+T/L08aqxYiU35Q=;
	h=Date:To:From:Subject:Message-Id; b=NDU+RXuVs6vcLB42lEneVqnMoeLN4udv9oH2I8Vuf2d3m4zgujUFF4Be1FtxHHVzV3MrvsaY+qbkVWN5WwvMMM7JxlZjjlf7V7mJwj98nfVQ/hMr8NmyvV9k987NLfHUABQ0/SVJ4T78MlRRr1VNv2ONCjxMW1mIq22fMhsOxkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y0lYCw0F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y0lYCw0F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A85C1F000FF;
	Thu, 10 Sep 2026 21:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789075459;
	bh=wyu4j9y0oPoQsMVbX23BIzou+1Cjbbpn/wEkmaIEtiU=;
	h=Date:To:From:Subject;
	b=Y0lYCw0FQoziOcI8D3NYLhOL9/6MlHhRnp5D+k83ap8s0cRgJInSmOD9SafDKZuGU
	 ZtFPm8l/lLnV+71gJxhBcICTC9pdDKl/6TY8+HjhMt0boqbGCQo0910tA2etWMp7zU
	 3VgG9aL3BDnvez/98H5YqYQVeA2Fa/Q/pzLxGU0Q=
Date: Thu, 10 Sep 2026 14:24:19 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sashiko-bot@kernel.org,ekffu200098@gmail.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] tools-bootconfig-fix-integer-overflow-in-size-check.patch removed from -mm tree
Message-Id: <20260910212419.7A85C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/bootconfig: fix integer overflow in size check
has been removed from the -mm tree.  Its filename was
     tools-bootconfig-fix-integer-overflow-in-size-check.patch

This patch was dropped because an updated version will be issued

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

bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch
tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks.patch
bootconfig-fix-integer-overflow-in-initrd-size-check.patch

