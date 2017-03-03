From: akpm@linux-foundation.org
Subject: + thp-fix-another-corner-case-of-munlock-vs-thps.patch added to
 -mm tree
Date: Fri, 03 Mar 2017 14:31:46 -0800
Message-ID: <58b9eed2.W6l5wAGnR6hHJ6wA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42098 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752087AbdCCWkz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 17:40:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix another corner case of munlock() vs. THPs
has been added to the -mm tree.  Its filename is
     thp-fix-another-corner-case-of-munlock-vs-thps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-fix-another-corner-case-of-munlock-vs-thps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-fix-another-corner-case-of-munlock-vs-thps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: fix another corner case of munlock() vs. THPs

The following test case triggers BUG() in munlock_vma_pages_range():

	int main(int argc, char *argv[])
	{
		int fd;

		system("mount -t tmpfs -o huge=always none /mnt");
		fd = open("/mnt/test", O_CREAT | O_RDWR);
		ftruncate(fd, 4UL << 20);
		mmap(NULL, 4UL << 20, PROT_READ | PROT_WRITE,
				MAP_SHARED | MAP_FIXED | MAP_LOCKED, fd, 0);
		mmap(NULL, 4096, PROT_READ | PROT_WRITE,
				MAP_SHARED | MAP_LOCKED, fd, 0);
		munlockall();
		return 0;
	}

The second mmap() create PTE-mapping of the first huge page in file.  It
makes kernel munlock the page as we never keep PTE-mapped page mlocked.

On munlockall() when we handle vma created by the first mmap(),
munlock_vma_page() returns page_mask == 0, as the page is not mlocked
anymore.  On next iteration follow_page_mask() return tail page, but
page_mask is HPAGE_NR_PAGES - 1.  It makes us skip to the first tail page
of the next huge page and step on VM_BUG_ON_PAGE(PageMlocked(page)).

The fix is not use the page_mask from follow_page_mask() at all.  It has
no use for us.

Link: http://lkml.kernel.org/r/20170302150252.34120-1-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>    [4.5+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/mlock.c~thp-fix-another-corner-case-of-munlock-vs-thps mm/mlock.c
--- a/mm/mlock.c~thp-fix-another-corner-case-of-munlock-vs-thps
+++ a/mm/mlock.c
@@ -442,7 +442,7 @@ void munlock_vma_pages_range(struct vm_a
 
 	while (start < end) {
 		struct page *page;
-		unsigned int page_mask;
+		unsigned int page_mask = 0;
 		unsigned long page_increm;
 		struct pagevec pvec;
 		struct zone *zone;
@@ -456,8 +456,7 @@ void munlock_vma_pages_range(struct vm_a
 		 * suits munlock very well (and if somehow an abnormal page
 		 * has sneaked into the range, we won't oops here: great).
 		 */
-		page = follow_page_mask(vma, start, FOLL_GET | FOLL_DUMP,
-				&page_mask);
+		page = follow_page(vma, start, FOLL_GET | FOLL_DUMP);
 
 		if (page && !IS_ERR(page)) {
 			if (PageTransTail(page)) {
@@ -468,8 +467,8 @@ void munlock_vma_pages_range(struct vm_a
 				/*
 				 * Any THP page found by follow_page_mask() may
 				 * have gotten split before reaching
-				 * munlock_vma_page(), so we need to recompute
-				 * the page_mask here.
+				 * munlock_vma_page(), so we need to compute
+				 * the page_mask here instead.
 				 */
 				page_mask = munlock_vma_page(page);
 				unlock_page(page);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rmap-fix-null-pointer-dereference-on-thp-munlocking.patch
thp-fix-another-corner-case-of-munlock-vs-thps.patch
thp-reduce-indentation-level-in-change_huge_pmd.patch
thp-fix-madv_dontneed-vs-numa-balancing-race.patch
thp-fix-madv_dontneed-vs-madv_free-race.patch
thp-fix-madv_dontneed-vs-clear-soft-dirty-race.patch

