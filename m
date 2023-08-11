Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320BDC001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbjHKXA2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237073AbjHKW7k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED1C3596
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D91D67657
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83C6C433C7;
        Fri, 11 Aug 2023 22:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794767;
        bh=k0YSZr1FaTK1JsqjPmxhmWFr7hPM5KUU5vLTLuBSOcQ=;
        h=Date:To:From:Subject:From;
        b=zLX4xZLfLyUecmkN4Uza3BoUnqX1xqkJUIFpCLiolOadM7C50rj0O8PN/TpSYIeKx
         lskCVZTjJw9KE/iggGyL1eaUO0raVi++CBx9dx+L9AaOk+daYosgTNto5EInuLlMbW
         U2NKk/bKwliTH6e2kpwQfZ9Z7ZUK/1Jv+5vXoiHk=
Date:   Fri, 11 Aug 2023 15:59:27 -0700
To:     mm-commits@vger.kernel.org, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch removed from -mm tree
Message-Id: <20230811225927.A83C6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove obsolete comment above struct per_cpu_pages
has been removed from the -mm tree.  Its filename was
     mm-remove-obsolete-comment-above-struct-per_cpu_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: remove obsolete comment above struct per_cpu_pages
Date: Thu, 6 Jul 2023 17:24:41 +0800

Since commit 01b44456a7aa ("mm/page_alloc: replace local_lock with normal
spinlock"), per_cpu_pages is protected by normal spinlock.  Remove the
obsolete comment as it's not that helpful.

Link: https://lkml.kernel.org/r/20230706092441.1574950-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/mmzone.h~mm-remove-obsolete-comment-above-struct-per_cpu_pages
+++ a/include/linux/mmzone.h
@@ -676,7 +676,6 @@ enum zone_watermarks {
 #define high_wmark_pages(z) (z->_watermark[WMARK_HIGH] + z->watermark_boost)
 #define wmark_pages(z, i) (z->_watermark[i] + z->watermark_boost)
 
-/* Fields and list protected by pagesets local_lock in page_alloc.c */
 struct per_cpu_pages {
 	spinlock_t lock;	/* Protects lists field */
 	int count;		/* number of pages in the list */
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memcg-fix-obsolete-function-name-in-mem_cgroup_protection.patch
mm-memory-failure-add-pageoffline-check.patch
mm-page_alloc-avoid-unneeded-alike_pages-calculation.patch
mm-memcg-update-obsolete-comment-above-parent_mem_cgroup.patch
mm-page_alloc-remove-unneeded-variable-base.patch
mm-memcg-fix-wrong-function-name-above-obj_cgroup_charge_zswap.patch
mm-memory-failure-use-helper-macro-llist_for_each_entry_safe.patch
mm-mm_init-use-helper-macro-bits_per_long-and-bits_per_byte.patch

