Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3450BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 22 Dec 2021 04:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242292AbhLVEQP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Dec 2021 23:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242289AbhLVEQN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Dec 2021 23:16:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7C5C061574
        for <mm-commits@vger.kernel.org>; Tue, 21 Dec 2021 20:16:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46AF5B817D0
        for <mm-commits@vger.kernel.org>; Wed, 22 Dec 2021 04:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1985C36AE5;
        Wed, 22 Dec 2021 04:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640146570;
        bh=ts3ikvRCgB4gTN2Hqy5IBzIyVw52mU9fWH/ycJPSSGE=;
        h=Date:From:To:Subject:From;
        b=1uO6MXc9y5sTM76do0FYwiDZQDuPo0Wxr1d3tMgNqREAs7YmXmyytMbe1HOeyz2Yq
         uvs5/HjO32MGstbO+QVIrifEaAbhlLc+XHwLDS450gkIDb0sDRR97XvNHiRRRpVIV9
         RahJyMXkbU+QOA2vsz/H5iTHBi6AADzxPB+Oilxc=
Date:   Tue, 21 Dec 2021 20:16:09 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, liuting.0x7c00@bytedance.com
Subject:  + mm-make-some-vars-and-functions-static-or-__init.patch
 added to -mm tree
Message-ID: <20211222041609.PZWdA%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make some vars and functions static or __init
has been added to the -mm tree.  Its filename is
     mm-make-some-vars-and-functions-static-or-__init.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-make-some-vars-and-functions-static-or-__init.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-make-some-vars-and-functions-static-or-__init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from liuting.0x7c00@bytedance.com are

mm-make-some-vars-and-functions-static-or-__init.patch

