Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E548F7A
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739415; cv=none; b=F5aNHw47IaYYH8lBH8etNDc6hUnMELw3YYCNZE0NJ/9WYHsjEe59/3dS0GVI5F97WHs81XwLIX+KcBJa70CQu6RD/9bDDmCKOP4DWltXRWB1KZkNYVPAFx9Jzc+dT8dX4Eu006Br4VBBF0xQFwM0fGMddvovP4cWDOZLqXomAKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739415; c=relaxed/simple;
	bh=YjaRSFX5dbzLSnf6WO84N12uiciLynORn0erwJpktZM=;
	h=Date:To:From:Subject:Message-Id; b=aEKsmhoN2xPxcBgOLsOPVAaf4dFMe+33jCixr4zkwUAUl3NKRJvM/OLeDMw+vIclyYqstIXpNkdQKYDoe9Gh0FPmVEgRAJhDEvdWZEhByDluu4XAieGV1bMFJ4YhTfW3JETixPDq1WAsgaAMqKmcjou7qMf9rk2qObhv8atEMtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C/faalvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C/faalvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB16C433C7;
	Sat, 24 Feb 2024 01:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739415;
	bh=YjaRSFX5dbzLSnf6WO84N12uiciLynORn0erwJpktZM=;
	h=Date:To:From:Subject:From;
	b=C/faalvgC7mWEljBNAU8sR99Rgr3ysjI+0G7PP/fgzVf4gWxZqlXKFjdRcsGWfG9X
	 fUlRMCCWozkigbPvErNoaI4yXP5wdPhOYI07q8jY+P4lhUuMF2lSrucXoZEfffylMl
	 dPhFkdklYhe++3sl5oCZxgJ55TBMsu0p8YG97cN8=
Date: Fri, 23 Feb 2024 17:50:14 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch removed from -mm tree
Message-Id: <20240224015015.5DB16C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document effective_bytes file
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: document effective_bytes file
Date: Mon, 19 Feb 2024 11:44:16 -0800

Update DAMON usage document for the effective quota file of the DAMON
sysfs interface.

Link: https://lkml.kernel.org/r/20240219194431.159606-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   19 ++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-effective_bytes-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -83,7 +83,7 @@ comma (",").
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
     │ │ │ │ │ │ │ │ age/min,max
-    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms
+    │ │ │ │ │ │ │ :ref:`quotas <sysfs_quotas>`/ms,bytes,reset_interval_ms,effective_bytes
     │ │ │ │ │ │ │ │ weights/sz_permil,nr_accesses_permil,age_permil
     │ │ │ │ │ │ │ │ :ref:`goals <sysfs_schemes_quota_goals>`/nr_goals
     │ │ │ │ │ │ │ │ │ 0/target_value,current_value
@@ -153,6 +153,9 @@ Users can write below commands for the k
 - ``clear_schemes_tried_regions``: Clear the DAMON-based operating scheme
   action tried regions directory for each DAMON-based operation scheme of the
   kdamond.
+- ``update_schemes_effective_bytes``: Update the contents of
+  ``effective_bytes`` files for each DAMON-based operation scheme of the
+  kdamond.  For more details, refer to :ref:`quotas directory <sysfs_quotas>`.
 
 If the state is ``on``, reading ``pid`` shows the pid of the kdamond thread.
 
@@ -320,8 +323,9 @@ schemes/<N>/quotas/
 The directory for the :ref:`quotas <damon_design_damos_quotas>` of the given
 DAMON-based operation scheme.
 
-Under ``quotas`` directory, three files (``ms``, ``bytes``,
-``reset_interval_ms``) and two directores (``weights`` and ``goals``) exist.
+Under ``quotas`` directory, four files (``ms``, ``bytes``,
+``reset_interval_ms``, ``effective_bytes``) and two directores (``weights`` and
+``goals``) exist.
 
 You can set the ``time quota`` in milliseconds, ``size quota`` in bytes, and
 ``reset interval`` in milliseconds by writing the values to the three files,
@@ -332,6 +336,15 @@ apply the action to only up to ``bytes``
 quota limits unless at least one :ref:`goal <sysfs_schemes_quota_goals>` is
 set.
 
+The time quota is internally transformed to a size quota.  Between the
+transformed size quota and user-specified size quota, smaller one is applied.
+Based on the user-specified :ref:`goal <sysfs_schemes_quota_goals>`, the
+effective size quota is further adjusted.  Reading ``effective_bytes`` returns
+the current effective size quota.  The file is not updated in real time, so
+users should ask DAMON sysfs interface to update the content of the file for
+the stats by writing a special keyword, ``update_schemes_effective_bytes`` to
+the relevant ``kdamonds/<N>/state`` file.
+
 Under ``weights`` directory, three files (``sz_permil``,
 ``nr_accesses_permil``, and ``age_permil``) exist.
 You can set the :ref:`prioritization weights
_

Patches currently in -mm which might be from sj@kernel.org are


