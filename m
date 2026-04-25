Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7920B37EFE4
	for <mm-commits@vger.kernel.org>; Sat, 25 Apr 2026 22:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777154814; cv=none; b=oHJB4i7pItY4NYFBrBcAjex/A1AS0azmj2teW596N5sN0If8DpTElIs9Up1P0TF7zkROuXGGAjHeXA+nY9Akf1ir9rTrflTXkUxxeRNLEYDNmXtYdTMH55IU6UtztnvuElL01rIknZD39TIKjY5oRLYsQQ1oLzSCmQJaTZWrjxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777154814; c=relaxed/simple;
	bh=Zu83nkmZiuLkT/Rc59I/pyk1BtPc8SnYh5QvwNyUozQ=;
	h=Date:To:From:Subject:Message-Id; b=cbVJunk8Z4FOsnnVJc0kszfFVZCw3Wt8o/S+fMoLWfW3AuR9RnOZz2aY3IGqkftddU/A0Sztx2VTEntr3kUglRMsWdDmHHp48Z/LJPLzlm+aIpi0FNRtYsloR0wzG0urGXVvuSWe/rI8bgmHRjKN78rKYtwskzi0uMGzbtS7xwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tcuFOcvB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tcuFOcvB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7C2C2BCB0;
	Sat, 25 Apr 2026 22:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777154814;
	bh=Zu83nkmZiuLkT/Rc59I/pyk1BtPc8SnYh5QvwNyUozQ=;
	h=Date:To:From:Subject:From;
	b=tcuFOcvBzNrYBufg27BC0HxLDbEvT7qL0DBNt+1Jc/nfD2Ec6iFy3MwtkxVxbBKKw
	 kEhLKLGNXLf2zRod3FSuOtfuc1SUGYDD90JKoriLXHXfBuSYeP4FXlLzXHlgvjomuK
	 6CMy8B5WHciIcIp0eF6rjaxJog2tJemEWdd5BBIg=
Date: Sat, 25 Apr 2026 15:06:53 -0700
To: mm-commits@vger.kernel.org,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-remove-read_only_thp_for_fs-check-fix.patch removed from -mm tree
Message-Id: <20260425220654.1A7C2C2BCB0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-khugepaged-remove-read_only_thp_for_fs-check-fix
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-read_only_thp_for_fs-check-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-khugepaged-remove-read_only_thp_for_fs-check-fix
Date: Sat Apr 25 02:54:04 PM PDT 2026

fix arm64 allnoconfig by uninlining mapping_pmd_thp_support()

In file included from ./include/linux/mm.h:31,
                 from fs/inode.c:9:
./include/linux/pagemap.h: In function 'mapping_pmd_thp_support':
./include/linux/pgtable.h:8:26: error: 'PMD_SHIFT' undeclared (first use in this function); did you mean 'PUD_SHIFT'?
    8 | #define PMD_ORDER       (PMD_SHIFT - PAGE_SHIFT)
      |                          ^~~~~~~~~
./include/linux/pagemap.h:521:52: note: in expansion of macro 'PMD_ORDER'
  521 |         return mapping_max_folio_order(mapping) >= PMD_ORDER;
      |                                                    ^~~~~~~~~
./include/linux/pgtable.h:8:26: note: each undeclared identifier is reported only once for each function it appears in
    8 | #define PMD_ORDER       (PMD_SHIFT - PAGE_SHIFT)
      |                          ^~~~~~~~~
./include/linux/pagemap.h:521:52: note: in expansion of macro 'PMD_ORDER'
  521 |         return mapping_max_folio_order(mapping) >= PMD_ORDER;
      |                                                    ^~~~~~~~~
make[3]: *** [scripts/Makefile.build:289: fs/inode.o] Error 1
make[2]: *** [scripts/Makefile.build:548: fs] Error 2
make[1]: *** [/usr/src/25/Makefile:2139: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2

Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    9 +--------
 mm/filemap.c            |    8 ++++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/include/linux/pagemap.h~mm-khugepaged-remove-read_only_thp_for_fs-check-fix
+++ a/include/linux/pagemap.h
@@ -513,14 +513,7 @@ static inline bool mapping_large_folio_s
 	return mapping_max_folio_order(mapping) > 0;
 }
 
-static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
-{
-	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
-	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
-
-	return mapping_max_folio_order(mapping) >= PMD_ORDER;
-}
-
+bool mapping_pmd_thp_support(const struct address_space *mapping);
 
 /* Return the maximum folio size for this pagecache mapping, in bytes. */
 static inline size_t mapping_max_folio_size(const struct address_space *mapping)
--- a/mm/filemap.c~mm-khugepaged-remove-read_only_thp_for_fs-check-fix
+++ a/mm/filemap.c
@@ -126,6 +126,14 @@
  *    ->private_lock		(zap_pte_range->block_dirty_folio)
  */
 
+bool mapping_pmd_thp_support(const struct address_space *mapping)
+{
+	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
+	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
+
+	return mapping_max_folio_order(mapping) >= PMD_ORDER;
+}
+
 static void page_cache_delete(struct address_space *mapping,
 				   struct folio *folio, void *shadow)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-fix-initialization-of-tags-of-the-huge-zero-folio-with-init_on_free-fix.patch
mm-page_owner-add-numa-node-filter-with-nodelist-support-fix.patch
include-asm-generic-fixmaph-reimplement-nasty-macros-in-c.patch
proc-rewrite-next_tgid-fix.patch

