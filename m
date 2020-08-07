Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D24C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:26:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9240922CAE
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781591;
	bh=ZZ9s+7THUYsNALh7tX+k1Qcg5zL3aj8zuj4I56CUPYw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=PA3KQF4EtDQiBY0yb+lQstyHpv76DGyAaXewwyRe0wRtlLYC3i2Ej5/kASMNld/49
	 kRGMmsJDu9cV/kUJg31TnjzaxS8no1Ff3JrObtLXiC32ZRfPVkyxStytT+Ux8ceNPG
	 QY8cFEPPR2LgYMJPM0ZdvxZlfCpHk9g+lnGbzCrk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgHGG0b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGG0a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:26:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 170DC22CF6;
        Fri,  7 Aug 2020 06:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781590;
        bh=ZZ9s+7THUYsNALh7tX+k1Qcg5zL3aj8zuj4I56CUPYw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=I76bF/LxO04T9JSZM+8ruIJ2WKUx3wlxKv619X/UEfFr+Q19Km2jR6eBiVyGf6H2i
         FnRH/mpIgCWVRCDxuCnfLYgZo0h7wF0BG0bh1527kYd8VNrZXzuVpaU989eesC6i3l
         jlanj0aeQEY/K4lckLKoTb4TAlC9gwQjzBb1WVqM=
Date:   Thu, 06 Aug 2020 23:26:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, spacct.spacct@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 162/163] mm/vmscan.c: fix typo
Message-ID: <20200807062629.4TnTBWcyR%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: dylan-meiners <spacct.spacct@gmail.com>
Subject: mm/vmscan.c: fix typo

Change "optizimation" to "optimization".

Link: http://lkml.kernel.org/r/20200609185144.10049-1-spacct.spacct@gmail.com
Signed-off-by: dylan-meiners <spacct.spacct@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscanc-fixed-typo
+++ a/mm/vmscan.c
@@ -910,7 +910,7 @@ static int __remove_mapping(struct addre
 		 * order to detect refaults, thus thrashing, later on.
 		 *
 		 * But don't store shadows in an address space that is
-		 * already exiting.  This is not just an optizimation,
+		 * already exiting.  This is not just an optimization,
 		 * inode reclaim needs to empty out the radix tree or
 		 * the nodes are lost.  Don't plant shadows behind its
 		 * back.
_
