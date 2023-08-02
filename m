Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D9DC001E0
	for <mm-commits@archiver.kernel.org>; Wed,  2 Aug 2023 21:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbjHBVvo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Aug 2023 17:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjHBVvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2023 17:51:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73615119
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 14:51:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA99C61B1F
        for <mm-commits@vger.kernel.org>; Wed,  2 Aug 2023 21:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E4F1C433C7;
        Wed,  2 Aug 2023 21:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691013100;
        bh=7LR8Ivm3DAlqFTqVDxaHBXspkamd4vtIr4nMXo/cb+s=;
        h=Date:To:From:Subject:From;
        b=TzJE4ajHdvQAWC6Ht6WHhebhpd8S7ep59CKfLRmM4EsoaFapDRZt1MSlqBt4IXcsI
         b5zkGR+V5L/8EBIea3lzBfkaPuehWuOCxaqnpfhCtqAGJ1A/5X01Sa4pa4izGI5QBd
         OWFNcaCriHPk6hHyENmJGq8xrx7o2TJ8LwesbenQ=
Date:   Wed, 02 Aug 2023 14:51:39 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, corbet@lwn.net,
        brendanhiggins@google.com, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-address-range-type-damos-filter.patch added to mm-unstable branch
Message-Id: <20230802215140.4E4F1C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/core: introduce address range type damos filter
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-introduce-address-range-type-damos-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-address-range-type-damos-filter.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm/damon/core: introduce address range type damos filter
Date: Wed, 2 Aug 2023 21:43:00 +0000

Patch series "Extend DAMOS filters for address ranges and DAMON monitoring
targets"

There are use cases that need to apply DAMOS schemes to specific address
ranges or DAMON monitoring targets.  NUMA nodes in the physical address
space, special memory objects in the virtual address space, and monitoring
target specific efficient monitoring results snapshot retrieval could be
examples of such use cases.  This patchset extends DAMOS filters feature
for such cases, by implementing two more filter types, namely address
ranges and DAMON monitoring types.

Patches sequence
----------------

The first seven patches are for the address ranges based DAMOS filter. 
The first patch implements the filter feature and expose it via DAMON
kernel API.  The second patch further expose the feature to users via
DAMON sysfs interface.  The third and fourth patches implement unit tests
and selftests for the feature.  Three patches (fifth to seventh) updating
the documents follow.

The following six patches are for the DAMON monitoring target based DAMOS
filter.  The eighth patch implements the feature in the core layer and
expose it via DAMON's kernel API.  The ninth patch further expose it to
users via DAMON sysfs interface.  Tenth patch add a selftest, and two
patches (eleventh and twelfth) update documents.

[1] https://lore.kernel.org/damon/20230728203444.70703-1-sj@kernel.org/


This patch (of 13):

Users can know special characteristic of specific address ranges.  NUMA
nodes or special objects or buffers in virtual address space could be such
examples.  For such cases, DAMOS schemes could required to be applied to
only specific address ranges.  Implement yet another type of DAMOS filter
for the purpose.

Note that the existing filter types, namely anon pages and memcg DAMOS
filters needed page level type check.  Because such check can be done
efficiently in the opertions set layer, those filters are handled in
operations set layer.  Specifically, only paddr operations set
implementation supports these filters.  Also, because statistics counting
is done in the DAMON core layer, the regions that filtered out by these
filters are counted as tried but failed to the statistics.

Unlike those, address range based filters can efficiently handled in the
core layer.  Hence, do the handling in the layer, and count the regions
that filtered out by those as the scheme has not tried for the region. 
This difference should clearly documented.

Link: https://lkml.kernel.org/r/20230802214312.110532-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230802214312.110532-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   22 ++++++++++++----
 mm/damon/core.c       |   52 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 6 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-introduce-address-range-type-damos-filter
+++ a/include/linux/damon.h
@@ -226,16 +226,24 @@ struct damos_stat {
  * enum damos_filter_type - Type of memory for &struct damos_filter
  * @DAMOS_FILTER_TYPE_ANON:	Anonymous pages.
  * @DAMOS_FILTER_TYPE_MEMCG:	Specific memcg's pages.
+ * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
  *
- * The support of each filter type is up to running &struct damon_operations.
- * &enum DAMON_OPS_PADDR is supporting all filter types, while
- * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR are not supporting any
- * filter types.
+ * The anon pages type and memcg type filters are handled by underlying
+ * &struct damon_operations as a part of scheme action trying, and therefore
+ * accounted as 'tried'.  In contrast, other types are handled by core layer
+ * before trying of the action and therefore not accounted as 'tried'.
+ *
+ * The support of the filters that handled by &struct damon_operations depend
+ * on the running &struct damon_operations.
+ * &enum DAMON_OPS_PADDR supports both anon pages type and memcg type filters,
+ * while &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR don't support any of
+ * the two types.
  */
 enum damos_filter_type {
 	DAMOS_FILTER_TYPE_ANON,
 	DAMOS_FILTER_TYPE_MEMCG,
+	DAMOS_FILTER_TYPE_ADDR,
 	NR_DAMOS_FILTER_TYPES,
 };
 
@@ -244,18 +252,20 @@ enum damos_filter_type {
  * @type:	Type of the page.
  * @matching:	If the matching page should filtered out or in.
  * @memcg_id:	Memcg id of the question if @type is DAMOS_FILTER_MEMCG.
+ * @addr_range:	Address range if @type is DAMOS_FILTER_TYPE_ADDR.
  * @list:	List head for siblings.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
  * page of the region matches to this and avoid applying the action if so.
- * Note that the check support is up to &struct damon_operations
- * implementation.
+ * Support of each filter type depends on the running &struct damon_operations
+ * and the type.  Refer to &enum damos_filter_type for more detai.
  */
 struct damos_filter {
 	enum damos_filter_type type;
 	bool matching;
 	union {
 		unsigned short memcg_id;
+		struct damon_addr_range addr_range;
 	};
 	struct list_head list;
 };
--- a/mm/damon/core.c~mm-damon-core-introduce-address-range-type-damos-filter
+++ a/mm/damon/core.c
@@ -878,6 +878,56 @@ static void damos_update_stat(struct dam
 	s->stat.sz_applied += sz_applied;
 }
 
+static bool __damos_filter_out(struct damon_target *t, struct damon_region *r,
+		struct damos_filter *filter)
+{
+	bool matched = false;
+	unsigned long start, end;
+
+	switch (filter->type) {
+	case DAMOS_FILTER_TYPE_ADDR:
+		start = ALIGN_DOWN(filter->addr_range.start, DAMON_MIN_REGION);
+		end = ALIGN_DOWN(filter->addr_range.end, DAMON_MIN_REGION);
+
+		/* inside the range */
+		if (start <= r->ar.start && r->ar.end <= end) {
+			matched = true;
+			break;
+		}
+		/* outside of the range */
+		if (r->ar.end <= start || end <= r->ar.start) {
+			matched = false;
+			break;
+		}
+		/* start before the range and overlap */
+		if (r->ar.start < start) {
+			damon_split_region_at(t, r, start - r->ar.start);
+			matched = false;
+			break;
+		}
+		/* start inside the range */
+		damon_split_region_at(t, r, end - r->ar.start);
+		matched = true;
+		break;
+	default:
+		break;
+	}
+
+	return matched == filter->matching;
+}
+
+static bool damos_filter_out(struct damon_target *t, struct damon_region *r,
+		struct damos *s)
+{
+	struct damos_filter *filter;
+
+	damos_for_each_filter(filter, s) {
+		if (__damos_filter_out(t, r, filter))
+			return true;
+	}
+	return false;
+}
+
 static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
@@ -895,6 +945,8 @@ static void damos_apply_scheme(struct da
 				goto update_stat;
 			damon_split_region_at(t, r, sz);
 		}
+		if (damos_filter_out(t, r, s))
+			return;
 		ktime_get_coarse_ts64(&begin);
 		if (c->callback.before_damos_apply)
 			err = c->callback.before_damos_apply(c, t, r, s);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damo_filter-list-from-damos_new_filter.patch
mm-damon-core-test-add-a-test-for-damos_new_filter.patch
mm-damon-sysfs-schemes-implement-damos-tried-total-bytes-file.patch
mm-damon-sysfs-implement-a-command-for-updating-only-schemes-tried-total-bytes.patch
selftests-damon-sysfs-test-tried_regions-total_bytes-file.patch
docs-abi-damon-update-for-tried_regions-total_bytes.patch
docs-admin-guide-mm-damon-usage-update-for-tried_regions-total_bytes.patch
mm-damon-core-introduce-address-range-type-damos-filter.patch
mm-damon-sysfs-schemes-support-address-range-type-damos-filter.patch
mm-damon-core-test-add-a-unit-test-for-__damos_filter_out.patch
selftests-damon-sysfs-test-address-range-damos-filter.patch
docs-mm-damon-design-update-for-address-range-filters.patch
docs-abi-damon-update-for-address-range-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-address-range-type-damos-filter.patch
mm-damon-core-implement-target-type-damos-filter.patch
mm-damon-sysfs-schemes-support-target-damos-filter.patch
selftests-damon-sysfs-test-damon_target-filter.patch
docs-mm-damon-design-update-for-damon-monitoring-target-type-damos-filter.patch
docs-abi-damon-update-for-damon-monitoring-target-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-damon-monitoring-target-type-damos-filter.patch

