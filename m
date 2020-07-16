Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD59C433DF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1658020870
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 23:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594942347;
	bh=0wNy2a3Xb6lRx0qgqMMAA+3LAkOJDZ7K9HdX90T+lVM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ZjTfO7HwS/TJ8IGSaaG2lZrMIDDQ6VKrBX7cu2pd5ztgfOSC8i2TlQqVoMDkZB9q+
	 XU+vrmWcm2QU55ZsyrF3Mx7G48QNPXHLRQRv1rtMN4JphH6tF1+BgJUYJtkgg37jgS
	 KQj3Wz28YEky8i/r/zd1mdePUOouHxGKyV59xUeM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgGPXc0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 19:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726113AbgGPXc0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 19:32:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA7F42076D;
        Thu, 16 Jul 2020 23:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594942346;
        bh=0wNy2a3Xb6lRx0qgqMMAA+3LAkOJDZ7K9HdX90T+lVM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zyo6XJrB7ooJ6ZKSXKaODD88HAmNBXxFQTT4c7kXat6DNQj7l6ZLFoWloVWIiJz8l
         fhW/tNzyOiFIKp1RlmqvOZKV+rw1CDbsQ2pKL1RyaRFljMYnBgPw3ISXSkOXGb3mW6
         bcn+tx4XO+Rfne/8bYutzBt9dGJhRYpZIhWdkXOc=
Date:   Thu, 16 Jul 2020 16:32:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cuibixuan@huawei.com, guro@fb.com, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject:  +
 mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-2.patch added
 to -mm tree
Message-ID: <20200716233225.BXIP04h2v%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/percpu: fix 'defined but not used' warning
has been added to the -mm tree.  Its filename is
     mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-2.patch

