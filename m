Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE7CC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:32:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A88C6103A
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 04:32:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhKKEfU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 23:35:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229699AbhKKEfT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 23:35:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51C3561052;
        Thu, 11 Nov 2021 04:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636605151;
        bh=RhTLhkXBUI90daJaOhsfezBzBaO0CCNwMSx9EtaULqg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=v97opWIveB+7ww0ilimk8hNMFUYOeV04nGkQ8+0D4yzNYvJaEoi+k95sEvOEAEeSq
         22mY5W2C8lfH4h0YgGAB4TraUtaTDCkwnEI5GkOvUcy0tA9ZMi7BCeM2z//8QY94qg
         RV2gZobi/xuIrv0/FQmEUhZ6iq0Hn/tU5idTMykI=
Date:   Wed, 10 Nov 2021 20:32:30 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, caoyixuan2019@email.szu.edu.cn,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 1/7] mm/page_owner.c: modify the type of argument
 "order" in some functions
Message-ID: <20211111043230.QinNUBtCp%akpm@linux-foundation.org>
In-Reply-To: <20211110203204.37de96048c3279ab2da758a5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
