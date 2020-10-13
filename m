Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B51C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDE8B2222F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633410;
	bh=i9oSlokWokNmxIsEDT/YUZ0P+2cRWS+fv2M7ehTSVQg=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XZwucTYT+gpdWgPq2CgIbUF2oPYYdwY7D2BkkyT0qg+FOjOeXWUEjPAxVPYBHuRRQ
	 AjUXxQzrt5urAqs4zo7PpTW8ftRIWuCZB/AEVdX4SMGBaNrXlB8KrYWz8mzUl7oSmx
	 b0CIzByrWXfRSm+64ndBzytMUFawMfBTD+CnFjaQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbgJMX4u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbgJMX4u (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:50 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFE852223F;
        Tue, 13 Oct 2020 23:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633410;
        bh=i9oSlokWokNmxIsEDT/YUZ0P+2cRWS+fv2M7ehTSVQg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=u9nhBcdiW1gaYZdcqi/eVyptx4N14BBB+UGrDIJlgbtZg3T4eVmhqTQ6my2STLFJL
         ql+3qUHTelRcbUBg49RRcbrOClK+GIj1MAKtsHHeQ+c9VZ1XBN3lo/KjN7N6blRnUX
         V289ItVCQYmVBpq4p3LN/3oGOO15jmLHDBbbfaWw=
Date:   Tue, 13 Oct 2020 16:56:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sh_def@163.com,
        torvalds@linux-foundation.org
Subject:  [patch 153/181] mm/vmscan: fix comments for
 isolate_lru_page()
Message-ID: <20201013235649.SkJtCR_OJ%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hui Su <sh_def@163.com>
Subject: mm/vmscan: fix comments for isolate_lru_page()

fix comments for isolate_lru_page():
s/fundamentnal/fundamental

Link: https://lkml.kernel.org/r/20200927173923.GA8058@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-fix-comments-for-isolate_lru_page
+++ a/mm/vmscan.c
@@ -1754,7 +1754,7 @@ static unsigned long isolate_lru_pages(u
  * Restrictions:
  *
  * (1) Must be called with an elevated refcount on the page. This is a
- *     fundamentnal difference from isolate_lru_pages (which is called
+ *     fundamental difference from isolate_lru_pages (which is called
  *     without a stable reference).
  * (2) the lru_lock must not be held.
  * (3) interrupts must be enabled.
_
