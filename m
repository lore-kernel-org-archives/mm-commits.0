Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF132451C1
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837166; cv=none; b=A349MWPmWnvqaA4+/5W4EvLPGwkYV3pDLvOsZga3bVwnkIOtyt3FZILIsWnqKMe7fCzLcOMosXvaRrtSBL3TYzWw1ulz0rThAUwrNz2AKd+hVFuxJQjJSR5efkM9DQ9IDF8q+6xqfXM6qHrHXCCqeZlRvnU4aVC8bpJEyWp4Xoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837166; c=relaxed/simple;
	bh=kexwLfUwSb8Ek1RxTckHy+AuhclnEhPPj52TIJ+4Jr8=;
	h=Date:To:From:Subject:Message-Id; b=Pk/O0xeWv/S9lmGDrvceqDsq5F7Z2vtTAULHXvSiRwx9qdUUEIT0RZKgEA2dL1A8QkXkzLdpLFaPM/D0Wxtz4lMtSlj26R6HPKU7TxtggYSZLc8UjSGiP5l349bOi9AFdKlpjw9rCEJV2eYs0W/xb4UhABEQ50G8N5c9lMMT0ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tT+ioT3T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tT+ioT3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBFCC4CEDF;
	Tue, 14 Jan 2025 06:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837166;
	bh=kexwLfUwSb8Ek1RxTckHy+AuhclnEhPPj52TIJ+4Jr8=;
	h=Date:To:From:Subject:From;
	b=tT+ioT3TK3cheFiZkr0GxNe7lzRjratfC9C6s6icHLy1r0XF2TW8UEw5/RLQQRTob
	 1HHLkp4MVgbVT2uyQi5vxmT1a1/GfV/wSGu8BLJImvzw17j80Fq59HILfBvi5/Rm57
	 K53oVGnZbVrJ7wWf7dJNNo+qTTk06A/CwL2vZjWg=
Date: Mon, 13 Jan 2025 22:46:05 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch removed from -mm tree
Message-Id: <20250114064606.5FBFCC4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document sz_ops_filter_passed
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document sz_ops_filter_passed
Date: Mon, 6 Jan 2025 11:33:55 -0800

Document the new per-scheme operations set layer-handled DAMOS filters
passed bytes statistic file on DAMON sysfs interface usage document.

Link: https://lkml.kernel.org/r/20250106193401.109161-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   20 +++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-sz_ops_filter_passed
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -90,7 +90,7 @@ comma (",").
     │ │ │ │ │ │ │ :ref:`watermarks <sysfs_watermarks>`/metric,interval_us,high,mid,low
     │ │ │ │ │ │ │ :ref:`filters <sysfs_filters>`/nr_filters
     │ │ │ │ │ │ │ │ 0/type,matching,memcg_id
-    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,qt_exceeds
+    │ │ │ │ │ │ │ :ref:`stats <sysfs_schemes_stats>`/nr_tried,sz_tried,nr_applied,sz_applied,sz_ops_filter_passed,qt_exceeds
     │ │ │ │ │ │ │ :ref:`tried_regions <sysfs_schemes_tried_regions>`/total_bytes
     │ │ │ │ │ │ │ │ 0/start,end,nr_accesses,age
     │ │ │ │ │ │ │ │ ...
@@ -454,18 +454,16 @@ difference is applied to :ref:`stats <da
 schemes/<N>/stats/
 ------------------
 
-DAMON counts the total number and bytes of regions that each scheme is tried to
-be applied, the two numbers for the regions that each scheme is successfully
-applied, and the total number of the quota limit exceeds.  This statistics can
-be used for online analysis or tuning of the schemes.  Refer to :ref:`design
-doc <damon_design_damos_stat>` for more details about the stats.
+DAMON counts statistics for each scheme.  This statistics can be used for
+online analysis or tuning of the schemes.  Refer to :ref:`design doc
+<damon_design_damos_stat>` for more details about the stats.
 
 The statistics can be retrieved by reading the files under ``stats`` directory
-(``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``, and
-``qt_exceeds``), respectively.  The files are not updated in real time, so you
-should ask DAMON sysfs interface to update the content of the files for the
-stats by writing a special keyword, ``update_schemes_stats`` to the relevant
-``kdamonds/<N>/state`` file.
+(``nr_tried``, ``sz_tried``, ``nr_applied``, ``sz_applied``,
+``sz_ops_filter_passed``, and ``qt_exceeds``), respectively.  The files are not
+updated in real time, so you should ask DAMON sysfs interface to update the
+content of the files for the stats by writing a special keyword,
+``update_schemes_stats`` to the relevant ``kdamonds/<N>/state`` file.
 
 .. _sysfs_schemes_tried_regions:
 
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

