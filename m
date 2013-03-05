From: akpm@linux-foundation.org
Subject: + revert-parts-of-hlist-drop-the-node-parameter-from-iterators.patch added to -mm tree
Date: Tue, 05 Mar 2013 14:45:02 -0800
Message-ID: <20130305224502.8676E31C20C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:41718 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3CEWpE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Mar 2013 17:45:04 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so414304qaj.5
        for <mm-commits@vger.kernel.org>; Tue, 05 Mar 2013 14:45:03 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, paulmck@linux.vnet.ibm.com, peter.senna@gmail.com, rusty@rustcorp.com.au, sasha.levin@oracle.com, tglx@linutronix.de


The patch titled
     Subject: Revert parts of "hlist: drop the node parameter from iterators"
has been added to the -mm tree.  Its filename is
     revert-parts-of-hlist-drop-the-node-parameter-from-iterators.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
revert-parts-of-hlist-drop-the-node-parameter-from-iterators.patch
kconfig-consolidate-config_debug_strict_user_copy_checks.patch

