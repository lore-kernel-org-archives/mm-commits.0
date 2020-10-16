Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F13AC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AB0C208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817804;
	bh=0EHkLYBp8znN/hIn2ydHD2xi6Ola3E48xHoujWM1IrU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HMuHvZF1MJ4DQdwCeTW4OdyQW9Lmf9BjQHMUH9MYejEriLj0amSJ3K6kJ6L304srn
	 1iUhrrOPHDKOf3EvtuF0SrIliIR4A5Lf5WIVzJ+HljrDvO8wZX4AjbItDD3clgBZfh
	 5JKrS+qi2SUSdk0ozVBESct8XXjFHi3iITsDk6/s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732478AbgJPDKD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbgJPDKD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:10:03 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16A6420789;
        Fri, 16 Oct 2020 03:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817803;
        bh=0EHkLYBp8znN/hIn2ydHD2xi6Ola3E48xHoujWM1IrU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R1x4u8Hg0RvX9aKAQndD+v32H3ghmav/r9CQ7qyh8c2SVNleprtNHk6EFyoTlJhGz
         EST6gGnQIOXpIQBwNtNGGek3TZnYHqN4zXQKs1RVEvt8AEKg85SgNmobRiiDTIVT1t
         3NjaHW2c3WZW0l1KWeF785IPDHzW8G3EVdLd536o=
Date:   Thu, 15 Oct 2020 20:10:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chentao3@hotmail.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 090/156] mm: fix some comments formatting
Message-ID: <20201016031001.p11TDixvp%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
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
