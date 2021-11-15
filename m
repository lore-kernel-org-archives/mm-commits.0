Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6085CC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42600633A4
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 17:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhKORrz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 12:47:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:55530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237707AbhKORpr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 12:45:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E78163313;
        Mon, 15 Nov 2021 17:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636997368;
        bh=FWVNjoIRlX1ztrXv599mpcjF5wxTAU2PY2VQtOAAjPo=;
        h=Date:From:To:Subject:From;
        b=X+9EgNTXTBtVR0O/lkIECzzBNJddVupS5kEeI2wO4/LL4DWhZs16ytz7oMfR5qAr4
         gylRHEZpDb4iTvos4ZQOb4F/2vhk77X1WKQd6rSCt7wfBapMMG4OrRevC4iRZpBHh7
         vympMXw/KltTp4nUYFA0ya8Zgkhk5YMD09joc8U0=
Date:   Mon, 15 Nov 2021 09:29:27 -0800
From:   akpm@linux-foundation.org
To:     caoyixuan2019@email.szu.edu.cn, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions.patch
 removed from -mm tree
Message-ID: <20211115172927.cv0TAzxgE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: modify the type of argument "order" in some functions
has been removed from the -mm tree.  Its filename was
     mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: mm/page_owner.c: modify the type of argument "order" in some functions

The type of "order" in struct page_owner is unsigned short.
However, it is unsigned int in the following 3 functions:
__reset_page_owner
__set_page_owner_handle
__set_page_owner_handle

The type of "order" in argument list is unsigned int, which is
inconsistent.

[akpm@linux-foundation.org: update include/linux/page_owner.h]
Link: https://lkml.kernel.org/r/20211020125945.47792-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |   12 ++++++------
 mm/page_owner.c            |    6 +++---
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/include/linux/page_owner.h~mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions
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
--- a/mm/page_owner.c~mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions
+++ a/mm/page_owner.c
@@ -125,7 +125,7 @@ static noinline depot_stack_handle_t sav
 	return handle;
 }
 
-void __reset_page_owner(struct page *page, unsigned int order)
+void __reset_page_owner(struct page *page, unsigned short order)
 {
 	int i;
 	struct page_ext *page_ext;
@@ -149,7 +149,7 @@ void __reset_page_owner(struct page *pag
 
 static inline void __set_page_owner_handle(struct page_ext *page_ext,
 					depot_stack_handle_t handle,
-					unsigned int order, gfp_t gfp_mask)
+					unsigned short order, gfp_t gfp_mask)
 {
 	struct page_owner *page_owner;
 	int i;
@@ -169,7 +169,7 @@ static inline void __set_page_owner_hand
 	}
 }
 
-noinline void __set_page_owner(struct page *page, unsigned int order,
+noinline void __set_page_owner(struct page *page, unsigned short order,
 					gfp_t gfp_mask)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
_

Patches currently in -mm which might be from caoyixuan2019@email.szu.edu.cn are


