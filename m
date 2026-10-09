Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA15140099C
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525444; cv=none; b=elwgM2vNC1xUHjfFMFasJHc0CHzFqtBp6CIPW3fXKuzEcjXoZf5RpGxVOZjPjkxrRnn/iJxc9M3DKENB3ALkKCtyOBx/prD2HcRfChQjQbgL89yPiuiNEXNgMbA5fMfhirgLD7/Txvr993mG3pCeKZ2zB2nTICs66kgrXdQXJxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525444; c=relaxed/simple;
	bh=aB9vBMq1yyhC+dvL3s1lwaq06J4iH/+4N0ndW/EzDwE=;
	h=Date:To:From:Subject:Message-Id; b=AjgAo/k2BwCm+rCNsZ0WtFd6kOsup2h/XMu5kTcltQMbkPfBjww8rsD/0qrjZdZkKVRZ86otjL+08qzdNe7UxVpsi0X6W1aCSu5xpdz9HSst8zGsIOuu0mflQrYf0pmjLgkkWo82vWqMc5EMjpWWWgQErmlR5RK/lydd8mHK0FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lrXfc1h1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lrXfc1h1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A431F00893;
	Fri,  9 Oct 2026 05:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525443;
	bh=Qz2wnql1XUUQiwWPVSCC6lWwMOM5fPhGoyP4MgGZOeo=;
	h=Date:To:From:Subject;
	b=lrXfc1h1n9ACax6/bsylAUhaoHmEq0rtcvE/16Y7gq1J4WQ4vOWHKZrU2ewx1Ubnp
	 aE3ZBg6R7EuRbHxfcppAlaNR+/Dh7ZAmxlWWaCrZzcPv0zaDpcdO8BNXpex8Egxu5h
	 Zms74yFDoV4E6iTgOprSovL3TDa3+pQAo9UaWnnk=
Date: Thu, 08 Oct 2026 22:57:23 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,zenghui.yu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch removed from -mm tree
Message-Id: <20261009055723.A0A431F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/mm/damon/design: fix broken :ref: usage and a typo
has been removed from the -mm tree.  Its filename was
     docs-mm-damon-design-fix-broken-ref-usage-and-a-typo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: Docs/mm/damon/design: fix broken :ref: usage and a typo
Date: Tue, 8 Sep 2026 06:52:55 -0700

The Statistics section refers readers to the DAMON sysfs interface
documentation for how to read the statistics, using a ':ref:' role. 
However, the role name has a superfluous 's' appended (':ref:s' instead of
':ref:').  Moreover, its target label 'sysfs_stats' does not exist; the
correct label is 'sysfs_schemes_stats'.  Fix both.

Also fix a typo, 'frequenceis' -> 'frequencies', in the Adaptive Regions
Adjustment section.

Link: https://lore.kernel.org/20260908135257.97523-1-sj@kernel.org
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-fix-broken-ref-usage-and-a-typo
+++ a/Documentation/mm/damon/design.rst
@@ -249,7 +249,7 @@ For each ``aggregation interval``, it co
 sum of the two regions' sizes is smaller than the size of total regions divided
 by the ``minimum number of regions``, DAMON merges the two regions.  If the
 resulting number of total regions is still higher than ``maximum number of
-regions``, it repeats the merging with increasing access frequenceis difference
+regions``, it repeats the merging with increasing access frequencies difference
 threshold until the upper-limit of the number of regions is met, or the
 threshold becomes higher than possible maximum value (``aggregation interval``
 divided by ``sampling interval``).   Then, after it reports and clears the
@@ -889,7 +889,7 @@ the scheme is deactivated.  Note that, u
 ``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
-<sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
+<sysfs_interface>`, refer to :ref:`stats <sysfs_schemes_stats>` part of the
 documentation.
 
 Regions Walking
_

Patches currently in -mm which might be from zenghui.yu@linux.dev are

selftests-damon-stop-kdamond-on-error-exits-of-no-op-commit-test.patch
selftests-damon-ignore-test-generated-damon_dump_output.patch
mm-damon-api-remove-unused-nr_damos_-enumerators.patch

