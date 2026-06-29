Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514D9282F23;
	Mon, 29 Jun 2026 04:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782708925; cv=none; b=nXBRkDaVVzfWSCcXaalMz64zC5CoyCcJPlPwR4Cilz7HY78IgcuhRY1jqkLE36f2iaYWyQpjAp2ROZvu2mzz7hG04GMF8UL1cXMn4eACoGpVHNfOKZD84endNlpXPGY8nHNr0x51pSBZBC+nqxpTeAosISKFARYlRZ/BKNACocs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782708925; c=relaxed/simple;
	bh=og7A5tlgKnmugtyE7BhibcPYh0EhZ3gUtGV5ORvNPJM=;
	h=Date:To:From:Subject:Message-Id; b=YYzKCKyVto3y9EIYSuTbuxOwW3be6/Upvkb344o0DUsiXh4nJDRYvhmYFvFHFkVmR8IU0O1M2TnW7po3jMgw0Sk4jLokoedbCHwzj8QoU5cSSgUEpf4qObLAvJgqLJmvSQQfz3gK2DlkMGZlwXRFINv/J9iZLhIjmgtR95kWCIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1j5lmJN7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1j5lmJN7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA8A1F000E9;
	Mon, 29 Jun 2026 04:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782708923;
	bh=lRZbZwxcosAT82HGOqfiPybzZikR7YiG88/AaNYe50Y=;
	h=Date:To:From:Subject;
	b=1j5lmJN7QmosEJZZnS+CDP35dYgj8s1X0mltXJQaJTB3uB6TVzk74tSuE5En4iVHR
	 /iSgFA0OdNoBsr7K9Vo+ZX4hDDiZThhESesLrVvDCkVNLxJrbqaat9O6bYOzUQyKGm
	 XeBuj78d8wD0RAuhCiPgg+CzzIh84N+RH9zeISis=
Date: Sun, 28 Jun 2026 21:55:23 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch added to mm-new branch
Message-Id: <20260629045523.ABA8A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: kobject_del() target (normal), context and kdamond dirs
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/sysfs: kobject_del() target (normal), context and kdamond dirs
Date: Sun, 28 Jun 2026 15:01:10 -0700

Patch series "mm/damon/sysfs: kobject_del() directories that users can
create/remove".

DAMON sysfs interface allows users to create and remove arbitrary number
of directories on sysfs, using a few files having 'nr_' prefix.  For
example, 'nr_kdamonds'.  When the user writes a number 'N' to the files,
directories having name starting from '0' to 'N - 1' are created in the
same directory.  The pre-existing number-named directories are removed
before creating the new directories.

For the removal of the existing directories, DAMON sysfs interface use
only kobject_put().  Because DAMON sysfs interface is the only kernel
component that manages the directories, there is no problem in normal
situations.  However, if CONFIG_DEBUG_KOBJECT_RELEASE is enabled, the
removal of dirs are delayed.  Let's suppose a user writes a non-zero
number to the 'nr_*' files while there are pre-existing number-named
directories, on the config enabled kernel.  DAMON sysfs interface
decreases the reference counts of the existing directories and immediately
creates new directories.  Because the removal of the sysfs directories is
delayed, it shows some pre-existing directories of the same names when it
tries to create the new directories, and fails.

For example, the issue can be triggered like below:

    # grep DEBUG_KOBJECT_RELEASE /boot/config-$(uname -r)
    CONFIG_DEBUG_KOBJECT_RELEASE=y
    # ls
    nr_kdamonds
    # echo 1 > nr_kdamonds
    # echo 1 > nr_kdamonds
    bash: echo: write error: File exists
    # dmesg
    [...]
    [  300.880458] kobject: kobject_add_internal failed for 0 with -EEXIST, don't try to register things with the same name in the same directory.
    [...]

Some of the error handling paths of the directories also lack the
kobject_del() call.  If the user uses nr_* file right after the errors,
similar issues can happen.

This doesn't cause catastrophic issues like kernel panics or memory
corruptions.  Users can work around by removing all directories first
(write 0 to the nr_* files) and then create new directories after
confirming the old directories are gone.  But, this is definitely a bug
that causes a bad user experience.

Fix the issues by calling kobject_del() before creating new directories.


This patch (of 11)

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for normal creation paths of target, context and kdamond
directories, and error paths of context and kdamond directories by adding
kobject_del() calls.

Note that this fix for target directories is not complete since it has a
similar issue in the damon_sysfs_targets_add_dirs() error path.  Because
the normal path issue and the error path issue are introduced by different
commits, this commit is fixing only the normal path issue.  A commit for
the error path will be added next.

Link: https://lore.kernel.org/20260628220121.97360-1-sj@kernel.org
Link: https://lore.kernel.org/20260628220121.97360-2-sj@kernel.org
Fixes: c951cd3b8901 ("mm/damon: implement a minimal stub for sysfs-based DAMON interface")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs
+++ a/mm/damon/sysfs.c
@@ -331,6 +331,7 @@ static void damon_sysfs_targets_rm_dirs(
 
 	for (i = 0; i < targets->nr; i++) {
 		damon_sysfs_target_rm_dirs(targets_arr[i]);
+		kobject_del(&targets_arr[i]->kobj);
 		kobject_put(&targets_arr[i]->kobj);
 	}
 	targets->nr = 0;
@@ -1640,6 +1641,7 @@ static void damon_sysfs_contexts_rm_dirs
 
 	for (i = 0; i < contexts->nr; i++) {
 		damon_sysfs_context_rm_dirs(contexts_arr[i]);
+		kobject_del(&contexts_arr[i]->kobj);
 		kobject_put(&contexts_arr[i]->kobj);
 	}
 	contexts->nr = 0;
@@ -1678,13 +1680,15 @@ static int damon_sysfs_contexts_add_dirs
 
 		err = damon_sysfs_context_add_dirs(context);
 		if (err)
-			goto out;
+			goto del_out;
 
 		contexts_arr[i] = context;
 		contexts->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&context->kobj);
 out:
 	damon_sysfs_contexts_rm_dirs(contexts);
 	kobject_put(&context->kobj);
@@ -2499,6 +2503,7 @@ static void damon_sysfs_kdamonds_rm_dirs
 
 	for (i = 0; i < kdamonds->nr; i++) {
 		damon_sysfs_kdamond_rm_dirs(kdamonds_arr[i]);
+		kobject_del(&kdamonds_arr[i]->kobj);
 		kobject_put(&kdamonds_arr[i]->kobj);
 	}
 	kdamonds->nr = 0;
@@ -2553,13 +2558,15 @@ static int damon_sysfs_kdamonds_add_dirs
 
 		err = damon_sysfs_kdamond_add_dirs(kdamond);
 		if (err)
-			goto out;
+			goto del_out;
 
 		kdamonds_arr[i] = kdamond;
 		kdamonds->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&kdamond->kobj);
 out:
 	damon_sysfs_kdamonds_rm_dirs(kdamonds);
 	kobject_put(&kdamond->kobj);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-fix-dir-put-orders-in-access_pattern_add_dirs.patch
mm-damon-sysfs-schemes-put-stats-for-scheme_add_dirs-internal-error.patch
mm-damon-ops-common-handle-extreme-intervals-in-damon_hot_score.patch
maintainers-s-seongjae-sj.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch

