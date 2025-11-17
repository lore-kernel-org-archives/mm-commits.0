Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CCD23958A
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343259; cv=none; b=SC9hwC1fR83wxVwotAwTZM1A9iMvJCRvJC6Sn5EhstjMgRKC9ODfAOm6Zoi/OVA2keErp7QVLnpxCg/9KKGRt2Zsj/xeJFQHCnSuDjHpFZxqx7OURGVCIaXXAC7u/t6iSf756QHdB6lZ9zhW3MJpYjzCnH/iGlIBDa2kottHzTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343259; c=relaxed/simple;
	bh=ThkDf+DIeIDktnCZN87f5SMmaNE9wSYo2/G7iSkeejo=;
	h=Date:To:From:Subject:Message-Id; b=koe8HoERCDbyw9SgKYUGnVpRfGmWTu1sdO8PsxyySQcU3v8kB0M9tZ+7Po7YjGf2Yl/eE4n+MFX+Vk7u1SyszswKaf70Iylc5kP/60RPCARF78JgUFC3USeOVx1pbHAEGajtY9qnJAuCLSpE6vRHKr6oqPlI6fWh5pseTXyKaDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hofCPjTL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hofCPjTL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2FAC19423;
	Mon, 17 Nov 2025 01:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343259;
	bh=ThkDf+DIeIDktnCZN87f5SMmaNE9wSYo2/G7iSkeejo=;
	h=Date:To:From:Subject:From;
	b=hofCPjTLsarmhYBLFe3ODCZklFo9m5KnOkAo4MClfUJ7kE6clQnYePvI+FkW8gmDX
	 ivOSA5120/4Tk37jz4u2bWwiDHJNEg2siD0lnwBiBkRsMn5iYgGquvZ9H1lwFEvVpX
	 WomUTdeO2CTXY7d1Xji091PenxIcGZCK0hQQ+4vw=
Date: Sun, 16 Nov 2025 17:34:19 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-damon-_damon_sysfs-support-obsolete_target-file.patch removed from -mm tree
Message-Id: <20251117013419.7E2FAC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/_damon_sysfs: support obsolete_target file
has been removed from the -mm tree.  Its filename was
     selftests-damon-_damon_sysfs-support-obsolete_target-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/_damon_sysfs: support obsolete_target file
Date: Wed, 22 Oct 2025 18:25:30 -0700

A DAMON sysfs file, namely obsolete_target, has been newly introduced. 
Add a support of that file to _damon_sysfs.py so that DAMON selftests for
the file can be easily written.

Link: https://lkml.kernel.org/r/20251023012535.69625-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Bijan Tabatabai <bijan311@gmail.com>
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

 tools/testing/selftests/damon/_damon_sysfs.py |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-obsolete_target-file
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -475,12 +475,14 @@ class Damos:
 
 class DamonTarget:
     pid = None
+    obsolete = None
     # todo: Support target regions if test is made
     idx = None
     context = None
 
-    def __init__(self, pid):
+    def __init__(self, pid, obsolete=False):
         self.pid = pid
+        self.obsolete = obsolete
 
     def sysfs_dir(self):
         return os.path.join(
@@ -491,8 +493,13 @@ class DamonTarget:
                 os.path.join(self.sysfs_dir(), 'regions', 'nr_regions'), '0')
         if err is not None:
             return err
-        return write_file(
+        err = write_file(
                 os.path.join(self.sysfs_dir(), 'pid_target'), self.pid)
+        if err is not None:
+            return err
+        return write_file(
+                os.path.join(self.sysfs_dir(), 'obsolete_target'),
+                'Y' if self.obsolete else 'N')
 
 class IntervalsGoal:
     access_bp = None
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-tests-core-kunit-remove-dynamic-allocs-on-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-split-out-damos_test_commit_filter-core-logic.patch
mm-damon-tests-core-kunit-extend-damos_test_commit_filter_for-for-union-fields.patch
mm-damon-tests-core-kunit-add-test-cases-to-damos_test_commit_filter.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goal-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota_goals-test.patch
mm-damon-tests-core-kunit-add-damos_commit_quota-test.patch
mm-damon-core-pass-migrate_dests-to-damos_commit_dests.patch
mm-damon-tests-core-kunit-add-damos_commit_dests-test.patch
mm-damon-tests-core-kunit-add-damos_commit-test.patch
mm-damon-tests-core-kunit-add-damon_commit_target_regions-test.patch
mm-damon-rename-damos-core-filter-helpers-to-have-word-core.patch
mm-damon-rename-damos-filters-to-damos-core_filters.patch
mm-damon-vaddr-cleanup-using-pmd_trans_huge_lock.patch
mm-damon-vaddr-use-vm_normal_folio_pmd-instead-of-damon_get_folio.patch
mm-damon-vaddr-consistently-use-only-pmd_entry-for-damos_migrate.patch
mm-damon-tests-core-kunit-remove-damon_min_region-redefinition.patch
selftests-damon-sysfspy-merge-damon-status-dumping-into-commitment-assertion.patch
docs-mm-damon-maintainer-profile-fix-a-typo-on-mm-untable-link.patch
docs-mm-damon-maintainer-profile-fix-grammartical-errors.patch

