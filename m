Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D28D21A0C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719290047; cv=none; b=Kbimkgd05CcT2kHL1oIkLTzbwykWvDeiNav49WbpuosIm81+LJlu4Jiq6D/RksV9SgEPfLAX7rxRp/BJwbwPC0mQb5cIZBo7zqZTfgXKzRKOUdUx5J8Ose/zxVicIzEc+TdSfrWnqhTNZv6XhlS6/wj1wGuMlvMotdHmRU+DLrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719290047; c=relaxed/simple;
	bh=/xbm+PmceureD4wB3xQqjMo5G6hXoN2t6CWzhRGe2W0=;
	h=Date:To:From:Subject:Message-Id; b=L6xDUQ7NenL2IC9JZ2bvT5bdm1AFUuoUFRRrNMKEzUR4KSab5qs8h1LpK0mOkySCensFGcbvzqWDrsIkG7CvgJqbCLCL7r3yRPNrte0uGeY6F5uA5Ch7uePHWQ8Q54jrMqZ9vLSiS7lqpx4klc+UivQM8KDr9MgWDzRLUsI0ZR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IqhIc6ne; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IqhIc6ne"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96EAC32782;
	Tue, 25 Jun 2024 04:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719290047;
	bh=/xbm+PmceureD4wB3xQqjMo5G6hXoN2t6CWzhRGe2W0=;
	h=Date:To:From:Subject:From;
	b=IqhIc6nekLMHEuWSDhDffEetoqxmCJDlaoGc7bGYMtIkUw/WGTjezFZ/q+ZO81S+l
	 02Q38H+5c0hOEnKPm4wQ2NR5unjcpCmCntqMQzA1tN6Sv0rSlYsl8Xn1sp8Z/F7EVG
	 F13tdsthnLj1h8Savl3CGuppNlofIJxbbo35zFV0=
Date: Mon, 24 Jun 2024 21:34:06 -0700
To: mm-commits@vger.kernel.org,honggyu.kim@sk.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes-fix.patch removed from -mm tree
Message-Id: <20240625043406.E96EAC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/ABI/damon: document target_nid file
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes-fix.patch

This patch was dropped because it was folded into mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/ABI/damon: document target_nid file
Date: Tue, 18 Jun 2024 14:36:30 -0700

Document target_nid DAMON sysfs file that introduced for
DAMOS_MIGRATE_{HOT,COLD}.

Link: https://lkml.kernel.org/r/20240618213630.84846-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Honggyu Kim <honggyu.kim@sk.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-kernel-mm-damon |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon~mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes-fix
+++ a/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -155,6 +155,12 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the action
 		of the scheme.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/target_nid
+Date:		Jun 2024
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Action's target NUMA node id.  Supported by only relevant
+		actions.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/apply_interval_us
 Date:		Sep 2023
 Contact:	SeongJae Park <sj@kernel.org>
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
mm-damon-sysfs-schemes-add-target_nid-on-sysfs-schemes.patch
docs-damon-document-damos_migrate_hotcold-fix.patch
mm-damon-core-implement-damos-quota-goals-online-commit-function.patch
mm-damon-core-implement-damon-context-commit-function.patch
mm-damon-sysfs-use-damon_commit_ctx.patch
mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch
mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets.patch
mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch
mm-damon-reclaim-use-damon_commit_ctx.patch
mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch
mm-damon-lru_sort-use-damon_commit_ctx.patch
mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

