From: akpm@osdl.org
Subject: - dcache-avoid-rcu-for-never-hashed-dentries.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:06:58 -0800
Message-ID: <200612072306.kB7N6wOV030324@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53361 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163671AbWLGXNy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:13:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, davem@davemloft.net, dipankar@in.ibm.com, maneesh@in.ibm.com, paulmck@us.ibm.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     dcache: avoid RCU for never-hashed dentries
has been removed from the -mm tree.  Its filename was
     dcache-avoid-rcu-for-never-hashed-dentries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: dcache: avoid RCU for never-hashed dentries
From: Eric Dumazet <dada1@cosmosbay.com>

Some dentries don't need to be globally visible in dentry hashtable. 
(pipes & sockets)

Such dentries dont need to wait for a RCU grace period at delete time. 
Being able to free them permits a better CPU cache use (hot cache)

This patch combined with (dont insert pipe dentries into dentry_hashtable)
reduced time of { pipe(p); close(p[0]); close(p[1]);} on my UP machine (1.6
GHz Pentium-M) from 3.23 us to 2.86 us (But this patch does not depend on
other patches, only bench results)

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Maneesh Soni <maneesh@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/dcache.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN fs/dcache.c~dcache-avoid-rcu-for-never-hashed-dentries fs/dcache.c
--- a/fs/dcache.c~dcache-avoid-rcu-for-never-hashed-dentries
+++ a/fs/dcache.c
@@ -68,15 +68,19 @@ struct dentry_stat_t dentry_stat = {
 	.age_limit = 45,
 };
 
-static void d_callback(struct rcu_head *head)
+static void __d_free(struct dentry *dentry)
 {
-	struct dentry * dentry = container_of(head, struct dentry, d_u.d_rcu);
-
 	if (dname_external(dentry))
 		kfree(dentry->d_name.name);
 	kmem_cache_free(dentry_cache, dentry); 
 }
 
+static void d_callback(struct rcu_head *head)
+{
+	struct dentry * dentry = container_of(head, struct dentry, d_u.d_rcu);
+	__d_free(dentry);
+}
+
 /*
  * no dcache_lock, please.  The caller must decrement dentry_stat.nr_dentry
  * inside dcache_lock.
@@ -85,7 +89,11 @@ static void d_free(struct dentry *dentry
 {
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
- 	call_rcu(&dentry->d_u.d_rcu, d_callback);
+	/* if dentry was never inserted into hash, immediate free is OK */
+	if (dentry->d_hash.pprev == NULL)
+		__d_free(dentry);
+	else
+		call_rcu(&dentry->d_u.d_rcu, d_callback);
 }
 
 /*
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
convert-i386-pda-code-to-use-%fs.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index.patch
slab-use-a-multiply-instead-of-a-divide-in-obj_to_index-tweaks.patch

