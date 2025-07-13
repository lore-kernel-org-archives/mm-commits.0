Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83C31EF38E
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450026; cv=none; b=IqfWDsmndm4EUVYpnwuweH97Mpy3ua6boeYmFLywQ9mq3PU6Muvh7snEOY5iyeN+n1wn+BOovnbboI5pOOVDEr8Wpwan89xUUaUhjhZQNwtycK+9HILBg+qm0jwnDfxyG5+UruVbupcvuvJdw3yD9MgPQfljZoYttCrxOuRwULA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450026; c=relaxed/simple;
	bh=Y6Qyfl6mvWGkT7l1kgNRCnbESNtEjBY26Lxo8GuiJN0=;
	h=Date:To:From:Subject:Message-Id; b=f4jzE9qgEeT5gGwbkcS6UoiZx7dWJNXgALhltkRh87hcuvroWS6tCWQiORiedbxeL5NFRDfQyD/aJokWxWQjtAGtjiSWOcrFAGLUGjb+Tf1dpW0g7FG5tUxrObgLZbf7o3iHPxDP1ITpYjQUpilILP3rZoP35d1MNXlAV9SZaGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zL4JJYpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zL4JJYpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FCAC4CEE3;
	Sun, 13 Jul 2025 23:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450026;
	bh=Y6Qyfl6mvWGkT7l1kgNRCnbESNtEjBY26Lxo8GuiJN0=;
	h=Date:To:From:Subject:From;
	b=zL4JJYpHmyMAkJ9UzucNoNBlZ9sK3YRx+8ZtHYbIJ+LqSNrJLY9mMuYPp5GZNLA+8
	 I7jodcKeI1C9LtkZ+46oAkJmt9b4O/dKfIrV5SVlgdbc46dLptw1g8KSzuJtBNRIbI
	 DPJYo0LYVsABgdmjS2afTiv/GqUS9Yk+Cdh0uchw=
Date: Sun, 13 Jul 2025 16:40:25 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch removed from -mm tree
Message-Id: <20250713234026.75FCAC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: set Kdamond.pid in start()
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-set-kdamondpid-in-start.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: set Kdamond.pid in start()
Date: Sat, 28 Jun 2025 09:04:24 -0700

_damon_sysfs.py is a Python module for reading and writing DAMON sysfs for
testing.  It is not reading resulting kdamond pids.  Read and update those
when starting kdamonds.

Link: https://lkml.kernel.org/r/20250628160428.53115-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-set-kdamondpid-in-start
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -408,6 +408,9 @@ class Kdamond:
             if err is not None:
                 return err
         err = write_file(os.path.join(self.sysfs_dir(), 'state'), 'on')
+        if err is not None:
+            return err
+        self.pid, err = read_file(os.path.join(self.sysfs_dir(), 'pid'))
         return err
 
     def stop(self):
_

Patches currently in -mm which might be from sj@kernel.org are

samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch

