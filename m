Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847FD13BC3E
	for <mm-commits@vger.kernel.org>; Wed,  5 Jun 2024 22:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717627857; cv=none; b=JR9P7KY6aQvqKR+egbW4B4Cc3MSsFl+bx1mHj1/W8QzuadE1NJoN7SpGrz9muFAklp9Weisjh0ORtILtVCJJCjA713lmcmiuJMyyJr4ZxZo2zfUzQaD9Mhx5tj4DkjUMqEqvqx1dwvivQvLbu3tC+ECaKv7m6Ss+45F+fP7baFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717627857; c=relaxed/simple;
	bh=VpnbSS8/uAKf3ZawD2ZaVb4LVYAuG+rN+5YAqTlDeRQ=;
	h=Date:To:From:Subject:Message-Id; b=pJh9hFkhYAbECygNTB9WVgLNiMVp5NkJqhARZxUDoffb38m0KaDLT5Uya804WpndXddtQqIX0AGp0PS2JBb9JEJsyN0zveqIn4p0iZhP+S8bF4XbQqJjU1R0zR9rKfiCoODdJ6oz9DKVXlBjEuyDfgPISbfx+k6TvJc9LTl2Iaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a2zEbZb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a2zEbZb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C8AC2BD11;
	Wed,  5 Jun 2024 22:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1717627856;
	bh=VpnbSS8/uAKf3ZawD2ZaVb4LVYAuG+rN+5YAqTlDeRQ=;
	h=Date:To:From:Subject:From;
	b=a2zEbZb6Ct3OUWXiRwVVPXBdR0cZP/UslQIzI5vVa37A1+wwRtho7pTfHw4DEkpTI
	 ldq2N+5KpMB/kBqcIZz7TWapUlMNLZKpvuknYBoyCxgXQkSVT3d3dM36JfOmRyjgN0
	 HDTGkWzZvlrr93RNNCD9z+ME4o4VYUIbou2vm/Vs=
Date: Wed, 05 Jun 2024 15:50:56 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,surenb@google.com,ryan.roberts@arm.com,minchan@kernel.org,kasong@tencent.com,david@redhat.com,chrisl@kernel.org,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch added to mm-unstable branch
Message-Id: <20240605225056.D2C8AC2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: swap: reuse exclusive folio directly instead of wp page faults
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch

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
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: swap: reuse exclusive folio directly instead of wp page faults
Date: Sun, 2 Jun 2024 12:45:02 +1200

After swapping out, we perform a swap-in operation.  If we first read and
then write, we encounter a major fault in do_swap_page for reading, along
with additional minor faults in do_wp_page for writing.  However, the
latter appears to be unnecessary and inefficient.  Instead, we can
directly reuse in do_swap_page and completely eliminate the need for
do_wp_page.

This patch achieves that optimization specifically for exclusive folios. 
The following microbenchmark demonstrates the significant reduction in
minor faults.

 #define DATA_SIZE (2UL * 1024 * 1024)
 #define PAGE_SIZE (4UL * 1024)

 static void *read_write_data(char *addr)
 {
         char tmp;

         for (int i = 0; i < DATA_SIZE; i += PAGE_SIZE) {
                 tmp = *(volatile char *)(addr + i);
                 *(volatile char *)(addr + i) = tmp;
         }
 }

 int main(int argc, char **argv)
 {
         struct rusage ru;

         char *addr = mmap(NULL, DATA_SIZE, PROT_READ | PROT_WRITE,
                         MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
         memset(addr, 0x11, DATA_SIZE);

         do {
                 long old_ru_minflt, old_ru_majflt;
                 long new_ru_minflt, new_ru_majflt;

                 madvise(addr, DATA_SIZE, MADV_PAGEOUT);

                 getrusage(RUSAGE_SELF, &ru);
                 old_ru_minflt = ru.ru_minflt;
                 old_ru_majflt = ru.ru_majflt;

                 read_write_data(addr);
                 getrusage(RUSAGE_SELF, &ru);
                 new_ru_minflt = ru.ru_minflt;
                 new_ru_majflt = ru.ru_majflt;

                 printf("minor faults:%ld major faults:%ld\n",
                         new_ru_minflt - old_ru_minflt,
                         new_ru_majflt - old_ru_majflt);
         } while(0);

         return 0;
 }

w/o patch,
/ # ~/a.out
minor faults:512 major faults:512

w/ patch,
/ # ~/a.out
minor faults:0 major faults:512

Minor faults decrease to 0!

Link: https://lkml.kernel.org/r/20240602004502.26895-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults
+++ a/mm/memory.c
@@ -4308,6 +4308,10 @@ check_folio:
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
 	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
 	pte = mk_pte(page, vma->vm_page_prot);
+	if (pte_swp_soft_dirty(vmf->orig_pte))
+		pte = pte_mksoft_dirty(pte);
+	if (pte_swp_uffd_wp(vmf->orig_pte))
+		pte = pte_mkuffd_wp(pte);
 
 	/*
 	 * Same logic as in do_wp_page(); however, optimize for pages that are
@@ -4317,18 +4321,18 @@ check_folio:
 	 */
 	if (!folio_test_ksm(folio) &&
 	    (exclusive || folio_ref_count(folio) == 1)) {
-		if (vmf->flags & FAULT_FLAG_WRITE) {
-			pte = maybe_mkwrite(pte_mkdirty(pte), vma);
-			vmf->flags &= ~FAULT_FLAG_WRITE;
+		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
+		    !vma_soft_dirty_enabled(vma)) {
+			pte = pte_mkwrite(pte, vma);
+			if (vmf->flags & FAULT_FLAG_WRITE) {
+				pte = pte_mkdirty(pte);
+				vmf->flags &= ~FAULT_FLAG_WRITE;
+			}
 		}
 		rmap_flags |= RMAP_EXCLUSIVE;
 	}
 	folio_ref_add(folio, nr_pages - 1);
 	flush_icache_pages(vma, page, nr_pages);
-	if (pte_swp_soft_dirty(vmf->orig_pte))
-		pte = pte_mksoft_dirty(pte);
-	if (pte_swp_uffd_wp(vmf->orig_pte))
-		pte = pte_mkuffd_wp(pte);
 	vmf->orig_pte = pte_advance_pfn(pte, page_idx);
 
 	/* ksm created a completely new copy */
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-huge_mm-fix-undefined-reference-to-mthp_stats-for-config_sysfs=n.patch
mm-arm64-fix-the-out-of-bounds-issue-in-contpte_clear_young_dirty_ptes.patch
mm-remove-the-implementation-of-swap_free-and-always-use-swap_free_nr.patch
mm-introduce-pte_move_swp_offset-helper-which-can-move-offset-bidirectionally.patch
mm-introduce-arch_do_swap_page_nr-which-allows-restore-metadata-for-nr-pages.patch
mm-swap-reuse-exclusive-folio-directly-instead-of-wp-page-faults.patch

