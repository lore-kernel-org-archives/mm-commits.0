From: akpm@linux-foundation.org
Subject: [merged] revert-parts-of-hlist-drop-the-node-parameter-from-iterators.patch removed from -mm tree
Date: Mon, 11 Mar 2013 13:16:42 -0700
Message-ID: <20130311201642.864EA5A41E9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:62887 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab3CKUQn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Mar 2013 16:16:43 -0400
Received: by mail-ye0-f202.google.com with SMTP id q5so423187yen.5
        for <mm-commits@vger.kernel.org>; Mon, 11 Mar 2013 13:16:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, paulmck@linux.vnet.ibm.com, peter.senna@gmail.com, rusty@rustcorp.com.au, sasha.levin@oracle.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: Revert parts of "hlist: drop the node parameter from iterators"
has been removed from the -mm tree.  Its filename was
     revert-parts-of-hlist-drop-the-node-parameter-from-iterators.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: Revert parts of "hlist: drop the node parameter from iterators"

commit b67bfe0d42 "hlist: drop the node parameter from iterators" did a
lot of nice changes but also contains two small hunks that seem to have
slipped in accidentally and have no apparent connection to the intent of
the patch.

This reverts the two extraneous changes.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/smpboot.c      |    2 +-
 net/9p/trans_virtio.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/smpboot.c~revert-parts-of-hlist-drop-the-node-parameter-from-iterators kernel/smpboot.c
--- a/kernel/smpboot.c~revert-parts-of-hlist-drop-the-node-parameter-from-iterators
+++ a/kernel/smpboot.c
@@ -131,7 +131,7 @@ static int smpboot_thread_fn(void *data)
 			continue;
 		}
 
-		//BUG_ON(td->cpu != smp_processor_id());
+		BUG_ON(td->cpu != smp_processor_id());
 
 		/* Check for state change setup */
 		switch (td->status) {
diff -puN net/9p/trans_virtio.c~revert-parts-of-hlist-drop-the-node-parameter-from-iterators net/9p/trans_virtio.c
--- a/net/9p/trans_virtio.c~revert-parts-of-hlist-drop-the-node-parameter-from-iterators
+++ a/net/9p/trans_virtio.c
@@ -655,7 +655,7 @@ static struct p9_trans_module p9_virtio_
 	.create = p9_virtio_create,
 	.close = p9_virtio_close,
 	.request = p9_virtio_request,
-	//.zc_request = p9_virtio_zc_request,
+	.zc_request = p9_virtio_zc_request,
 	.cancel = p9_virtio_cancel,
 	/*
 	 * We leave one entry for input and one entry for response
_

Patches currently in -mm which might be from arnd@arndb.de are

linux-next.patch
kconfig-consolidate-config_debug_strict_user_copy_checks.patch

