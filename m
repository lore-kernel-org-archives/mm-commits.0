Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DBA1714C0
	for <mm-commits@vger.kernel.org>; Tue, 13 May 2025 01:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747099092; cv=none; b=lV4+XJR0ctUQNP5o+LHW5RdrXjLpmTY7HBoUrWhKLFTfR9Xkn3NQbpdSfGcwkE7r/NPaI50qr4eTIOKTGpRYsMMe85DOPIzNXktY03Cg4CxiQHk16S0Qg9aSNxzTdxgoHH6fCucc7qY/vwKd2Os5YmKFTzEtd65dOO+GFYByHzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747099092; c=relaxed/simple;
	bh=8G0rFvTvu/CJvsHvbbczDgIRz6KvqRwd1KzBWJDLJoM=;
	h=Date:To:From:Subject:Message-Id; b=QpJrlVwSJdNKMxdzL3oNZCBKHfpQLycA/CApGmZiuw9y69oeB2GnZ3yXVC/2q6dTIcCVVXrtXs4gDt8I7UoqIlAydek9ClRotWqvWYj7/P/G7ey61X/2GmWios6jcz5H8Z3QCMqEVAc6q2ycqwh8eC8K/K07O+uC1GXccfKAW6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rlR7oHK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rlR7oHK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93916C4CEE7;
	Tue, 13 May 2025 01:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747099092;
	bh=8G0rFvTvu/CJvsHvbbczDgIRz6KvqRwd1KzBWJDLJoM=;
	h=Date:To:From:Subject:From;
	b=rlR7oHK0cgukHwC0Oi+u54kAL21WrI/VfauxPvW/IAsmoBrSf+r9E72Ga49pS6PEC
	 QTO5qXz1JTix01L4r0I2t0/0+Egci7qthmXNnugstex9QRhe1HpMTXRNTORdteyPEF
	 f74NyzgtebjKyZDSmGp9mAYH8RpzhZ3C5NJl5GiY=
Date: Mon, 12 May 2025 18:18:12 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch added to mm-new branch
Message-Id: <20250513011812.93916C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: read tried regions directories in order
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch

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
Subject: selftests/damon/_damon_sysfs: read tried regions directories in order
Date: Mon, 12 May 2025 17:27:14 -0700

Kdamond.update_schemes_tried_regions() reads and stores tried regions
information out of address order.  It makes debugging a test failure
difficult.  Change the behavior to do the reading and writing in the
address order.

Link: https://lkml.kernel.org/r/20250513002715.40126-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -420,11 +420,16 @@ class Kdamond:
                 tried_regions = []
                 tried_regions_dir = os.path.join(
                         scheme.sysfs_dir(), 'tried_regions')
+                region_indices = []
                 for filename in os.listdir(
                         os.path.join(scheme.sysfs_dir(), 'tried_regions')):
                     tried_region_dir = os.path.join(tried_regions_dir, filename)
                     if not os.path.isdir(tried_region_dir):
                         continue
+                    region_indices.append(int(filename))
+                for region_idx in sorted(region_indices):
+                    tried_region_dir = os.path.join(tried_regions_dir,
+                                                    '%d' % region_idx)
                     region_values = []
                     for f in ['start', 'end', 'nr_accesses', 'age']:
                         content, err = read_file(
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos-quota-goal-metrics-for-memory-node-utilization.patch
mm-damon-sysfs-schemes-implement-file-for-quota-goal-nid-parameter.patch
mm-damon-sysfs-schemes-connect-damos_quota_goal-nid-with-core-layer.patch
docs-mm-damon-design-document-node_mem_usedfree_bp.patch
docs-admin-guide-mm-damon-usage-document-nid-file.patch
docs-abi-damon-document-nid-file.patch
samples-damon-implement-a-damon-module-for-memory-tiering.patch
samples-damon-implement-a-damon-module-for-memory-tiering-fix.patch
mm-damon-core-warn-and-fix-nr_accesses-corruption.patch
mm-damon-sysfs-schemes-fix-wrong-comment-on-damons_sysfs_quota_goal_metric_strs.patch
mm-damon-paddr-remove-unused-variable-folio_list-in-damon_pa_stat.patch
mm-damon-tests-core-kunit-add-a-test-for-damos_set_filters_default_reject.patch
selftests-damon-_damon_sysfs-read-tried-regions-directories-in-order.patch
docs-damon-update-titles-and-brief-introductions-to-explain-damos.patch

