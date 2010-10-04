From: akpm@linux-foundation.org
Subject: + mm-alloc_large_system_hash-printk-overflow-on-16tb-boot.patch added to -mm tree
Date: Mon, 04 Oct 2010 12:53:12 -0700
Message-ID: <201010041953.o94JrCmW010911@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756939Ab0JDTxo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Oct 2010 15:53:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com


The patch titled
     mm: alloc_large_system_hash() printk overflow on 16TB boot
has been added to the -mm tree.  Its filename is
     mm-alloc_large_system_hash-printk-overflow-on-16tb-boot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: alloc_large_system_hash() printk overflow on 16TB boot
From: Robin Holt <holt@sgi.com>

During boot of a 16TB system, the following is printed:
Dentry cache hash table entries: -2147483648 (order: 22, 17179869184 bytes)

Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-alloc_large_system_hash-printk-overflow-on-16tb-boot mm/page_alloc.c
--- a/mm/page_alloc.c~mm-alloc_large_system_hash-printk-overflow-on-16tb-boot
+++ a/mm/page_alloc.c
@@ -5198,9 +5198,9 @@ void *__init alloc_large_system_hash(con
 	if (!table)
 		panic("Failed to allocate %s hash table\n", tablename);
 
-	printk(KERN_INFO "%s hash table entries: %d (order: %d, %lu bytes)\n",
+	printk(KERN_INFO "%s hash table entries: %ld (order: %d, %lu bytes)\n",
 	       tablename,
-	       (1U << log2qty),
+	       (1UL << log2qty),
 	       ilog2(size) - PAGE_SHIFT,
 	       size);
 
_

Patches currently in -mm which might be from holt@sgi.com are

mm-alloc_large_system_hash-printk-overflow-on-16tb-boot.patch
linux-next.patch

