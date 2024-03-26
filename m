Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669F11B59A;
	Tue, 26 Mar 2024 18:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711476505; cv=none; b=ozoc4QVBRD2gAhbMkExI8m1UinTrMHblaJV+DfeFd7Rzx3BCLGiYPams9n+5JAz2D/08gAhQdklwwOLsWYT68aSKlwekqxEJRGioCPo++rTiJfHCnk6TPNa+B/4nR1xp23uRrtcVRSvS66o5MrwhY/jTUb+IH3M+Ymuy6rdbXao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711476505; c=relaxed/simple;
	bh=/pcANzZwF1IiU7ErWgj2QFS58+v8NAvF3NBuwTC9i98=;
	h=Date:To:From:Subject:Message-Id; b=Mu6c4Lp0c8AFL8YtTne5bVdvVmuaDcYeYh7bX/8Ido8TfXANTqwYJPOxytBFVjyBS9ccyzv5N9gbVDNisgoRWuU+zo1bNmstVZo8v8x1Cx9kRXmPrLLdvxDNORFLhjiGDUvU+3Rwnj03awcPatGOyDOVwy1VJYxunZgTgIM7Ptw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XZli9lGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XZli9lGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39372C43399;
	Tue, 26 Mar 2024 18:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711476505;
	bh=/pcANzZwF1IiU7ErWgj2QFS58+v8NAvF3NBuwTC9i98=;
	h=Date:To:From:Subject:From;
	b=XZli9lGAikRwU0G1agTnCIsUql4fAjH1WX56jtDMfODzlAwoeuqWzQ3IAMS7Y++if
	 bdDNdtRjG/P0sqv6gEM/6hwmrH16tMrbHI1sqELwSbx/+pbpyYHSSB/On5Jleqk70I
	 IQHt0eDr0xSl8z2WeVk4bUSBbz3JtZ2h1kO4fuZQ=
Date: Tue, 26 Mar 2024 11:08:24 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,jack@suse.cz,hughd@google.com,cmaiolino@redhat.com,bugreport@ubisectech.com,cem@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tmpfs-fix-race-on-handling-dquot-rbtree.patch removed from -mm tree
Message-Id: <20240326180825.39372C43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tmpfs: fix race on handling dquot rbtree
has been removed from the -mm tree.  Its filename was
     tmpfs-fix-race-on-handling-dquot-rbtree.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: eafc474e2029 ("shmem: prepare shmem quota infrastructure")
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


