Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A9B9C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:43:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236184AbiCVVoe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbiCVVo1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:44:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763C95F4FC
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 140D560A1B
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69587C340EC;
        Tue, 22 Mar 2022 21:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985368;
        bh=65vsjaCa7K823HTWNhYf+T6ODYlPVC1bXOGpsV6LcrY=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=CGwX50YZDJZgYNuN7CkQRueu6llexKonykLskDYIsgrceEVohXlGUyUJPxf/VqPgF
         Jw1rQbTaxJkwTstxb66Zn4bQ11ABYjorb314NO9Q2hcZttG4UyXnZvmBnxcGiqAnJK
         FMHXw45dCB60G7ilTkwU/2Z4xizaYrPW85hUsAzU=
Date:   Tue, 22 Mar 2022 14:42:47 -0700
To:     urezki@gmail.com, linmiaohe@huawei.com, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 084/227] mm/vmalloc: remove unneeded function forward declaration
Message-Id: <20220322214248.69587C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmalloc: remove unneeded function forward declaration

The forward declaration for lazy_max_pages() is unnecessary.  Remove it.

Link: https://lkml.kernel.org/r/20220124133752.60663-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-unneeded-function-forward-declaration
+++ a/mm/vmalloc.c
@@ -791,7 +791,6 @@ RB_DECLARE_CALLBACKS_MAX(static, free_vm
 
 static void purge_vmap_area_lazy(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
-static unsigned long lazy_max_pages(void);
 
 static atomic_long_t nr_vmalloc_pages;
 
_
