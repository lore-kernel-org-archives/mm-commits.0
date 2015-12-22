From: akpm@linux-foundation.org
Subject: + mm-memblock-fix-ordering-of-flags-argument-in-comments.patch
 added to -mm tree
Date: Tue, 22 Dec 2015 14:56:25 -0800
Message-ID: <5679d519.JYuZb06l8JwIzB/P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbbLVW40 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Dec 2015 17:56:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: f.fainelli@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/memblock.h: fix ordering of 'flags' argument in comments
has been added to the -mm tree.  Its filename is
     mm-memblock-fix-ordering-of-flags-argument-in-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-fix-ordering-of-flags-argument-in-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-fix-ordering-of-flags-argument-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: include/linux/memblock.h: fix ordering of 'flags' argument in comments

for_each_free_mem_range() and for_each_free_mem_range_reverse() both
accept a 'flags' argument, the comment surrounding the macro placed the
'flags' documentation at the very end, while 'flags' is in fact the 3rd
argument to the macro, so let's preserve natural ordering here.

Fixes: fc6daaf931518 ("mm/memblock: add extra "flags" to memblock to allow selection of memory based on attribute")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-fix-ordering-of-flags-argument-in-comments include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-fix-ordering-of-flags-argument-in-comments
+++ a/include/linux/memblock.h
@@ -209,10 +209,10 @@ void __next_mem_pfn_range(int *idx, int
  * for_each_free_mem_range - iterate through free memblock areas
  * @i: u64 used as loop variable
  * @nid: node selector, %NUMA_NO_NODE for all nodes
+ * @flags: pick from blocks based on memory attributes
  * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
- * @flags: pick from blocks based on memory attributes
  *
  * Walks over free (memory && !reserved) areas of memblock.  Available as
  * soon as memblock is initialized.
@@ -225,10 +225,10 @@ void __next_mem_pfn_range(int *idx, int
  * for_each_free_mem_range_reverse - rev-iterate through free memblock areas
  * @i: u64 used as loop variable
  * @nid: node selector, %NUMA_NO_NODE for all nodes
+ * @flags: pick from blocks based on memory attributes
  * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
- * @flags: pick from blocks based on memory attributes
  *
  * Walks over free (memory && !reserved) areas of memblock in reverse
  * order.  Available as soon as memblock is initialized.
_

Patches currently in -mm which might be from f.fainelli@gmail.com are

mm-memblock-fix-ordering-of-flags-argument-in-comments.patch

