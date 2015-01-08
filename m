From: akpm@linux-foundation.org
Subject: [failures]
 kernel-async-fixed-the-wrong-waitting-condition-of-wait_event.patch removed from -mm tree
Date: Wed, 07 Jan 2015 16:42:25 -0800
Message-ID: <54add271.FNzEZsDUdAUwy2ll%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbbAHAm0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2015 19:42:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.yang@spreadtrum.com, arjan@infradead.org, chunyan.zhang@spreadtrum.com, geng.ren@spreadtrum.com, tj@kernel.org, wei.qiao@spreadtrum.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/async.c: fix wrong waiting condition of wait_event
has been removed from the -mm tree.  Its filename was
     kernel-async-fixed-the-wrong-waitting-condition-of-wait_event.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Yonghui Yang <mark.yang@spreadtrum.com>
Subject: kernel/async.c: fix wrong waiting condition of wait_event

Change the waitting condition of wait_event in
async_synchronize_cookie_domain().

This function waits until all asynchronous function calls for the certain
domain have been done.

But, lowest_in_progress() returns the lowest *pending* entry's cookie.

So we should make sure that the return value of lowest_in_progress(domain)
must be larger than @cookie.

Signed-off-by: Yonghui Yang <mark.yang@spreadtrum.com>
Signed-off-by: Geng Ren <geng.ren@spreadtrum.com>
Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Tested-by: Wei Qiao <wei.qiao@spreadtrum.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/async.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/async.c~kernel-async-fixed-the-wrong-waitting-condition-of-wait_event kernel/async.c
--- a/kernel/async.c~kernel-async-fixed-the-wrong-waitting-condition-of-wait_event
+++ a/kernel/async.c
@@ -267,7 +267,7 @@ EXPORT_SYMBOL_GPL(async_unregister_domai
  */
 void async_synchronize_full_domain(struct async_domain *domain)
 {
-	async_synchronize_cookie_domain(ASYNC_COOKIE_MAX, domain);
+	async_synchronize_cookie_domain(ASYNC_COOKIE_MAX-1, domain);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 
@@ -289,7 +289,7 @@ void async_synchronize_cookie_domain(asy
 		starttime = ktime_get();
 	}
 
-	wait_event(async_done, lowest_in_progress(domain) >= cookie);
+	wait_event(async_done, lowest_in_progress(domain) > cookie);
 
 	if (initcall_debug && system_state == SYSTEM_BOOTING) {
 		endtime = ktime_get();
_

Patches currently in -mm which might be from mark.yang@spreadtrum.com are


