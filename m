Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03AA298CA2
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 23:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761261589; cv=none; b=LxzF62FKooBSqQvlMW1z1qHs0k2fVTlDTKHDOwV57HnSqmiiHI4ZskkemuWDItb6NeQkPxgMi1ld81eoKgEiju0XKAaiZYclC+Rdb4UM3zETiTzNSPlOyY8orjbL5gFbRrv97yGgr/OEb5efDPveKlItEBA9r0oNEvq5AkFUvi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761261589; c=relaxed/simple;
	bh=w1UyIiQ0RqSq7bb70PTqhl2YxLs+Ubb2aIO9e4bfFl4=;
	h=Date:To:From:Subject:Message-Id; b=YLHILKPY7Ym0oEMZQucz5LmUDQ6SxJBWHOln5uAZJE6GMd93aecdq3kmOIB+Zt12XBVenEvym42RyGkZIte7Nh2tRDtNFBYIePm0bTVjkR3SiAq6ElfEPSfEOfTdEOeU2WnGZ3ya2H6ptrsLao7p98fTeqEWdny8PYdlegKLdME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=znvjzdwr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="znvjzdwr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6383C4CEE7;
	Thu, 23 Oct 2025 23:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761261588;
	bh=w1UyIiQ0RqSq7bb70PTqhl2YxLs+Ubb2aIO9e4bfFl4=;
	h=Date:To:From:Subject:From;
	b=znvjzdwrGC+mxrSeLxQVSvLOMu8EkpHDluU8Vbb9bnepFV/w6JM8RlHJiW8q1Uw1g
	 nZlRjwfsazXWfBrRipSUdVudc5SZqXV5oAsha8X8jdN8RRh5S8XBAlA2ctgFXEpqWY
	 Cs7SL7UACELTtq2DIPOA2OAZ3HXGk5NUaFNK9em4=
Date: Thu, 23 Oct 2025 16:19:48 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-obsolete_target-file.patch added to mm-new branch
Message-Id: <20251023231948.A6383C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support obsolete_target file
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-support-obsolete_target-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-obsolete_target-file.patch

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

