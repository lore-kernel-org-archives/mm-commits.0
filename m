Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E12C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiANWKp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:45 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38608 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbiANWKp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D263FCE2384
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D5DC36AEC;
        Fri, 14 Jan 2022 22:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198242;
        bh=B52i9MSp+eHr0i0/0dXWUWYTfW+JhUWQgTL4pNV8vRk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gxsNJIk205z7B/ML9iGBwC1nf/QLPuwNw9NETV2lPYcQ58yvQ9WuwnJDWvjvVHUme
         I6dK87tzel0vH+HuKaUudUpjHdmg50F4bJZOd0PBEOT/4AVHuqJBHQpd1QnB17M1O2
         Lcj7sqWYrjGQCXwND/Jr2RGBbGneeC8nQn6ot+Vw=
Date:   Fri, 14 Jan 2022 14:10:41 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 143/146] mm/damon/dbgfs: remove an unnecessary
 variable
Message-ID: <20220114221041.whTITHaup%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/dbgfs: remove an unnecessary variable

Patch series "mm/damon: Hide unnecessary information disclosures".

DAMON is exposing some unnecessary information including kernel pointer
in kernel log and tracepoint.  This patchset hides such information.
The first patch is only for a trivial cleanup, though.


This patch (of 4):

This commit removes a unnecessarily used variable in
dbgfs_target_ids_write().

Link: https://lkml.kernel.org/r/20211229131016.23641-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211229131016.23641-2-sj@kernel.org
Fixes: 4bc05954d007 ("mm/damon: implement a debugfs-based user space interface")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/dbgfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/damon/dbgfs.c~mm-damon-dbgfs-remove-a-unnecessary-variable
+++ a/mm/damon/dbgfs.c
@@ -364,7 +364,7 @@ static ssize_t dbgfs_target_ids_write(st
 	struct damon_ctx *ctx = file->private_data;
 	struct damon_target *t, *next_t;
 	bool id_is_pid = true;
-	char *kbuf, *nrs;
+	char *kbuf;
 	unsigned long *targets;
 	ssize_t nr_targets;
 	ssize_t ret;
@@ -374,14 +374,13 @@ static ssize_t dbgfs_target_ids_write(st
 	if (IS_ERR(kbuf))
 		return PTR_ERR(kbuf);
 
-	nrs = kbuf;
 	if (!strncmp(kbuf, "paddr\n", count)) {
 		id_is_pid = false;
 		/* target id is meaningless here, but we set it just for fun */
 		scnprintf(kbuf, count, "42    ");
 	}
 
-	targets = str_to_target_ids(nrs, count, &nr_targets);
+	targets = str_to_target_ids(kbuf, count, &nr_targets);
 	if (!targets) {
 		ret = -ENOMEM;
 		goto out;
_
