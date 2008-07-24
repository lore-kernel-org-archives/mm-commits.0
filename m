From: akpm@linux-foundation.org
Subject: - autofs4-use-struct-qstr-in-waitqc.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:20 -0700
Message-ID: <200807242329.m6ONTKc6011367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756245AbYGXX3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jmoyer@redhat.com, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: use struct qstr in waitq.c
has been removed from the -mm tree.  Its filename was
     autofs4-use-struct-qstr-in-waitqc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: use struct qstr in waitq.c
From: Jeff Moyer <jmoyer@redhat.com>

The autofs_wait_queue already contains all of the fields of the
struct qstr, so change it into a qstr.

This patch, from Jeff Moyer, has been modified a liitle by myself.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    4 -
 fs/autofs4/waitq.c    |   86 ++++++++++++++++++++--------------------
 2 files changed, 46 insertions(+), 44 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-use-struct-qstr-in-waitqc fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-use-struct-qstr-in-waitqc
+++ a/fs/autofs4/autofs_i.h
@@ -75,9 +75,7 @@ struct autofs_wait_queue {
 	struct autofs_wait_queue *next;
 	autofs_wqt_t wait_queue_token;
 	/* We use the following to see what we are waiting for */
-	unsigned int hash;
-	unsigned int len;
-	char *name;
+	struct qstr name;
 	u32 dev;
 	u64 ino;
 	uid_t uid;
diff -puN fs/autofs4/waitq.c~autofs4-use-struct-qstr-in-waitqc fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-use-struct-qstr-in-waitqc
+++ a/fs/autofs4/waitq.c
@@ -36,8 +36,10 @@ void autofs4_catatonic_mode(struct autof
 	while (wq) {
 		nwq = wq->next;
 		wq->status = -ENOENT; /* Magic is gone - report failure */
-		kfree(wq->name);
-		wq->name = NULL;
+		if (wq->name.name) {
+			kfree(wq->name.name);
+			wq->name.name = NULL;
+		}
 		wake_up_interruptible(&wq->queue);
 		wq = nwq;
 	}
@@ -92,7 +94,7 @@ static void autofs4_notify_daemon(struct
 	size_t pktsz;
 
 	DPRINTK("wait id = 0x%08lx, name = %.*s, type=%d",
-		wq->wait_queue_token, wq->len, wq->name, type);
+		wq->wait_queue_token, wq->name.len, wq->name.name, type);
 
 	memset(&pkt,0,sizeof pkt); /* For security reasons */
 
@@ -107,9 +109,9 @@ static void autofs4_notify_daemon(struct
 		pktsz = sizeof(*mp);
 
 		mp->wait_queue_token = wq->wait_queue_token;
-		mp->len = wq->len;
-		memcpy(mp->name, wq->name, wq->len);
-		mp->name[wq->len] = '\0';
+		mp->len = wq->name.len;
+		memcpy(mp->name, wq->name.name, wq->name.len);
+		mp->name[wq->name.len] = '\0';
 		break;
 	}
 	case autofs_ptype_expire_multi:
@@ -119,9 +121,9 @@ static void autofs4_notify_daemon(struct
 		pktsz = sizeof(*ep);
 
 		ep->wait_queue_token = wq->wait_queue_token;
-		ep->len = wq->len;
-		memcpy(ep->name, wq->name, wq->len);
-		ep->name[wq->len] = '\0';
+		ep->len = wq->name.len;
+		memcpy(ep->name, wq->name.name, wq->name.len);
+		ep->name[wq->name.len] = '\0';
 		break;
 	}
 	/*
@@ -138,9 +140,9 @@ static void autofs4_notify_daemon(struct
 		pktsz = sizeof(*packet);
 
 		packet->wait_queue_token = wq->wait_queue_token;
-		packet->len = wq->len;
-		memcpy(packet->name, wq->name, wq->len);
-		packet->name[wq->len] = '\0';
+		packet->len = wq->name.len;
+		memcpy(packet->name, wq->name.name, wq->name.len);
+		packet->name[wq->name.len] = '\0';
 		packet->dev = wq->dev;
 		packet->ino = wq->ino;
 		packet->uid = wq->uid;
@@ -191,15 +193,15 @@ static int autofs4_getpath(struct autofs
 }
 
 static struct autofs_wait_queue *
-autofs4_find_wait(struct autofs_sb_info *sbi,
-		  char *name, unsigned int hash, unsigned int len)
+autofs4_find_wait(struct autofs_sb_info *sbi, struct qstr *qstr)
 {
 	struct autofs_wait_queue *wq;
 
 	for (wq = sbi->queues; wq; wq = wq->next) {
-		if (wq->hash == hash &&
-		    wq->len == len &&
-		    wq->name && !memcmp(wq->name, name, len))
+		if (wq->name.hash == qstr->hash &&
+		    wq->name.len == qstr->len &&
+		    wq->name.name &&
+			 !memcmp(wq->name.name, qstr->name, qstr->len))
 			break;
 	}
 	return wq;
@@ -210,9 +212,8 @@ int autofs4_wait(struct autofs_sb_info *
 {
 	struct autofs_info *ino;
 	struct autofs_wait_queue *wq;
+	struct qstr qstr;
 	char *name;
-	unsigned int len = 0;
-	unsigned int hash = 0;
 	int status, type;
 
 	/* In catatonic mode, we don't wait for nobody */
@@ -225,22 +226,23 @@ int autofs4_wait(struct autofs_sb_info *
 
 	/* If this is a direct mount request create a dummy name */
 	if (IS_ROOT(dentry) && (sbi->type & AUTOFS_TYPE_DIRECT))
-		len = sprintf(name, "%p", dentry);
+		qstr.len = sprintf(name, "%p", dentry);
 	else {
-		len = autofs4_getpath(sbi, dentry, &name);
-		if (!len) {
+		qstr.len = autofs4_getpath(sbi, dentry, &name);
+		if (!qstr.len) {
 			kfree(name);
 			return -ENOENT;
 		}
 	}
-	hash = full_name_hash(name, len);
+	qstr.name = name;
+	qstr.hash = full_name_hash(name, qstr.len);
 
 	if (mutex_lock_interruptible(&sbi->wq_mutex)) {
-		kfree(name);
+		kfree(qstr.name);
 		return -EINTR;
 	}
 
-	wq = autofs4_find_wait(sbi, name, hash, len);
+	wq = autofs4_find_wait(sbi, &qstr);
 	ino = autofs4_dentry_ino(dentry);
 	if (!wq && ino && notify == NFY_NONE) {
 		/*
@@ -254,10 +256,10 @@ int autofs4_wait(struct autofs_sb_info *
 			mutex_unlock(&sbi->wq_mutex);
 			schedule_timeout_interruptible(HZ/10);
 			if (mutex_lock_interruptible(&sbi->wq_mutex)) {
-				kfree(name);
+				kfree(qstr.name);
 				return -EINTR;
 			}
-			wq = autofs4_find_wait(sbi, name, hash, len);
+			wq = autofs4_find_wait(sbi, &qstr);
 			if (wq)
 				break;
 		}
@@ -268,7 +270,7 @@ int autofs4_wait(struct autofs_sb_info *
 		 * return status of the wait.
 		 */
 		if (!wq) {
-			kfree(name);
+			kfree(qstr.name);
 			mutex_unlock(&sbi->wq_mutex);
 			return 0;
 		}
@@ -278,7 +280,7 @@ int autofs4_wait(struct autofs_sb_info *
 		/* Create a new wait queue */
 		wq = kmalloc(sizeof(struct autofs_wait_queue),GFP_KERNEL);
 		if (!wq) {
-			kfree(name);
+			kfree(qstr.name);
 			mutex_unlock(&sbi->wq_mutex);
 			return -ENOMEM;
 		}
@@ -289,9 +291,7 @@ int autofs4_wait(struct autofs_sb_info *
 		wq->next = sbi->queues;
 		sbi->queues = wq;
 		init_waitqueue_head(&wq->queue);
-		wq->hash = hash;
-		wq->name = name;
-		wq->len = len;
+		memcpy(&wq->name, &qstr, sizeof(struct qstr));
 		wq->dev = autofs4_get_dev(sbi);
 		wq->ino = autofs4_get_ino(sbi);
 		wq->uid = current->uid;
@@ -319,16 +319,18 @@ int autofs4_wait(struct autofs_sb_info *
 		}
 
 		DPRINTK("new wait id = 0x%08lx, name = %.*s, nfy=%d\n",
-			(unsigned long) wq->wait_queue_token, wq->len, wq->name, notify);
+			(unsigned long) wq->wait_queue_token, wq->name.len,
+			wq->name.name, notify);
 
 		/* autofs4_notify_daemon() may block */
 		autofs4_notify_daemon(sbi, wq, type);
 	} else {
 		atomic_inc(&wq->wait_ctr);
 		mutex_unlock(&sbi->wq_mutex);
-		kfree(name);
+		kfree(qstr.name);
 		DPRINTK("existing wait id = 0x%08lx, name = %.*s, nfy=%d",
-			(unsigned long) wq->wait_queue_token, wq->len, wq->name, notify);
+			(unsigned long) wq->wait_queue_token, wq->name.len,
+			wq->name.name, notify);
 	}
 
 	/* wq->name is NULL if and only if the lock is already released */
@@ -336,11 +338,13 @@ int autofs4_wait(struct autofs_sb_info *
 	if (sbi->catatonic) {
 		/* We might have slept, so check again for catatonic mode */
 		wq->status = -ENOENT;
-		kfree(wq->name);
-		wq->name = NULL;
+		if (wq->name.name) {
+			kfree(wq->name.name);
+			wq->name.name = NULL;
+		}
 	}
 
-	if (wq->name) {
+	if (wq->name.name) {
 		/* Block all but "shutdown" signals while waiting */
 		sigset_t oldset;
 		unsigned long irqflags;
@@ -351,7 +355,7 @@ int autofs4_wait(struct autofs_sb_info *
 		recalc_sigpending();
 		spin_unlock_irqrestore(&current->sighand->siglock, irqflags);
 
-		wait_event_interruptible(wq->queue, wq->name == NULL);
+		wait_event_interruptible(wq->queue, wq->name.name == NULL);
 
 		spin_lock_irqsave(&current->sighand->siglock, irqflags);
 		current->blocked = oldset;
@@ -388,8 +392,8 @@ int autofs4_wait_release(struct autofs_s
 
 	*wql = wq->next;	/* Unlink from chain */
 	mutex_unlock(&sbi->wq_mutex);
-	kfree(wq->name);
-	wq->name = NULL;	/* Do not wait on this queue */
+	kfree(wq->name.name);
+	wq->name.name = NULL;	/* Do not wait on this queue */
 
 	wq->status = status;
 
_

Patches currently in -mm which might be from jmoyer@redhat.com are

origin.patch

