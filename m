Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DD718FDAE
	for <mm-commits@vger.kernel.org>; Fri,  7 Feb 2025 23:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738972285; cv=none; b=ugmrF6AX7x7byuOXE1bbYK9eB8YBML75xNJZ8QIqD0n1aV1vYN5C5T6vUBbZijtdpbv1x6Mqtlmmd6Gjp2d2UXvyQa3OfcCZ2vol4+1mvip7pBZg8RHgK8jKA51Zy0fSfVtCL5A+xm7jgL0oyVx1krLVsHySwp8Rfm0P17+LoaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738972285; c=relaxed/simple;
	bh=C78NHdZfmhSQEU+PuY37qkDz1cKO31B0gFnzUdvPTLM=;
	h=Date:To:From:Subject:Message-Id; b=KzcyEYLMlmr7FFnT2HHqOxn4Amr/KkEmCoRn09PhjA3EngduW9s7yDPxlkTA2qK9MNZ45Oa4n7oYtwjjjBaTf2Ck70D36Jwsdu4i8rXMTGkP9CGvqd2CEuHH5ud36nVX9kyxdL2K3xdovK0Hq7QDlmsEf09i+VVI+gxW4dTlYFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TG+3vyYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TG+3vyYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31733C4CED1;
	Fri,  7 Feb 2025 23:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738972285;
	bh=C78NHdZfmhSQEU+PuY37qkDz1cKO31B0gFnzUdvPTLM=;
	h=Date:To:From:Subject:From;
	b=TG+3vyYZflwRgdIW3Z4YA9/BIdB2JyWhOGJsTeTeVJVFwYJuLPBS3S54ZAwp3cMX6
	 P4OF7FVjvENuEWcDIUHzSonqcwrUwVDDA6CGwnSiPiInna2pIuG+XUdiuA13qUtHOE
	 YD3pINHs/iBSgX0Jz3LZxBUKUCt8zHOuOCmnRwEg=
Date: Fri, 07 Feb 2025 15:51:24 -0800
To: mm-commits@vger.kernel.org,yuehongwu@tencent.com,urezki@gmail.com,tglx@linutronix.de,rostedt@goodmis.org,qiang.zhang1211@gmail.com,paulmck@kernel.org,mengensun@tencent.com,mathieu.desnoyers@efficios.com,josh@joshtriplett.org,joel@joelfernandes.org,jiangshanlai@gmail.com,boqun.feng@gmail.com,bigeasy@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + ucount-use-rcu-for-ucounts-lookups.patch added to mm-nonmm-unstable branch
Message-Id: <20250207235125.31733C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: ucount: use RCU for ucounts lookups
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ucount-use-rcu-for-ucounts-lookups.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ucount-use-rcu-for-ucounts-lookups.patch

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

rcu-provide-a-static-initializer-for-hlist_nulls_head.patch
ucount-replace-get_ucounts_or_wrap-with-atomic_inc_not_zero.patch
ucount-use-rcu-for-ucounts-lookups.patch
ucount-use-rcuref_t-for-reference-counting.patch

