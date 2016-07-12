From: akpm@linux-foundation.org
Subject: + ipc-sem-sem_lock-with-hysteresis.patch added to -mm tree
Date: Tue, 12 Jul 2016 14:30:18 -0700
Message-ID: <5785616a.MsTGcw3FvQAhrhyy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbcGLVaY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2016 17:30:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, 1vier1@web.de, dave@stgolabs.net, hpa@zytor.com, mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: sem_lock with hysteresis
has been added to the -mm tree.  Its filename is
     ipc-sem-sem_lock-with-hysteresis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-sem_lock-with-hysteresis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-sem_lock-with-hysteresis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Return-Path: <manfred@colorfullife.com>
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on y.localdomain
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=2.5 tests=BAYES_00,T_DKIM_INVALID
	autolearn=ham autolearn_force=no version=3.4.1
Received: from y.localdomain (localhost [127.0.0.1])
	by y.localdomain (8.14.9/8.14.9/Debian-4) with ESMTP id u5PHcSjA013494
	for <akpm@localhost>; Sat, 25 Jun 2016 10:38:29 -0700
X-Original-To: akpm@mail.linuxfoundation.org
Delivered-To: akpm@mail.linuxfoundation.org
Received: from mail.linuxfoundation.org [140.211.169.12]
	by y.localdomain with IMAP (fetchmail-6.3.26)
	for <akpm@localhost> (single-drop); Sat, 25 Jun 2016 10:38:29 -0700 (PDT)
Received: from smtp1.linuxfoundation.org (smtp1.linux-foundation.org [172.17.192.35])
	by mail.linuxfoundation.org (Postfix) with ESMTPS id F0D7B9D
	for <akpm@mail.linuxfoundation.org>; Sat, 25 Jun 2016 17:38:25 +0000 (UTC)
X-Greylist: whitelisted by SQLgrey-1.7.6
Received: from mail-lf0-f69.google.com (mail-lf0-f69.google.com [209.85.215.69])
	by smtp1.linuxfoundation.org (Postfix) with ESMTPS id C9DFF21F
	for <akpm@mail.linuxfoundation.org>; Sat, 25 Jun 2016 17:38:24 +0000 (UTC)
Received: by mail-lf0-f69.google.com with SMTP id l184so94987549lfl.3
        for <akpm@mail.linuxfoundation.org>; Sat, 25 Jun 2016 10:38:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20130820;
        h=x-gm-message-state:dkim-signature:from:to:cc:subject:date
         :message-id:in-reply-to:references:delivered-to;
        bh=sEFU3vdxB2LcdX4M8JlJhPYqz/sl12SexaAlUndXyeY=;
        b=OcQRqNbQPwbdDNcNazahlTS0P2vlnp+0VICs1WO94HxOV31t5IbAqo6zdy2JK+d2P8
         vCcQ0tTMP1ymZcYrHKGTXPsooCg1qpABWl1EmDyaQ6vzZeRS6NyOx6XMygZY/4rkDoNT
         9VSf0JucQ6gvqS1IXFClMSl2V/4LJ53L3V/oTYncSF3V/t8i8WF8do6YwC5MrfWMbEpZ
         6eR/sBFEvz7Z9l8aGMSHnUZDiNgP75JDCuvCyaYGDG1nj/qzi3JDRPhxP+57u3La/Zb8
         zYM9c39n7K4L8EA579Px66VasjdPqQJ9T+EqkLVrmok1yy14w1pNSms7NkWW8X4TgzzF
         NuEw==
X-Gm-Message-State: ALyK8tLbYxKSZZDmVgloI1m4Q8qQIqvtu3iz19bDyQVDyE61yVwVGTVK+NMswuxdBhfruC4dp6h531izoE1C+n1KOAUR2rSIP1KMfcj/7kP36zdoJaWAOLvcc9e/dCfevnEqISotUcVfXo2dX9bWYbMpttApgUlG/TtI2D94vjzWaPSET6k2IM66zdQJPOkpS8N1MNdsGkonNJmJJpVlTGZXFaPUo4fYsxZYDjVie0z18p3vNGYl28dYpElUaQ1NrDQHs41IOZdK66LFxPxvkvwtv6WTHht8q/LLoEAaZCOMmE8QfDEQS3E1yia1iG4VaJzP/NM=
X-Received: by 10.28.88.206 with SMTP id m197mr3215991wmb.18.1466876303021;
        Sat, 25 Jun 2016 10:38:23 -0700 (PDT)
X-Received: by 10.28.88.206 with SMTP id m197mr3215972wmb.18.1466876302511;
        Sat, 25 Jun 2016 10:38:22 -0700 (PDT)
Received: from mail-wm0-x241.google.com (mail-wm0-x241.google.com. [2a00:1450:400c:c09::241])
        by mx.google.com with ESMTPS id bd7si15323610wjb.138.2016.06.25.10.38.22
        for <akpm@linux-foundation.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 Jun 2016 10:38:22 -0700 (PDT)
Received-SPF: pass (google.com: domain of manfred@colorfullife.com designates 2a00:1450:400c:c09::241 as permitted sender) client-ip=2a00:1450:400c:c09::241;
Authentication-Results: mx.google.com;
       dkim=pass header.i=@colorfullife-com.20150623.gappssmtp.com;
       spf=pass (google.com: domain of manfred@colorfullife.com designates 2a00:1450:400c:c09::241 as permitted sender) smtp.mailfrom=manfred@colorfullife.com
Received: by mail-wm0-x241.google.com with SMTP id a66so13527720wme.2
        for <akpm@linux-foundation.org>; Sat, 25 Jun 2016 10:38:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sEFU3vdxB2LcdX4M8JlJhPYqz/sl12SexaAlUndXyeY=;
        b=z4THjH/t/dojyynYgHIsnX2f6WCeDdYslNIFG1i1+6nljCh+ZeZprjokSscZy7aHba
         vLbDcem4T0fVBprW3OCGwR89RJ82BO8NyFOQoqlgK+kYseYM7OvckysBALl3ZZqzanPM
         Fd5Ma+CYAoTyvDjjQGCY+pivvmiAdItLaNCKb2gi6nNt7CoHUJMFIeqmxCdgiKiGbVs3
         wOBhRkPqnoNI4kUC9OyLi/V37dmAEZJpNzD8GSByjXJMnU5CsBKRVcYh0a0pFFWjFAyK
         4/Fb4iQNE2YM4apvcCgcBJWOYePR5C9E5s1+0cmtj/wTjbzHj6BE0spLG2OIE2ae/KrE
         UCkg==
X-Received: by 10.194.82.74 with SMTP id g10mr8706800wjy.11.1466876302111;
        Sat, 25 Jun 2016 10:38:22 -0700 (PDT)
Received: from localhost.localdomain (dslb-088-071-110-173.088.071.pools.vodafone-ip.de. [88.71.110.173])
        by smtp.googlemail.com with ESMTPSA id a4sm4630275wjq.40.2016.06.25.10.38.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 Jun 2016 10:38:21 -0700 (PDT)
To: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <dave@stgolabs.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, 1vier1@web.de,
        felixh@informatik.uni-bremen.de,
        Manfred Spraul <manfred@colorfullife.com>
Subject: ipc/sem: sem_lock with hysteresis
Date: Sat, 25 Jun 2016 19:37:52 +0200
Message-Id: <1466876272-3824-3-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 2.5.5
In-Reply-To: <1466876272-3824-2-git-send-email-manfred@colorfullife.com>
References: <1466876272-3824-1-git-send-email-manfred@colorfullife.com>
 <1466876272-3824-2-git-send-email-manfred@colorfullife.com>
Delivered-To: akpm@linux-foundation.org

sysv sem has two lock modes: One with per-semaphore locks, one lock mode
with a single big lock for the whole array.
When switching from the per-semaphore locks to the big lock, all
per-semaphore locks must be scanned for ongoing operations.

The patch adds a hysteresis for switching from the big lock to the per
semaphore locks. This reduces how often the per-semaphore locks must
be scanned.

Passed stress testing with sem-scalebench.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 include/linux/sem.h |  2 +-
 ipc/sem.c           | 89 +++++++++++++++++++++++++++++------------------------
 2 files changed, 49 insertions(+), 42 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index d0efd6e..6fb3227 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -21,7 +21,7 @@ struct sem_array {
 	struct list_head	list_id;	/* undo requests on this array */
 	int			sem_nsems;	/* no. of semaphores in array */
 	int			complex_count;	/* pending complex operations */
-	bool			complex_mode;	/* no parallel simple ops */
+	int			complex_mode;	/* >0: no parallel simple ops */
 };
 
 #ifdef CONFIG_SYSVIPC
diff --git a/ipc/sem.c b/ipc/sem.c
index 538f43a..076b7c9 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -161,6 +161,13 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it);
 #define SEMOPM_FAST	64  /* ~ 372 bytes on stack */
 
 /*
+ * Switching from the mode suitable for simple ops
+ * to the mode for complex ops is costly. Therefore:
+ * use some hysteresis
+ */
+#define COMPLEX_MODE_ENTER 10
+
+/*
  * Locking:
  * a) global sem_lock() for read/write
  *	sem_undo.id_next,
@@ -269,17 +276,25 @@ static void sem_rcu_free(struct rcu_head *head)
 /*
  * Enter the mode suitable for non-simple operations:
  * Caller must own sem_perm.lock.
+ * Note:
+ * There is no leave complex mode function. Leaving
+ * happens in sem_lock, with some hysteresis.
  */
 static void complexmode_enter(struct sem_array *sma)
 {
 	int i;
 	struct sem *sem;
 
-	if (sma->complex_mode)  {
-		/* We are already in complex_mode. Nothing to do */
+	if (sma->complex_mode > 0)  {
+		/*
+		 * We are already in complex_mode.
+		 * Nothing to do, just increase
+		 * counter until we return to simple mode
+		 */
+		WRITE_ONCE(sma->complex_mode, COMPLEX_MODE_ENTER);
 		return;
 	}
-	WRITE_ONCE(sma->complex_mode, true);
+	WRITE_ONCE(sma->complex_mode, COMPLEX_MODE_ENTER);
 
 	/* We need a full barrier:
 	 * The write to complex_mode must be visible
@@ -294,27 +309,6 @@ static void complexmode_enter(struct sem_array *sma)
 }
 
 /*
- * Try to leave the mode that disallows simple operations:
- * Caller must own sem_perm.lock.
- */
-static void complexmode_tryleave(struct sem_array *sma)
-{
-	if (sma->complex_count)  {
-		/* Complex ops are sleeping.
-		 * We must stay in complex mode
-		 */
-		return;
-	}
-	/*
-	 * Immediately after setting complex_mode to false,
-	 * a simple op can start. Thus: all memory writes
-	 * performed by the current operation must be visible
-	 * before we set complex_mode to false.
-	 */
-	smp_store_release(&sma->complex_mode, false);
-}
-
-/*
  * If the request contains only one semaphore operation, and there are
  * no complex transactions pending, lock only the semaphore involved.
  * Otherwise, lock the entire semaphore array, since we either have
@@ -372,27 +366,42 @@ static inline int sem_lock(struct sem_array *sma, struct sembuf *sops,
 	ipc_lock_object(&sma->sem_perm);
 
 	if (sma->complex_count == 0) {
-		/* False alarm:
-		 * There is no complex operation, thus we can switch
-		 * back to the fast path.
-		 */
-		spin_lock(&sem->lock);
-		ipc_unlock_object(&sma->sem_perm);
-		return sops->sem_num;
-	} else {
-		/* Not a false alarm, thus complete the sequence for a
-		 * full lock.
+		/*
+		 * Check if fast path is possible:
+		 * There is no complex operation, check hysteresis
+		 * If 0, switch back to the fast path.
 		 */
-		complexmode_enter(sma);
-		return -1;
+		if (sma->complex_mode > 0) {
+			/* Note:
+			 * Immediately after setting complex_mode to 0,
+			 * a simple op could start.
+			 * The data it would access was written by the
+			 * previous owner of sem->sem_perm.lock, i.e
+			 * a release and an acquire memory barrier ago.
+			 * No need for another barrier.
+			 */
+			WRITE_ONCE(sma->complex_mode, sma->complex_mode-1);
+		}
+		if (sma->complex_mode == 0) {
+			spin_lock(&sem->lock);
+			ipc_unlock_object(&sma->sem_perm);
+			return sops->sem_num;
+		}
 	}
+	/*
+	 * Not a false alarm, full lock is required.
+	 * Since we are already in complex_mode (either because of waiting
+	 * complex ops or due to hysteresis), there is not need for a
+	 * complexmode_enter().
+	 */
+	WARN_ON(sma->complex_mode == 0);
+	return -1;
 }
 
 static inline void sem_unlock(struct sem_array *sma, int locknum)
 {
 	if (locknum == -1) {
 		unmerge_queues(sma);
-		complexmode_tryleave(sma);
 		ipc_unlock_object(&sma->sem_perm);
 	} else {
 		struct sem *sem = sma->sem_base + locknum;
@@ -544,7 +553,7 @@ static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 	}
 
 	sma->complex_count = 0;
-	sma->complex_mode = true; /* dropped by sem_unlock below */
+	WRITE_ONCE(sma->complex_mode, COMPLEX_MODE_ENTER);
 	INIT_LIST_HEAD(&sma->pending_alter);
 	INIT_LIST_HEAD(&sma->pending_const);
 	INIT_LIST_HEAD(&sma->list_id);
@@ -2201,7 +2210,7 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 	 * The proc interface isn't aware of sem_lock(), it calls
 	 * ipc_lock_object() directly (in sysvipc_find_ipc).
 	 * In order to stay compatible with sem_lock(), we must
-	 * enter / leave complex_mode.
+	 * enter complex_mode.
 	 */
 	complexmode_enter(sma);
 
@@ -2220,8 +2229,6 @@ static int sysvipc_sem_proc_show(struct seq_file *s, void *it)
 		   sem_otime,
 		   sma->sem_ctime);
 
-	complexmode_tryleave(sma);
