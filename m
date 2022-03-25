Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F81DC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357437AbiCYBgT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357416AbiCYBfY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2FF13D3D
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07AF460A75
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F45C340ED;
        Fri, 25 Mar 2022 01:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171988;
        bh=wFRBheCBJYx2NRbAg5k2bRveSYMw0uWsSOuSNK3Gu9o=;
        h=Date:To:From:Subject:From;
        b=kwTLJeoajHR7R92LQNWaaDQEBhPvQW2jdOz0n6uM/yjSb/mglHisvY5GS7l+MMYLs
         F0f1P89vjShKK/6OVJvc+hWtK3g1JA3gOgSmB06Ft8yKMUOgNralwkQqD7kniOpd6a
         4LRigmvk5aWB9aWXGdswUJX7xlhoAx6YAnW57hoM=
Date:   Thu, 24 Mar 2022 18:33:07 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch removed from -mm tree
Message-Id: <20220325013308.59F45C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/dbgfs/init_regions: use target index instead of target id
has been removed from the -mm tree.  Its filename was
     mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs/init_regions: use target index instead of target id

Patch series "Remove the type-unclear target id concept".

DAMON asks each monitoring target ('struct damon_target') to have one
'unsigned long' integer called 'id', which should be unique among the
targets of same monitoring context.  Meaning of it is, however, totally up
to the monitoring primitives that registered to the monitoring context. 
For example, the virtual address spaces monitoring primitives treats the
id as a 'struct pid' pointer.

This makes the code flexible but ugly, not well-documented, and
type-unsafe[1].  Also, identification of each target can be done via its
index.  For the reason, this patchset removes the concept and uses clear
type definition.

[1] https://lore.kernel.org/linux-mm/20211013154535.4aaeaaf9d0182922e405dd1e@linux-foundation.org/


This patch (of 4):

Target id is a 'unsigned long' data, which can be interpreted differently
by each monitoring primitives.  For example, it means 'struct pid *' for
the virtual address spaces monitoring, while it means nothing but an
integer to be displayed to debugfs interface users for the physical
address space monitoring.  It's flexible but makes code ugly and
type-unsafe[1].

To be prepared for eventual removal of the concept, this commit removes a
use case of the concept in 'init_regions' debugfs file handling.  In
detail, this commit replaces use of the id with the index of each target
in the context's targets list.

[1] https://lore.kernel.org/linux-mm/20211013154535.4aaeaaf9d0182922e405dd1e@linux-foundation.org/

Link: https://lkml.kernel.org/r/20211230100723.2238-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211230100723.2238-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs-test.h |   20 ++++++++++----------
 mm/damon/dbgfs.c      |   25 ++++++++++++-------------
 2 files changed, 22 insertions(+), 23 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id
+++ a/mm/damon/dbgfs.c
@@ -440,18 +440,20 @@ static ssize_t sprint_init_regions(struc
 {
 	struct damon_target *t;
 	struct damon_region *r;
+	int target_idx = 0;
 	int written = 0;
 	int rc;
 
 	damon_for_each_target(t, c) {
 		damon_for_each_region(r, t) {
 			rc = scnprintf(&buf[written], len - written,
-					"%lu %lu %lu\n",
-					t->id, r->ar.start, r->ar.end);
+					"%d %lu %lu\n",
+					target_idx, r->ar.start, r->ar.end);
 			if (!rc)
 				return -ENOMEM;
 			written += rc;
 		}
+		target_idx++;
 	}
 	return written;
 }
@@ -485,22 +487,19 @@ out:
 	return len;
 }
 
-static int add_init_region(struct damon_ctx *c,
-			 unsigned long target_id, struct damon_addr_range *ar)
+static int add_init_region(struct damon_ctx *c, int target_idx,
+		struct damon_addr_range *ar)
 {
 	struct damon_target *t;
 	struct damon_region *r, *prev;
-	unsigned long id;
+	unsigned long idx = 0;
 	int rc = -EINVAL;
 
 	if (ar->start >= ar->end)
 		return -EINVAL;
 
 	damon_for_each_target(t, c) {
-		id = t->id;
-		if (targetid_is_pid(c))
-			id = (unsigned long)pid_vnr((struct pid *)id);
-		if (id == target_id) {
+		if (idx++ == target_idx) {
 			r = damon_new_region(ar->start, ar->end);
 			if (!r)
 				return -ENOMEM;
@@ -523,7 +522,7 @@ static int set_init_regions(struct damon
 	struct damon_target *t;
 	struct damon_region *r, *next;
 	int pos = 0, parsed, ret;
-	unsigned long target_id;
+	int target_idx;
 	struct damon_addr_range ar;
 	int err;
 
@@ -533,11 +532,11 @@ static int set_init_regions(struct damon
 	}
 
 	while (pos < len) {
-		ret = sscanf(&str[pos], "%lu %lu %lu%n",
-				&target_id, &ar.start, &ar.end, &parsed);
+		ret = sscanf(&str[pos], "%d %lu %lu%n",
+				&target_idx, &ar.start, &ar.end, &parsed);
 		if (ret != 3)
 			break;
-		err = add_init_region(c, target_id, &ar);
+		err = add_init_region(c, target_idx, &ar);
 		if (err)
 			goto fail;
 		pos += parsed;
--- a/mm/damon/dbgfs-test.h~mm-damon-dbgfs-init_regions-use-target-index-instead-of-target-id
+++ a/mm/damon/dbgfs-test.h
@@ -113,19 +113,19 @@ static void damon_dbgfs_test_set_init_re
 {
 	struct damon_ctx *ctx = damon_new_ctx();
 	unsigned long ids[] = {1, 2, 3};
-	/* Each line represents one region in ``<target id> <start> <end>`` */
-	char * const valid_inputs[] = {"2 10 20\n 2   20 30\n2 35 45",
-		"2 10 20\n",
-		"2 10 20\n1 39 59\n1 70 134\n  2  20 25\n",
+	/* Each line represents one region in ``<target idx> <start> <end>`` */
+	char * const valid_inputs[] = {"1 10 20\n 1   20 30\n1 35 45",
+		"1 10 20\n",
+		"1 10 20\n0 39 59\n0 70 134\n  1  20 25\n",
 		""};
 	/* Reading the file again will show sorted, clean output */
-	char * const valid_expects[] = {"2 10 20\n2 20 30\n2 35 45\n",
-		"2 10 20\n",
-		"1 39 59\n1 70 134\n2 10 20\n2 20 25\n",
+	char * const valid_expects[] = {"1 10 20\n1 20 30\n1 35 45\n",
+		"1 10 20\n",
+		"0 39 59\n0 70 134\n1 10 20\n1 20 25\n",
 		""};
-	char * const invalid_inputs[] = {"4 10 20\n",	/* target not exists */
-		"2 10 20\n 2 14 26\n",		/* regions overlap */
-		"1 10 20\n2 30 40\n 1 5 8"};	/* not sorted by address */
+	char * const invalid_inputs[] = {"3 10 20\n",	/* target not exists */
+		"1 10 20\n 1 14 26\n",		/* regions overlap */
+		"0 10 20\n1 30 40\n 0 5 8"};	/* not sorted by address */
 	char *input, *expect;
 	int i, rc;
 	char buf[256];
_

Patches currently in -mm which might be from sj@kernel.org are


