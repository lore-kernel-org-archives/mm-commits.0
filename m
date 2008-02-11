From: akpm@linux-foundation.org
Subject: + ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch added to -mm tree
Date: Mon, 11 Feb 2008 12:48:27 -0800
Message-ID: <200802112048.m1BKmRx0032197@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbYBKU6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 15:58:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net, cmm@us.ibm.com, matthltc@us.ibm.com, pierre.peiffer@bull.net, y-goto@jp.fujitsu.com


The patch titled
     ipc: invoke the ipcns notifier chain as a work item
has been added to the -mm tree.  Its filename is
     ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ipc: invoke the ipcns notifier chain as a work item
From: Nadia Derbey <Nadia.Derbey@bull.net>

Make the memory hotplug chain's mutex held for a shorter time: when memory is
offlined or onlined a work item is added to the global workqueue.  When the
work item is run, it notifies the ipcns notifier chain with the
IPCNS_MEMCHANGED event.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff -puN ipc/util.c~ipc-invoke-the-ipcns-notifier-chain-as-a-work-item ipc/util.c
--- a/ipc/util.c~ipc-invoke-the-ipcns-notifier-chain-as-a-work-item
+++ a/ipc/util.c
@@ -58,6 +58,14 @@ atomic_t nr_ipc_ns = ATOMIC_INIT(1);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 
+static void ipc_memory_notifier(struct work_struct *work)
+{
+	ipcns_notify(IPCNS_MEMCHANGED);
+}
+
+static DECLARE_WORK(ipc_memory_wq, ipc_memory_notifier);
+
+
 static int ipc_memory_callback(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
@@ -67,8 +75,13 @@ static int ipc_memory_callback(struct no
 		/*
 		 * This is done by invoking the ipcns notifier chain with the
 		 * IPC_MEMCHANGED event.
+		 * In order not to keep the lock on the hotplug memory chain
+		 * for too long, queue a work item that will, when waken up,
+		 * activate the ipcns notification chain.
+		 * No need to keep several ipc work items on the queue.
 		 */
-		ipcns_notify(IPCNS_MEMCHANGED);
+		if (!work_pending(&ipc_memory_wq))
+			schedule_work(&ipc_memory_wq);
 		break;
 	case MEM_GOING_ONLINE:
 	case MEM_GOING_OFFLINE:
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
ipc-use-ipc_buildid-directly-from-ipc_addid.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-scale-msgmni-to-the-amount-of-lowmem.patch
ipc-scale-msgmni-to-the-number-of-ipc-namespaces.patch
ipc-define-the-slab_memory_callback-priority-as-a-constant.patch
ipc-recompute-msgmni-on-memory-add--remove.patch
ipc-invoke-the-ipcns-notifier-chain-as-a-work-item.patch
ipc-recompute-msgmni-on-ipc-namespace-creation-removal.patch
ipc-do-not-recompute-msgmni-anymore-if-explicitly-set-by-user.patch
ipc-re-enable-msgmni-automatic-recomputing-msgmni-if-set-to-negative.patch
