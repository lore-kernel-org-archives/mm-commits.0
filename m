Return-Path: <SRS0=GXSN=CI=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB77C433E6
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48CA520693
	for <mm-commits@archiver.kernel.org>; Sun, 30 Aug 2020 22:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598825735;
	bh=OQHB+gX75ejRzLp3JCddyarREco/IeI/YqR/koegjl0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=b5fU0yNQpsIGc9HGhqu8kecRpNzY2Pw07SD7vuH5XcVaQ76hF8mUeBDBCnSJiCHyE
	 70fe0ScGqsVGO8qo+vwM/inxUzFDh9quostK2k2u7PLgX3t9Z7AzM+1Efp4n6ZP4+Y
	 nGP/8NbNT5qnHUQ88QvhQaTCT7p2UG7BevffKQ60=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgH3WPe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 30 Aug 2020 18:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726178AbgH3WPd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 30 Aug 2020 18:15:33 -0400
Received: from X1 (unknown [65.49.58.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00CFE20693;
        Sun, 30 Aug 2020 22:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598825732;
        bh=OQHB+gX75ejRzLp3JCddyarREco/IeI/YqR/koegjl0=;
        h=Date:From:To:Subject:From;
        b=slCy2dxb+8p3q4aMAjED2MOZQ8BTyLARYUdYBeNHaDZCzI9or8qlKw483R7EssnhM
         pv55ug2t5635LyWQHLmh+QicExsd3FcADf86LFvotR4tByIYBqM59do6eOyVkIYR3j
         GtoxXlurhc13s9fiFXio2s4mfhKELnKU/GItfRXA=
Date:   Sun, 30 Aug 2020 15:15:31 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, shakeelb@google.com, mhocko@kernel.org,
        hannes@cmpxchg.org, guro@fb.com
Subject:  +
 mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch added to
 -mm tree
Message-ID: <20200830221531.3YfuH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: enable kernel memcg accounting from interrupt contexts
has been added to the -mm tree.  Its filename is
     mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: kmem: enable kernel memcg accounting from interrupt contexts

If a memcg to charge can be determined (using remote charging API), there
are no reasons to exclude allocations made from an interrupt context from
the accounting.

Such allocations will pass even if the resulting memcg size will exceed
the hard limit, but it will affect the application of the memory pressure
and an inability to put the workload under the limit will eventually
trigger the OOM.

To use active_memcg() helper, memcg_kmem_bypass() is moved back to
memcontrol.c.

Link: http://lkml.kernel.org/r/20200827225843.1270629-5-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   12 ------------
 mm/memcontrol.c            |   13 +++++++++++++
 2 files changed, 13 insertions(+), 12 deletions(-)

--- a/include/linux/memcontrol.h~mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts
+++ a/include/linux/memcontrol.h
@@ -1528,18 +1528,6 @@ static inline bool memcg_kmem_enabled(vo
 	return static_branch_likely(&memcg_kmem_enabled_key);
 }
 
-static inline bool memcg_kmem_bypass(void)
-{
-	if (in_interrupt())
-		return true;
-
-	/* Allow remote memcg charging in kthread contexts. */
-	if ((!current->mm || (current->flags & PF_KTHREAD)) &&
-	     !current->active_memcg)
-		return true;
-	return false;
-}
-
 static inline int memcg_kmem_charge_page(struct page *page, gfp_t gfp,
 					 int order)
 {
--- a/mm/memcontrol.c~mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts
+++ a/mm/memcontrol.c
@@ -1098,6 +1098,19 @@ static __always_inline struct mem_cgroup
 	return memcg;
 }
 
+static __always_inline bool memcg_kmem_bypass(void)
+{
+	/* Allow remote memcg charging from any context. */
+	if (unlikely(active_memcg()))
+		return false;
+
+	/* Memcg to charge can't be determined. */
+	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
+		return true;
+
+	return false;
+}
+
 /**
  * If active memcg is set, do not fallback to current->mm->memcg.
  */
_

Patches currently in -mm which might be from guro@fb.com are

mm-rework-remote-memcg-charging-api-to-support-nesting.patch
mm-kmem-move-memcg_kmem_bypass-calls-to-get_mem-obj_cgroup_from_current.patch
mm-kmem-remove-redundant-checks-from-get_obj_cgroup_from_current.patch
mm-kmem-prepare-remote-memcg-charging-infra-for-interrupt-contexts.patch
mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

