Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277F5286425
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 23:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761261581; cv=none; b=QWP8NK/ycUXI6C/4tVkeQxhrYFrOO9g5kqgZDtReZfbxoP4aKhWNZxhKp0GZr6OoFMHD3+xwPgnKviSEtUDS+yXLFFyyf6R9cR84SkMBj/9YVie727QSrEKuxIwStn4N9r6QF7HGZ/iDx7vsK5CWgugS3IWIikf/h96d+ohV8s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761261581; c=relaxed/simple;
	bh=GQy0T1FQSfvo+Ra3UWMrKXJ/O1sT2M0D0duZKgyIxGQ=;
	h=Date:To:From:Subject:Message-Id; b=RaFcFBQfDsvzWPBZ1L7G0q1jGtHJz9B9pE3nenJ4rD4fwFTX5yyQgpp2iHsqC5os7Z/oG2xhrjuuZ4YauFb65AbJ/4KO2H4E2l5xZjuPsXOzfMTR6SECF5B9VQsGF+6dBbCpjmxza+pX0Ej5VASypF9Ffq3F8p2GA1ol+OM4jdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UZGW6BOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UZGW6BOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A95C4CEF7;
	Thu, 23 Oct 2025 23:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761261580;
	bh=GQy0T1FQSfvo+Ra3UWMrKXJ/O1sT2M0D0duZKgyIxGQ=;
	h=Date:To:From:Subject:From;
	b=UZGW6BOCU752FDYm9LhR6BTRt6poz8gYQj2cKevZsyCAFuGOMn/g+vJpSjLb0+Or4
	 jBZznIAtwKWidgweixDlt8uYTE7qzyjotCwtu/A4TUJvlpAFX2j+x/+Jp7AUYVvSdF
	 frv1q9MF0veilz30W3SIkQJN2Vg1JSsFxn95EweM=
Date: Thu, 23 Oct 2025 16:19:40 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-test-commit-input-against-realistic-destination.patch added to mm-new branch
Message-Id: <20251023231940.98A95C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: test commit input against realistic destination
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-test-commit-input-against-realistic-destination.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-test-commit-input-against-realistic-destination.patch

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
Subject: mm/damon/sysfs: test commit input against realistic destination
Date: Wed, 22 Oct 2025 18:25:26 -0700

DAMON sysfs interface tests if given online parameters update request is
valid, by committing those using the DAMON kernel API, to a test-purpose
destination context.  The test-purpose destination context is constructed
using damon_new_ctx(), so it has no target, no scheme.

If a source target has the obsolete field set, the test-purpose commit
will fail because damon_commit_targets() fails when there is a source
obsolete target that cannot find its matching destination target.  DAMON
sysfs interface is not letting users set the field for now, so there is no
problem.  However, the following commit will support that.  Also there
could be similar future changes that making commit fails based on current
context structure.

Make the test purpose commit destination context similar to the current
running one, by committing the running one to the test purpose context,
before doing the real test-purpose commit.

Link: https://lkml.kernel.org/r/20251023012535.69625-3-sj@kernel.org
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

 mm/damon/sysfs.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-test-commit-input-against-realistic-destination
+++ a/mm/damon/sysfs.c
@@ -1452,6 +1452,26 @@ static struct damon_ctx *damon_sysfs_bui
 		struct damon_sysfs_context *sys_ctx);
 
 /*
+ * Return a new damon_ctx for testing new parameters to commit.
+ */
+static struct damon_ctx *damon_sysfs_new_test_ctx(
+		struct damon_ctx *running_ctx)
+{
+	struct damon_ctx *test_ctx;
+	int err;
+
+	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return NULL;
+	err = damon_commit_ctx(test_ctx, running_ctx);
+	if (err) {
+		damon_destroy_ctx(test_ctx);
+		return NULL;
+	}
+	return test_ctx;
+}
+
+/*
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
  * @kdamond:	The kobject wrapper for the associated kdamond.
  *
@@ -1472,7 +1492,7 @@ static int damon_sysfs_commit_input(void
 	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
-	test_ctx = damon_new_ctx();
+	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
 	if (!test_ctx)
 		return -ENOMEM;
 	err = damon_commit_ctx(test_ctx, param_ctx);
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

