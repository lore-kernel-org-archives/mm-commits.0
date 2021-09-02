Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48680C43219
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 328FD610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243139AbhIBV7V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347962AbhIBV7H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DBE160F12;
        Thu,  2 Sep 2021 21:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619888;
        bh=d9c8R0THXOKK5/e1epdyW+I/9d/GDIqxH8veGcD6vKQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wUT26+CEM0EaYe/5Tz5VzPcOnf59Lmi29z43gn+Euqb0whslejmQh8ZnWm7yyJnxr
         q+JA/2vAC/8SSCE2wcPIcphEZw0xR7yX2FbCWB4qSiEY6G2OdBiASQf0opSBAzzIIB
         yIJa+BqqAHkOAn3KYX2Koo569oUO7qr+F9DqX4hY=
Date:   Thu, 02 Sep 2021 14:58:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, npache@redhat.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org
Subject:  [patch 154/212] mm/page_alloc.c: fix 'zone_id' may be
 used uninitialized in this function warning
Message-ID: <20210902215808.cDXkJez81%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nico Pache <npache@redhat.com>
Subject: mm/page_alloc.c: fix 'zone_id' may be used uninitialized in this function warning

When compiling with -Werror, cc1 will warn that 'zone_id' may be used
uninitialized in this function warning.

Initialize the zone_id as 0.

Its safe to assume that if the code reaches this point it has at least one
numa node with memory, so no need for an assertion before
init_unavilable_range.

Link: https://lkml.kernel.org/r/20210716210336.1114114-1-npache@redhat.com
Fixes: 122e093c1734 ("mm/page_alloc: fix memory map initialization for descending nodes")
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~fix-zone_id-may-be-used-uninitialized-in-this-function-warning
+++ a/mm/page_alloc.c
@@ -6715,7 +6715,7 @@ static void __init memmap_init(void)
 {
 	unsigned long start_pfn, end_pfn;
 	unsigned long hole_pfn = 0;
-	int i, j, zone_id, nid;
+	int i, j, zone_id = 0, nid;
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
 		struct pglist_data *node = NODE_DATA(nid);
_
