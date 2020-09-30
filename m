Return-Path: <SRS0=jIyd=DH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD994C4363D
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:04:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 679A020719
	for <mm-commits@archiver.kernel.org>; Wed, 30 Sep 2020 22:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601503494;
	bh=cXZyOuJ20tt7eZhjYYBKfpsuSw5Q/aobMbBmLlc87Ns=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=L8Vu6BdIzplpzePXSNHsbkOZ1ZtB8IaA3dYX/g7OHmCxODPv448vzNUI9hazUPT8Q
	 iJlOZm8fE4HPFO0VMrxaHyRljzM7rmFsuXs2HO7I/Hkpo6zFAcm6RJZJc60CWTsORA
	 ZEKbhEMQ/VG616ZL/6/6JkqsDhE9havU2bVjkBZ4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbgI3WEy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbgI3WEy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Sep 2020 18:04:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE6BD206CA;
        Wed, 30 Sep 2020 22:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601503493;
        bh=cXZyOuJ20tt7eZhjYYBKfpsuSw5Q/aobMbBmLlc87Ns=;
        h=Date:From:To:Subject:From;
        b=ehi3adrGB6q5Z93a9I7+e8F48v+2Fh2zXrMn4ErtAcOf3j70niUPjhh3kuKP+3ijw
         UZlq8EozL7Kw9t3vhnUdtAU4XC83NqGMQLv31jM1CVeEOQyxglqqS8y8eYvXBAOWtF
         8uRu5Nse2JJyVupemL5h8RviDqYM5MPaC0SXh+l8=
Date:   Wed, 30 Sep 2020 15:04:52 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, david@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        zangchunxin@bytedance.com
Subject:  [obsolete]
 mm-vmscan-add-a-fatal-signals-check-in-drop_slab_node.patch removed from
 -mm tree
Message-ID: <20200930220452.xAek1FZQj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: add a fatal signals check in drop_slab_node
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-a-fatal-signals-check-in-drop_slab_node.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Chunxin Zang <zangchunxin@bytedance.com>
Subject: mm/vmscan: add a fatal signals check in drop_slab_node

On our server, there are about 10k memcg in one machine.  They use memory
very frequently.  We have observed that drop_caches can take a
considerable amount of time, and can't stop it.

There are two reasons:
1. There is somebody constantly generating more objects to reclaim
  on drop_caches, result the 'freed' always bigger than 10.
2. The process has no chance to process signals.

We can get the following info through 'ps':

 root:~# ps -aux | grep drop
 root  357956 ... R    Aug25 21119854:55 echo 3 > /proc/sys/vm/drop_caches
 root 1771385 ... R    Aug16 21146421:17 echo 3 > /proc/sys/vm/drop_caches

Add a bail out on the fatal signals in the main loop so that the
operation can be terminated by userspace.

Link: https://lkml.kernel.org/r/20200916025359.70203-1-zangchunxin@bytedance.com
Signed-off-by: Chunxin Zang <zangchunxin@bytedance.com>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-add-a-fatal-signals-check-in-drop_slab_node
+++ a/mm/vmscan.c
@@ -702,6 +702,9 @@ void drop_slab_node(int nid)
 		if (fatal_signal_pending(current))
 			return;
 
+		if (fatal_signal_pending(current))
+			return;
+
 		freed = 0;
 		memcg = mem_cgroup_iter(NULL, NULL, NULL);
 		do {
_

Patches currently in -mm which might be from zangchunxin@bytedance.com are

mm-vmscan-fix-infinite-loop-in-drop_slab_node.patch

