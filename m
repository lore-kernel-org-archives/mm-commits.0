From: akpm@linux-foundation.org
Subject: - extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:02:27 -0800
Message-ID: <200703060102.l2612Shv007082@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43929 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932850AbXCFBCm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:02:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, mm-commits@vger.kernel.org


The patch titled
     
has been removed from the -mm tree.  Its filename was
     extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch

This patch was dropped because it was folded into extend-notifier_call_chain-to-count-nr_calls-made.patch

------------------------------------------------------
Subject: 
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

kernel/sys.c:359: error: conflicting types for '__blocking_notifier_call_chain'
include/linux/notifier.h:140: error: previous declaration of '__blocking_notifier_call_chain' was here
kernel/sys.c:375: error: conflicting types for '__blocking_notifier_call_chain'
include/linux/notifier.h:140: error: previous declaration of '__blocking_notifier_call_chain' was here

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sys.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~extend-notifier_call_chain-to-count-nr_calls-made-fixes-3 kernel/sys.c
--- a/kernel/sys.c~extend-notifier_call_chain-to-count-nr_calls-made-fixes-3
+++ a/kernel/sys.c
@@ -354,7 +354,7 @@ EXPORT_SYMBOL_GPL(blocking_notifier_chai
  
 int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 				   unsigned long val, void *v,
-				   int nr_to_call, unsigned int *nr_calls)
+				   int nr_to_call, int *nr_calls)
 {
 	int ret = NOTIFY_DONE;
 
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

origin.patch
git-ia64.patch
git-input.patch
i386-irq-kill-irq-compression-fix.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
reiser4-configh.patch
