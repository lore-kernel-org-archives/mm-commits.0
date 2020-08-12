Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B6DC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB64720829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 00:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597193770;
	bh=vOmSgD1kjyvzPfmhD/nzWKpMkwRWxjG+KqtI6llFDEk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=yp64Eadxb0IDcsqQaxbvIlM6qefBLbPN5gnVFKfpxntWDGA7hiCBOe0f1MLR9B1gi
	 xdcWyeaHBoxnq5qg/GxYMgoBGbZ8O6D1dmF61/rXf0CY2hfZ/cyIxoOmaqKYIso+sl
	 uQzMsrC1EZKBN7VURTYEhpzyPNsCZ0CSwfHsyiEU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbgHLA4K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 20:56:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbgHLA4K (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 20:56:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D93672078B;
        Wed, 12 Aug 2020 00:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597193769;
        bh=vOmSgD1kjyvzPfmhD/nzWKpMkwRWxjG+KqtI6llFDEk=;
        h=Date:From:To:Subject:From;
        b=v7GFkNPfCW1fLNr3KqTORNNgpVV8ElBp1qjAv+soQEkYp9lTTHNuBN/JkCTITkG41
         NRmv+73tNzSmBD2eDcNUoQi+6BGn537h1EPVV6KVUOcU+yYOWxLKnTCiM3UY0d7D5h
         oPwmf6xYS4P3/0WoXSZt6XEc5RVcuUb0pdSX26D8=
Date:   Tue, 11 Aug 2020 17:56:08 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, cuibixuan@huawei.com, dennis@kernel.org, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, longman@redhat.com,
        mgorman@techsingularity.net, mhocko@kernel.org, mkoutny@suse.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sfr@canb.auug.org.au, shakeelb@google.com,
        tj@kernel.org, tobin@kernel.org, vbabka@suse.cz
Subject:  [folded-merged]
 mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-2.patch removed
 from -mm tree
Message-ID: <20200812005608.7_KhaKIJL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/percpu: fix 'defined but not used' warning
has been removed from the -mm tree.  Its filename was
     mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-2.patch

This patch was dropped because it was folded into mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch

------------------------------------------------------
From: Bixuan Cui <cuibixuan@huawei.com>
Subject: mm/percpu: fix 'defined but not used' warning

Gcc report the following warning without CONFIG_MEMCG_KMEM:

mm/percpu-internal.h:145:29: warning: 'pcpu_chunk_type' defined
but not used [-Wunused-function]
 static enum pcpu_chunk_type pcpu_chunk_type(struct pcpu_chunk *chunk)
                             ^~~~~~~~~~~~~~~

Add 'inline' to pcpu_chunk_type(),pcpu_is_memcg_chunk() and
pcpu_chunk_list() to clear warning.

Link: http://lkml.kernel.org/r/6d41b939-a741-b521-a7a2-e7296ec16219@huawei.com
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Suggested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/percpu-internal.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/percpu-internal.h~mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-2
+++ a/mm/percpu-internal.h
@@ -129,31 +129,31 @@ static inline int pcpu_chunk_map_bits(st
 }
 
 #ifdef CONFIG_MEMCG_KMEM
-static enum pcpu_chunk_type pcpu_chunk_type(struct pcpu_chunk *chunk)
+static inline enum pcpu_chunk_type pcpu_chunk_type(struct pcpu_chunk *chunk)
 {
 	if (chunk->obj_cgroups)
 		return PCPU_CHUNK_MEMCG;
 	return PCPU_CHUNK_ROOT;
 }
 
-static bool pcpu_is_memcg_chunk(enum pcpu_chunk_type chunk_type)
+static inline bool pcpu_is_memcg_chunk(enum pcpu_chunk_type chunk_type)
 {
 	return chunk_type == PCPU_CHUNK_MEMCG;
 }
 
 #else
-static enum pcpu_chunk_type pcpu_chunk_type(struct pcpu_chunk *chunk)
+static inline enum pcpu_chunk_type pcpu_chunk_type(struct pcpu_chunk *chunk)
 {
 	return PCPU_CHUNK_ROOT;
 }
 
-static bool pcpu_is_memcg_chunk(enum pcpu_chunk_type chunk_type)
+static inline bool pcpu_is_memcg_chunk(enum pcpu_chunk_type chunk_type)
 {
 	return false;
 }
 #endif
 
-static struct list_head *pcpu_chunk_list(enum pcpu_chunk_type chunk_type)
+static inline struct list_head *pcpu_chunk_list(enum pcpu_chunk_type chunk_type)
 {
 	return &pcpu_chunk_lists[pcpu_nr_slots *
 				 pcpu_is_memcg_chunk(chunk_type)];
_

Patches currently in -mm which might be from cuibixuan@huawei.com are

mm-memcg-percpu-account-percpu-memory-to-memory-cgroups.patch

