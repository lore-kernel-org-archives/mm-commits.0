Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65F64685
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560131; cv=none; b=aE40uI+ILJNE9Ix8ABZUzNL7XGYZcphNsNRhS/9Ub0DQv87e3AYgi3snE1lFM1KLJ281uiyIVyQDoFTW2F4Vs/Lkn81tOupds1azFSxBY1FmRM5Cgszso40d9fCOgKU9jr0K6Qt4jFGryXwJuPkmvxwpttSXKpstPtlQSswnabo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560131; c=relaxed/simple;
	bh=DJszT5OAQjlw9rqCNt1QAW9kLaliOA/muQ7TS5pebJU=;
	h=Date:To:From:Subject:Message-Id; b=NWPDLcVX0eFWzbATTncL3hEjizudoseqB30tO/Pg9jf1An/B5JFp6AplpL8FLHo2N4t07AYKmmO9xdBJ5NxDJCSP+69b0yaVbkihKXEJo2pap1WM5KMaW5tsLQpIeof0+ODAmLOKLBC3Rmcdoh3sbn6igc5XssUalQaMwjq+Zmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=so3yVcAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="so3yVcAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4817FC43399;
	Thu, 22 Feb 2024 00:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560131;
	bh=DJszT5OAQjlw9rqCNt1QAW9kLaliOA/muQ7TS5pebJU=;
	h=Date:To:From:Subject:From;
	b=so3yVcAXCfV35sLNrIm/seWLvaThIIJYpeVNhGQLfVtXmUb50wTpSglED/zi6DxOj
	 eEcy4b1w8VW1qGxhpz5Kbk2l1tljbHNXKNhWgO9xDvucYO+233tEARXmHFFvCip37s
	 4rrv4m57N+P3iCwvSkVbP64mLDIuhv0DytZPiuWI=
Date: Wed, 21 Feb 2024 16:02:10 -0800
To: mm-commits@vger.kernel.org,siyanteng@loongson.cn,shuah@kernel.org,corbet@lwn.net,alexs@kernel.org,2023002089@link.tyut.edu.cn,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch removed from -mm tree
Message-Id: <20240222000211.4817FC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: rename CONFIG_DAMON_DBGFS to DAMON_DBGFS_DEPRECATED
has been removed from the -mm tree.  Its filename was
     mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: rename CONFIG_DAMON_DBGFS to DAMON_DBGFS_DEPRECATED
Date: Mon, 29 Jan 2024 17:35:41 -0800

DAMON debugfs interface is deprecated.  The fact has documented by commit
5445fcbc4cda ("Docs/admin-guide/mm/damon/usage: add DAMON debugfs
interface deprecation notice").  Commit 620932cd2852 ("mm/damon/dbgfs:
print DAMON debugfs interface deprecation message") further started
printing a warning message when users still use it.  Many people don't
read documentation or kernel log, though.

Make the deprecation harder to be ignored using the approach of commit
eb07c4f39c3e ("mm/slab: rename CONFIG_SLAB to CONFIG_SLAB_DEPRECATED"). 
'make oldconfig' with 'CONFIG_DAMON_DBGFS=y' will get a new prompt with
the explicit deprecation notice on the name.  'make olddefconfig' with
'CONFIG_DAMON_DBGFS=y' will result in not building DAMON debugfs
interface.  If there is a real user of DAMON debugfs interface, they will
complain the change to the builder.

Link: https://lkml.kernel.org/r/20240130013549.89538-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Alex Shi <alexs@kernel.org>
Cc: Hu Haowen <2023002089@link.tyut.edu.cn>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Yanteng Si <siyanteng@loongson.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/Kconfig |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/damon/Kconfig~mm-damon-rename-config_damon_dbgfs-to-damon_dbgfs_deprecated
+++ a/mm/damon/Kconfig
@@ -71,7 +71,7 @@ config DAMON_SYSFS_KUNIT_TEST
 
 	  If unsure, say N.
 
-config DAMON_DBGFS
+config DAMON_DBGFS_DEPRECATED
 	bool "DAMON debugfs interface (DEPRECATED!)"
 	depends on DAMON_VADDR && DAMON_PADDR && DEBUG_FS
 	help
@@ -84,6 +84,11 @@ config DAMON_DBGFS
 	  (DAMON_SYSFS).  If you depend on this and cannot move, please report
 	  your usecase to damon@lists.linux.dev and linux-mm@kvack.org.
 
+config DAMON_DBGFS
+	bool
+	default y
+	depends on DAMON_DBGFS_DEPRECATED
+
 config DAMON_DBGFS_KUNIT_TEST
 	bool "Test for damon debugfs interface" if !KUNIT_ALL_TESTS
 	depends on DAMON_DBGFS && KUNIT=y
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-maintainer-profile-fix-reference-links-for-mm-stable-tree.patch
docs-mm-damon-move-the-list-of-damos-actions-to-design-doc.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document.patch
docs-mm-damon-move-damon-operation-sets-list-from-the-usage-to-the-design-document-fix.patch
docs-mm-damon-move-monitoring-target-regions-setup-detail-from-the-usage-to-the-design-document.patch
docs-admin-guide-mm-damon-usage-fix-wrong-quotas-diabling-condition.patch
mm-damon-core-set-damos_quota-esz-as-public-field-and-document.patch
mm-damon-sysfs-schemes-implement-quota-effective_bytes-file.patch
mm-damon-sysfs-implement-a-kdamond-command-for-updating-schemes-effective-quotas.patch
docs-abi-damon-document-effective_bytes-sysfs-file.patch
docs-admin-guide-mm-damon-usage-document-effective_bytes-file.patch
mm-damon-move-comments-and-fields-for-damos-quota-prioritization-to-the-end.patch
mm-damon-core-split-out-quota-goal-related-fields-to-a-struct.patch
mm-damon-core-add-multiple-goals-per-damos_quota-and-helpers-for-those.patch
mm-damon-sysfs-use-only-quota-goals.patch
mm-damon-core-remove-goal-field-of-damos_quota.patch
mm-damon-core-let-goal-specified-with-only-target-and-current-values.patch
mm-damon-core-support-multiple-metrics-for-quota-goal.patch
mm-damon-core-implement-psi-metric-damos-quota-goal.patch
mm-damon-sysfs-schemes-support-psi-based-quota-auto-tune.patch
docs-mm-damon-design-document-quota-goal-self-tuning.patch
docs-abi-damon-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file.patch
docs-admin-guide-mm-damon-usage-document-quota-goal-metric-file-fix.patch
mm-damon-reclaim-implement-user-feedback-driven-quota-auto-tuning.patch
mm-damon-reclaim-implement-memory-psi-driven-quota-self-tuning.patch
docs-admin-guide-mm-damon-reclaim-document-auto-tuning-parameters.patch

