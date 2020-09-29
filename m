Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57DD5C4727C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAF4B208B8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 20:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601413025;
	bh=M7FOw35xFh7QLXPFRymx+YQMYALSSVeYmFeInXCRk5Q=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=seaRW1AmH9xatJ5638zkT/T1xEeTKBsE9enb3+k/Zb5NRcWRFNJ6F2+fulROnsMm7
	 ZhAR/X0oUQNv11VNMyW3JxTwrGKSVzvxfM2208CJIRG06rold3xGnuEXJ65SCldQ63
	 XsxD2piO2KKG+0cUUodKixUv3GfYdiCuQZikbjps=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgI2U5E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Sep 2020 16:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgI2U5E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Sep 2020 16:57:04 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2D0A20757;
        Tue, 29 Sep 2020 20:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601413022;
        bh=M7FOw35xFh7QLXPFRymx+YQMYALSSVeYmFeInXCRk5Q=;
        h=Date:From:To:Subject:From;
        b=j9LS1hiUCTdlp/4Ik6qv4sRwNRycd0yRfaUg4KbU4SWMD+pEqkBmDb9VRrxD7KtHE
         nDHzdyw9j3wmU0t8TSxFWomc3rUcoXQaM+/oDE5FA3SI88zsAAg8ep6EmK1AjRfnE8
         nHkX9hlp+adnwcrywhrQnTTAVBlEihyq8K5BaV74=
Date:   Tue, 29 Sep 2020 13:57:01 -0700
From:   akpm@linux-foundation.org
To:     chenxiang66@hisilicon.com, david@redhat.com, ddstreet@ieee.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com
Subject:  + mm-zbud-remove-redundant-initialization.patch added to
 -mm tree
Message-ID: <20200929205701.T0oFCInV6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/zbud: remove redundant initialization
has been added to the -mm tree.  Its filename is
     mm-zbud-remove-redundant-initialization.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-zbud-remove-redundant-initialization.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-zbud-remove-redundant-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from chenxiang66@hisilicon.com are

mm-zbud-remove-redundant-initialization.patch

