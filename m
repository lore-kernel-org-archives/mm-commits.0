Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A4BC47088
	for <mm-commits@archiver.kernel.org>; Wed, 30 Nov 2022 23:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiK3XB7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 18:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiK3XB6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 18:01:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDB08E592
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 15:01:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D154B81D4C
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 23:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E42C433C1;
        Wed, 30 Nov 2022 23:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669849314;
        bh=v2z9jRslu5MiVukoixy7I+3hzylyKewdFDXW84R92rw=;
        h=Date:To:From:Subject:From;
        b=ThzSBpBJo/UBrd+tgMwJ81xuX+6WHXLbCvuPYYFREuiZpQ1oqKLRNJPRhrvzzyF0t
         mTReWmd2yVQOr/4jrMMpEypfN3HIjzs50zNdLMDVYdiXhKSZq215HrUiMSHgBgyvPn
         yWVPs4iRyEmA5tWfi3GZEh5+YLO/VhBh2saiCX14=
Date:   Wed, 30 Nov 2022 15:01:53 -0800
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch removed from -mm tree
Message-Id: <20221130230154.48E42C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: split out DAMOS-charged region skip logic into a new function
has been removed from the -mm tree.  Its filename was
     mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: split out DAMOS-charged region skip logic into a new function
Date: Wed, 26 Oct 2022 22:59:32 +0000

Patch series "mm/damon: cleanup and refactoring code", v2.

This patchset cleans up and refactors a range of DAMON code including the
core, DAMON sysfs interface, and DAMON modules, for better readability and
convenient future feature implementations.

In detail, this patchset splits unnecessarily long and complex functions
in core into smaller functions (patches 1-4).  Then, it cleans up the
DAMON sysfs interface by using more type-safe code (patch 5) and removing
unnecessary function parameters (patch 6).  Further, it refactor the code
by distributing the code into multiple files (patches 7-10).  Last two
patches (patches 11 and 12) deduplicates and remove unnecessary header
inclusion in DAMON modules (reclaim and lru_sort).


This patch (of 12):

The DAMOS action applying function, 'damon_do_apply_schemes()', is quite
long and not so simple.  Split out the already quota-charged region skip
code, which is not a small amount of simple code, into a new function with
some comments for better readability.

Link: https://lkml.kernel.org/r/20221026225943.100429-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20221026225943.100429-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   96 +++++++++++++++++++++++++++++++---------------
 1 file changed, 65 insertions(+), 31 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function
+++ a/mm/damon/core.c
@@ -694,6 +694,67 @@ static bool damos_valid_target(struct da
 	return c->ops.get_scheme_score(c, t, r, s) >= s->quota.min_score;
 }
 
+/*
+ * damos_skip_charged_region() - Check if the given region or starting part of
+ * it is already charged for the DAMOS quota.
+ * @t:	The target of the region.
+ * @rp:	The pointer to the region.
+ * @s:	The scheme to be applied.
+ *
+ * If a quota of a scheme has exceeded in a quota charge window, the scheme's
+ * action would applied to only a part of the target access pattern fulfilling
+ * regions.  To avoid applying the scheme action to only already applied
+ * regions, DAMON skips applying the scheme action to the regions that charged
+ * in the previous charge window.
+ *
+ * This function checks if a given region should be skipped or not for the
+ * reason.  If only the starting part of the region has previously charged,
+ * this function splits the region into two so that the second one covers the
+ * area that not charged in the previous charge widnow and saves the second
+ * region in *rp and returns false, so that the caller can apply DAMON action
+ * to the second one.
+ *
+ * Return: true if the region should be entirely skipped, false otherwise.
+ */
+static bool damos_skip_charged_region(struct damon_target *t,
+		struct damon_region **rp, struct damos *s)
+{
+	struct damon_region *r = *rp;
+	struct damos_quota *quota = &s->quota;
+	unsigned long sz_to_skip;
+
+	/* Skip previously charged regions */
+	if (quota->charge_target_from) {
+		if (t != quota->charge_target_from)
+			return true;
+		if (r == damon_last_region(t)) {
+			quota->charge_target_from = NULL;
+			quota->charge_addr_from = 0;
+			return true;
+		}
+		if (quota->charge_addr_from &&
+				r->ar.end <= quota->charge_addr_from)
+			return true;
+
+		if (quota->charge_addr_from && r->ar.start <
+				quota->charge_addr_from) {
+			sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
+					r->ar.start, DAMON_MIN_REGION);
+			if (!sz_to_skip) {
+				if (damon_sz_region(r) <= DAMON_MIN_REGION)
+					return true;
+				sz_to_skip = DAMON_MIN_REGION;
+			}
+			damon_split_region_at(t, r, sz_to_skip);
+			r = damon_next_region(r);
+			*rp = r;
+		}
+		quota->charge_target_from = NULL;
+		quota->charge_addr_from = 0;
+	}
+	return false;
+}
+
 static void damon_do_apply_schemes(struct damon_ctx *c,
 				   struct damon_target *t,
 				   struct damon_region *r)
@@ -702,7 +763,7 @@ static void damon_do_apply_schemes(struc
 
 	damon_for_each_scheme(s, c) {
 		struct damos_quota *quota = &s->quota;
-		unsigned long sz = damon_sz_region(r);
+		unsigned long sz;
 		struct timespec64 begin, end;
 		unsigned long sz_applied = 0;
 
@@ -713,41 +774,14 @@ static void damon_do_apply_schemes(struc
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			continue;
 
-		/* Skip previously charged regions */
-		if (quota->charge_target_from) {
-			if (t != quota->charge_target_from)
-				continue;
-			if (r == damon_last_region(t)) {
-				quota->charge_target_from = NULL;
-				quota->charge_addr_from = 0;
-				continue;
-			}
-			if (quota->charge_addr_from &&
-					r->ar.end <= quota->charge_addr_from)
-				continue;
-
-			if (quota->charge_addr_from && r->ar.start <
-					quota->charge_addr_from) {
-				sz = ALIGN_DOWN(quota->charge_addr_from -
-						r->ar.start, DAMON_MIN_REGION);
-				if (!sz) {
-					if (damon_sz_region(r) <=
-					    DAMON_MIN_REGION)
-						continue;
-					sz = DAMON_MIN_REGION;
-				}
-				damon_split_region_at(t, r, sz);
-				r = damon_next_region(r);
-				sz = damon_sz_region(r);
-			}
-			quota->charge_target_from = NULL;
-			quota->charge_addr_from = 0;
-		}
+		if (damos_skip_charged_region(t, &r, s))
+			continue;
 
 		if (!damos_valid_target(c, t, r, s))
 			continue;
 
 		/* Apply the scheme */
+		sz = damon_sz_region(r);
 		if (c->ops.apply_scheme) {
 			if (quota->esz &&
 					quota->charged_sz + sz > quota->esz) {
_

Patches currently in -mm which might be from sj@kernel.org are

docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

