Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35D61C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F121222D02
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgLPAAB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729903AbgLOX0m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:42 -0500
Date:   Tue, 15 Dec 2020 15:16:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074164;
        bh=X3B2txZ/c1QOlHUCGVFos1MdhsWoF7KlS33LSZoj9tU=;
        h=From:To:Subject:From;
        b=quIRGgLNbghrz3ARAkNbGeBcO55vEljGP4DjUk8r1axVrdU9bB3nO11ahVAthAKib
         Au/FFQ014Z3kw4pf6EkgK8UTRbXgmOvXbg2WTGcCFmQmo1XlH+03VM9X25+eKdPXgR
         B4lGh7SuxEr1v2zx3PsRm07ZhALMEuT2sSEL09iM=
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, sh_def@163.com
Subject:  [merged]
 mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch
 removed from -mm tree
Message-ID: <20201215231604.Hgjvi5Tg6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab_common.c: use list_for_each_entry in dump_unreclaimable_slab()
has been removed from the -mm tree.  Its filename was
     mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/slab_common.c: use list_for_each_entry in dump_unreclaimable_slab()

dump_unreclaimable_slab() acquires the slab_mutex first, and it won't
remove any slab_caches list entry when itering the slab_caches lists.

Thus we do not need list_for_each_entry_safe here, which is against
removal of list entry.

Link: https://lkml.kernel.org/r/20200926043440.GA180545@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab_common.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slab_common.c~mmslab_common-use-list_for_each_entry-in-dump_unreclaimable_slab
+++ a/mm/slab_common.c
@@ -978,7 +978,7 @@ static int slab_show(struct seq_file *m,
 
 void dump_unreclaimable_slab(void)
 {
-	struct kmem_cache *s, *s2;
+	struct kmem_cache *s;
 	struct slabinfo sinfo;
 
 	/*
@@ -996,7 +996,7 @@ void dump_unreclaimable_slab(void)
 	pr_info("Unreclaimable slab info:\n");
 	pr_info("Name                      Used          Total\n");
 
-	list_for_each_entry_safe(s, s2, &slab_caches, list) {
+	list_for_each_entry(s, &slab_caches, list) {
 		if (s->flags & SLAB_RECLAIM_ACCOUNT)
 			continue;
 
_

Patches currently in -mm which might be from sh_def@163.com are

fs-proc-make-pde_get-return-nothing.patch
acctc-use-elif-instead-of-end-and-elif.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

