From: akpm@linux-foundation.org
Subject: + zsmalloc-use-bit_spin_lock.patch added to -mm tree
Date: Wed, 01 Jun 2016 14:41:23 -0700
Message-ID: <574f5683.lXVCWIMWIqDLqFIt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbcFAVlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jun 2016 17:41:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use bit_spin_lock
has been added to the -mm tree.  Its filename is
     zsmalloc-use-bit_spin_lock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-use-bit_spin_lock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-use-bit_spin_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: use bit_spin_lock

Use kernel standard bit spin-lock instead of custom mess.  Even, it has a
bug which doesn't disable preemption.  The reason we don't have any
problem is that we have used it during preemption disable section by
class->lock spinlock.  So no need to go to stable.

Link: http://lkml.kernel.org/r/1464736881-24886-6-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/zsmalloc.c~zsmalloc-use-bit_spin_lock mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-bit_spin_lock
+++ a/mm/zsmalloc.c
@@ -868,21 +868,17 @@ static unsigned long obj_idx_to_offset(s
 
 static inline int trypin_tag(unsigned long handle)
 {
-	unsigned long *ptr = (unsigned long *)handle;
-
-	return !test_and_set_bit_lock(HANDLE_PIN_BIT, ptr);
+	return bit_spin_trylock(HANDLE_PIN_BIT, (unsigned long *)handle);
 }
 
 static void pin_tag(unsigned long handle)
 {
-	while (!trypin_tag(handle));
+	bit_spin_lock(HANDLE_PIN_BIT, (unsigned long *)handle);
 }
 
 static void unpin_tag(unsigned long handle)
 {
-	unsigned long *ptr = (unsigned long *)handle;
