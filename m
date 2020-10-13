Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 160A4C2D0A4
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B444422203
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633202;
	bh=eh0yrjKgpj2wD9uJ5+XaG5mddDwra5Wy0OCm3f30ZBA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dChrb1+bf2/AwSG1K0Be6d+Qe8Q6x9d7/z1GYApbn0OPIgv54NfWTiVC+cqibAY71
	 KfRuqe+9zijGteP9AFNk25dxzrVtUtBHyOFuPDI6Es7Sz+MCXfzM/6wcts/W/sbLB0
	 Fa/9gCGkGRbZJLLtOsheMmLavJS7NANcYjFhaD1k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbgJMXxV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387433AbgJMXwu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:50 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93B7F22200;
        Tue, 13 Oct 2020 23:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633170;
        bh=eh0yrjKgpj2wD9uJ5+XaG5mddDwra5Wy0OCm3f30ZBA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=H9H+X6su3eqNsA1RFPCIyHEHTcucxXr0Ylxixk0nAu3vkEveCRFt6WcBfWHzlmC/k
         t/vo03aovAdDlUpWxayQUCnyYYLjhPvESfr40o2y+gcgFyyF7KYw9Wi4T2UwxcrZIQ
         KsR4AME1tZPBGmzunOHeb9YC0P7HYRSULDhWp78E=
Date:   Tue, 13 Oct 2020 16:52:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chris@chrisdown.name, guro@fb.com,
        hannes@cmpxchg.org, laoar.shao@gmail.com, linux-mm@kvack.org,
        longman@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, tj@kernel.org, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 082/181] mm/memcg: clean up obsolete enum
 charge_type
Message-ID: <20201013235249.f1GP1jxfh%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Waiman Long <longman@redhat.com>
Subject: mm/memcg: clean up obsolete enum charge_type

Patch series "mm/memcg: Miscellaneous cleanups and streamlining", v2.


This patch (of 3):

Since commit 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") and
commit 00501b531c47 ("mm: memcontrol: rewrite charge API") in v3.17, the
enum charge_type was no longer used anywhere.  However, the enum itself
was not removed at that time.  Remove the obsolete enum charge_type now.

Link: https://lkml.kernel.org/r/20200914024452.19167-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20200914024452.19167-2-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-clean-up-obsolete-enum-charge_type
+++ a/mm/memcontrol.c
@@ -197,14 +197,6 @@ static struct move_charge_struct {
 #define	MEM_CGROUP_MAX_RECLAIM_LOOPS		100
 #define	MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS	2
 
-enum charge_type {
-	MEM_CGROUP_CHARGE_TYPE_CACHE = 0,
-	MEM_CGROUP_CHARGE_TYPE_ANON,
-	MEM_CGROUP_CHARGE_TYPE_SWAPOUT,	/* for accounting swapcache */
-	MEM_CGROUP_CHARGE_TYPE_DROP,	/* a page was unused swap cache */
-	NR_CHARGE_TYPE,
-};
-
 /* for encoding cft->private value on file */
 enum res_type {
 	_MEM,
_
