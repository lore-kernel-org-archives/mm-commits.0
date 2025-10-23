Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51011D6DA9
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 23:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761261578; cv=none; b=bzbaj+19KQW40eH8NiYx+q9/phzqFjgJuSUKJn/ucip4khrjKTka8vAg7ZukXvKAMHQwvM1jeXPzy3L1Xnl4RxJmQsnxv43mbVjcg2MFmOUS/FWk+64twweRgFMVvYRKu4/mOVFaXMnMBOLWYSFX/1vQP23BVo5nB7IAuVWdTIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761261578; c=relaxed/simple;
	bh=jOHx1y783lRUgV1scCbx0NcNCuYlf8yYD2Q7p6W71n4=;
	h=Date:To:From:Subject:Message-Id; b=qm8MMn65lMdwKBrctV62MSuLAvbv9iaEKv04AUAjTgD5jVDBtH1blewyqLVCFx9FS7EwtmWAOv9+GjlGu6SWLDMz2qXC/XOjXP/xqwX+7Nfio0sRqY7JNuZ50+Whj1p/pTjrGufMHtGG4B22YQEiHAVfRpctKT0S3Ai7b+XttfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hf/KN7+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hf/KN7+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F74C4CEF7;
	Thu, 23 Oct 2025 23:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761261578;
	bh=jOHx1y783lRUgV1scCbx0NcNCuYlf8yYD2Q7p6W71n4=;
	h=Date:To:From:Subject:From;
	b=hf/KN7+odrWt674Iz6JKxkK+s+hJL7asqry729RMu+tWHzk+4erSHLXzPUuZ2Lhvb
	 /1GfaqKH8bNk1krXpebv9xih7+dH7r0knEVReAZ/kdtcjJYUOfkBZpFOUs0vCwdGPP
	 vo7NQ/k/tWjrvkk9mj4lgWijwSzAWs8hgHSpCv5w=
Date: Thu, 23 Oct 2025 16:19:37 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch added to mm-new branch
Message-Id: <20251023231938.28F74C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: add damon_target->obsolete for pin-point removal
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-damon_target-obsolete-for-pin-point-removal.patch

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
Subject: mm/damon/core: add damon_target->obsolete for pin-point removal
Date: Wed, 22 Oct 2025 18:25:25 -0700

Patch series "mm/damon: support pin-point targets removal".

DAMON maintains the targets in a list, and allows committing only an
entire list of targets having the new parameters.  Targets having same
index on the lists are treated as matching source and destination
targets.  If an existing target cannot find a matching one in the
sources list, the target is removed.  This means that there is no way to
remove only a specific monitoring target in the middle of the current
targets list.

Such pin-point target removal is really needed in some use cases,
though.  Monitoring access patterns on virtual address spaces of
processes that spawned from the same ancestor is one example.  If a
process of the group is terminated, the user may want to remove the
matching DAMON target as soon as possible, to save in-kernel memory
usage for the unnecessary target data.  The user may also want to do
that without turning DAMON off or removing unnecessary targets, to keep
the current monitoring results for other active processes.

Extend DAMON kernel API and sysfs ABI to support the pin-point removal
in the following way.  For API, add a new damon_target field, namely
'obsolete'.  If the field on parameters commit source target is set, it
means the matching destination target is obsolete.  Then the parameters
commit logic removes the destination target from the existing targets
list.  For sysfs ABI, add a new file under the target directory, namely
'obsolete_target'.  It is connected with the 'obsolete' field of the
commit source targets, so internally using the new API.

Also add a selftest for the new feature.  The related helper scripts for
manipulating the sysfs interface and dumping in-kernel DAMON status are
also extended for this.  Note that the selftest part was initially
posted as an individual RFC series [1], but now merged into this one.

Bijan Tabatabai has originally reported this issue, and participated in
this solution design on a GitHub issue [1] for DAMON user-space tool.


This patch (of 9):

DAMON's monitoring targets parameters update function,
damon_commit_targets(), is not providing a way to remove a target in the
middle of the existing targets list.  Extend the API by adding a field to
struct damon_target.  If the field of a damon_commit_targets() source
target is set, it indicates the matching target on the existing targets
list is obsolete.  damon_commit_targets() understands that and removes
those from the list, while respecting the index based matching for other
non-obsolete targets.

Link: https://lkml.kernel.org/r/20251023012535.69625-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20251023012535.69625-2-sj@kernel.org
Link: https://github.com/damonitor/damo/issues/36 [1]
Signed-off-by: SeongJae Park <sj@kernel.org>
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

 include/linux/damon.h |    6 ++++++
 mm/damon/core.c       |   10 +++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-core-add-damon_target-obsolete-for-pin-point-removal
+++ a/include/linux/damon.h
@@ -91,17 +91,23 @@ struct damon_region {
  * @nr_regions:		Number of monitoring target regions of this target.
  * @regions_list:	Head of the monitoring target regions of this target.
  * @list:		List head for siblings.
+ * @obsolete:		Whether the commit destination target is obsolete.
  *
  * Each monitoring context could have multiple targets.  For example, a context
  * for virtual memory address spaces could have multiple target processes.  The
  * @pid should be set for appropriate &struct damon_operations including the
  * virtual address spaces monitoring operations.
+ *
+ * @obsolete is used only for damon_commit_targets() source targets, to specify
+ * the matching destination targets are obsolete.  Read damon_commit_targets()
+ * to see how it is handled.
  */
 struct damon_target {
 	struct pid *pid;
 	unsigned int nr_regions;
 	struct list_head regions_list;
 	struct list_head list;
+	bool obsolete;
 };
 
 /**
--- a/mm/damon/core.c~mm-damon-core-add-damon_target-obsolete-for-pin-point-removal
+++ a/mm/damon/core.c
@@ -479,6 +479,7 @@ struct damon_target *damon_new_target(vo
 	t->nr_regions = 0;
 	INIT_LIST_HEAD(&t->regions_list);
 	INIT_LIST_HEAD(&t->list);
+	t->obsolete = false;
 
 	return t;
 }
@@ -1187,7 +1188,11 @@ static int damon_commit_targets(
 
 	damon_for_each_target_safe(dst_target, next, dst) {
 		src_target = damon_nth_target(i++, src);
-		if (src_target) {
+		/*
+		 * If src target is obsolete, do not commit the parameters to
+		 * the dst target, and further remove the dst target.
+		 */
+		if (src_target && !src_target->obsolete) {
 			err = damon_commit_target(
 					dst_target, damon_target_has_pid(dst),
 					src_target, damon_target_has_pid(src),
@@ -1210,6 +1215,9 @@ static int damon_commit_targets(
 	damon_for_each_target_safe(src_target, next, src) {
 		if (j++ < i)
 			continue;
+		/* target to remove has no matching dst */
+		if (src_target->obsolete)
+			return -EINVAL;
 		new_target = damon_new_target();
 		if (!new_target)
 			return -ENOMEM;
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

