Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0351C18637
	for <mm-commits@vger.kernel.org>; Thu,  4 Jul 2024 02:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720060714; cv=none; b=eIJThmFevX90Cddwx0/qt7SL9/jHg8Y23FMXNTNXahK788atyHQgBbCHMh7Ugy2WwNVyAdgTP5Iy+PnORwHcHKFrEG6iiwmduGurP6EYxBbE+R5Ns7emcsFzZlM5faRZlFTydbnQyJUKhgpn2lp0toJMeWEpCoqIz5LbXJ+STsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720060714; c=relaxed/simple;
	bh=JPZNHTY6edwwhlDsc9kGdRvDkHxc4lWCfvXDI+gw+tI=;
	h=Date:To:From:Subject:Message-Id; b=H9AIoOJeJOvaXW4ItEd2dcbACaQjd23MwTqyYAHYlIetP7Rklxwsiyr1Ts/CUpiGP60opmoIc6+0nOuPiOUEj4Muh9VCeOS6SCJFpHGfM/YH9MrXnQWDZnQb3cyLOTZ/vPiUrLI/XP2LlpnKoyq3QL4uQq8v2MiY3BoFqpDvRw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kaDGeyfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kaDGeyfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90312C2BD10;
	Thu,  4 Jul 2024 02:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720060713;
	bh=JPZNHTY6edwwhlDsc9kGdRvDkHxc4lWCfvXDI+gw+tI=;
	h=Date:To:From:Subject:From;
	b=kaDGeyfMC37gjkNZbzMNd9LZEtyUYSC+IOTmCyO3qouA5VzZr2EjbQI/AX1yW6EEN
	 Eb6FNBSMoGfobuMiovWZ/bI3l+wi3lOf8EBHH/qcnVBRHGtun8PPR/59T8EC/M+UPc
	 L1FYhejatc/xlrV/8ejWLtoMb9hjI34FCOtyS1kw=
Date: Wed, 03 Jul 2024 19:38:33 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,david@redhat.com,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system-v2.patch added to mm-unstable branch
Message-Id: <20240704023833.90312C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system-v2.patch

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
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system-v2
Date: Thu, 4 Jul 2024 01:59:06 +0000

slightly adjust the loop based on David's comment

Link: https://lkml.kernel.org/r/20240704015906.18437-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system-v2
+++ a/mm/page_alloc.c
@@ -1224,7 +1224,7 @@ void __free_pages_core(struct page *page
 {
 	unsigned int nr_pages = 1 << order;
 	struct page *p = page;
-	unsigned int loop;
+	unsigned int loop = 0;
 
 	/*
 	 * When initializing the memmap, __init_single_page() sets the refcount
@@ -1236,10 +1236,13 @@ void __free_pages_core(struct page *page
 	 */
 	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG) &&
 	    unlikely(context == MEMINIT_HOTPLUG)) {
-		for (loop = 0; loop < nr_pages; loop++, p++) {
+		for (;;) {
 			VM_WARN_ON_ONCE(PageReserved(p));
 			__ClearPageOffline(p);
 			set_page_count(p, 0);
+			if (++loop >= nr_pages)
+				break;
+			p++;
 		}
 
 		/*
@@ -1250,9 +1253,12 @@ void __free_pages_core(struct page *page
 		debug_pagealloc_map_pages(page, nr_pages);
 		adjust_managed_page_count(page, nr_pages);
 	} else {
-		for (loop = 0; loop < nr_pages; loop++, p++) {
+		for (;;) {
 			__ClearPageReserved(p);
 			set_page_count(p, 0);
+			if (++loop >= nr_pages)
+				break;
+			p++;
 		}
 
 		/* memblock adjusts totalram_pages() manually. */
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

kernel-forkc-get-totalram_pages-from-memblock-to-calculate-max_threads.patch
kernel-forkc-put-set_max_threads-task_struct_whitelist-in-__init-section.patch
mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system.patch
mm-page_alloc-remove-prefetchw-on-freeing-page-to-buddy-system-v2.patch

