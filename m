Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35841FBBDE
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837202; cv=none; b=BpdTJbXbUo53F8q2X4+/2VAg3Pgt+SuEfTzogyX2ei8FQi2DFtVYobz6JjCZioSGSuoIESKUVgRVQIBUcoBOApuZ6khKCJYa08YeY/YSUL8LZW28IvzUGfK6L45YQbM5XobWzD+R1KMu0FeyvnCdILdISUPBbpNbj7p2SpfrEM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837202; c=relaxed/simple;
	bh=EgZruZrnriA70x8aF1ybDlgbBS0RGwEVcf63DwotybM=;
	h=Date:To:From:Subject:Message-Id; b=IbxJwityM7QIZyVV2TFT384SH8oGG1Me39pF3gOVFW2LW06DH9cw6tAqQqZfVM8E4VfELT8mLorJoDjJc9zFHelEGXjrja/0xCor3zEt1+WaErttpBuTAlRrQT8ya1wP+7pvxja6P8sdReuJ4qmRmJ8JvfbwFJEJ+f5RjQmw69I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wsNDUOrp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wsNDUOrp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB2BC4CEDD;
	Tue, 14 Jan 2025 06:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837202;
	bh=EgZruZrnriA70x8aF1ybDlgbBS0RGwEVcf63DwotybM=;
	h=Date:To:From:Subject:From;
	b=wsNDUOrpJmHxqXgcflYs0Oc21qdwUlFDPewhcwSpl0ugFROGIPBQX6IEtCEdU8ekP
	 Gp0q441k3ohVa6ZXMQTdUXTaRI/kFSOMfq8ATWZ1Wtc4hEAjpq3Wk3Mi7Zx/ILtQik
	 kbXbSGJVd4PaH/B25aksnRTaynwRsuuhvDNwPE8c=
Date: Mon, 13 Jan 2025 22:46:41 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-fixup-damos_filter-kernel-doc.patch removed from -mm tree
Message-Id: <20250114064642.5EB2BC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: fixup damos_filter kernel-doc
has been removed from the -mm tree.  Its filename was
     mm-damon-fixup-damos_filter-kernel-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: fixup damos_filter kernel-doc
Date: Thu, 9 Jan 2025 09:51:17 -0800

Patch series "mm/damon: extend DAMOS filters for inclusion", v2.

DAMOS fitlers are exclusive filters.  It only excludes memory of given
criterias from the DAMOS action targets.  This has below limitations.

First, the name is not explicitly explaining the behavior.  This actually
resulted in users' confusions[1].  Secondly, combined uses of multiple
filters provide only restriced coverages.  For example, building a DAMOS
scheme that applies the action to memory that belongs to cgroup A "or"
cgroup B is impossible.  A workaround would be using two schemes that
fitlers out memory that not belong to cgroup A and cgroup B, respectively.
It is cumbersome, and difficult to control quota-like per-scheme features
in an orchestration.  Monitoring of filters-passed memory statistic will
also be complicated.

Extend DAMOS filters to support not only exclusion (rejecting), but also
inclusion (allowing) behavior.  For this, add a new damos_filter struct
field called 'allow' for DAMON kernel API users.  The filter works as an
inclusion or exclusion filter when it is set or unset, respectively.  For
DAMON user-space ABI users, add a DAMON sysfs file of same name under
DAMOS filter sysfs directory.  To prevent exposing a behavioral change to
old users, set rejecting as the default behavior.

Note that allow-filters work for only inclusion, not exclusion of memory
that not satisfying the criteria.  And the default behavior of DAMOS for
memory that no filter has involved is that the action can be applied to
those memory.  Also, filters-passed memory statistics are for any memory
that passed through the DAMOS filters check stage.  These implies
installing allow-filters at the endof the filter list is useless.  Refer
to the design doc change of this series for more details.

[1] https://lore.kernel.org/20240320165619.71478-1-sj@kernel.org


This patch (of 10):

The comment is slightly wrong.  DAMOS filters are not only for pages, but
general bytes of memory.  Also the description of 'matching' is bit
confusing, since DAMOS filters do only filtering out.  Update the comments
to be less confusing.

Link: https://lkml.kernel.org/r/20250109175126.57878-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250109175126.57878-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-fixup-damos_filter-kernel-doc
+++ a/include/linux/damon.h
@@ -347,8 +347,8 @@ enum damos_filter_type {
 
 /**
  * struct damos_filter - DAMOS action target memory filter.
- * @type:	Type of the page.
- * @matching:	If the matching page should filtered out or in.
+ * @type:	Type of the target memory.
+ * @matching:	If the @type-matching memory should be filtered out.
  * @memcg_id:	Memcg id of the question if @type is DAMOS_FILTER_MEMCG.
  * @addr_range:	Address range if @type is DAMOS_FILTER_TYPE_ADDR.
  * @target_idx:	Index of the &struct damon_target of
@@ -357,9 +357,10 @@ enum damos_filter_type {
  * @list:	List head for siblings.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
- * page of the region matches to this and avoid applying the action if so.
- * Support of each filter type depends on the running &struct damon_operations
- * and the type.  Refer to &enum damos_filter_type for more detai.
+ * byte of the region matches to this given condition and avoid applying the
+ * action if so.  Support of each filter type depends on the running &struct
+ * damon_operations and the type.  Refer to &enum damos_filter_type for more
+ * details.
  */
 struct damos_filter {
 	enum damos_filter_type type;
_

Patches currently in -mm which might be from sj@kernel.org are

docs-mm-damon-design-add-monitoring-parameters-tuning-guide.patch
docs-mm-damon-add-an-example-monitoring-intervals-tuning.patch
docs-admin-guide-mm-damon-usage-fix-and-add-missing-damos-filter-sysfs-files-on-files-hierarchy.patch
docs-admin-guide-mm-damon-start-update-snapshot-example.patch
mm-damon-explain-effective-quota-on-kernel-doc-comment.patch

