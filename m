Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3847AC433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D9F92177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781210;
	bh=A5XTRG/WG6FSRjHL8HCFSEvfNsiBkY/8EkP+IYiv6Kk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=z1L3sWt4kKQ0OWrv4VoIbkOAGJhUjayNfiSnGkURBQoIMGUBGcSsUCKpJgOId1bBa
	 s60iA4GDALvu/4uezS3NsYw7FF+fHunJ0dS+6VrchyA6OrgSaZ2SQl/9Hb/6aQ7c/c
	 brR6iWLRCs6/iLSyR7CVqgkALn2K5aCV8u+L5Mww=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbgHGGUJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:20:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGUJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:20:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C19E722C9F;
        Fri,  7 Aug 2020 06:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781209;
        bh=A5XTRG/WG6FSRjHL8HCFSEvfNsiBkY/8EkP+IYiv6Kk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=y7m20ZAwRlQQUjSMR3WjhBLCXkE0dt3X+NwF7czXSEcH2UGgyp3Fdr92itU79Ocjj
         OCaY9gIzK86PgtcUDpcrar70ff7mrPlDTqEebKZV8EFRi9jJuFWRkO0dY2jB0Au6DQ
         WYBqRpxHsKyNjm3mL7oOZQsv2oFz6/SZ9nN0OQAU=
Date:   Thu, 06 Aug 2020 23:20:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, thunder.leizhen@huawei.com,
        tim.c.chen@linux.intel.com, torvalds@linux-foundation.org
Subject:  [patch 055/163] mm/swap_slots.c: simplify
 enable_swap_slots_cache()
Message-ID: <20200807062008.XfHKlbvxo%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: mm/swap_slots.c: simplify enable_swap_slots_cache()

Whether swap_slot_cache_initialized is true or false,
__reenable_swap_slots_cache() is always called.  To make this meaning
clear, leave only one call to __reenable_swap_slots_cache().  This also
make it clearer what extra needs be done when swap_slot_cache_initialized
is false.

No functional change.

Link: http://lkml.kernel.org/r/20200430061143.450-3-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/mm/swap_slots.c~mm-swap-simplify-enable_swap_slots_cache
+++ a/mm/swap_slots.c
@@ -240,21 +240,19 @@ static int free_slot_cache(unsigned int
 
 int enable_swap_slots_cache(void)
 {
-	int ret = 0;
-
 	mutex_lock(&swap_slots_cache_enable_mutex);
-	if (swap_slot_cache_initialized) {
-		__reenable_swap_slots_cache();
-		goto out_unlock;
-	}
+	if (!swap_slot_cache_initialized) {
+		int ret;
 
-	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "swap_slots_cache",
-				alloc_swap_slot_cache, free_slot_cache);
-	if (WARN_ONCE(ret < 0, "Cache allocation failed (%s), operating "
-			       "without swap slots cache.\n", __func__))
-		goto out_unlock;
+		ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "swap_slots_cache",
+					alloc_swap_slot_cache, free_slot_cache);
+		if (WARN_ONCE(ret < 0, "Cache allocation failed (%s), operating "
+				       "without swap slots cache.\n", __func__))
+			goto out_unlock;
+
+		swap_slot_cache_initialized = true;
+	}
 
-	swap_slot_cache_initialized = true;
 	__reenable_swap_slots_cache();
 out_unlock:
 	mutex_unlock(&swap_slots_cache_enable_mutex);
_
