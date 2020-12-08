Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50946C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 00:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1373D23A1C
	for <mm-commits@archiver.kernel.org>; Tue,  8 Dec 2020 00:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728803AbgLHArR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Dec 2020 19:47:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgLHArR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 7 Dec 2020 19:47:17 -0500
Date:   Mon, 07 Dec 2020 16:46:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607388380;
        bh=XTIIMbjDAHAjOCEGfRSnHksXkqMeACSP7SLpUsO6+JE=;
        h=From:To:Subject:From;
        b=HK49m5HAonvikyHtqDvs6tYaBtfa1PLiG3MIJDA3pLY11vuA5TKhTmooHE6YZA8z9
         Hl4C5KsEKrgZHSGFz28gPk7yEzoQFbdw9Z6etaQtD89sZ1GHFJsk/pJxpr5w+r7Jf/
         5aKRCy5Dh1mpY3RonK23qOYLGWkZvmg8w4Ztu3N8=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hughd@google.com,
        mm-commits@vger.kernel.org, qcai@redhat.com, stable@vger.kernel.org
Subject:  [merged]
 mm-swapfile-do-not-sleep-with-a-spin-lock-held.patch removed from -mm tree
Message-ID: <20201208004620.V9_Q79gId%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: do not sleep with a spin lock held
has been removed from the -mm tree.  Its filename was
     mm-swapfile-do-not-sleep-with-a-spin-lock-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <qcai@redhat.com>
Subject: mm/swapfile: do not sleep with a spin lock held

We can't call kvfree() with a spin lock held, so defer it.  Fixes a
might_sleep() runtime warning.

Link: https://lkml.kernel.org/r/20201202151549.10350-1-qcai@redhat.com
Fixes: 873d7bcfd066 ("mm/swapfile.c: use kvzalloc for swap_info_struct allocation")
Signed-off-by: Qian Cai <qcai@redhat.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-do-not-sleep-with-a-spin-lock-held
+++ a/mm/swapfile.c
@@ -2867,6 +2867,7 @@ late_initcall(max_swapfiles_check);
 static struct swap_info_struct *alloc_swap_info(void)
 {
 	struct swap_info_struct *p;
+	struct swap_info_struct *defer = NULL;
 	unsigned int type;
 	int i;
 
@@ -2895,7 +2896,7 @@ static struct swap_info_struct *alloc_sw
 		smp_wmb();
 		WRITE_ONCE(nr_swapfiles, nr_swapfiles + 1);
 	} else {
-		kvfree(p);
+		defer = p;
 		p = swap_info[type];
 		/*
 		 * Do not memset this entry: a racing procfs swap_next()
@@ -2908,6 +2909,7 @@ static struct swap_info_struct *alloc_sw
 		plist_node_init(&p->avail_lists[i], 0);
 	p->flags = SWP_USED;
 	spin_unlock(&swap_lock);
+	kvfree(defer);
 	spin_lock_init(&p->lock);
 	spin_lock_init(&p->cont_lock);
 
_

Patches currently in -mm which might be from qcai@redhat.com are


