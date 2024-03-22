Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227D6376;
	Fri, 22 Mar 2024 00:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711066779; cv=none; b=lyWcbvD1ytSflziPFNzenIoTNPbDONDg4sqYNgRdyUURQzF3R0lXiQcXRvCIrrYLRaezCnwdzQO2NITqf7A6DJcN56W9vmjAyR0HtWo5TQ6lz038Lm17uVqHSDmuHOOPHxCnSseke6q8EW0BhfYJ16+48kI1fl+Kv/YfdD/Zy6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711066779; c=relaxed/simple;
	bh=uc2r7HoQ8OKZNrE7ua7uvrgrD+GSmmWdRylhkDcXb1w=;
	h=Date:To:From:Subject:Message-Id; b=cON2N8MU5fVDnX8zX9rtPUeQ5f7zckNoiIKOSOt7CPveOi8/sj1s0atjg9tWw65WfXbDLP2m05x36697QAzt9wArhIZ2E6Rf7+vUWRlFe3DTLwx32g9g3Rqq3H3ZRme25OAXDyuJWlST5zxfrujgo8c2E7DGlNCwQXN/Lj20cuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ix8/kw67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ix8/kw67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972A2C433C7;
	Fri, 22 Mar 2024 00:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711066778;
	bh=uc2r7HoQ8OKZNrE7ua7uvrgrD+GSmmWdRylhkDcXb1w=;
	h=Date:To:From:Subject:From;
	b=ix8/kw676lY96qbbIIA1Lfzh5spCcve1/mkv45l4AuH9OEEJtoU3XsS+qQpQVWIgF
	 sMhTJ1cWttt+nq9WMGDOw6dCbGVAFTgnzDcLJfYOU5SL4HZ94RDml/WPmsfDVnHt27
	 Jhjflq/9gYPixBNY6BtlHOX23Efo3aPyOlYvFUrM=
Date: Thu, 21 Mar 2024 17:19:38 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jack@suse.cz,hughd@google.com,cmaiolino@redhat.com,bugreport@ubisectech.com,cem@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-fix-race-on-handling-dquot-rbtree.patch added to mm-hotfixes-unstable branch
Message-Id: <20240322001938.972A2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tmpfs: fix race on handling dquot rbtree
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tmpfs-fix-race-on-handling-dquot-rbtree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-fix-race-on-handling-dquot-rbtree.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Carlos Maiolino <cem@kernel.org>
Subject: tmpfs: fix race on handling dquot rbtree
Date: Wed, 20 Mar 2024 13:39:59 +0100

A syzkaller reproducer found a race while attempting to remove dquot
information from the rb tree.

Fetching the rb_tree root node must also be protected by the
dqopt->dqio_sem, otherwise, giving the right timing, shmem_release_dquot()
will trigger a warning because it couldn't find a node in the tree, when
the real reason was the root node changing before the search starts:

Thread 1				Thread 2
- shmem_release_dquot()			- shmem_{acquire,release}_dquot()

- fetch ROOT				- Fetch ROOT

					- acquire dqio_sem
- wait dqio_sem

					- do something, triger a tree rebalance
					- release dqio_sem

- acquire dqio_sem
- start searching for the node, but
  from the wrong location, missing
  the node, and triggering a warning.

Link: https://lkml.kernel.org/r/20240320124011.398847-1-cem@kernel.org
Fixes: eafc474e202978 ("shmem: prepare shmem quota infrastructure")
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reported-by: Ubisectech Sirius <bugreport@ubisectech.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem_quota.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/shmem_quota.c~tmpfs-fix-race-on-handling-dquot-rbtree
+++ a/mm/shmem_quota.c
@@ -116,7 +116,7 @@ static int shmem_free_file_info(struct s
 static int shmem_get_next_id(struct super_block *sb, struct kqid *qid)
 {
 	struct mem_dqinfo *info = sb_dqinfo(sb, qid->type);
-	struct rb_node *node = ((struct rb_root *)info->dqi_priv)->rb_node;
+	struct rb_node *node;
 	qid_t id = from_kqid(&init_user_ns, *qid);
 	struct quota_info *dqopt = sb_dqopt(sb);
 	struct quota_id *entry = NULL;
@@ -126,6 +126,7 @@ static int shmem_get_next_id(struct supe
 		return -ESRCH;
 
 	down_read(&dqopt->dqio_sem);
+	node = ((struct rb_root *)info->dqi_priv)->rb_node;
 	while (node) {
 		entry = rb_entry(node, struct quota_id, node);
 
@@ -165,7 +166,7 @@ out_unlock:
 static int shmem_acquire_dquot(struct dquot *dquot)
 {
 	struct mem_dqinfo *info = sb_dqinfo(dquot->dq_sb, dquot->dq_id.type);
-	struct rb_node **n = &((struct rb_root *)info->dqi_priv)->rb_node;
+	struct rb_node **n;
 	struct shmem_sb_info *sbinfo = dquot->dq_sb->s_fs_info;
 	struct rb_node *parent = NULL, *new_node = NULL;
 	struct quota_id *new_entry, *entry;
@@ -176,6 +177,8 @@ static int shmem_acquire_dquot(struct dq
 	mutex_lock(&dquot->dq_lock);
 
 	down_write(&dqopt->dqio_sem);
+	n = &((struct rb_root *)info->dqi_priv)->rb_node;
+
 	while (*n) {
 		parent = *n;
 		entry = rb_entry(parent, struct quota_id, node);
@@ -264,7 +267,7 @@ static bool shmem_is_empty_dquot(struct
 static int shmem_release_dquot(struct dquot *dquot)
 {
 	struct mem_dqinfo *info = sb_dqinfo(dquot->dq_sb, dquot->dq_id.type);
-	struct rb_node *node = ((struct rb_root *)info->dqi_priv)->rb_node;
+	struct rb_node *node;
 	qid_t id = from_kqid(&init_user_ns, dquot->dq_id);
 	struct quota_info *dqopt = sb_dqopt(dquot->dq_sb);
 	struct quota_id *entry = NULL;
@@ -275,6 +278,7 @@ static int shmem_release_dquot(struct dq
 		goto out_dqlock;
 
 	down_write(&dqopt->dqio_sem);
+	node = ((struct rb_root *)info->dqi_priv)->rb_node;
 	while (node) {
 		entry = rb_entry(node, struct quota_id, node);
 
_

Patches currently in -mm which might be from cem@kernel.org are

tmpfs-fix-race-on-handling-dquot-rbtree.patch

