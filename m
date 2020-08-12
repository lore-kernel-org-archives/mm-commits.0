Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28B0BC433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F124D207DA
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195875;
	bh=gNoXGryWPF0iLXtXvVeizJyJL+IqwrJGt/4GwCXJ3Jo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=2Qpa5/HYOt07MYXIGfKxD+7c4uPtpDxyhlGOd7A9yWvzrHZKn2wlGvHx0+B03ypSi
	 0xX2Yabr75MW9Do6/gbQM4m8emcUtEFNaQp+xDEkp5jEIO7NG7YUjA6+lwBirv8LCB
	 dfpS8Mqtb5uGLw50eHUldr8RS70nwEENC7xofRjI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgHLBbO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBbO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:14 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19E342076C;
        Wed, 12 Aug 2020 01:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195874;
        bh=gNoXGryWPF0iLXtXvVeizJyJL+IqwrJGt/4GwCXJ3Jo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=byyR1kIAk7s+jEPpKN7/OG7nKwm1BFXg+jG5aFBLTA/Kp81EIGbyjXaToPpT40kOo
         PorzEHseXzoKmpBoYnPkKeXsn7sbe7v131hnIX24e1WxF82kGG2vvEF3XZ4jv3L8wX
         x0vyzuAFmrdR+x3+vQqZqTIAt2uYBnGdT+y8XSBw=
Date:   Tue, 11 Aug 2020 18:31:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, krzk@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 018/165] mm: mempolicy: fix kerneldoc of
 numa_map_to_online_node()
Message-ID: <20200812013113.DvUDQYR-9%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: mm: mempolicy: fix kerneldoc of numa_map_to_online_node()

Fix W=1 compile warnings (invalid kerneldoc):

    mm/mempolicy.c:137: warning: Function parameter or member 'node' not described in 'numa_map_to_online_node'
    mm/mempolicy.c:137: warning: Excess function parameter 'nid' description in 'numa_map_to_online_node'

Link: http://lkml.kernel.org/r/20200728171109.28687-3-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-kerneldoc-of-numa_map_to_online_node
+++ a/mm/mempolicy.c
@@ -129,7 +129,7 @@ static struct mempolicy preferred_node_p
 
 /**
  * numa_map_to_online_node - Find closest online node
- * @nid: Node id to start the search
+ * @node: Node id to start the search
  *
  * Lookup the next closest node by distance if @nid is not online.
  */
_
