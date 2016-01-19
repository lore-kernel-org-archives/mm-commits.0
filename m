From: akpm@linux-foundation.org
Subject: + mlocked-pages-statistics-shows-bogus-value.patch added to -mm
 tree
Date: Tue, 19 Jan 2016 14:22:36 -0800
Message-ID: <569eb72c.bAZKO+Tn8+kCkaeK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbcASWWh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 17:22:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org, walken@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix mlock accouting
has been added to the -mm tree.  Its filename is
     mlocked-pages-statistics-shows-bogus-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mlocked-pages-statistics-shows-bogus-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mlocked-pages-statistics-shows-bogus-value.patch

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
Subject: mm: fix mlock accouting

Tetsuo Handa reported underflow of NR_MLOCK on munlock.

Testcase:
	#include <stdio.h>
	#include <stdlib.h>
	#include <sys/mman.h>

	#define BASE ((void *)0x400000000000)
	#define SIZE (1UL << 21)

	int main(int argc, char *argv[])
	{
		void *addr;

		system("grep Mlocked /proc/meminfo");
		addr = mmap(BASE, SIZE, PROT_READ | PROT_WRITE,
				MAP_ANONYMOUS | MAP_PRIVATE | MAP_LOCKED | MAP_FIXED,
				-1, 0);
		if (addr == MAP_FAILED)
			printf("mmap() failed\n"), exit(1);
		munmap(addr, SIZE);
		system("grep Mlocked /proc/meminfo");
		return 0;
	}

It happens on munlock_vma_page() due to unfortunate choice of nr_pages
data type:

	__mod_zone_page_state(zone, NR_MLOCK, -nr_pages);

For unsigned int nr_pages, implicitly casted to long in
__mod_zone_page_state(), it becomes something around UINT_MAX.

munlock_vma_page() usually called for THP as small pages go though
pagevec.

Let's make nr_pages signed int.

Similar fixes in 6cdb18ad98a4 ("mm/vmstat: fix overflow in
mod_zone_page_state()") used `long' type, but `int' here is OK for a count
of the number of sub-pages in a huge page.

Fixes: ff6a6da60b89 ("mm: accelerate munlock() treatment of THP pages")
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Michel Lespinasse <walken@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>  [4.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mlock.c~mlocked-pages-statistics-shows-bogus-value mm/mlock.c
--- a/mm/mlock.c~mlocked-pages-statistics-shows-bogus-value
+++ a/mm/mlock.c
@@ -175,7 +175,7 @@ static void __munlock_isolation_failed(s
  */
 unsigned int munlock_vma_page(struct page *page)
 {
-	unsigned int nr_pages;
+	int nr_pages;
 	struct zone *zone = page_zone(page);
 
 	/* For try_to_munlock() and to serialize with page migration */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-change-pmd_trans_huge_lock-interface-to-return-ptl.patch
mlocked-pages-statistics-shows-bogus-value.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

