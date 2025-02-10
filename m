Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D9E25EF9A
	for <mm-commits@vger.kernel.org>; Mon, 10 Feb 2025 23:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739228765; cv=none; b=GS/0zEpgF9EU2DFop4sKm7rBBojJqberqAENuB0tzNZkaPvxH13glFYGB4doJmLu7L+mCiT8UFE8uoRGUtKUBUV4SK5nS7CYo7Ld+aZWtaD2XspV9ehWBvJxWSg+U1jDK9v8vFZRcWhl12ogax4WqZRi27T8Aztn0mhXeQ6YtSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739228765; c=relaxed/simple;
	bh=MTM64qFS1Q8A5IvNVYD/oD6mVkpeow+CI609Jawizfw=;
	h=Date:To:From:Subject:Message-Id; b=KszQLRdKqUpTUhcymgBNKbuONzos3h36P1lqd3lkjuaBp4KwjaKQQxXhhoZMNzwpdcuDZ8EiviqAL3qjhYZ7ne81bq0hWwIUWZNDBI51EZnGD8/jZlyC2eKO1mO7y44kh55D6nbnSOmCGEawYoG9h55zvl0IFMKiEfGeuRvOV4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vWuQGD5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vWuQGD5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B727C4CED1;
	Mon, 10 Feb 2025 23:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739228764;
	bh=MTM64qFS1Q8A5IvNVYD/oD6mVkpeow+CI609Jawizfw=;
	h=Date:To:From:Subject:From;
	b=vWuQGD5FZSOWQMHH/kxcFZVWOr0iq+xtDQdyVthIQvwLXrLAsYhW09SPTyyNB2r3c
	 u1SIglY4Cjg4I5JvQ/sQEcQZSkZHF/0P/xmnBPJRanllaL4b0+b9secNGh3pwuLQle
	 G6FJYADzgIHSy0I8ZOdAXviBycM42ODyZCQy8kRI=
Date: Mon, 10 Feb 2025 15:06:03 -0800
To: mm-commits@vger.kernel.org,v-songbaohua@oppo.com,vbabka@suse.cz,sj@kernel.org,si.yanteng@linux.dev,simona.vetter@ffwll.ch,peterz@infradead.org,peterx@redhat.com,pasha.tatashin@soleen.com,oleg@redhat.com,mhiramat@kernel.org,lyude@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kherbst@redhat.com,jhubbard@nvidia.com,jglisse@redhat.com,jgg@nvidia.com,jannh@google.com,dakr@kernel.org,corbet@lwn.net,apopple@nvidia.com,alexs@kernel.org,airlied@gmail.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-single-swp_device_exclusive-entry-type.patch added to mm-unstable branch
Message-Id: <20250210230604.9B727C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: use single SWP_DEVICE_EXCLUSIVE entry type
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-single-swp_device_exclusive-entry-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-single-swp_device_exclusive-entry-type.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm: use single SWP_DEVICE_EXCLUSIVE entry type
Date: Mon, 10 Feb 2025 20:37:48 +0100

There is no need for the distinction anymore; let's merge the readable and
writable device-exclusive entries into a single device-exclusive entry
type.

Link: https://lkml.kernel.org/r/20250210193801.781278-7-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Simona Vetter <simona.vetter@ffwll.ch>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Karol Herbst <kherbst@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Lyude <lyude@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yanteng Si <si.yanteng@linux.dev>
Cc: Barry Song <v-songbaohua@oppo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h    |    7 +++----
 include/linux/swapops.h |   27 ++++-----------------------
 mm/mprotect.c           |    8 --------
 mm/page_table_check.c   |    5 ++---
 mm/rmap.c               |    2 +-
 5 files changed, 10 insertions(+), 39 deletions(-)

--- a/include/linux/swap.h~mm-use-single-swp_device_exclusive-entry-type
+++ a/include/linux/swap.h
@@ -74,14 +74,13 @@ static inline int current_is_kswapd(void
  * to a special SWP_DEVICE_{READ|WRITE} entry.
  *
  * When a page is mapped by the device for exclusive access we set the CPU page
- * table entries to special SWP_DEVICE_EXCLUSIVE_* entries.
+ * table entries to a special SWP_DEVICE_EXCLUSIVE entry.
  */
 #ifdef CONFIG_DEVICE_PRIVATE
-#define SWP_DEVICE_NUM 4
+#define SWP_DEVICE_NUM 3
 #define SWP_DEVICE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM)
 #define SWP_DEVICE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+1)
-#define SWP_DEVICE_EXCLUSIVE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+2)
-#define SWP_DEVICE_EXCLUSIVE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+3)
+#define SWP_DEVICE_EXCLUSIVE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+2)
 #else
 #define SWP_DEVICE_NUM 0
 #endif
--- a/include/linux/swapops.h~mm-use-single-swp_device_exclusive-entry-type
+++ a/include/linux/swapops.h
@@ -186,26 +186,16 @@ static inline bool is_writable_device_pr
 	return unlikely(swp_type(entry) == SWP_DEVICE_WRITE);
 }
 
-static inline swp_entry_t make_readable_device_exclusive_entry(pgoff_t offset)
+static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 {
-	return swp_entry(SWP_DEVICE_EXCLUSIVE_READ, offset);
-}
-
-static inline swp_entry_t make_writable_device_exclusive_entry(pgoff_t offset)
-{
-	return swp_entry(SWP_DEVICE_EXCLUSIVE_WRITE, offset);
+	return swp_entry(SWP_DEVICE_EXCLUSIVE, offset);
 }
 
 static inline bool is_device_exclusive_entry(swp_entry_t entry)
 {
-	return swp_type(entry) == SWP_DEVICE_EXCLUSIVE_READ ||
-		swp_type(entry) == SWP_DEVICE_EXCLUSIVE_WRITE;
+	return swp_type(entry) == SWP_DEVICE_EXCLUSIVE;
 }
 
-static inline bool is_writable_device_exclusive_entry(swp_entry_t entry)
-{
-	return unlikely(swp_type(entry) == SWP_DEVICE_EXCLUSIVE_WRITE);
-}
 #else /* CONFIG_DEVICE_PRIVATE */
 static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 {
@@ -227,12 +217,7 @@ static inline bool is_writable_device_pr
 	return false;
 }
 
-static inline swp_entry_t make_readable_device_exclusive_entry(pgoff_t offset)
-{
-	return swp_entry(0, 0);
-}
-
-static inline swp_entry_t make_writable_device_exclusive_entry(pgoff_t offset)
+static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 {
 	return swp_entry(0, 0);
 }
@@ -242,10 +227,6 @@ static inline bool is_device_exclusive_e
 	return false;
 }
 
-static inline bool is_writable_device_exclusive_entry(swp_entry_t entry)
-{
-	return false;
-}
 #endif /* CONFIG_DEVICE_PRIVATE */
 
 #ifdef CONFIG_MIGRATION
--- a/mm/mprotect.c~mm-use-single-swp_device_exclusive-entry-type
+++ a/mm/mprotect.c
@@ -225,14 +225,6 @@ static long change_pte_range(struct mmu_
 				newpte = swp_entry_to_pte(entry);
 				if (pte_swp_uffd_wp(oldpte))
 					newpte = pte_swp_mkuffd_wp(newpte);
-			} else if (is_writable_device_exclusive_entry(entry)) {
-				entry = make_readable_device_exclusive_entry(
-							swp_offset(entry));
-				newpte = swp_entry_to_pte(entry);
-				if (pte_swp_soft_dirty(oldpte))
-					newpte = pte_swp_mksoft_dirty(newpte);
-				if (pte_swp_uffd_wp(oldpte))
-					newpte = pte_swp_mkuffd_wp(newpte);
 			} else if (is_pte_marker_entry(entry)) {
 				/*
 				 * Ignore error swap entries unconditionally,
--- a/mm/page_table_check.c~mm-use-single-swp_device_exclusive-entry-type
+++ a/mm/page_table_check.c
@@ -196,9 +196,8 @@ EXPORT_SYMBOL(__page_table_check_pud_cle
 /* Whether the swap entry cached writable information */
 static inline bool swap_cached_writable(swp_entry_t entry)
 {
-	return is_writable_device_exclusive_entry(entry) ||
-	    is_writable_device_private_entry(entry) ||
-	    is_writable_migration_entry(entry);
+	return is_writable_device_private_entry(entry) ||
+	       is_writable_migration_entry(entry);
 }
 
 static inline void page_table_check_pte_flags(pte_t pte)
--- a/mm/rmap.c~mm-use-single-swp_device_exclusive-entry-type
+++ a/mm/rmap.c
@@ -2492,7 +2492,7 @@ struct page *make_device_exclusive(struc
 	 * do_swap_page() will trigger the conversion back while holding the
 	 * folio lock.
 	 */
-	entry = make_writable_device_exclusive_entry(page_to_pfn(page));
+	entry = make_device_exclusive_entry(page_to_pfn(page));
 	swp_pte = swp_entry_to_pte(entry);
 	if (pte_soft_dirty(fw.pte))
 		swp_pte = pte_swp_mksoft_dirty(swp_pte);
_

Patches currently in -mm which might be from david@redhat.com are

mm-gup-reject-foll_split_pmd-with-hugetlb-vmas.patch
mm-rmap-reject-hugetlb-folios-in-folio_make_device_exclusive.patch
mm-rmap-convert-make_device_exclusive_range-to-make_device_exclusive.patch
mm-rmap-implement-make_device_exclusive-using-folio_walk-instead-of-rmap-walk.patch
mm-memory-detect-writability-in-restore_exclusive_pte-through-can_change_pte_writable.patch
mm-use-single-swp_device_exclusive-entry-type.patch
mm-page_vma_mapped-device-exclusive-entries-are-not-migration-entries.patch
kernel-events-uprobes-handle-device-exclusive-entries-correctly-in-__replace_page.patch
mm-ksm-handle-device-exclusive-entries-correctly-in-write_protect_page.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_unmap_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-try_to_migrate_one.patch
mm-rmap-handle-device-exclusive-entries-correctly-in-page_vma_mkclean_one.patch
mm-page_idle-handle-device-exclusive-entries-correctly-in-page_idle_clear_pte_refs_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_young_one.patch
mm-damon-handle-device-exclusive-entries-correctly-in-damon_folio_mkold_one.patch
mm-rmap-keep-mapcount-untouched-for-device-exclusive-entries.patch
mm-rmap-avoid-ebusy-from-make_device_exclusive.patch

