Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1702AC43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D20D42222E
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633416;
	bh=thfvBQYVqxf+ssDdjOcetoODjOIxNkdIcCqgNk9q4os=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fVUmNaOLbY4l7hptGtfYdK5W+Rsi9weIc3JzYV2MPWyZbdIodKdRZLTERYhz7kRaJ
	 kXuVeC44OWeF+pnlo3JH5QKU310oia/HvKwqa8d6jMwwGovX3hG18Y5QFi3B56OVMt
	 Aa+xkFJwHYrzXRPOrINMnLPfqwcfTBC19Z/dgUio=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388694AbgJMX44 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:56:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMX44 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:56:56 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C01112222F;
        Tue, 13 Oct 2020 23:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633416;
        bh=thfvBQYVqxf+ssDdjOcetoODjOIxNkdIcCqgNk9q4os=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PKnd4hLQJ1PEAPFckAH5wKg7ph+r3+j8n6hgsh/7H7V/Aa5I7sm0kuCeZrabCgVE8
         wv9hO6x8clbCVPAQ12yVoAAs0sYFTyFrq5aFA5NakE9BWJT8nm/pD/72bLQHE9jvCb
         KkumOmS2W70gRnIGHAyR3YJh7On6dHraUDqm8qrA=
Date:   Tue, 13 Oct 2020 16:56:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, chenxiang66@hisilicon.com,
        david@redhat.com, ddstreet@ieee.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        torvalds@linux-foundation.org
Subject:  [patch 155/181] mm/zbud: remove redundant initialization
Message-ID: <20201013235655.u5gEzxH1n%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>
Subject: mm/zbud: remove redundant initialization

zhdr is already initialized in the front of the function, so remove
redundant initialization here.

Link: https://lkml.kernel.org/r/1600419885-191907-1-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zbud.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zbud.c~mm-zbud-remove-redundant-initialization
+++ a/mm/zbud.c
@@ -367,7 +367,6 @@ int zbud_alloc(struct zbud_pool *pool, s
 	spin_lock(&pool->lock);
 
 	/* First, try to find an unbuddied zbud page. */
-	zhdr = NULL;
 	for_each_unbuddied_list(i, chunks) {
 		if (!list_empty(&pool->unbuddied[i])) {
 			zhdr = list_first_entry(&pool->unbuddied[i],
_
