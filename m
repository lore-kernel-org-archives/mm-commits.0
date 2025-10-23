Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F7F2BB1D
	for <mm-commits@vger.kernel.org>; Thu, 23 Oct 2025 23:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761261585; cv=none; b=lwNrJA/M6TyoEzwFggVK1ZIAE/PLT3x8L2KLyKHY9Ced4zFQjRrXlmAT4a4ZQi7swis0sQ1Ru2wDvhJyVLsCUvS3Ycb63LvTTQeXxLgBH3pfiSMjtn4YiSuhRSVVomjOk24RYtW3vMZe7gndo2cjFNwVPM1YkfuV6Z7vPcdfDXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761261585; c=relaxed/simple;
	bh=5K1JOf6qWJ0dh8AfF394/6JwK0xAItu+dciwGgFUuZg=;
	h=Date:To:From:Subject:Message-Id; b=Vo3uKSwD4O1+5GYzMI7//UnQh6c03iY7hExbteby9bCgSth+IpXhhqQLu0OYw7gpADCgXqU5UXDMmMlbsJfY8RMhoavzF82wv2HQ9eABMEWgVX791vG5wAZSQAG40kr5eiJaRe9ZosDsNuzCtvKE6rWnDnSWtClRpNNJAOKuap8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IMS95zhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IMS95zhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A6CC4CEE7;
	Thu, 23 Oct 2025 23:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761261584;
	bh=5K1JOf6qWJ0dh8AfF394/6JwK0xAItu+dciwGgFUuZg=;
	h=Date:To:From:Subject:From;
	b=IMS95zhNraInXBeiwIPhD8ALJvnt8pEaUqQp74h1M0q3Kzp71qjWMEzui13mKg8m7
	 jDKax9wxGEkbig0ylq7ZWI35Qbxe11qKvBJcrkvyXwNdYgqgDk5J4MATWwTd3j3RFI
	 A3SS7fPzHoGp/GlzVuRCMLq9V8SQHEcjgfbHTSBw=
Date: Thu, 23 Oct 2025 16:19:44 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,corbet@lwn.net,bijan311@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch added to mm-new branch
Message-Id: <20251023231944.B9A6CC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document obsolete_target file
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-obsolete_target-file.patch

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
Subject: Docs/admin-guide/mm/damon/usage: document obsolete_target file
Date: Wed, 22 Oct 2025 18:25:28 -0700

Document the newly added obsolete_target DAMON sysfs file.

Link: https://lkml.kernel.org/r/20251023012535.69625-5-sj@kernel.org
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

 Documentation/admin-guide/mm/damon/usage.rst |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-obsolete_target-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -67,7 +67,7 @@ comma (",").
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
-    │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target
+    │ │ │ │ │ │ :ref:`0 <sysfs_target>`/pid_target,obsolete_target
     │ │ │ │ │ │ │ :ref:`regions <sysfs_regions>`/nr_regions
     │ │ │ │ │ │ │ │ :ref:`0 <sysfs_region>`/start,end
     │ │ │ │ │ │ │ │ ...
@@ -264,13 +264,20 @@ to ``N-1``.  Each directory represents e
 targets/<N>/
 ------------
 
-In each target directory, one file (``pid_target``) and one directory
-(``regions``) exist.
+In each target directory, two files (``pid_target`` and ``obsolete_target``)
+and one directory (``regions``) exist.
 
 If you wrote ``vaddr`` to the ``contexts/<N>/operations``, each target should
 be a process.  You can specify the process to DAMON by writing the pid of the
 process to the ``pid_target`` file.
 
+Users can selectively remove targets in the middle of the targets array by
+writing non-zero value to ``obsolete_target`` file and committing it (writing
+``commit`` to ``state`` file).  DAMON will remove the matching targets from its
+internal targets array.  Users are responsible to construct target directories
+again, so that those correctly represent the changed internal targets array.
+
+
 .. _sysfs_regions:
 
 targets/<N>/regions
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

