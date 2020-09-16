Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C25AC43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 00:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4ADA2080C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 00:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600216686;
	bh=OIEmM1GlWkPdeXkZ2zxotOMzyDP+fFc+XRnh28PQT6Y=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=lDicmlAqIDvOhEmSRtFjxlJtBhKMSAGrgyv7QebSKykeNgmvsomkOs7y/Jj4QtvfE
	 339TtTDS8lsr1c+FP3l4lHyYddK4VKI5DQp5NQsFtVCq4ZwKxynruLWWGwyiR3JImh
	 cZWrp9fM+r2Y0wxoEP71ctR2OccKE+miVYIDj/u4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgIPAhy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgIPAhg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Sep 2020 20:37:36 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D574720732;
        Wed, 16 Sep 2020 00:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600216656;
        bh=OIEmM1GlWkPdeXkZ2zxotOMzyDP+fFc+XRnh28PQT6Y=;
        h=Date:From:To:Subject:From;
        b=seqm8H+2ArhWQRnwBrfzD/Ihw4aCFKDxvL6NTaF4VyqwkIP2VlkPMCqjcuxXoQzhX
         tSGf5HsiyAOjfflXLQTAhd7Jb9K4rq2qpkZHBsbV2WzygZHNRYejBAn5RmkMRpgVZL
         u1ayat+36MKdD8/YmZhrqnkqMXsXKjjQVoaboNF0=
Date:   Tue, 15 Sep 2020 17:37:35 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, chentao3@hotmail.com
Subject:  + mm-fix-some-comments-formatting.patch added to -mm tree
Message-ID: <20200916003735.IWs6C%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some comments formatting
has been added to the -mm tree.  Its filename is
     mm-fix-some-comments-formatting.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fix-some-comments-formatting.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-some-comments-formatting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Tao <chentao3@hotmail.com>
Subject: mm: fix some comments formatting

Correct one function name "get_partials" with "get_partial".  Update the
old struct name of list3 with kmem_cache_node.

Link: https://lkml.kernel.org/r/Message-ID:
Signed-off-by: Chen Tao <chentao3@hotmail.com>
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
@@ -1960,7 +1960,7 @@ static void *get_partial_node(struct kme
 	/*
 	 * Racy check. If we mistakenly see no partial slabs then we
 	 * just allocate an empty slab. If we mistakenly try to get a
-	 * partial slab and there is none available then get_partials()
+	 * partial slab and there is none available then get_partial()
 	 * will return NULL.
 	 */
 	if (!n || !n->nr_partial)
_

Patches currently in -mm which might be from chentao3@hotmail.com are

mm-fix-some-comments-formatting.patch

