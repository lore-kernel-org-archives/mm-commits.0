Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5086E36E476;
	Sat, 18 Apr 2026 07:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498909; cv=none; b=WJN0/EdBQRPcTcdT3krGYhPtXLHGkAdgrzA0hUmSd+j3JBnAIIga5ctem4Ng5hQXNk1RAMP76k7WXWvAPrt/cKuampd1fnl1AA5um37MG+56qOVQtcSDt1Bf/v1STgaVdtB/4p9bQD5CrcD4EcB5rv5qcrh3pgkb6/5gxHecfgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498909; c=relaxed/simple;
	bh=zy2exY+W79EhQ4eULeVVNfiA6QqczW5YXeXX6v0K1xM=;
	h=Date:To:From:Subject:Message-Id; b=ixyrSIVVs7PEqxqLhcJ76HORPog5o2OCfPx2xFuhfY2Xhlnqx0vFVibEZHHcr0PKGU35Zcc2XGi+45LsBZa8oXV5BrMI9N4YHwL9xJIsDguB/4yxlutaMJvWxp2XVPe9ucENN8epNFeojsx3yWKaTq0p+OOIKsJ67z+pEiBFPvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ElEYOR3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ElEYOR3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477C8C19424;
	Sat, 18 Apr 2026 07:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498909;
	bh=zy2exY+W79EhQ4eULeVVNfiA6QqczW5YXeXX6v0K1xM=;
	h=Date:To:From:Subject:From;
	b=ElEYOR3DJyCVIlW2bMUKliiayqdXEFYWoY0n/4DA/mQHzxFFFazD2M84qXsRqFn5y
	 10oIuGu4qfoKqRTgLPiHT0+RGD3NcmmtNjRP0wOJ8dlee74Y1MMDFxNWBkcFy6HbsB
	 CynV5Vsemuoc59xki/JHKDecVyNghu5QcIPz5EG8=
Date: Sat, 18 Apr 2026 00:55:04 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race.patch removed from -mm tree
Message-Id: <20260418075508.477C8C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/lru_sort: warn commit_inputs vs param updates race
Date: Sun, 29 Mar 2026 08:30:50 -0700

DAMON_LRU_SORT handles commit_inputs request inside kdamond thread,
reading the module parameters.  If the user updates the module
parameters while the kdamond thread is reading those, races can happen.
To avoid this, the commit_inputs parameter shows whether it is still in
the progress, assuming users wouldn't update parameters in the middle of
the work.  Some users might ignore that.  Add a warning about the
behavior.

The issue was discovered in [1] by sashiko.

Link: https://lore.kernel.org/20260329153052.46657-3-sj@kernel.org
Link: https://lore.kernel.org/20260319161620.189392-2-objecting@objecting.org [1]
Fixes: 6acfcd0d7524 ("Docs/admin-guide/damon: add a document for DAMON_LRU_SORT")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.0.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/lru_sort.rst |    4 ++++
 1 file changed, 4 insertions(+)

--- a/Documentation/admin-guide/mm/damon/lru_sort.rst~docs-admin-guide-mm-damon-lru_sort-warn-commit_inputs-vs-param-updates-race
+++ a/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -79,6 +79,10 @@ of parametrs except ``enabled`` again.
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_LRU_SORT will be disabled.
 
+Once ``Y`` is written to this parameter, the user must not write to any
+parameters until reading ``commit_inputs`` again returns ``N``.  If users
+violate this rule, the kernel may exhibit undefined behavior.
+
 active_mem_bp
 -------------
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-disallow-time-quota-setting-zero-esz.patch
mm-damon-core-disallow-non-power-of-two-min_region_sz-on-damon_start.patch

