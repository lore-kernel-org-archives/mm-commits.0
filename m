From: akpm@linux-foundation.org
Subject: + dax-fix-deadlock-with-dax-4k-holes.patch added to -mm tree
Date: Wed, 04 Jan 2017 14:06:32 -0800
Message-ID: <586d71e8.hXEHBNpPBYxHn3g3%akpm__45013.2637554363$1483567649$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39750 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753441AbdADWHA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jan 2017 17:07:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.cz, stable@vger.kernel.org, xzhou@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: fix deadlock with DAX 4k holes
has been added to the -mm tree.  Its filename is
     dax-fix-deadlock-with-dax-4k-holes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-fix-deadlock-with-dax-4k-holes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-fix-deadlock-with-dax-4k-holes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: fix deadlock with DAX 4k holes

Currently in DAX if we have three read faults on the same hole address we
can end up with the following:

Thread 0		Thread 1		Thread 2
--------		--------		--------
dax_iomap_fault
 grab_mapping_entry
  lock_slot
   <locks empty DAX entry>

  			dax_iomap_fault
			 grab_mapping_entry
			  get_unlocked_mapping_entry
			   <sleeps on empty DAX entry>

						dax_iomap_fault
						 grab_mapping_entry
						  get_unlocked_mapping_entry
						   <sleeps on empty DAX entry>
  dax_load_hole
   find_or_create_page
   ...
    page_cache_tree_insert
     dax_wake_mapping_entry_waiter
      <wakes one sleeper>
     __radix_tree_replace
      <swaps empty DAX entry with 4k zero page>

			<wakes>
			get_page
			lock_page
			...
			put_locked_mapping_entry
			unlock_page
			put_page

						<sleeps forever on the DAX
						 wait queue>

The crux of the problem is that once we insert a 4k zero page, all locking
from then on is done in terms of that 4k zero page and any additional
threads sleeping on the empty DAX entry will never be woken.  Fix this by
waking all sleepers when we replace the DAX radix tree entry with a 4k
zero page.  This will allow all sleeping threads to successfully
transition from locking based on the DAX empty entry to locking on the 4k
zero page.

With the test case reported by Xiong this happens very regularly in my
test setup, with some runs resulting in 9+ threads in this deadlocked
state.  With this fix I've been able to run that same test dozens of times
in a loop without issue.

Fixes: ac401cc78242 ("dax: New fault locking")
Link: http://lkml.kernel.org/r/1483479365-13607-1-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reported-by: Xiong Zhou <xzhou@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>	[4.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~dax-fix-deadlock-with-dax-4k-holes mm/filemap.c
--- a/mm/filemap.c~dax-fix-deadlock-with-dax-4k-holes
+++ a/mm/filemap.c
@@ -138,7 +138,7 @@ static int page_cache_tree_insert(struct
 				dax_radix_locked_entry(0, RADIX_DAX_EMPTY));
 			/* Wakeup waiters for exceptional entry lock */
 			dax_wake_mapping_entry_waiter(mapping, page->index, p,
-						      false);
+						      true);
 		}
 	}
 	__radix_tree_replace(&mapping->page_tree, node, slot, page,
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-fix-deadlock-with-dax-4k-holes.patch
mm-add-follow_pte_pmd.patch
dax-wrprotect-pmd_t-in-dax_mapping_entry_mkclean.patch

