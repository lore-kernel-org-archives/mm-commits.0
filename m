Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9755213BAF1
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 20:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745182584; cv=none; b=lkNTCB2zYGypM01Q8z5EXOW6q2hc9cyn8eJ+JK4bOzD2LsZsHDKtIP5F5C0tfd4Jz9brp33YDFijmehStNnSAo5GfpQiQ2py1OtCwd0K6pCZo2la/rU+8WASk6kwFOMUFygaBL4PjZb0PBk4zolVTd4wXUvKAR3JJDbjJq4hD4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745182584; c=relaxed/simple;
	bh=UZz4fwX55pERAAgcYU6MJLArdyI3Kya6M19114la+QA=;
	h=Date:To:From:Subject:Message-Id; b=Bs39y7djl0j7qwzjfI2y+1kDEXTPao9rxv0xhBHpj0Ql79MTe6+BQxpvCh/ChDxUSj7UqvBtZ1w609HiZ6L2jNmOHyyj1dCGuBDH0oaJ7tHyNYFTqyA1EyDr0UlhCuR5CJduA4s0yF5lsjN06DL1VrSBqC9qTzhun9H9BWOgVH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rylrk8c2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rylrk8c2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E3FC4CEE2;
	Sun, 20 Apr 2025 20:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745182584;
	bh=UZz4fwX55pERAAgcYU6MJLArdyI3Kya6M19114la+QA=;
	h=Date:To:From:Subject:From;
	b=rylrk8c2UnSSkJr6H+XJJZQqd5DEJ3AiLYqBeYnDCSdt8Q2dJSdHRrhscaFxM+NI4
	 BoiyraP8MkMl13/3IFeuMuUCx+TSLI5NWQIYaikSvjGYkED8VCiOTA78Pr5xtd6KXc
	 vEjUlvOWbebKygiHRrDRreULHwiVejZhmLeQuvAk=
Date: Sun, 20 Apr 2025 13:56:23 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,nao.horiguchi@gmail.com,lrh2000@pku.edu.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_init-dont-iterate-pages-below-arch_pfn_offset.patch added to mm-unstable branch
Message-Id: <20250420205623.F0E3FC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mm_init: don't iterate pages below ARCH_PFN_OFFSET
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_init-dont-iterate-pages-below-arch_pfn_offset.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_init-dont-iterate-pages-below-arch_pfn_offset.patch

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
From: Ruihan Li <lrh2000@pku.edu.cn>
Subject: mm/mm_init: don't iterate pages below ARCH_PFN_OFFSET
Date: Sat, 19 Apr 2025 20:28:01 +0800

Currently, memmap_init initializes pfn_hole with 0 instead of
ARCH_PFN_OFFSET. Then init_unavailable_range will start iterating each
page from the page at address zero to the first available page, but it
won't do anything for pages below ARCH_PFN_OFFSET because pfn_valid
won't pass.

If ARCH_PFN_OFFSET is very large (e.g., something like 2^64-2GiB if the
kernel is used as a library and loaded at a very high address), the
pointless iteration for pages below ARCH_PFN_OFFSET will take a very
long time, and the kernel will look stuck at boot time.

This commit sets the initial value of pfn_hole to ARCH_PFN_OFFSET, which
avoids the problematic and useless iteration mentioned above.

This problem has existed since commit 907ec5fca3dc ("mm: zero remaining
unavailable struct pages").

Link: https://lkml.kernel.org/r/20250419122801.1752234-1-lrh2000@pku.edu.cn
Fixes: 907ec5fca3dc ("mm: zero remaining unavailable struct pages")
Signed-off-by: Ruihan Li <lrh2000@pku.edu.cn>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/mm/mm_init.c~mm-mm_init-dont-iterate-pages-below-arch_pfn_offset
+++ a/mm/mm_init.c
@@ -975,6 +975,15 @@ static void __init memmap_init(void)
 	unsigned long hole_pfn = 0;
 	int i, j, zone_id = 0, nid;
 
+#ifdef CONFIG_FLATMEM
+	/*
+	 * Pages below ARCH_PFN_OFFSET are invalid as far as pfn_valid is
+	 * concerned, so don't waste time iterating on them when looking
+	 * for holes.
+	 */
+	hole_pfn = ARCH_PFN_OFFSET;
+#endif
+
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
 		struct pglist_data *node = NODE_DATA(nid);
 
_

Patches currently in -mm which might be from lrh2000@pku.edu.cn are

mm-mm_init-dont-iterate-pages-below-arch_pfn_offset.patch

