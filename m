Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A968EC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C54C21775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881535;
	bh=U/hQxuDz58vKmugZNREZy7uTbQygIwDC0mRlx+z7q3U=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DnyU+DObxyVgP/QMHt7i0M9snif+PPlNibB1yGea42AfjToksyCbgpMhzrk1XC4NN
	 6YBOI3p2QOpx0x7DmJuQalTTnkta83IfKmRTCrwIgfeQ3vF0gyaQYoqQh4FlXvbONm
	 z6IR8iis+AnBfI0AdmH25eo2Hfkk8i3r3SvS8iME=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408486AbgJPUwO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732579AbgJPUwO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:14 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B29620878;
        Fri, 16 Oct 2020 20:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881533;
        bh=U/hQxuDz58vKmugZNREZy7uTbQygIwDC0mRlx+z7q3U=;
        h=Date:From:To:Subject:From;
        b=C+V+rGW57bDuuOv/GA0D/YfY8HvZS6dK9hKf5i0LbN/VFNbi3iB8PxrIWCAtEpak5
         ks6HeHbCSkwJQXjPlC6BQMSmfIxm27c36NOPI/MgZA3vBSVxD5AK1HDVvyoDl32gTu
         hBG9cgTtFGxmHzhz26SATp/91rOiC61Afc/3fwog=
Date:   Fri, 16 Oct 2020 13:52:13 -0700
From:   akpm@linux-foundation.org
To:     chentao3@hotmail.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com
Subject:  [merged] mm-fix-some-comments-formatting.patch removed
 from -mm tree
Message-ID: <20201016205213.8TIe7yWYE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix some comments formatting
has been removed from the -mm tree.  Its filename was
     mm-fix-some-comments-formatting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from chentao3@hotmail.com are


