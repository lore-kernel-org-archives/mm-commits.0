Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1665CC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EECC86147E
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhD3F5u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229834AbhD3F5t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A192B6147D;
        Fri, 30 Apr 2021 05:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762221;
        bh=jM7NWJ4ENY0LYQwrI/jrq0gPB+aVFZ2IVjkMRx1t7zw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vOL+XrFhJECmmT7/5OCCkvqYXetnIZm5TGqSC/sbmhpWyCrxi4rH9YGVjZKQ69uy3
         fF1eyRgU78rRBD+TSq9pTi/1dp30L4du/ZL1R4lB6iJuZBqlGm+ZWJIa46OLc3vPyv
         8KposZ43XLHxl+vXi43adspzdSj7CDjR/HlAVfeg=
Date:   Thu, 29 Apr 2021 22:57:01 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        torvalds@linux-foundation.org, wanjiabing@vivo.com
Subject:  [patch 075/178] linux/memcontrol.h: remove duplicate
 struct declaration
Message-ID: <20210430055701.KvvCEM-j6%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
