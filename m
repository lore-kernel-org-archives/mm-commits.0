Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC5B19E7E2
	for <mm-commits@vger.kernel.org>; Fri, 22 Aug 2025 23:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755905836; cv=none; b=r08Ey49Da/CgHeSA64alFaqlh4soQ5WHGD9RJZZ6axKDYlHkMmrw2gGn2kGf/80EAmKw5jbwV+n1A4ClAP8MKZlkGYijMRpzJXSbl0IZrDuVsOpiOG6NgoHs/VEaCm2tGlgvcNN9cZcX5kfgnP5MPW+V7FTLP1aprzyFWsq3Pvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755905836; c=relaxed/simple;
	bh=sdC0xj4tV3a+K5oi2jd/fOFQNlwXS36NXoNHT6qOlBQ=;
	h=Date:To:From:Subject:Message-Id; b=F13EusXX4QWj+OCeoxaE/En7IpZe4bxN6029ByKwYw1496nC9Ij6ciffR01sM3zpuyIvg3G9OTN+JkanUSfVxHVEJjHyhgKtrSnY1Qj3cpgVRNjgiHWcQmVWqgfejiO7CCiFqOzYQShFje1MbH8pGke4LNo82wJxFNEK8bDT/0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x/BlVcg5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x/BlVcg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80250C4CEED;
	Fri, 22 Aug 2025 23:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755905836;
	bh=sdC0xj4tV3a+K5oi2jd/fOFQNlwXS36NXoNHT6qOlBQ=;
	h=Date:To:From:Subject:From;
	b=x/BlVcg5BD6oRf0OjA1/MsUJPnThu/WIyiAOkrF8Gc0+Q1J0rEZ8VozsmXZVUqY7J
	 YZNmUqaTlS881xh6CTO1dcE2u7dD4dmYHRDjF5FYb4cgBrFk1t/QWyqkhsQQLr3Q36
	 +ATNh2jNZSlAdScyAzHevSAhCQT3riiukbLaDkRo=
Date: Fri, 22 Aug 2025 16:37:15 -0700
To: mm-commits@vger.kernel.org,zuoze1@huawei.com,yanquanmin1@huawei.com,wangkefeng.wang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch added to mm-new branch
Message-Id: <20250822233716.80250C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: document addr_unit file
has been added to the -mm mm-new branch.  Its filename is
     docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-document-addr_unit-file.patch

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
Subject: Docs/admin-guide/mm/damon/usage: document addr_unit file
Date: Fri, 22 Aug 2025 17:34:17 +0800

Document addr_unit DAMON sysfs file on DAMON usage document.

Link: https://lkml.kernel.org/r/20250822093420.2103803-10-yanquanmin1@huawei.com
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   11 +++++++----
 Documentation/mm/damon/design.rst            |    2 ++
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-document-addr_unit-file
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -61,7 +61,7 @@ comma (",").
     │ :ref:`kdamonds <sysfs_kdamonds>`/nr_kdamonds
     │ │ :ref:`0 <sysfs_kdamond>`/state,pid,refresh_ms
     │ │ │ :ref:`contexts <sysfs_contexts>`/nr_contexts
-    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations
+    │ │ │ │ :ref:`0 <sysfs_context>`/avail_operations,operations,addr_unit
     │ │ │ │ │ :ref:`monitoring_attrs <sysfs_monitoring_attrs>`/
     │ │ │ │ │ │ intervals/sample_us,aggr_us,update_us
     │ │ │ │ │ │ │ intervals_goal/access_bp,aggrs,min_sample_us,max_sample_us
@@ -188,9 +188,9 @@ details).  At the moment, only one conte
 contexts/<N>/
 -------------
 
-In each context directory, two files (``avail_operations`` and ``operations``)
-and three directories (``monitoring_attrs``, ``targets``, and ``schemes``)
-exist.
+In each context directory, three files (``avail_operations``, ``operations``
+and ``addr_unit``) and three directories (``monitoring_attrs``, ``targets``,
+and ``schemes``) exist.
 
 DAMON supports multiple types of :ref:`monitoring operations
 <damon_design_configurable_operations_set>`, including those for virtual address
@@ -205,6 +205,9 @@ You can set and get what type of monitor
 context by writing one of the keywords listed in ``avail_operations`` file and
 reading from the ``operations`` file.
 
+``addr_unit`` file is for setting and getting the :ref:`address unit
+<damon_design_addr_unit>` parameter of the operations set.
+
 .. _sysfs_monitoring_attrs:
 
 contexts/<N>/monitoring_attrs/
--- a/Documentation/mm/damon/design.rst~docs-admin-guide-mm-damon-usage-document-addr_unit-file
+++ a/Documentation/mm/damon/design.rst
@@ -135,6 +135,8 @@ the interference is the responsibility o
 conflict with the reclaim logic using ``PG_idle`` and ``PG_young`` page flags,
 as Idle page tracking does.
 
+.. _damon_design_addr_unit:
+
 Address Unit
 ------------
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-zswap-store-page_size-compression-failed-page-as-is.patch
mm-zswap-store-page_size-compression-failed-page-as-is-fix.patch
mm-zswap-store-page_size-compression-failed-page-as-is-v5.patch
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

