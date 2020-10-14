Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA8EBC433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7955322248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709215;
	bh=OD4zIDJo+oikVNQIHl7Ltg3GcdlbhuOGXGs2TFtXySo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JS44T8kN6CWwnQs/BAu446AYmrvUyaPW/2LpSc3w5pZHecTGCPZPiDPEyiT15CnHS
	 0R/yvvK5okJRm/45ivpmswROMex3Btv/x7jprRflzTAiURsd2OzhFKNIF1S5ZQ77c/
	 p3uhjaGAm7ubYvIIHR2yPk0W7eEp1825ceWNttSg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgJNVAP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:50562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNVAP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:00:15 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5AAE2068E;
        Wed, 14 Oct 2020 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709214;
        bh=OD4zIDJo+oikVNQIHl7Ltg3GcdlbhuOGXGs2TFtXySo=;
        h=Date:From:To:Subject:From;
        b=FDkgQDwHOU5wyV5vEhYUSI1QGFyHwFn+CaZ836LyBPuUsiEZoI+39jzG+yKwcDDHk
         9hvmC5KZ4Z9XmMrDXP6FheT6CjaGncoIvRCmr8TD5JHKQChAOZ0UasVHd/ZGgc5L8W
         howilrt9rKizsYm+sZLtNZJCoN5YqNJyS9GhEEQA=
Date:   Wed, 14 Oct 2020 14:00:13 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        laoar.shao@gmail.com, longman@redhat.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcg-clean-up-obsolete-enum-charge_type.patch removed from -mm tree
Message-ID: <20201014210013.1OpNLRMg-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: clean up obsolete enum charge_type
has been removed from the -mm tree.  Its filename was
     mm-memcg-clean-up-obsolete-enum-charge_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from longman@redhat.com are


