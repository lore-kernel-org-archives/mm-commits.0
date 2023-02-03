Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142F5C63797
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbjBCGne (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbjBCGmA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:42:00 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26EA14205
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:38:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3A60DCE2EA3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6026BC433D2;
        Fri,  3 Feb 2023 06:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406293;
        bh=qNBSqN7yAwb5B7oK1cb6AO2HPgLEFtZ4RnCn8nsijU4=;
        h=Date:To:From:Subject:From;
        b=DmwQ5Xgum9z12ARabechc/LIcWqqS4ejIWpUjhni0Me3v5CTojuKdNhP+4m4Ksrko
         P6C347dE6wYyQHNIQ9ugGTYeOl728cWd2xtNgHqZBaf5uUPblfKbx2RbpCzFukROTq
         Ztxty5MXhgtm/lZ20cYQXF8Cn1SUcso973uBPlGk=
Date:   Thu, 02 Feb 2023 22:38:12 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-multi-gen-lru-improve-lru_gen_exit_memcg.patch removed from -mm tree
Message-Id: <20230203063813.6026BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: multi-gen LRU: improve lru_gen_exit_memcg()
has been removed from the -mm tree.  Its filename was
     mm-multi-gen-lru-improve-lru_gen_exit_memcg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: improve lru_gen_exit_memcg()
Date: Wed, 18 Jan 2023 00:18:25 +0000

Add warnings and poison ->next.

Link: https://lkml.kernel.org/r/20230118001827.1040870-6-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmscan.c~mm-multi-gen-lru-improve-lru_gen_exit_memcg
+++ a/mm/vmscan.c
@@ -6168,12 +6168,17 @@ void lru_gen_exit_memcg(struct mem_cgrou
 	int i;
 	int nid;
 
+	VM_WARN_ON_ONCE(!list_empty(&memcg->mm_list.fifo));
+
 	for_each_node(nid) {
 		struct lruvec *lruvec = get_lruvec(memcg, nid);
 
+		VM_WARN_ON_ONCE(lruvec->mm_state.nr_walkers);
 		VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
 					   sizeof(lruvec->lrugen.nr_pages)));
 
+		lruvec->lrugen.list.next = LIST_POISON1;
+
 		for (i = 0; i < NR_BLOOM_FILTERS; i++) {
 			bitmap_free(lruvec->mm_state.filters[i]);
 			lruvec->mm_state.filters[i] = NULL;
_

Patches currently in -mm which might be from talumbau@google.com are


