Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B41C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5C726152A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhKKE3g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 23:29:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhKKE3g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 23:29:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1CDC6134F;
        Thu, 11 Nov 2021 04:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636604808;
        bh=sjlovAzlOfCz+ABHPAf6wxYINSQSL2aDMNrzETBBjLg=;
        h=Date:From:To:Subject:From;
        b=KPe6IB6lGd+niu2dZYo7xlZo7MXMGPbtz2uCnom5aY+SGSIjg5Jl4vJpu8LM4osbX
         mxcQI9+pKMSQfGo1G9SNbgy+UtFEicgapX+jc847BDqSGnU5bLiYh7dk2fk3ZjuzaP
         4Irs7mzaTDPUFpMiGy+vnI2W/gB7y8qu8ZT2SLy8=
Date:   Wed, 10 Nov 2021 20:26:47 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, caoyixuan2019@email.szu.edu.cn,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-page=5Fownerc-modify-the-type-of-argument-order-in-some?=
 =?US-ASCII?Q?-functions-fix.patch?= removed from -mm tree
Message-ID: <20211111042647.k-VunNX2c%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix
has been removed from the -mm tree.  Its filename was
     mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch

This patch was dropped because it was folded into mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix

update include/linux/page_owner.h

Cc: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/page_owner.h~mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix
+++ a/include/linux/page_owner.h
@@ -8,9 +8,9 @@
 extern struct static_key_false page_owner_inited;
 extern struct page_ext_operations page_owner_ops;
 
-extern void __reset_page_owner(struct page *page, unsigned int order);
+extern void __reset_page_owner(struct page *page, unsigned short order);
 extern void __set_page_owner(struct page *page,
-			unsigned int order, gfp_t gfp_mask);
+			unsigned short order, gfp_t gfp_mask);
 extern void __split_page_owner(struct page *page, unsigned int nr);
 extern void __folio_copy_owner(struct folio *newfolio, struct folio *old);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
@@ -18,14 +18,14 @@ extern void __dump_page_owner(const stru
 extern void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 					pg_data_t *pgdat, struct zone *zone);
 
-static inline void reset_page_owner(struct page *page, unsigned int order)
+static inline void reset_page_owner(struct page *page, unsigned short order)
 {
 	if (static_branch_unlikely(&page_owner_inited))
 		__reset_page_owner(page, order);
 }
 
 static inline void set_page_owner(struct page *page,
-			unsigned int order, gfp_t gfp_mask)
+			unsigned short order, gfp_t gfp_mask)
 {
 	if (static_branch_unlikely(&page_owner_inited))
 		__set_page_owner(page, order, gfp_mask);
@@ -52,7 +52,7 @@ static inline void dump_page_owner(const
 		__dump_page_owner(page);
 }
 #else
-static inline void reset_page_owner(struct page *page, unsigned int order)
+static inline void reset_page_owner(struct page *page, unsigned short order)
 {
 }
 static inline void set_page_owner(struct page *page,
@@ -60,7 +60,7 @@ static inline void set_page_owner(struct
 {
 }
 static inline void split_page_owner(struct page *page,
-			unsigned int order)
+			unsigned short order)
 {
 }
 static inline void folio_copy_owner(struct folio *newfolio, struct folio *folio)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions.patch
kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

