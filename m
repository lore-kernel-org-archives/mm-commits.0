Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22EDC636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 05:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjBCFoc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 00:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbjBCFob (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 00:44:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C93B760CA3
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 21:44:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62C5FB828B2
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 05:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013EBC433D2;
        Fri,  3 Feb 2023 05:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675403068;
        bh=+CTYLQ+5Z7iEc2Mr9RB0JvO7bV8iTTCBfULzXyZQRu8=;
        h=Date:To:From:Subject:From;
        b=DNABuT/8ZQ/hJJq28XhjEwfvKOp7/+9qkAnm1BK/5NvWTbKpcJX1+ZdCnFY6WriHp
         yOh8SMs5YYW3Ou3yfinCOaUJp3Jh8C57bT9FRer3KZr2erM1wn7LotGHeoh/xLDgWH
         RXD/bES52T+NF1fAJldk6XAmLCT2gXwqNw3XwZ/M=
Date:   Thu, 02 Feb 2023 21:44:27 -0800
To:     mm-commits@vger.kernel.org, pasha.tatashin@soleen.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2.patch removed from -mm tree
Message-Id: <20230203054428.013EBC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2
has been removed from the -mm tree.  Its filename was
     mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2.patch

This patch was dropped because it was folded into mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages.patch

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2
Date: Wed, 18 Jan 2023 15:52:51 +0000

fix build with CONFIG_PAGE_EXTENSION=n

Link: https://lkml.kernel.org/r/20230118155251.2522985-1-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/page_ext.h~mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages-v2
+++ a/include/linux/page_ext.h
@@ -29,6 +29,8 @@ struct page_ext_operations {
 	bool need_shared_flags;
 };
 
+extern bool deferred_struct_pages;
+
 #ifdef CONFIG_PAGE_EXTENSION
 
 /*
@@ -54,7 +56,6 @@ struct page_ext {
 	unsigned long flags;
 };
 
-extern bool deferred_struct_pages;
 extern bool early_page_ext;
 extern unsigned long page_ext_size;
 extern void pgdat_page_ext_init(struct pglist_data *pgdat);
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

mm-page_ext-do-not-allocate-space-for-page_ext-flags-if-not-needed.patch
mm-page_ext-init-page_ext-early-if-there-are-no-deferred-struct-pages.patch

