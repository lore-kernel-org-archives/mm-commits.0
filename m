Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8031CF5C0
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274594; cv=none; b=S66sFzFNjeZ40ElkzLz8e+7/lV/GeJqJzx52MdRMudLGi3ZO/zLVMx/zxjZYJXMPDjD8P+ZDNByIUO0/ki7/2EVdfvPQFer++GpBinqzFYM6cGblhhtCWJ0WgYuiRbknNGwf+GRvtdF6oSb/7cqejHhU5GruOJyPoPyLEMiPsMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274594; c=relaxed/simple;
	bh=n4U3d44hLHyDq1kQN0lH1jQz2130+aTmBjniyv9QyoY=;
	h=Date:To:From:Subject:Message-Id; b=afhf4+MolamESwNsO6bgzbLr/yelxFNWLXFEX5m2ALUYR1ougb7vhFJzkUcJUbConfUwHUtbXhe0lDjnA4MCZsCWqrvwlw0qQTBb3oiXlIbxVJDnbFA+oCVLr4RVSyMBawJJZ8dt4IycEOrNsCFx5UKhdilkBMjqmcUEznxlbQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qWAIQtEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qWAIQtEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EE3C4CEEA;
	Tue, 18 Mar 2025 05:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274594;
	bh=n4U3d44hLHyDq1kQN0lH1jQz2130+aTmBjniyv9QyoY=;
	h=Date:To:From:Subject:From;
	b=qWAIQtEkM3rArh7wclDkRTF2u6ZEKPuz6ZZJLtXd0Vg9USgH8lUbX8sm640keuDZj
	 eHvGIhbjrqyDAh3747tLJ9XpmN8NmVbad0naHIdm+Gx0yzpfXWB6nSD2eCKQW6Busq
	 JOMXxAEma9OdyU07g9xXSArY3TjoQugQhQmKSGHU=
Date: Mon, 17 Mar 2025 22:09:53 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch removed from -mm tree
Message-Id: <20250318050954.20EE3C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs: validate user inputs from damon_sysfs_commit_input()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: validate user inputs from damon_sysfs_commit_input()
Date: Thu, 6 Mar 2025 09:58:56 -0800

Patch series "mm/damon/sysfs: commit parameters online via damon_call()".

Due to the lack of ways to synchronously access DAMON internal data, DAMON
sysfs interface is using damon_callback hooks with its own synchronization
mechanism.  The mechanism is built on top of damon_callback hooks in an
ineifficient and complicated way.

Patch series "mm/damon: replace most damon_callback usages in sysfs with
new core functions", which starts with commit e035320fd38e
("mm/damon/sysfs-schemes: remove unnecessary schemes existence check in
damon_sysfs_schemes_clear_regions()") introduced two new DAMON kernel API
functions that providing the synchronous access, replaced most
damon_callback hooks usage in DAMON sysfs interface, and cleaned up
unnecessary code.

Continue the replacement and cleanup works.  Update the last DAMON sysfs'
usage of its own synchronization mechanism, namely online DAMON parameters
commit, to use damon_call() instead of the damon_callback hooks and the
hard-to-maintain core-external synchronization mechanism.  Then remove the
no more be used code due to the change, and more unused code that just not
yet cleaned up.

The first four patches (patches 1-4) of this series makes DAMON sysfs
interface's online parameters commit to use damon_call().  Then, following
three patches (patches 5-7) remove the DAMON sysfs interface's own
synchronization mechanism and its usages, which is no more be used by
anyone due to the first four patches.  Finally, six patches (8-13) do more
cleanup of outdated comment and unused code.


This patch (of 13):

Online DAMON parameters commit via DAMON sysfs interface can make kdamond
stop.  This behavior was made because it can make the implementation
simpler.  The implementation tries committing the parameter without
validation.  If it finds something wrong in the middle of the parameters
update, it returns error without reverting the partially committed
parameters back.  It is safe though, since it immediately breaks kdamond
main loop in the case of the error return.

Users can make the wrong parameters by mistake, though.  Stopping kdamond
in the case is not very useful behavior.  Also this makes it difficult to
utilize damon_call() instead of damon_callback hook for online parameters
update, since damon_call() cannot immediately break kdamond main loop in
the middle.

Validate the input parameters and return error when it fails before
starting parameters updates.  In case of mistakenly wrong parameters,
kdamond can continue running with the old and valid parameters.

Link: https://lkml.kernel.org/r/20250306175908.66300-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250306175908.66300-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input
+++ a/mm/damon/sysfs.c
@@ -1449,11 +1449,11 @@ static struct damon_ctx *damon_sysfs_bui
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
  * @kdamond:	The kobject wrapper for the associated kdamond.
  *
- * If the sysfs input is wrong, the kdamond will be terminated.
+ * Returns error if the sysfs input is wrong.
  */
 static int damon_sysfs_commit_input(struct damon_sysfs_kdamond *kdamond)
 {
-	struct damon_ctx *param_ctx;
+	struct damon_ctx *param_ctx, *test_ctx;
 	int err;
 
 	if (!damon_sysfs_kdamond_running(kdamond))
@@ -1465,7 +1465,15 @@ static int damon_sysfs_commit_input(stru
 	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
+	test_ctx = damon_new_ctx();
+	err = damon_commit_ctx(test_ctx, param_ctx);
+	if (err) {
+		damon_sysfs_destroy_targets(test_ctx);
+		damon_destroy_ctx(test_ctx);
+		goto out;
+	}
 	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
+out:
 	damon_sysfs_destroy_targets(param_ctx);
 	damon_destroy_ctx(param_ctx);
 	return err;
_

Patches currently in -mm which might be from sj@kernel.org are


