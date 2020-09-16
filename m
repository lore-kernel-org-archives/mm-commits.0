Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2CE7C433E2
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A9C02220E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600300591;
	bh=AqJXUj2PcbQhjVaJCbIuYzoe/gwRPlkhlZs+atx8gDI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=iGlwZBZTZrOGHiqgeLFONXzMIy8qWCwBpBwuEzO8qkClpDA+svcTqLhG604MBsOcx
	 DVjPDsKT2WZCfHa//I24JedK5DAMIya2psRZMixS7uD66KQV2YsiLckglGi6mhID1s
	 silvsGjCRmYDpDFj69cu6WLbc+50dKfd5UzKovAc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgIPX4a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 19:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgIPX43 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 19:56:29 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02F9622207;
        Wed, 16 Sep 2020 23:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600300589;
        bh=AqJXUj2PcbQhjVaJCbIuYzoe/gwRPlkhlZs+atx8gDI=;
        h=Date:From:To:Subject:From;
        b=JFpFsWQ+rriDZWUP8e6jIGSabneTVOQh2YqxsIaZ89oO4/JrFJ5+zoAiDsCw0VKNv
         c1c1k83/VeMoH2nfhY3aTxzaCPE4eH1glsyZ76LdKhagu81+8JUDHfLu3VC11MgoXv
         t2QLTFSHY47+PB/3F33wytecoxtXnmE+7V1N5Ko0=
Date:   Wed, 16 Sep 2020 16:56:28 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mhocko@suse.com, david@redhat.com, chris@chrisdown.name,
        zangchunxin@bytedance.com
Subject:  +
 mm-vmscan-add-a-fatal-signals-check-in-drop_slab_node.patch added to -mm tree
Message-ID: <20200916235628.8JHWf%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: add a fatal signals check in drop_slab_node
has been added to the -mm tree.  Its filename is
     mm-vmscan-add-a-fatal-signals-check-in-drop_slab_node.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-add-a-fatal-signals-check-in-drop_slab_node.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-add-a-fatal-signals-check-in-drop_slab_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
mm-vmscan-add-a-fatal-signals-check-in-drop_slab_node.patch

