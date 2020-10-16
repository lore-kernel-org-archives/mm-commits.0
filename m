Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 357B8C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2CB720897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816420;
	bh=0EHkLYBp8znN/hIn2ydHD2xi6Ola3E48xHoujWM1IrU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GuYvQ0fD3oPlPhPib+sSFmQnQ7nnu1x/wn9ROYMFTdSg4r8UcB3dggxJWV3vV60gk
	 g2dnpVcbyj8F0/q55f7CgFEuKUlNOONIhQCWFsPh+zzY+DKaNouX1kqZYiDxlEuLb4
	 Wecu2VDmSaIUWoaR5Lms/qogH1bfgtap9eglaMEo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393915AbgJPCq7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:46:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:34600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393913AbgJPCq7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:46:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 415D220B1F;
        Fri, 16 Oct 2020 02:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816417;
        bh=0EHkLYBp8znN/hIn2ydHD2xi6Ola3E48xHoujWM1IrU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FMSHXsgiTuQhLxfboMl6Djzv6QSE8vICqucGF2TiXzJ6FB5FJEU/XFTA1VkT5MlZs
         YKqLd8oXCtWtPETI8azi57u/O6PatXKLyKlpn+O5WHtMC2Vpe4ZkWjCoWiXa2sWX6E
         TJTGDe6x9BFg9HyZafVdSQeDhwETbgnlCr4ICJ68=
Date:   Thu, 15 Oct 2020 19:46:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chentao3@hotmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 090/156] mm: fix some comments formatting
Message-ID: <20201016024656.OF4MJeKpG%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Chen Tao <chentao3@hotmail.com>
Subject: mm: fix some comments formatting

Correct one function name "get_partials" with "get_partial".  Update the
old struct name of list3 with kmem_cache_node.

Link: https://lkml.kernel.org/r/Message-ID:
Signed-off-by: Chen Tao <chentao3@hotmail.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 mm/slub.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/slab.c~mm-fix-some-comments-formatting
+++ a/mm/slab.c
@@ -1062,7 +1062,7 @@ int slab_prepare_cpu(unsigned int cpu)
  * Even if all the cpus of a node are down, we don't free the
  * kmem_cache_node of any cache. This to avoid a race between cpu_down, and
  * a kmalloc allocation from another cpu for memory from the node of
- * the cpu going down.  The list3 structure is usually allocated from
+ * the cpu going down.  The kmem_cache_node structure is usually allocated from
  * kmem_cache_create() and gets destroyed at kmem_cache_destroy().
  */
 int slab_dead_cpu(unsigned int cpu)
--- a/mm/slub.c~mm-fix-some-comments-formatting
+++ a/mm/slub.c
@@ -1956,7 +1956,7 @@ static void *get_partial_node(struct kme
 	/*
 	 * Racy check. If we mistakenly see no partial slabs then we
 	 * just allocate an empty slab. If we mistakenly try to get a
-	 * partial slab and there is none available then get_partials()
+	 * partial slab and there is none available then get_partial()
 	 * will return NULL.
 	 */
 	if (!n || !n->nr_partial)
_
