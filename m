Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E4F8C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7848860E52
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345895AbhIHC51 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:57:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347302AbhIHC5U (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 194BF60555;
        Wed,  8 Sep 2021 02:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069773;
        bh=ivNpzlW2A1uyW/sfBXcXZ3ASaB34QnCZ07tbwoeVSrE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vPZmAvpg6u80QqXGJd+DhPGWFjyOjFN6BF2S2Dj9ZI+nnJr+qgCdOJ7v2zEQ16MF7
         OX7eFpOl3rVYopwMOH04hHwKJnYhi28vMOJS5s27iCAIagjNtXn76IMwxVjApl9lZE
         04GpEesQ/C58Ffaq2+yaJ50nIUo4/nBoQHYzwktI=
Date:   Tue, 07 Sep 2021 19:56:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, catalin.marinas@arm.com,
        changbin.du@gmail.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 058/147] mm: in_irq() cleanup
Message-ID: <20210908025612.HIrVK1YBi%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Changbin Du <changbin.du@gmail.com>
Subject: mm: in_irq() cleanup

Replace the obsolete and ambiguos macro in_irq() with new macro
in_hardirq().

Link: https://lkml.kernel.org/r/20210813145245.86070-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[kmemleak]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c  |    2 +-
 mm/kmemleak.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/highmem.c~mm-in_irq-cleanup
+++ a/mm/highmem.c
@@ -436,7 +436,7 @@ EXPORT_SYMBOL(zero_user_segments);
 
 static inline int kmap_local_idx_push(void)
 {
-	WARN_ON_ONCE(in_irq() && !irqs_disabled());
+	WARN_ON_ONCE(in_hardirq() && !irqs_disabled());
 	current->kmap_ctrl.idx += KM_INCR;
 	BUG_ON(current->kmap_ctrl.idx >= KM_MAX_IDX);
 	return current->kmap_ctrl.idx - 1;
--- a/mm/kmemleak.c~mm-in_irq-cleanup
+++ a/mm/kmemleak.c
@@ -598,7 +598,7 @@ static struct kmemleak_object *create_ob
 	object->checksum = 0;
 
 	/* task information */
-	if (in_irq()) {
+	if (in_hardirq()) {
 		object->pid = 0;
 		strncpy(object->comm, "hardirq", sizeof(object->comm));
 	} else if (in_serving_softirq()) {
_
