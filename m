Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB35140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189508; cv=none; b=Ua3rPHvMy+H3bHDAxVS1kKWSHl/z7II0el8RQol+P+fhy69mqywz45Buw6QjG1RYpx5x+7qpcwwi4mdRHTrGcFTnEHpjiGJDwmM2AYwfBiudZlDzSXmxKDgUcVBqExywBE6oLbQ5RPpsmeLNzER1LzihZX+KP20rTnBVLRv1Pos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189508; c=relaxed/simple;
	bh=3O96sisMnAUBeXIkXqUhvmI8zExe+0eDnXmMjXuRNC0=;
	h=Date:To:From:Subject:Message-Id; b=a5pyyRpDFQUZpwB8BxGGSeMtk4aD2yoeEOI8ROB0EtM5DwfA8SNvMfkdGUSHwlSaL8zw9Ss/a08fY3yI07L3syiLrd4jjuD/SYwRX3kfvEPzAOWxpLTEq00kd9oSAjyUm526h3wgZK6GdAzK9Vq7VgRi19XmurMipeDAYbeDgE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Py26Rqs7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Py26Rqs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5F70C4CEEC;
	Mon, 17 Mar 2025 05:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189507;
	bh=3O96sisMnAUBeXIkXqUhvmI8zExe+0eDnXmMjXuRNC0=;
	h=Date:To:From:Subject:From;
	b=Py26Rqs76dc+n+IWtx0oacHdc6zMFzHhND2AipZRxRb4B6SrSgCTvVr+3iT4G4f8y
	 5/21in2c/UDjbdWmIk1+g7wkvHhuICvz6NSjLlO681BtSvLtoybZRVyY72es1cWiVZ
	 ihlxRcqlnBTzr6e4vNKe25v1iDjCtql4GEFU6gY0=
Date: Sun, 16 Mar 2025 22:31:47 -0700
To: mm-commits@vger.kernel.org,yuehongwu@tencent.com,urezki@gmail.com,tglx@linutronix.de,rostedt@goodmis.org,qiang.zhang1211@gmail.com,paulmck@kernel.org,mengensun@tencent.com,mathieu.desnoyers@efficios.com,josh@joshtriplett.org,joel@joelfernandes.org,jiangshanlai@gmail.com,boqun.feng@gmail.com,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ucount-use-rcu-for-ucounts-lookups.patch removed from -mm tree
Message-Id: <20250317053147.D5F70C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ucount: use RCU for ucounts lookups
has been removed from the -mm tree.  Its filename was
     ucount-use-rcu-for-ucounts-lookups.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: ucount: use RCU for ucounts lookups
Date: Mon, 3 Feb 2025 16:05:24 +0100

The ucounts element is looked up under ucounts_lock.  This can be
optimized by using RCU for a lockless lookup and return and element if the
reference can be obtained.

Replace hlist_head with hlist_nulls_head which is RCU compatible.  Let
find_ucounts() search for the required item within a RCU section and
return the item if a reference could be obtained.  This means
alloc_ucounts() will always return an element (unless the memory
allocation failed).  Let put_ucounts() RCU free the element if the
reference counter dropped to zero.

Link: https://lkml.kernel.org/r/20250203150525.456525-4-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
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

 include/linux/user_namespace.h |    4 +
 kernel/ucount.c                |   75 ++++++++++++++++---------------
 2 files changed, 43 insertions(+), 36 deletions(-)

--- a/include/linux/user_namespace.h~ucount-use-rcu-for-ucounts-lookups
+++ a/include/linux/user_namespace.h
@@ -5,6 +5,7 @@
 #include <linux/kref.h>
 #include <linux/nsproxy.h>
 #include <linux/ns_common.h>
+#include <linux/rculist_nulls.h>
 #include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <linux/rwsem.h>
@@ -115,9 +116,10 @@ struct user_namespace {
 } __randomize_layout;
 
 struct ucounts {
-	struct hlist_node node;
+	struct hlist_nulls_node node;
 	struct user_namespace *ns;
 	kuid_t uid;
+	struct rcu_head rcu;
 	atomic_t count;
 	atomic_long_t ucount[UCOUNT_COUNTS];
 	atomic_long_t rlimit[UCOUNT_RLIMIT_COUNTS];
--- a/kernel/ucount.c~ucount-use-rcu-for-ucounts-lookups
+++ a/kernel/ucount.c
@@ -15,7 +15,10 @@ struct ucounts init_ucounts = {
 };
 
 #define UCOUNTS_HASHTABLE_BITS 10
-static struct hlist_head ucounts_hashtable[(1 << UCOUNTS_HASHTABLE_BITS)];
+#define UCOUNTS_HASHTABLE_ENTRIES (1 << UCOUNTS_HASHTABLE_BITS)
+static struct hlist_nulls_head ucounts_hashtable[UCOUNTS_HASHTABLE_ENTRIES] = {
+	[0 ... UCOUNTS_HASHTABLE_ENTRIES - 1] = HLIST_NULLS_HEAD_INIT(0)
+};
 static DEFINE_SPINLOCK(ucounts_lock);
 
 #define ucounts_hashfn(ns, uid)						\
@@ -24,7 +27,6 @@ static DEFINE_SPINLOCK(ucounts_lock);
 #define ucounts_hashentry(ns, uid)	\
 	(ucounts_hashtable + ucounts_hashfn(ns, uid))
 
-
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_set *
 set_lookup(struct ctl_table_root *root)
@@ -127,22 +129,28 @@ void retire_userns_sysctls(struct user_n
 #endif
 }
 
-static struct ucounts *find_ucounts(struct user_namespace *ns, kuid_t uid, struct hlist_head *hashent)
+static struct ucounts *find_ucounts(struct user_namespace *ns, kuid_t uid,
+				    struct hlist_nulls_head *hashent)
 {
 	struct ucounts *ucounts;
+	struct hlist_nulls_node *pos;
 
-	hlist_for_each_entry(ucounts, hashent, node) {
-		if (uid_eq(ucounts->uid, uid) && (ucounts->ns == ns))
-			return ucounts;
+	guard(rcu)();
+	hlist_nulls_for_each_entry_rcu(ucounts, pos, hashent, node) {
+		if (uid_eq(ucounts->uid, uid) && (ucounts->ns == ns)) {
+			if (atomic_inc_not_zero(&ucounts->count))
+				return ucounts;
+		}
 	}
 	return NULL;
 }
 
 static void hlist_add_ucounts(struct ucounts *ucounts)
 {
-	struct hlist_head *hashent = ucounts_hashentry(ucounts->ns, ucounts->uid);
+	struct hlist_nulls_head *hashent = ucounts_hashentry(ucounts->ns, ucounts->uid);
+
 	spin_lock_irq(&ucounts_lock);
-	hlist_add_head(&ucounts->node, hashent);
+	hlist_nulls_add_head_rcu(&ucounts->node, hashent);
 	spin_unlock_irq(&ucounts_lock);
 }
 
@@ -155,37 +163,33 @@ struct ucounts *get_ucounts(struct ucoun
 
 struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 {
-	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
-	struct ucounts *ucounts, *new = NULL;
+	struct hlist_nulls_head *hashent = ucounts_hashentry(ns, uid);
+	struct ucounts *ucounts, *new;
+
+	ucounts = find_ucounts(ns, uid, hashent);
+	if (ucounts)
+		return ucounts;
+
+	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	if (!new)
+		return NULL;
+
+	new->ns = ns;
+	new->uid = uid;
+	atomic_set(&new->count, 1);
 
 	spin_lock_irq(&ucounts_lock);
 	ucounts = find_ucounts(ns, uid, hashent);
-	if (!ucounts) {
+	if (ucounts) {
 		spin_unlock_irq(&ucounts_lock);
-
-		new = kzalloc(sizeof(*new), GFP_KERNEL);
-		if (!new)
-			return NULL;
-
-		new->ns = ns;
-		new->uid = uid;
-		atomic_set(&new->count, 1);
-
-		spin_lock_irq(&ucounts_lock);
-		ucounts = find_ucounts(ns, uid, hashent);
-		if (!ucounts) {
-			hlist_add_head(&new->node, hashent);
-			get_user_ns(new->ns);
-			spin_unlock_irq(&ucounts_lock);
-			return new;
-		}
+		kfree(new);
+		return ucounts;
 	}
-	if (!atomic_inc_not_zero(&ucounts->count))
-		ucounts = NULL;
-	spin_unlock_irq(&ucounts_lock);
-	kfree(new);
 
-	return ucounts;
+	hlist_nulls_add_head_rcu(&new->node, hashent);
+	get_user_ns(new->ns);
+	spin_unlock_irq(&ucounts_lock);
+	return new;
 }
 
 void put_ucounts(struct ucounts *ucounts)
@@ -193,10 +197,11 @@ void put_ucounts(struct ucounts *ucounts
 	unsigned long flags;
 
 	if (atomic_dec_and_lock_irqsave(&ucounts->count, &ucounts_lock, flags)) {
-		hlist_del_init(&ucounts->node);
+		hlist_nulls_del_rcu(&ucounts->node);
 		spin_unlock_irqrestore(&ucounts_lock, flags);
+
 		put_user_ns(ucounts->ns);
-		kfree(ucounts);
+		kfree_rcu(ucounts, rcu);
 	}
 }
 
_

Patches currently in -mm which might be from bigeasy@linutronix.de are


