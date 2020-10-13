Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 075A2C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C743122227
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633141;
	bh=mjPi6wokPOUxp8J3CoPQLNV0jvYu5pwBNMtnnVkNNz0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ZMY739iVunPmT2eA9nyFjcmHm7IPiOOJxJgLJvCMy6iyTkppSQh3BJYp+jqY/50Tf
	 D79A3pa8pII8g+a0G8Sa3K++wn+WaGLipcxSylrtOZjTHTWYPfYkYrMkYEvCmMJyg4
	 ApPbkhWB43KMAxwsm7izGSqcQbz7OrTxuChKC3Io=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgJMXwV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728822AbgJMXwU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7062C221FF;
        Tue, 13 Oct 2020 23:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633138;
        bh=mjPi6wokPOUxp8J3CoPQLNV0jvYu5pwBNMtnnVkNNz0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xYDm5k+Qf4ixsh6rFHNguuvu1GoXF+1885f13Kpcu8kpUpCLBmxcIu/vS0EKPwQtu
         o6vWAP/nlWAOanea3n4nznCkKNHjx27Dp0Lu84F1q7lq6XIylDL/ZMu7ZtCk1JAUiA
         FTORHoXhn9Uu+v6ibwPhzY1/LTmSgjKh3nJoir0M=
Date:   Tue, 13 Oct 2020 16:52:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 072/181] mm/swap_slots.c: remove always zero and
 unused return value of enable_swap_slots_cache()
Message-ID: <20201013235218.u2YnLRsFt%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap_slots.c: remove always zero and unused return value of enable_swap_slots_cache()

enable_swap_slots_cache() always return zero and its return value is just
ignored by the caller.  So make enable_swap_slots_cache() void.

Link: https://lkml.kernel.org/r/20200924113554.50614-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap_slots.h |    2 +-
 mm/swap_slots.c            |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/swap_slots.h~mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache
+++ a/include/linux/swap_slots.h
@@ -23,7 +23,7 @@ struct swap_slots_cache {
 
 void disable_swap_slots_cache_lock(void);
 void reenable_swap_slots_cache_unlock(void);
-int enable_swap_slots_cache(void);
+void enable_swap_slots_cache(void);
 int free_swap_slot(swp_entry_t entry);
 
 extern bool swap_slot_cache_enabled;
--- a/mm/swap_slots.c~mm-swap_slotsc-remove-always-zero-and-unused-return-value-of-enable_swap_slots_cache
+++ a/mm/swap_slots.c
@@ -237,7 +237,7 @@ static int free_slot_cache(unsigned int
 	return 0;
 }
 
-int enable_swap_slots_cache(void)
+void enable_swap_slots_cache(void)
 {
 	mutex_lock(&swap_slots_cache_enable_mutex);
 	if (!swap_slot_cache_initialized) {
@@ -255,7 +255,6 @@ int enable_swap_slots_cache(void)
 	__reenable_swap_slots_cache();
 out_unlock:
 	mutex_unlock(&swap_slots_cache_enable_mutex);
-	return 0;
 }
 
 /* called with swap slot cache's alloc lock held */
_
