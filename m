Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EA4C388F9
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 784E8223BF
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408163;
	bh=ZGLfNg1+9U01svwD3BXAdQMY9/BjfqqbwqreA3F3JOo=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Xfe00zSJH+D+BxzFaVeAs/bxwSjpgpI0njerA3lUA9eobqox5fhuDX2LIH0Q9hZru
	 Suo/WAJ9Ontz2VunSxGth1PWfHoxaHqIgf6hs0GESs6k07FlRXPIgW2wCCRsrDts8H
	 1Z01SIkL66kv8sNQYG0of8hbRJ7jJG8CY2cspQt8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373150AbgJVXJX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:09:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373127AbgJVXJW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:09:22 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFA8720756;
        Thu, 22 Oct 2020 23:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408162;
        bh=ZGLfNg1+9U01svwD3BXAdQMY9/BjfqqbwqreA3F3JOo=;
        h=Date:From:To:Subject:From;
        b=JfBA//r19G0vT5/Umoo7Fix8IYoIrZyQVWcOOxNWJtsaMTFTOAv0djckfCKN6fUAj
         JboJQScdiWuluZNbM0GQ2ivuoPZxpaXcaamYoX8hA0/can6BEVWIjO7tx/QI2JqoMj
         3Cm/re/Eqj1qxuwoWu26syWUL8piDOl1HJttIW4I=
Date:   Thu, 22 Oct 2020 16:09:21 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com
Subject:  [merged]
 mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch
 removed from -mm tree
Message-ID: <20201022230921.UGEbqr2Jz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: enable kernel memcg accounting from interrupt contexts
has been removed from the -mm tree.  Its filename was
     mm-kmem-enable-kernel-memcg-accounting-from-interrupt-contexts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -1531,18 +1531,6 @@ static inline bool memcg_kmem_enabled(vo
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
@@ -1090,6 +1090,19 @@ static __always_inline struct mem_cgroup
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

mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

