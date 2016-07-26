From: akpm@linux-foundation.org
Subject: [patch 046/126] zsmalloc: use bit_spin_lock
Date: Tue, 26 Jul 2016 15:23:14 -0700
Message-ID: <5797e2d2.Znb83twL9g1Kbnfb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56716 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbcGZWXP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:23:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz

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
