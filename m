Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D524C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C091206CD
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026890;
	bh=+6BW2uT4M1OLmLlkVcx/S+SeoZB8wfN6jZ3P5y+np+w=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=KlM0gfu0bt5QIZ53je+D3FWbaoXfjieJN8zQOhZwxiUwONT2CmbuuIOapOGu51A9f
	 poaWt1rCAJlJFIKAxTq5h+LWyEt9uNN8PpKjuM/ww51oIO/1Z5XWQQXrnUcMwVSHfz
	 huWztqbk1aqkg1inAhY4qviL2DqvaY13IsiirddM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgHJCet (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCet (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:49 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A1A12078D;
        Mon, 10 Aug 2020 02:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026888;
        bh=+6BW2uT4M1OLmLlkVcx/S+SeoZB8wfN6jZ3P5y+np+w=;
        h=Date:From:To:Subject:From;
        b=fTK+UygqPWNzycqizbHg9pYklvZ5SxI87GL/oUjP4ZPnFJMR+N5SLTC4/4n9uOcl5
         HozwMri/e/yEnRZzDku1U/qkTBjRmsjDozBFKPPtt/aq2BKeAaoUzTCrPERikKg57s
         oaRlIDcwEi/zKe23t/hgQLsiC/vfRGBzY7m23/mI=
Date:   Sun, 09 Aug 2020 19:34:48 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, yangx.jy@cn.fujitsu.com
Subject:  [merged]
 mm-slabc-update-outdated-kmem_list3-in-a-comment.patch removed from -mm
 tree
Message-ID: <20200810023448.bYxFamaZY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab.c: update outdated kmem_list3 in a comment
has been removed from the -mm tree.  Its filename was
     mm-slabc-update-outdated-kmem_list3-in-a-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


