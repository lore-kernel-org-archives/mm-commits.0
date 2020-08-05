Return-Path: <SRS0=JYiv=BP=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCDAAC433DF
	for <mm-commits@archiver.kernel.org>; Wed,  5 Aug 2020 21:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFDFF2250E
	for <mm-commits@archiver.kernel.org>; Wed,  5 Aug 2020 21:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596662147;
	bh=iCzxQR/gX7JV26e7oD111UcqMD4BpDA7rZqkLneag5w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Gr5urXcpmXD/AbFLQK63D0oxBY7Ss7hcmfUQSJov2EW/C0WaMOKScLN9faTA9QcdE
	 W8BygTv23LRXkaNv/fcMEXh+w9+rLzng5SAUHI7eNh0U747uvCut+1+srzFaDjDjzk
	 PS4lWVod6U3/X7t4lBLTbb3L1u98MWNjcEiGIoZI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgHEVPr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Aug 2020 17:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbgHEVPq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 5 Aug 2020 17:15:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9836E2076E;
        Wed,  5 Aug 2020 21:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596662145;
        bh=iCzxQR/gX7JV26e7oD111UcqMD4BpDA7rZqkLneag5w=;
        h=Date:From:To:Subject:From;
        b=QZXbCoa9LjdJDK7awrkqDAGqNhHpQM4Qg8JCnPEDiXKb8FBbxEYUW4sDVgFjc9jKL
         nqtixY2xLG6OBDwWdShIaI3TaMUhue2zUZ3ffUo41Qz/3xjBmjz4egZz8mE3BFreSw
         VglAdlY5Iyvl3ecr4IeDf5glvn6gxz4qi1cvmXNU=
Date:   Wed, 05 Aug 2020 14:15:45 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, yangx.jy@cn.fujitsu.com
Subject:  + mm-slabc-update-outdated-kmem_list3-in-a-comment.patch
 added to -mm tree
Message-ID: <20200805211545.RzIOeDJ4I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: update outdated kmem_list3 in a comment
has been added to the -mm tree.  Its filename is
     mm-slabc-update-outdated-kmem_list3-in-a-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slabc-update-outdated-kmem_list3-in-a-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slabc-update-outdated-kmem_list3-in-a-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: mm/slab.c: update outdated kmem_list3 in a comment

kmem_list3 has been renamed to kmem_cache_node long long ago so update it.

References:
6744f087ba2a ("slab: Common name for the per node structures")
ce8eb6c424c7 ("slab: Rename list3/l3 to node")

Link: http://lkml.kernel.org/r/20200722033355.26908-1-yangx.jy@cn.fujitsu.com
Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.c~mm-slabc-update-outdated-kmem_list3-in-a-comment
+++ a/mm/slab.c
@@ -1060,7 +1060,7 @@ int slab_prepare_cpu(unsigned int cpu)
  * offline.
  *
  * Even if all the cpus of a node are down, we don't free the
- * kmem_list3 of any cache. This to avoid a race between cpu_down, and
+ * kmem_cache_node of any cache. This to avoid a race between cpu_down, and
  * a kmalloc allocation from another cpu for memory from the node of
  * the cpu going down.  The list3 structure is usually allocated from
  * kmem_cache_create() and gets destroyed at kmem_cache_destroy().
_

Patches currently in -mm which might be from yangx.jy@cn.fujitsu.com are

mm-slabc-update-outdated-kmem_list3-in-a-comment.patch

