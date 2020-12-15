Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4383C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7433A223C8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgLODEu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:04:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:60718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727205AbgLODEo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:04:44 -0500
Date:   Mon, 14 Dec 2020 19:03:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001427;
        bh=BrOs31bzRzbga8iT77pebv9RMCkDkAX3J0D5AQxY54c=;
        h=From:To:Subject:In-Reply-To:From;
        b=VTCJQBzAZvQwsKu9eWSmDIjmQwdy7K4FzUjTpERUfFmKSPmstlGS3PAScvYvzCqFN
         D0W8eeGLDyLGyf6J7CFlZSL+sxqZAsyksBAzoLVM66CnimR4nT7r8v6ePh3RILZNDk
         KJn5lK+ANZyF1WiLFPfpq/G3PI+zweq2fnIM4fnI=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sh_def@163.com, torvalds@linux-foundation.org
Subject:  [patch 011/200] mm/slab_common.c: use list_for_each_entry
 in dump_unreclaimable_slab()
Message-ID: <20201215030347.ipFWzEFOp%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
