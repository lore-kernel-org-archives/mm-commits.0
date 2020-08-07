Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D5AC433E4
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 713E822CB3
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781113;
	bh=yEGq3QmsfsiD7ZQzvEF9Iu4ht28IgB/X7T284JZKEAk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=g3WuytHpQHQAbA3wQMkb1J1iLEE7jDmhrcWlmTPXwnqDhtATYuhsnaBkwf1AqFG6G
	 FnLrudmN77plxGL8jTlVcWQbPFuT5iUYki0adDZd579EyigGOCwBlPXvSgtc7E8SWV
	 4019Gp0yeAkyr1SVqvkMBjxYZVtW0ZqDI3pNBGR4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGGSd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:18:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGSd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:18:33 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 416BC22CAE;
        Fri,  7 Aug 2020 06:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781112;
        bh=yEGq3QmsfsiD7ZQzvEF9Iu4ht28IgB/X7T284JZKEAk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XHwR3lzsUlaWXKMS0ay4BbtYJP+9ERo3H2KjPs2HXy8tP4Wowjm/m6NLm18X8RcH0
         u/gqBis+tx54K97K/BwcBzRBaq0NdxjE8+OAoluluGCf5pykhhBioExB2qu4RQhGbp
         zu849xbsDlXCVjNP2ion7Slcjn087SSHUN06vYIQ=
Date:   Thu, 06 Aug 2020 23:18:31 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org,
        yangx.jy@cn.fujitsu.com
Subject:  [patch 027/163] mm/slab.c: update outdated kmem_list3 in
 a comment
Message-ID: <20200807061831.mb1JDJlMk%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
