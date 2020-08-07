Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B3EC433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CBD622C9F
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781348;
	bh=OL8oqQ2stk7opHjsLnLzeXyTEWilQEc9tZV1tv1GZv4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XbgNski3ihtBaFcIUtGBuHlKwSPqau7kpHjPuYJOmtIC8cAY8lc+bb5Iz8H+OZROc
	 t//GwqdKWX1CWSjh5LGTXDl5Pk0q33hjCBbV2GOhgM/q0oWWfyuxhq+fJZhp7mwf7x
	 wacO5Ock8zqecOXgNPvH3h6hvLhqCpSr690dP+40=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHGGW2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:22:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGWW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:22:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56144221E5;
        Fri,  7 Aug 2020 06:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781342;
        bh=OL8oqQ2stk7opHjsLnLzeXyTEWilQEc9tZV1tv1GZv4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gI5gry7Ff4w8WcIdQzDNk2zmIeW9HzTGQ2FFn3Wag6KwBRxacU8JdKT5CFfeEyFjq
         ht9Cc/4tB6zTA3J2LudZoNMllvAeKPbjcqMfzvAr9RKi/4PpTNgr4GmS2ZjaijABO3
         W2mNszdK++VPEfMR+4krN6IOrFicXICwyyZ5sK5U=
Date:   Thu, 06 Aug 2020 23:22:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, jgg@mellanox.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rcampbell@nvidia.com, torvalds@linux-foundation.org
Subject:  [patch 094/163] mm: remove redundant check
 non_swap_entry()
Message-ID: <20200807062221.EfR5XGPgf%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm: remove redundant check non_swap_entry()

In zap_pte_range(), the check for non_swap_entry() and
is_device_private_entry() is unnecessary since the latter is sufficient to
determine if the page is a device private page.  Remove the test for
non_swap_entry() to simplify the code and for clarity.

Link: http://lkml.kernel.org/r/20200615175405.4613-1-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-remove-redundant-check-non_swap_entry
+++ a/mm/memory.c
@@ -1098,7 +1098,7 @@ again:
 		}
 
 		entry = pte_to_swp_entry(ptent);
-		if (non_swap_entry(entry) && is_device_private_entry(entry)) {
+		if (is_device_private_entry(entry)) {
 			struct page *page = device_private_entry_to_page(entry);
 
 			if (unlikely(details && details->check_mapping)) {
_
