Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D6EC433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D65F6141D
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhEHWmm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhEHWmm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A7146100C;
        Sat,  8 May 2021 22:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513699;
        bh=q0HePs5NyFXHn/zB/k/I+QVRVXNQh4x5AMoDXfbmtVg=;
        h=Date:From:To:Subject:From;
        b=ZQVQxQpG5NQwy35rcVSFmAGtWMhWY/WEyQF6cyXhPe82annB3W+oD38oMbxWFyzRF
         Ftdd8/74cwYytQoeJxZVv1SQJcCIZyvKgx+zd8aimw9ASmNanJyZzz9H40/2VCxbHd
         KNfl7FL8fl8RdaqTsb7cGM/He0VXB/fN08i0thZk=
Date:   Sat, 08 May 2021 15:41:39 -0700
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org,
        songmuchun@bytedance.com, wanjiabing@vivo.com
Subject:  [merged]
 linux-memcontrolh-remove-duplicate-struct-declaration.patch removed from
 -mm tree
Message-ID: <20210508224139.XOdvZiSIb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: linux/memcontrol.h: remove duplicate struct declaration
has been removed from the -mm tree.  Its filename was
     linux-memcontrolh-remove-duplicate-struct-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wan Jiabing <wanjiabing@vivo.com>
Subject: linux/memcontrol.h: remove duplicate struct declaration

struct mem_cgroup is declared twice.  One has been declared at forward
struct declaration.  Remove the duplicate.

Link: https://lkml.kernel.org/r/20210330020246.2265371-1-wanjiabing@vivo.com
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/memcontrol.h~linux-memcontrolh-remove-duplicate-struct-declaration
+++ a/include/linux/memcontrol.h
@@ -1123,8 +1123,6 @@ unsigned long mem_cgroup_soft_limit_recl
 #define MEM_CGROUP_ID_SHIFT	0
 #define MEM_CGROUP_ID_MAX	0
 
-struct mem_cgroup;
-
 static inline struct mem_cgroup *page_memcg(struct page *page)
 {
 	return NULL;
_

Patches currently in -mm which might be from wanjiabing@vivo.com are


