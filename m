Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656FE148FFA;
	Fri, 26 Jul 2024 20:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722026294; cv=none; b=RceQramGcU8g8rPyVPBABK0Wqbt/XbvvCj/uTOv6tFqeLTNVEM9WXlTU64yvYi8RzYcN4bM8eCPMJDNc7U1kq/leGWXKUEur27Q+rzjC0BfyiI/oQIYj3TgpQ7woxdUPZ/Mn8DdhOLyLZlKHJh2/LSH6p1Cr9Kx8kKSREg2fnNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722026294; c=relaxed/simple;
	bh=KiwtFBWWjk+HzvIyGnCKaWrhN0OvYvrf9WPRYSzYq0g=;
	h=Date:To:From:Subject:Message-Id; b=h+lvnjjVXIhBTSXm1C15k35pGikEPUbDnakwDi13eEZQ+TZtcWrxOpf5CHkhss7ReBK22kdNVI5wmkuw0WUAhCUWnm/0hEfX1qLS9brAcR0XBAl/GC/efB/CYnVYJ99QoYeT+oSpGtoeb1e6W7RfYmPFNNAlUnPgXSpwGHrG6xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tKT0YnHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tKT0YnHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30751C32782;
	Fri, 26 Jul 2024 20:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722026294;
	bh=KiwtFBWWjk+HzvIyGnCKaWrhN0OvYvrf9WPRYSzYq0g=;
	h=Date:To:From:Subject:From;
	b=tKT0YnHGTtMN9wsTXVrJhLxJ4Z3brlzG1JVA1AFb+MIuW0uTGlTFg36i4G4j1mOTT
	 /0kUf0tIAbuMvhAoEWjFN4SrT4ijh3mDMVT8SmBeciQev0XaA9lO5JIXgMMcV8LP2+
	 wBhazMEWcVTTfQZiIZ7L6KOoDc31OU7O+hu5r9A8=
Date: Fri, 26 Jul 2024 13:38:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,souravpanda@google.com,pasha.tatashin@soleen.com,lkp@intel.com,kent.overstreet@linux.dev,keescook@chromium.org,hch@infradead.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] alloc_tag-outline-and-export-free_reserved_page.patch removed from -mm tree
Message-Id: <20240726203814.30751C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alloc_tag: outline and export free_reserved_page()
has been removed from the -mm tree.  Its filename was
     alloc_tag-outline-and-export-free_reserved_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: alloc_tag: outline and export free_reserved_page()
Date: Wed, 17 Jul 2024 14:28:44 -0700

Outline and export free_reserved_page() because modules use it and it in
turn uses page_ext_{get|put} which should not be exported.  The same
result could be obtained by outlining {get|put}_page_tag_ref() but that
would have higher performance impact as these functions are used in more
performance critical paths.

Link: https://lkml.kernel.org/r/20240717212844.2749975-1-surenb@google.com
Fixes: dcfe378c81f7 ("lib: introduce support for page allocation tagging")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202407080044.DWMC9N9I-lkp@intel.com/
Suggested-by: Christoph Hellwig <hch@infradead.org>
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <keescook@chromium.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: <stable@vger.kernel.org>	[6.10]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   16 +---------------
 mm/page_alloc.c    |   17 +++++++++++++++++
 2 files changed, 18 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~alloc_tag-outline-and-export-free_reserved_page
+++ a/include/linux/mm.h
@@ -3130,21 +3130,7 @@ extern void reserve_bootmem_region(phys_
 				   phys_addr_t end, int nid);
 
 /* Free the reserved page into the buddy system, so it gets managed. */
-static inline void free_reserved_page(struct page *page)
-{
-	if (mem_alloc_profiling_enabled()) {
-		union codetag_ref *ref = get_page_tag_ref(page);
-
-		if (ref) {
-			set_codetag_empty(ref);
-			put_page_tag_ref(ref);
-		}
-	}
-	ClearPageReserved(page);
-	init_page_count(page);
-	__free_page(page);
-	adjust_managed_page_count(page, 1);
-}
+void free_reserved_page(struct page *page);
 #define free_highmem_page(page) free_reserved_page(page)
 
 static inline void mark_page_reserved(struct page *page)
--- a/mm/page_alloc.c~alloc_tag-outline-and-export-free_reserved_page
+++ a/mm/page_alloc.c
@@ -5815,6 +5815,23 @@ unsigned long free_reserved_area(void *s
 	return pages;
 }
 
+void free_reserved_page(struct page *page)
+{
+	if (mem_alloc_profiling_enabled()) {
+		union codetag_ref *ref = get_page_tag_ref(page);
+
+		if (ref) {
+			set_codetag_empty(ref);
+			put_page_tag_ref(ref);
+		}
+	}
+	ClearPageReserved(page);
+	init_page_count(page);
+	__free_page(page);
+	adjust_managed_page_count(page, 1);
+}
+EXPORT_SYMBOL(free_reserved_page);
+
 static int page_alloc_cpu_dead(unsigned int cpu)
 {
 	struct zone *zone;
_

Patches currently in -mm which might be from surenb@google.com are


