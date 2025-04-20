Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98633101E6
	for <mm-commits@vger.kernel.org>; Sun, 20 Apr 2025 20:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745180733; cv=none; b=cTqF9aa79Tlh2ZxDhkEgrFBEUYv84FzDPY+JNvXptEoRS98+hN2yw87HkPHHPGt8AjFF5BkrvVJDpsBxIHZ/QygU6DDOP9ew/x8tMO+vgB4RFQ2h5riBIilR6QWPaMWGppSdOeo249CUuYU4SkgW108PAtXAgtUMRxXlasL5aHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745180733; c=relaxed/simple;
	bh=gzVFWbOepQCAfGXrhUFfCfiRf5wd0XkokbwNM00zVH0=;
	h=Date:To:From:Subject:Message-Id; b=emstqUQ7YkEbBbiPLf9FMwCuoijp2EjgZYWpLDKBMvkKMOMCukdSfiduQJgDA3uE4O2bayjGDw2ZhZJ6FZLZoK1IUdYS+KJ+3V2g7PFPArDceNFbjHyGt0BPwfH8FxiDs1bgl1zhw9aFe7iqEvdDUGXsHyd/k7BfSwFQcnhKKWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UmGu9Iee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UmGu9Iee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C51C4CEE2;
	Sun, 20 Apr 2025 20:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745180732;
	bh=gzVFWbOepQCAfGXrhUFfCfiRf5wd0XkokbwNM00zVH0=;
	h=Date:To:From:Subject:From;
	b=UmGu9Ieet/4S+GG0bz412IPh7cmcy9qwry3ODclaEXBpzeqiz9Pc7vi0ULxGE3kNp
	 izxhblSZ+DQG7EdgW+QXTzf18YTHLIILe2usVY8V7fBs8I0KOEXCN7mvz3w6q/6xll
	 LsmFGxtyByCKGPBswg5L1vG51/NGmimS9Bj5WIcg=
Date: Sun, 20 Apr 2025 13:25:32 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch added to mm-unstable branch
Message-Id: <20250420202532.B7C51C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: implement file for quota goal nid parameter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch

This patch will later appear in the mm-unstable branch at
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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: implement file for quota goal nid parameter
Date: Sun, 20 Apr 2025 12:40:25 -0700

DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP DAMOS quota goal metrics require the
node id parameter.  However, there is no DAMON user ABI for setting it. 
Implement a DAMON sysfs file for that with name 'nid', under the quota
goal directory.

Link: https://lkml.kernel.org/r/20250420194030.75838-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter
+++ a/mm/damon/sysfs-schemes.c
@@ -936,6 +936,7 @@ struct damos_sysfs_quota_goal {
 	enum damos_quota_goal_metric metric;
 	unsigned long target_value;
 	unsigned long current_value;
+	int nid;
 };
 
 /* This should match with enum damos_action */
@@ -1016,6 +1017,28 @@ static ssize_t current_value_store(struc
 	return err ? err : count;
 }
 
+static ssize_t nid_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
+			damos_sysfs_quota_goal, kobj);
+
+	/* todo: return error if the goal is not using nid */
+
+	return sysfs_emit(buf, "%d\n", goal->nid);
+}
+
+static ssize_t nid_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damos_sysfs_quota_goal *goal = container_of(kobj, struct
+			damos_sysfs_quota_goal, kobj);
+	int err = kstrtoint(buf, 0, &goal->nid);
+
+	/* feed callback should check existence of this file and read value */
+	return err ? err : count;
+}
+
 static void damos_sysfs_quota_goal_release(struct kobject *kobj)
 {
 	/* or, notify this release to the feed callback */
@@ -1031,10 +1054,14 @@ static struct kobj_attribute damos_sysfs
 static struct kobj_attribute damos_sysfs_quota_goal_current_value_attr =
 		__ATTR_RW_MODE(current_value, 0600);
 
+static struct kobj_attribute damos_sysfs_quota_goal_nid_attr =
+		__ATTR_RW_MODE(nid, 0600);
+
 static struct attribute *damos_sysfs_quota_goal_attrs[] = {
 	&damos_sysfs_quota_goal_target_metric_attr.attr,
 	&damos_sysfs_quota_goal_target_value_attr.attr,
 	&damos_sysfs_quota_goal_current_value_attr.attr,
+	&damos_sysfs_quota_goal_nid_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damos_sysfs_quota_goal);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-define-and-use-madvise_behavior-struct-for-madvise_do_behavior.patch
mm-madvise-batch-tlb-flushes-for-madv_free.patch
mm-memory-split-non-tlb-flushing-part-from-zap_page_range_single.patch
mm-madvise-batch-tlb-flushes-for-madv_dontneed.patch
mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch

