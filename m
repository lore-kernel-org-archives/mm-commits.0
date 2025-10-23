Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37952C08B6
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 23:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761261583; cv=none; b=hWSu3zK4wYsvTUP8o/bUm5g4H5wh15dCjy1NPdc5XANzsPjCFIBCnFXNjNtzzSZlTVOL08pEAredDGsYn/v2hv5PDXDOH5A69AHlE4OUz169UJTPuEDE7jFPgD0GS5Kl2aKESUgLlcqlIfA3HyTrFkYNqm26Ur0RlviooXLscPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761261583; c=relaxed/simple;
	bh=r9RXj/mCdeCYUWtV6q73FGZzlN466nJo8o5wTVAi6oc=;
	h=Date:To:From:Subject:Message-Id; b=QqeQWZkW5TLuTpWijJosFkCYxFNwCCjXsxxBCHhU6a30apKDhA51EXyVNzBe/KPdCMy17F8C8Dwetx3EeQW6NvD2Hx5iTglLVMyZURavbj4fYwWTyQz6NR1jIMIGbrnBEC4EEHx+jPE35d486Tjc8zJLROIJZQOBV+luM83JK7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hCy/Dj+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hCy/Dj+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7FEDC4CEF7;
	Thu, 23 Oct 2025 23:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761261582;
	bh=r9RXj/mCdeCYUWtV6q73FGZzlN466nJo8o5wTVAi6oc=;
	h=Date:To:From:Subject:From;
	b=hCy/Dj+GlJzShrMGQfzJ5wUtJKZ4QzWAaUYddNQ5rAXRi6Cep/8vhPfGA6+ZVHAuM
	 ffRrbfWpOyElYahM7b+j2QsqEyZiO5ajx5J1OG4Hcml897YfZTJm7aSI4Abcg27g7Q
	 BXaoMHhuV7Wmh/xObMfjBdWY2hEu+INtWf+TTYhs=
Date: Thu, 23 Oct 2025 16:19:42 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-implement-obsolete_target-file.patch added to mm-new branch
Message-Id: <20251023231942.A7FEDC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: implement obsolete_target file
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-implement-obsolete_target-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-implement-obsolete_target-file.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Subject: mm/damon/sysfs: implement obsolete_target file
Date: Wed, 22 Oct 2025 18:25:27 -0700

There is no good way to remove DAMON targets in the middle of the existing
targets list.  It restricts efficient and flexible DAMON use cases. 
Improve the usability by implementing a new DAMON sysfs interface file,
namely obsolete_target, under each target directory.  It is connected to
the obsolete field of parameters commit-source targets, so allows removing
arbitrary targets in the middle of existing targets list.

Note that the sysfs files are not automatically updated.  For example,
let's suppose there are three targets in the running context, and a user
removes the third target using this feature.  If the user writes 'commit'
to the kdamond 'state' file again, DAMON sysfs interface will again try to
remove the third target.  But because there is no matching target in the
running context, the commit will fail.  It is the user's responsibility to
understand resulting DAMON internal targets list change, and construct
sysfs files (using nr_targets and other sysfs files) to correctly
represent it.

Also note that this is arguably an improvement rather than a fix of broken
things.

Link: https://lkml.kernel.org/r/20251023012535.69625-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Bijan Tabatabai <bijan311@gmail.com>
Closes: https://github.com/damonitor/damo/issues/36
Reviewed-by: Bijan Tabatabai <bijan311@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-implement-obsolete_target-file
+++ a/mm/damon/sysfs.c
@@ -212,6 +212,7 @@ struct damon_sysfs_target {
 	struct kobject kobj;
 	struct damon_sysfs_regions *regions;
 	int pid;
+	bool obsolete;
 };
 
 static struct damon_sysfs_target *damon_sysfs_target_alloc(void)
@@ -263,6 +264,29 @@ static ssize_t pid_target_store(struct k
 	return count;
 }
 
+static ssize_t obsolete_target_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct damon_sysfs_target *target = container_of(kobj,
+			struct damon_sysfs_target, kobj);
+
+	return sysfs_emit(buf, "%c\n", target->obsolete ? 'Y' : 'N');
+}
+
+static ssize_t obsolete_target_store(struct kobject *kobj,
+		struct kobj_attribute *attr, const char *buf, size_t count)
+{
+	struct damon_sysfs_target *target = container_of(kobj,
+			struct damon_sysfs_target, kobj);
+	bool obsolete;
+	int err = kstrtobool(buf, &obsolete);
+
+	if (err)
+		return err;
+	target->obsolete = obsolete;
+	return count;
+}
+
 static void damon_sysfs_target_release(struct kobject *kobj)
 {
 	kfree(container_of(kobj, struct damon_sysfs_target, kobj));
@@ -271,8 +295,12 @@ static void damon_sysfs_target_release(s
 static struct kobj_attribute damon_sysfs_target_pid_attr =
 		__ATTR_RW_MODE(pid_target, 0600);
 
+static struct kobj_attribute damon_sysfs_target_obsolete_attr =
+		__ATTR_RW_MODE(obsolete_target, 0600);
+
 static struct attribute *damon_sysfs_target_attrs[] = {
 	&damon_sysfs_target_pid_attr.attr,
+	&damon_sysfs_target_obsolete_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(damon_sysfs_target);
@@ -1377,6 +1405,7 @@ static int damon_sysfs_add_target(struct
 			/* caller will destroy targets */
 			return -EINVAL;
 	}
+	t->obsolete = sys_target->obsolete;
 	return damon_sysfs_set_regions(t, sys_target->regions, ctx->min_sz_region);
 }
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-remove-unnecessary-dlen-writes-for-incompressible-pages.patch
mm-zswap-fix-typos-s-zwap-zswap.patch
mm-zswap-s-red-black-tree-xarray.patch
docs-admin-guide-mm-zswap-s-red-black-tree-xarray.patch
mm-damon-document-damos_quota_goal-nid-use-case.patch
mm-damon-add-damos-quota-goal-type-for-per-memcg-per-node-memory-usage.patch
mm-damon-core-implement-damos_quota_node_memcg_used_bp.patch
mm-damon-sysfs-schemes-implement-path-file-under-quota-goal-directory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_used_bp.patch
mm-damon-core-add-damos-quota-gaol-metric-for-per-memcg-per-numa-free-memory.patch
mm-damon-sysfs-schemes-support-damos_quota_node_memcg_free_bp.patch
docs-mm-damon-design-document-damos_quota_node_memcg_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-damos-quota-goal-path-file.patch
docs-abi-damon-document-damos-quota-goal-path-file.patch
mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch
mm-damon-sysfs-test-commit-input-against-realistic-destination.patch
mm-damon-sysfs-implement-obsolete_target-file.patch
docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch
docs-abi-damon-document-obsolete_target-sysfs-file.patch
selftests-damon-_damon_sysfs-support-obsolete_target-file.patch
drgn_dump_damon_status-dump-damon_target-obsolete.patch
sysfspy-extend-assert_ctx_committed-for-monitoring-targets.patch
selftests-damon-sysfs-add-obsolete_target-test.patch

