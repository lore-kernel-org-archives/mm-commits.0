From: akpm@linux-foundation.org
Subject: - idr-introduce-ridr_init.patch removed from -mm tree
Date: Mon, 05 May 2008 09:28:43 -0700
Message-ID: <200805051628.m45GShx7025489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752451AbYEEQaD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 12:30:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Nadia.Derbey@bull.net, jim.houston@comcast.net, manfred@colorfullife.com, nickpiggin@yahoo.com.au, paulmck@us.ibm.com, peifferp@gmail.com, mm-commits@vger.kernel.org


The patch titled
     idr: introduce ridr_init()
has been removed from the -mm tree.  Its filename was
     idr-introduce-ridr_init.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: idr: introduce ridr_init()
From: Nadia Derbey <Nadia.Derbey@bull.net>

Introduce the ridr_init() routine.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Jim Houston <jim.houston@comcast.net>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Pierre Peiffer <peifferp@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ridr.h |    1 +
 lib/ridr.c           |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff -puN include/linux/ridr.h~idr-introduce-ridr_init include/linux/ridr.h
--- a/include/linux/ridr.h~idr-introduce-ridr_init
+++ a/include/linux/ridr.h
@@ -44,6 +44,7 @@ struct ridr {
  * This is what we export.
  */
 int ridr_pre_get(struct ridr *, gfp_t);
+void ridr_init(struct ridr *);
 
 
 void __init ridr_init_cache(void);
diff -puN lib/ridr.c~idr-introduce-ridr_init lib/ridr.c
--- a/lib/ridr.c~idr-introduce-ridr_init
+++ a/lib/ridr.c
@@ -70,3 +70,17 @@ void __init ridr_init_cache(void)
 				ridr_cache_ctor);
 }
 
+/**
+ * ridr_init - initialize ridr handle
+ * @idp:	ridr handle
+ *
+ * This function is used to set up the handle (@idp) that you will pass
+ * to the rest of the functions.
+ */
+void ridr_init(struct ridr *idp)
+{
+	memset(idp, 0, sizeof(struct ridr));
+	spin_lock_init(&idp->lock);
+}
+EXPORT_SYMBOL(ridr_init);
+
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

origin.patch
idr-introduce-ridr_init.patch
idr-introduce-ridr_get_new_above.patch
idr-introduce-ridr_get_new.patch
idr-introduce-ridr_find.patch
idr-introduce-ridr_remove.patch
ipc-integrate-the-ridr-code-into-ipc-code.patch
ipc-get-rid-of-ipc_lock_down.patch

