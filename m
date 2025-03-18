Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062481C6889
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274556; cv=none; b=TfiKVUFFRlBIvAoAX5Durg5xG0irD5xLt0pua14ugfGpJkhBNcjbBpIOkKSpTR8yYaUJwtsyafcBjZzqfe10VFexz1v9Xn2HWmEHVhIMdFYXw71qfQ23wdvudT9vt+D4XLYkIFft298R0ymcXAPNgvzvGdLUB5Z/MpM6XKJlpuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274556; c=relaxed/simple;
	bh=WlNbkIkD8EC9XmFii3z4WXPb58gR+KU1WG0MIK+8rSA=;
	h=Date:To:From:Subject:Message-Id; b=hSb9bbZicT8U9MkAZxlGSFTUTueLCpgqGuxl7kwANU4iZ2EjmMXtk7/hI9t05NIbl0EZH+hTudrXOAdt/iG0M9H/znf3X4LS9TLl4hjoEGzQciK/79A5AkkyBFTuCEX3elWuojYxAa4/IFeea8r6wMNmRKviaqdCODNtmgZwFmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yhfb6s36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yhfb6s36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC55AC4CEDD;
	Tue, 18 Mar 2025 05:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274555;
	bh=WlNbkIkD8EC9XmFii3z4WXPb58gR+KU1WG0MIK+8rSA=;
	h=Date:To:From:Subject:From;
	b=Yhfb6s36GeDkKkOTVtu2VGuPGsdtZYYfaai6eJy548FptMFVdYqaL3I0Ev/mNBO7T
	 Y18BXFNSQbq8A44LQ3R7HO+jD+N1r3nsPJ9+g36uN13a5dCqUaeRINOhX4sKWOwtPf
	 KMmE8Xfm2pN6WZ3ZMtcq6gEZSQ+1X8PZy9e1/M2U=
Date: Mon, 17 Mar 2025 22:09:15 -0700
To: mm-commits@vger.kernel.org,corbet@lwn.net,arnd@arndb.de,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch removed from -mm tree
Message-Id: <20250318050915.CC55AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/sysfs-schemes: let damon_sysfs_scheme_set_filters() be used for different named directories
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs-schemes: let damon_sysfs_scheme_set_filters() be used for different named directories
Date: Wed, 5 Mar 2025 14:27:26 -0800

Patch series "mm/damon: add sysfs dirs for managing DAMOS filters based on
handling layers".

DAMOS filters are categorized into two groups based on their handling
layers, namely core and operations layers.  The categorization affects
when each filter is evaluated.  Core layer handled filters are evaluated
first.  The order meant nothing before, but introduction of allow filters
changed that.

DAMOS sysfs interface provides single directory for filters, namely
'filters'.  Users can install any filters in any order there.  DAMON will
internally categorize those into core and operations layer handled ones,
and apply the evaluation order rule.  The ordering rule is clearly
documented.  But the interface could still confuse users since it is
allowed to install filters on the directory in mixed ways.

Add two sysfs directories for managing filters by handling layers, namely
'core_filters' and 'ops_filters' for filters that handled by core and
operations layer, respectively.  Those are avoided to be used for
installing filters that not handled by the assumed layers.

For backward compatibility, keep 'filters' directory with its curernt
behavior.  Filters installed in the directory will be added to DAMON after
those of 'core_filters' and 'ops_filters' directories, with the automatic
categorizations.  Also recommend users to use the new directories while
noticing 'filters' directory could be deprecated in future on the usage
documents.

Note that new directories provide all features that were provided with
'filters', but just in a more clear way.  Deprecating 'filters' in future
will hence not make an irreversal feature loss.


This patch (of 8):

damon_sysfs_scheme_set_filters() is using a hard-coded directory name,
"filters".  Refactor for general named directories of same files
hierarchy, to use from upcoming changes for adding sibling directories
having files same to those of "filters", and named as "core_filters" and
"ops_filters".

[arnd@arndb.deL avoid Wformat-security warning]
  Link: https://lkml.kernel.org/r/20250310135142.4176976-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20250305222733.59089-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250305222733.59089-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories
+++ a/mm/damon/sysfs-schemes.c
@@ -1604,7 +1604,9 @@ static int damon_sysfs_scheme_set_waterm
 	return err;
 }
 
-static int damon_sysfs_scheme_set_filters(struct damon_sysfs_scheme *scheme)
+static int damon_sysfs_scheme_set_filters(struct damon_sysfs_scheme *scheme,
+		const char *name,
+		struct damon_sysfs_scheme_filters **filters_ptr)
 {
 	struct damon_sysfs_scheme_filters *filters =
 		damon_sysfs_scheme_filters_alloc();
@@ -1614,11 +1616,11 @@ static int damon_sysfs_scheme_set_filter
 		return -ENOMEM;
 	err = kobject_init_and_add(&filters->kobj,
 			&damon_sysfs_scheme_filters_ktype, &scheme->kobj,
-			"filters");
+			"%s", name);
 	if (err)
 		kobject_put(&filters->kobj);
 	else
-		scheme->filters = filters;
+		*filters_ptr = filters;
 	return err;
 }
 
@@ -1670,7 +1672,8 @@ static int damon_sysfs_scheme_add_dirs(s
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
 		goto put_quotas_access_pattern_out;
-	err = damon_sysfs_scheme_set_filters(scheme);
+	err = damon_sysfs_scheme_set_filters(scheme, "filters",
+			&scheme->filters);
 	if (err)
 		goto put_watermarks_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_stats(scheme);
_

Patches currently in -mm which might be from sj@kernel.org are


