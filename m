Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07FBBC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiANWJg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60820 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiANWJb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65A8AB8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3A8C36AE9;
        Fri, 14 Jan 2022 22:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198169;
        bh=sJj+3KSGx0lT8xZbK1n+Apk8RaMnsSo4xCzroKRdGoc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=2AEDeP6k2XFvv1PUg1DeQD6jPiPE/9JuFzLfuhIX/vFYUokjcTpvqRx9sssIcZ1ls
         0D9faQcNwG+q0CYHsiyiFUUSRyG6EKNmqSWN+1ifTOUlQvx2yt2kJJjuY431p9hSXl
         YiW0HHB20b3zI+pv/8GadKriA89Sb1qymnaYa1OI=
Date:   Fri, 14 Jan 2022 14:09:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        liuting.0x7c00@bytedance.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 119/146] mm: make some vars and functions static
 or __init
Message-ID: <20220114220928.xzpniNG1e%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ting Liu <liuting.0x7c00@bytedance.com>
Subject: mm: make some vars and functions static or __init

"page_idle_ops" as a global var, but its scope of use within this
document.  So it should be static.

"page_ext_ops" is a var used in the kernel initial phase.  And other
functions are aslo used in the kernel initial phase.  So they should be
__init or __initdata to reclaim memory.

Link: https://lkml.kernel.org/r/20211217095023.67293-1-liuting.0x7c00@bytedance.com
Signed-off-by: Ting Liu <liuting.0x7c00@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_idle.h |    1 -
 mm/page_ext.c             |    4 ++--
 mm/page_owner.c           |    4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

--- a/include/linux/page_idle.h~mm-make-some-vars-and-functions-static-or-__init
+++ a/include/linux/page_idle.h
@@ -13,7 +13,6 @@
  * If there is not enough space to store Idle and Young bits in page flags, use
  * page ext flags instead.
  */
-extern struct page_ext_operations page_idle_ops;
 
 static inline bool folio_test_young(struct folio *folio)
 {
--- a/mm/page_ext.c~mm-make-some-vars-and-functions-static-or-__init
+++ a/mm/page_ext.c
@@ -64,12 +64,12 @@ static bool need_page_idle(void)
 {
 	return true;
 }
-struct page_ext_operations page_idle_ops = {
+static struct page_ext_operations page_idle_ops __initdata = {
 	.need = need_page_idle,
 };
 #endif
 
-static struct page_ext_operations *page_ext_ops[] = {
+static struct page_ext_operations *page_ext_ops[] __initdata = {
 #ifdef CONFIG_PAGE_OWNER
 	&page_owner_ops,
 #endif
--- a/mm/page_owner.c~mm-make-some-vars-and-functions-static-or-__init
+++ a/mm/page_owner.c
@@ -46,7 +46,7 @@ static int __init early_page_owner_param
 }
 early_param("page_owner", early_page_owner_param);
 
-static bool need_page_owner(void)
+static __init bool need_page_owner(void)
 {
 	return page_owner_enabled;
 }
@@ -75,7 +75,7 @@ static noinline void register_early_stac
 	early_handle = create_dummy_stack();
 }
 
-static void init_page_owner(void)
+static __init void init_page_owner(void)
 {
 	if (!page_owner_enabled)
 		return;
_
