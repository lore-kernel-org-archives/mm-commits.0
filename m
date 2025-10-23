Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFACA72629
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 23:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761261594; cv=none; b=G8xI9qZdZJ4+Yhihhe17OM2KBKTnqni9nS2mpHZusrqtH73vPQisZOCy5Kda/vCYdgixYRQE4Wj7YnTA8sUT/SiWxu52KpcQi+9s/OCdNsLAce4XsKk2TgHLw+IKIg+Jx4SkMuS1wABqE7hjyo3ET7uHqAprb0v3Q+LFLGNRuYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761261594; c=relaxed/simple;
	bh=4DuLc3+qAM6OXLA8NNQ5F5N82MWMB0BY0DSWH5tAInQ=;
	h=Date:To:From:Subject:Message-Id; b=TTEvt3GRZ0UJXpR9FwI5BW6vaBy1PZKkOxqXnusinJe1HCF57+04uVcZNmbkCJa0bXUd+jlor318xlu4/X0lk4fZ9DLMFaj7NuKA1pjnk3JSWs80wV2Voe1frWeW0VlrssBmO04mJJXQtUyuT2HWWVdF+dOQm9pMPnltjb0MsWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vR6cuywf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vR6cuywf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C29C4CEE7;
	Thu, 23 Oct 2025 23:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761261594;
	bh=4DuLc3+qAM6OXLA8NNQ5F5N82MWMB0BY0DSWH5tAInQ=;
	h=Date:To:From:Subject:From;
	b=vR6cuywfASMJSyAzaTbHQAf4uLnwkhQb4zURC3mDSRiplB9mC7eI6Pcdqu1AYsg1B
	 vR/zkoAkUXJSiwD2H2baeC6OuClmWCtzp8dJijJz9VRcKVPK2t68B9lJFiqg4okrZ5
	 ZgFdMrdpkX9dY9UATMv6GJTdszDACbTKtxm6o1Ok=
Date: Thu, 23 Oct 2025 16:19:54 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfs-add-obsolete_target-test.patch added to mm-new branch
Message-Id: <20251023231954.89C29C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs: add obsolete_target test
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfs-add-obsolete_target-test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfs-add-obsolete_target-test.patch

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
Subject: selftests/damon/sysfs: add obsolete_target test
Date: Wed, 22 Oct 2025 18:25:33 -0700

A new DAMON sysfs file for pin-point target removal, namely
obsolete_target, has been added.  Add a test for the functionality.  It
starts DAMON with three monitoring target processes, mark one in the
middle as obsolete, commit it, and confirm the internal DAMON status is
updated to remove the target in the middle.

Link: https://lkml.kernel.org/r/20251023012535.69625-10-sj@kernel.org
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

 tools/testing/selftests/damon/sysfs.py |   37 +++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfs-add-obsolete_target-test
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -279,5 +279,42 @@ def main():
 
     kdamonds.stop()
 
+    # test obsolete_target.
+    proc1 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
+                             stderr=subprocess.PIPE)
+    proc2 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
+                             stderr=subprocess.PIPE)
+    proc3 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
+                             stderr=subprocess.PIPE)
+    kdamonds = _damon_sysfs.Kdamonds(
+            [_damon_sysfs.Kdamond(
+                contexts=[_damon_sysfs.DamonCtx(
+                    ops='vaddr',
+                    targets=[
+                        _damon_sysfs.DamonTarget(pid=proc1.pid),
+                        _damon_sysfs.DamonTarget(pid=proc2.pid),
+                        _damon_sysfs.DamonTarget(pid=proc3.pid),
+                        ],
+                    schemes=[_damon_sysfs.Damos()],
+                    )])])
+    err = kdamonds.start()
+    if err is not None:
+        print('kdamond start failed: %s' % err)
+        exit(1)
+    kdamonds.kdamonds[0].contexts[0].targets[1].obsolete = True
+    kdamonds.kdamonds[0].commit()
+
+    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        kdamonds.stop()
+        exit(1)
+
+    del kdamonds.kdamonds[0].contexts[0].targets[1]
+
+    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+
+    kdamonds.stop()
+
 if __name__ == '__main__':
     main()
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

