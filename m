Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B07724C076;
	Tue,  9 Sep 2025 02:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757385462; cv=none; b=K6gYtaXgovsogKbm+Wd0vx2o8g4iBI2rlSlpa82TEx4vTB9aO5ZPQKO48D627FVFoky8qoyarYvxDHX5Xec+OBWg5vr/lG9rI+V+/73AXHeR4SQJzmQTKk8awr5B98xFLl6Jg6vBJ4dI9PqBkiI4gniilmFlWKjRlx+eUum5Z+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757385462; c=relaxed/simple;
	bh=iWqLToYwDbmj9YpSOx+VEK7A/udc35AhIr2tVrN+gZE=;
	h=Date:To:From:Subject:Message-Id; b=WprqD3fRelKiCCdzWtil2QzZ5mfwwVDC5JacJlC0YVsmYJPg35VvOkvjpDE6Xai+gyxu3GzCxsi0yXbZU9cPln50ActyHpYlB03zJ70tObR8JCaNCLwV1DpVxAXC8zM//KzR0Qf07QwHKSryswAI/KbzbqXC/A61NlC7U02fSJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=o3x5Cx+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="o3x5Cx+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE600C4CEF1;
	Tue,  9 Sep 2025 02:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757385462;
	bh=iWqLToYwDbmj9YpSOx+VEK7A/udc35AhIr2tVrN+gZE=;
	h=Date:To:From:Subject:From;
	b=o3x5Cx+Vx6hNZucC0AZ5fCqXpqxN8bio+yahmtoU2kkgwHNr2aS8WMlljisSxGXnb
	 41sSbSYau3g7J+D1TEVOeNxf+bwrkJVCZSEqipvPk5Chv3dK1ftEkwEg/yJ3lvjSj7
	 l6cOLfWKu91x/+4ojKztl7iGFyYzl6/S83IBPM78=
Date: Mon, 08 Sep 2025 19:37:41 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + samples-damon-prcl-avoid-starting-damon-before-initialization.patch added to mm-hotfixes-unstable branch
Message-Id: <20250909023741.DE600C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: samples/damon/prcl: avoid starting DAMON before initialization
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     samples-damon-prcl-avoid-starting-damon-before-initialization.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/samples-damon-prcl-avoid-starting-damon-before-initialization.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: samples/damon/prcl: avoid starting DAMON before initialization
Date: Mon, 8 Sep 2025 19:22:37 -0700

Commit 2780505ec2b4 ("samples/damon/prcl: fix boot time enable crash") is
somehow incompletely applying the origin patch [1].  It is missing the
part that avoids starting DAMON before module initialization.  Probably a
mistake during a merge has happened.  Fix it by applying the missed part
again.

Link: https://lkml.kernel.org/r/20250909022238.2989-3-sj@kernel.org
Link: https://lore.kernel.org/20250706193207.39810-3-sj@kernel.org [1]
Fixes: 2780505ec2b4 ("samples/damon/prcl: fix boot time enable crash")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 samples/damon/prcl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/samples/damon/prcl.c~samples-damon-prcl-avoid-starting-damon-before-initialization
+++ a/samples/damon/prcl.c
@@ -137,6 +137,9 @@ static int damon_sample_prcl_enable_stor
 	if (enabled == is_enabled)
 		return 0;
 
+	if (!init_called)
+		return 0;
+
 	if (enabled) {
 		err = damon_sample_prcl_start();
 		if (err)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damon_call_control-dealloc_on_cancel.patch
mm-damon-sysfs-use-dynamically-allocated-repeat-mode-damon_call_control.patch
samples-damon-wsse-avoid-starting-damon-before-initialization.patch
samples-damon-prcl-avoid-starting-damon-before-initialization.patch
samples-damon-mtier-avoid-starting-damon-before-initialization.patch
mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix-2.patch
mm-damon-core-add-damon_ctx-addr_unit.patch
mm-damon-paddr-support-addr_unit-for-access-monitoring.patch
mm-damon-paddr-support-addr_unit-for-damos_pageout.patch
mm-damon-paddr-support-addr_unit-for-damos_lru_prio.patch
mm-damon-paddr-support-addr_unit-for-migrate_hotcold.patch
mm-damon-paddr-support-addr_unit-for-damos_stat.patch
mm-damon-sysfs-implement-addr_unit-file-under-context-dir.patch
docs-mm-damon-design-document-address-unit-parameter.patch
docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch
docs-abi-damon-document-addr_unit-file.patch

