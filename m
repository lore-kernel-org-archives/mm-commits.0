Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415FDC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2580F6137C
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 21:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhJTVn5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:43:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231297AbhJTVn4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 17:43:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B29A56135F;
        Wed, 20 Oct 2021 21:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634766101;
        bh=pl5jDblQNyG1US1aCuqWT/4RAdQXk4pAVL+k1m8cwco=;
        h=Date:From:To:Subject:From;
        b=aiCKgljuV6mlTCKcN0d5jipuTH6lYd98xidqHaZyFGMK8T9y4vFHLLxgUoeF/E3d9
         avsICvfnvNPR/wZYKSMnTN1FTj0L0oO7VM5gZSd4p4hEr/Ewo6wlVbEtI5ThFWD1k8
         pqz3R2K+Qn8ECuVf9RV7BW0yCtGRpalVY1sxyzm8=
Date:   Wed, 20 Oct 2021 14:41:41 -0700
From:   akpm@linux-foundation.org
To:     caoyixuan2019@email.szu.edu.cn, mm-commits@vger.kernel.org
Subject:  +
 mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions.patch
 added to -mm tree
Message-ID: <20211020214141.DU55S2SFD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: modify the type of argument "order" in some functions
has been added to the -mm tree.  Its filename is
     mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20211020125945.47792-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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

mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions.patch

