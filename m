Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF14157469
	for <mm-commits@vger.kernel.org>; Mon, 16 Dec 2024 05:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734328336; cv=none; b=LPwldJqqrJIPSmj4cdVmsZeDf3lu9t2OK27hFla7gSy2d9VBK1kzWwGcx3TwxQgPkj5nxd4TjYP4ASJKuASenm1O/h7pvqAbSj3o33t5u65lDBsYEXzoY6bpET2cOir8ohSCDh6+ezraqMOXaVYp+EzX1OtS5k/BYl1DSD7Pxa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734328336; c=relaxed/simple;
	bh=BxeI+IUaFy6QdhD31Z/tCUP3toyuixODm3Moud41kXw=;
	h=Date:To:From:Subject:Message-Id; b=Ra2e4M333MKD6zc7Zlytypy4x+1bnUjkEHhQB2pcOUh3zTOJhOHC+m9L/Z/4mxBCVnOQbMEoOVCRbBvqJzbmUtSvJEbqsyV4dbhVRwsxE2noQFKBrcTG0dwksNza1Lo1G7Nxvqfpdx5KxKubO6rMNJEH4TKE2+XYT+6zMReW3Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Lzy8aKN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Lzy8aKN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6ECC4CED0;
	Mon, 16 Dec 2024 05:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734328334;
	bh=BxeI+IUaFy6QdhD31Z/tCUP3toyuixODm3Moud41kXw=;
	h=Date:To:From:Subject:From;
	b=Lzy8aKN5RSWjyINf4wl/KI9ZPESbnrLdS5RBR2N4vQf5qP4Th46ynf7jjFwAzVd0N
	 +XgTcRyaCUHSZMMaDgDPPob7ghZcbXRtzlShmz//34xqkPr0eyCJ6z+PYzx7zGrlYT
	 ZOaCw1L8UyTv9YCRyWAHmU8pJe3vYdWeY5mjmpW4=
Date: Sun, 15 Dec 2024 21:52:14 -0800
To: mm-commits@vger.kernel.org,leocstone@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memoryc-rename-shadowed-local.patch added to mm-unstable branch
Message-Id: <20241216055214.BE6ECC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory.c: rename shadowed local
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memoryc-rename-shadowed-local.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memoryc-rename-shadowed-local.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/huge_memory.c: rename shadowed local
Date: Sun Dec 15 09:44:47 PM PST 2024

split_huge_pages_write() has a lccal `buf' which shadows incoming arg
`buf'.  Reviewer confusion resulted.  Rename the inner local to `tok_buf'.

Cc: Leo Stone <leocstone@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memoryc-rename-shadowed-local
+++ a/mm/huge_memory.c
@@ -4169,20 +4169,21 @@ static ssize_t split_huge_pages_write(st
 
 	if (input_buf[0] == '/') {
 		char *tok;
-		char *buf = input_buf;
+		char *tok_buf = input_buf;
 		char file_path[MAX_INPUT_BUF_SZ];
 		pgoff_t off_start = 0, off_end = 0;
 		size_t input_len = strlen(input_buf);
 
-		tok = strsep(&buf, ",");
-		if (tok && buf) {
+		tok = strsep(&tok_buf, ",");
+		if (tok && tok_buf) {
 			strscpy(file_path, tok);
 		} else {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		ret = sscanf(buf, "0x%lx,0x%lx,%d", &off_start, &off_end, &new_order);
+		ret = sscanf(tok_buf, "0x%lx,0x%lx,%d", &off_start,
+			    &off_end, &new_order);
 		if (ret != 2 && ret != 3) {
 			ret = -EINVAL;
 			goto out;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmscan-account-for-free-pages-to-prevent-infinite-loop-in-throttle_direct_reclaim-checkpatch-fixes.patch
mm-swap_cgroup-allocate-swap_cgroup-map-using-vcalloc-fix.patch
mm-page_alloc-add-some-detailed-comments-in-can_steal_fallback-fix.patch
mm-introduce-mmap_lock_speculate_try_beginretry-fix.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-damon-tests-vaddr-kunith-reduce-stack-consumption-fix.patch
mm-remove-an-avoidable-load-of-page-refcount-in-page_ref_add_unless-fix.patch
mm-fix-outdated-incorrect-code-comments-for-handle_mm_fault-fix.patch
mm-huge_memoryc-rename-shadowed-local.patch
xarray-port-tests-to-kunit-fix.patch
fault-inject-use-prandom-where-cryptographically-secure-randomness-is-not-needed-fix.patch

