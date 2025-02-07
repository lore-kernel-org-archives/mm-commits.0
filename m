Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005BD1DC04A
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 23:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738972288; cv=none; b=Nvf81UDcLRzuHS1BoQ4Me8DTMhmLED1J0z3f2rI2i/MwjQBv8k5Zess1/ahT10jCgDbuiKBMjcWwrh/MItdlVYhqs+VnhC2r0mQvLJJcGr3MzQNsh5A5ipG1WMNgCy50PORG+bDpsiQmfeC7d8mK2hBA4YWe/9iChSMqDG8rjFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738972288; c=relaxed/simple;
	bh=zPaGCz8xM2h2lRdQtjUxSR4NNfnvaEVuombsOFPVm1c=;
	h=Date:To:From:Subject:Message-Id; b=cZJKztiF2gCiFyycPIXxN0ul31ktyliE+szpvXb6S5qRkdpekEIOSJ+v/+SLTa/3wggQRuRcEvNwFALt24k8jPZm1hto3uu4JigTMO2WnMmziUwASjeshE/51t/UuJ7ta7Tq7E3RJRsPji30ro8IPRAJx/zrM6Wnn32M2qK6zqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2BU+wuCR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2BU+wuCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4852C4CED1;
	Fri,  7 Feb 2025 23:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738972287;
	bh=zPaGCz8xM2h2lRdQtjUxSR4NNfnvaEVuombsOFPVm1c=;
	h=Date:To:From:Subject:From;
	b=2BU+wuCR1iGjLe8H1LvTgXsHARgYlDxxveI/9uXW28pFFesq2A28br5MnZs/l3RDc
	 BqG/rWxRIvzQEOiwKMMQqGaUyIIfHV5ckrd1SOTfVUGcOXv2v3yccIEz/6D7eOEmiZ
	 PI1nZnLLvn1izPFUxIvEldSF7ZGSFsUrzEMW5i5k=
Date: Fri, 07 Feb 2025 15:51:27 -0800
To: mm-commits@vger.kernel.org,yuehongwu@tencent.com,urezki@gmail.com,tglx@linutronix.de,rostedt@goodmis.org,qiang.zhang1211@gmail.com,paulmck@kernel.org,mengensun@tencent.com,mathieu.desnoyers@efficios.com,josh@joshtriplett.org,joel@joelfernandes.org,jiangshanlai@gmail.com,boqun.feng@gmail.com,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ucount-use-rcuref_t-for-reference-counting.patch added to mm-nonmm-unstable branch
Message-Id: <20250207235127.A4852C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ucount: Use rcuref_t for reference counting
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ucount-use-rcuref_t-for-reference-counting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ucount-use-rcuref_t-for-reference-counting.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: ucount: Use rcuref_t for reference counting
Date: Mon, 3 Feb 2025 16:05:25 +0100

Use rcuref_t for reference counting.  This eliminates the cmpxchg loop in
the get and put path.  This also eliminates the need to acquire the lock
in the put path because once the final user returns the reference, it can
no longer be obtained anymore.

Use rcuref_t for reference counting.

Link: https://lkml.kernel.org/r/20250203150525.456525-5-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Acked-by:Thomas Gleixner <tglx@linutronix.de>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mengen Sun <mengensun@tencent.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: YueHong Wu <yuehongwu@tencent.com>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/user_namespace.h |   11 +++++++++--
 kernel/ucount.c                |   16 +++++-----------
 2 files changed, 14 insertions(+), 13 deletions(-)

--- a/include/linux/user_namespace.h~ucount-use-rcuref_t-for-reference-counting
+++ a/include/linux/user_namespace.h
@@ -8,6 +8,7 @@
 #include <linux/rculist_nulls.h>
 #include <linux/sched.h>
 #include <linux/workqueue.h>
+#include <linux/rcuref.h>
 #include <linux/rwsem.h>
 #include <linux/sysctl.h>
 #include <linux/err.h>
@@ -120,7 +121,7 @@ struct ucounts {
 	struct user_namespace *ns;
 	kuid_t uid;
 	struct rcu_head rcu;
-	atomic_t count;
+	rcuref_t count;
 	atomic_long_t ucount[UCOUNT_COUNTS];
 	atomic_long_t rlimit[UCOUNT_RLIMIT_COUNTS];
 };
@@ -133,9 +134,15 @@ void retire_userns_sysctls(struct user_n
 struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid, enum ucount_type type);
 void dec_ucount(struct ucounts *ucounts, enum ucount_type type);
 struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid);
-struct ucounts * __must_check get_ucounts(struct ucounts *ucounts);
 void put_ucounts(struct ucounts *ucounts);
 
+static inline struct ucounts * __must_check get_ucounts(struct ucounts *ucounts)
+{
+	if (rcuref_get(&ucounts->count))
+		return ucounts;
+	return NULL;
+}
+
 static inline long get_rlimit_value(struct ucounts *ucounts, enum rlimit_type type)
 {
 	return atomic_long_read(&ucounts->rlimit[type]);
--- a/kernel/ucount.c~ucount-use-rcuref_t-for-reference-counting
+++ a/kernel/ucount.c
@@ -11,7 +11,7 @@
 struct ucounts init_ucounts = {
 	.ns    = &init_user_ns,
 	.uid   = GLOBAL_ROOT_UID,
-	.count = ATOMIC_INIT(1),
+	.count = RCUREF_INIT(1),
 };
 
 #define UCOUNTS_HASHTABLE_BITS 10
@@ -138,7 +138,7 @@ static struct ucounts *find_ucounts(stru
 	guard(rcu)();
 	hlist_nulls_for_each_entry_rcu(ucounts, pos, hashent, node) {
 		if (uid_eq(ucounts->uid, uid) && (ucounts->ns == ns)) {
-			if (atomic_inc_not_zero(&ucounts->count))
+			if (rcuref_get(&ucounts->count))
 				return ucounts;
 		}
 	}
@@ -154,13 +154,6 @@ static void hlist_add_ucounts(struct uco
 	spin_unlock_irq(&ucounts_lock);
 }
 
-struct ucounts *get_ucounts(struct ucounts *ucounts)
-{
-	if (atomic_inc_not_zero(&ucounts->count))
-		return ucounts;
-	return NULL;
-}
-
 struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 {
 	struct hlist_nulls_head *hashent = ucounts_hashentry(ns, uid);
@@ -176,7 +169,7 @@ struct ucounts *alloc_ucounts(struct use
 
 	new->ns = ns;
 	new->uid = uid;
-	atomic_set(&new->count, 1);
+	rcuref_init(&new->count, 1);
 
 	spin_lock_irq(&ucounts_lock);
 	ucounts = find_ucounts(ns, uid, hashent);
@@ -196,7 +189,8 @@ void put_ucounts(struct ucounts *ucounts
 {
 	unsigned long flags;
 
-	if (atomic_dec_and_lock_irqsave(&ucounts->count, &ucounts_lock, flags)) {
+	if (rcuref_put(&ucounts->count)) {
+		spin_lock_irqsave(&ucounts_lock, flags);
 		hlist_nulls_del_rcu(&ucounts->node);
 		spin_unlock_irqrestore(&ucounts_lock, flags);
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are

rcu-provide-a-static-initializer-for-hlist_nulls_head.patch
ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero.patch
ucount-use-rcu-for-ucounts-lookups.patch
ucount-use-rcuref_t-for-reference-counting.patch

