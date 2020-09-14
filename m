Return-Path: <SRS0=BOB0=CX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F8BC43461
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:03:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F8E2221E8
	for <mm-commits@archiver.kernel.org>; Mon, 14 Sep 2020 03:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600052637;
	bh=XOv4wgDtY8SkkcUsDE8DeRq0y6hSGaXlRo2OemI+qaY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LRsSlA66maOinMsdkdwSYXDv7EvTMenI51CGKz0Av4vN5DG2+wXbvRNg3PiUvITC+
	 Jcr8zrTGDWF0okK5O052y8qGrpraL3F6OlgoQoktcznobdk/4yxwJfAyYSoPaSzD7/
	 30cwcSEPw66pReZshKn6O74xQiT6ujhIPdHE6PO4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgINDD4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 13 Sep 2020 23:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgINDDz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 13 Sep 2020 23:03:55 -0400
Received: from X1 (unknown [209.33.215.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCD8621D1B;
        Mon, 14 Sep 2020 03:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600052635;
        bh=XOv4wgDtY8SkkcUsDE8DeRq0y6hSGaXlRo2OemI+qaY=;
        h=Date:From:To:Subject:From;
        b=n5vuVWWvVzSq3vyhL4+p2ag+paDYeXgSNMC/5plvzcN8zj5IGVDUifJXXFn28bGiy
         lpTq8tOe34h4f77y9wJ/2zXd36QOBFp1D5xzXT3Btg02vGTRkuS1yj38z0yYXkLRII
         joHlufloh1CRDNu7UaAm/GI+kSDA4tMSL2gYAI/k=
Date:   Sun, 13 Sep 2020 20:03:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com, tj@kernel.org,
        shakeelb@google.com, mhocko@kernel.org, laoar.shao@gmail.com,
        hannes@cmpxchg.org, guro@fb.com, chris@chrisdown.name,
        longman@redhat.com
Subject:  + mm-memcg-clean-up-obsolete-enum-charge_type.patch added
 to -mm tree
Message-ID: <20200914030354.cyQu8%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: clean up obsolete enum charge_type
has been added to the -mm tree.  Its filename is
     mm-memcg-clean-up-obsolete-enum-charge_type.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-clean-up-obsolete-enum-charge_type.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-clean-up-obsolete-enum-charge_type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Chris Down <chris@chrisdown.name>
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

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-clean-up-obsolete-enum-charge_type.patch
mm-memcg-simplify-mem_cgroup_get_max.patch
mm-memcg-unify-swap-and-memsw-page-counters.patch

