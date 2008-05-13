From: akpm@linux-foundation.org
Subject: - dlm-convert-connections_lock-in-a-mutex.patch removed from -mm tree
Date: Tue, 13 May 2008 14:34:34 -0700
Message-ID: <200805132134.m4DLYYGs000933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761124AbYEMVey (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 May 2008 17:34:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: matthias@kaehlcke.net, ccaulfie@redhat.com, swhiteho@redhat.com, teigland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     dlm: convert connections_lock in a mutex
has been removed from the -mm tree.  Its filename was
     dlm-convert-connections_lock-in-a-mutex.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dlm: convert connections_lock in a mutex
From: Matthias Kaehlcke <matthias@kaehlcke.net>

The semaphore connections_lock is used as a mutex.  Convert it to the mutex
API.

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dlm/lowcomms.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/dlm/lowcomms.c~dlm-convert-connections_lock-in-a-mutex fs/dlm/lowcomms.c
--- a/fs/dlm/lowcomms.c~dlm-convert-connections_lock-in-a-mutex
+++ a/fs/dlm/lowcomms.c
@@ -138,7 +138,7 @@ static struct workqueue_struct *recv_wor
 static struct workqueue_struct *send_workqueue;
 
 static DEFINE_IDR(connections_idr);
-static DECLARE_MUTEX(connections_lock);
+static DEFINE_MUTEX(connections_lock);
 static int max_nodeid;
 static struct kmem_cache *con_cache;
 
@@ -205,9 +205,9 @@ static struct connection *nodeid2con(int
 {
 	struct connection *con;
 
-	down(&connections_lock);
+	mutex_lock(&connections_lock);
 	con = __nodeid2con(nodeid, allocation);
-	up(&connections_lock);
+	mutex_unlock(&connections_lock);
 
 	return con;
 }
@@ -218,15 +218,15 @@ static struct connection *assoc2con(int 
 	int i;
 	struct connection *con;
 
-	down(&connections_lock);
+	mutex_lock(&connections_lock);
 	for (i=0; i<=max_nodeid; i++) {
 		con = __nodeid2con(i, 0);
 		if (con && con->sctp_assoc == assoc_id) {
-			up(&connections_lock);
+			mutex_unlock(&connections_lock);
 			return con;
 		}
 	}
-	up(&connections_lock);
+	mutex_unlock(&connections_lock);
 	return NULL;
 }
 
@@ -381,7 +381,7 @@ static void sctp_init_failed(void)
 	int i;
 	struct connection *con;
 
-	down(&connections_lock);
+	mutex_lock(&connections_lock);
 	for (i=1; i<=max_nodeid; i++) {
 		con = __nodeid2con(i, 0);
 		if (!con)
@@ -393,7 +393,7 @@ static void sctp_init_failed(void)
 			}
 		}
 	}
-	up(&connections_lock);
+	mutex_unlock(&connections_lock);
 }
 
 /* Something happened to an association */
@@ -1417,7 +1417,7 @@ void dlm_lowcomms_stop(void)
 	/* Set all the flags to prevent any
 	   socket activity.
 	*/
-	down(&connections_lock);
+	mutex_lock(&connections_lock);
 	for (i = 0; i <= max_nodeid; i++) {
 		con = __nodeid2con(i, 0);
 		if (con) {
@@ -1426,11 +1426,11 @@ void dlm_lowcomms_stop(void)
 				con->sock->sk->sk_user_data = NULL;
 		}
 	}
-	up(&connections_lock);
+	mutex_unlock(&connections_lock);
 
 	work_stop();
 
-	down(&connections_lock);
+	mutex_lock(&connections_lock);
 	clean_writequeues();
 
 	for (i = 0; i <= max_nodeid; i++) {
@@ -1443,7 +1443,7 @@ void dlm_lowcomms_stop(void)
 		}
 	}
 	max_nodeid = 0;
-	up(&connections_lock);
+	mutex_unlock(&connections_lock);
 	kmem_cache_destroy(con_cache);
 	idr_init(&connections_idr);
 }
_

Patches currently in -mm which might be from matthias@kaehlcke.net are

linux-next.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex.patch
arm-omap1-n770-convert-audio_pwr_sem-in-a-mutex-fix.patch
pxafb-convert-ctrlr_sem-in-a-mutex.patch
sa1100fb-convert-ctrlr_sem-in-a-mutex.patch
hfs-convert-bitmap_lock-in-a-mutex.patch
hfs-convert-extents_lock-in-a-mutex.patch
hfsplus-convert-the-extents_lock-in-a-mutex.patch
affs-convert-s_bmlock-into-a-mutex.patch

