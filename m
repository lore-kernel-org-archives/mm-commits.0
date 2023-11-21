Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2F9AC61D98
	for <mm-commits@archiver.kernel.org>; Tue, 21 Nov 2023 23:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234736AbjKUXBx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Nov 2023 18:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234727AbjKUXBw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2023 18:01:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E74F4
        for <mm-commits@vger.kernel.org>; Tue, 21 Nov 2023 15:01:49 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C525AC433C7;
        Tue, 21 Nov 2023 23:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700607708;
        bh=CYRUFbCPutrnt8Ap5pQ7INylaqlaBc40ljO2UkvN2AY=;
        h=Date:To:From:Subject:From;
        b=cKLlQtBp4aEIo6vlTmcbJiY3m5ZzWz1pJxSQ7ZSZ3VnB5+XcPH0ID51oJh2TcWeIq
         2SCeQ9oZS39q+saxmtz11W584haET9jIGwWCT5mI9je7DwXWvuiAB9f0WdiDr4nvph
         QUBHTo37+Ier7jJZI6IsEkFdEfAgCEsfvPoMhYeM=
Date:   Tue, 21 Nov 2023 15:01:48 -0800
To:     mm-commits@vger.kernel.org, vishal.moola@gmail.com,
        hca@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + pgtable-rename-ptdesc-_refcount-field-to-__page_refcount.patch added to mm-unstable branch
Message-Id: <20231121230148.C525AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: pgtable: rename ptdesc _refcount field to __page_refcount
has been added to the -mm mm-unstable branch.  Its filename is
     pgtable-rename-ptdesc-_refcount-field-to-__page_refcount.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/pgtable-rename-ptdesc-_refcount-field-to-__page_refcount.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: pgtable: rename ptdesc _refcount field to __page_refcount
Date: Tue, 21 Nov 2023 20:43:50 +0100

Rename ptdesc _refcount field to __page_refcount similar to the other
unused page fields.

Link: https://lkml.kernel.org/r/982bdc652ba79a606c3d01c905766e7e076b3315.1700594815.git.agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Suggested-by: Vishal Moola <vishal.moola@gmail.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm_types.h~pgtable-rename-ptdesc-_refcount-field-to-__page_refcount
+++ a/include/linux/mm_types.h
@@ -405,7 +405,7 @@ FOLIO_MATCH(compound_head, _head_2a);
  * @_pt_pad_2:        Padding to ensure proper alignment.
  * @ptl:              Lock for the page table.
  * @__page_type:      Same as page->page_type. Unused for page tables.
- * @_refcount:        Same as page refcount.
+ * @__page_refcount:  Same as page refcount.
  * @pt_memcg_data:    Memcg data. Tracked for page tables here.
  *
  * This struct overlays struct page for now. Do not modify without a good
@@ -438,7 +438,7 @@ struct ptdesc {
 #endif
 	};
 	unsigned int __page_type;
-	atomic_t _refcount;
+	atomic_t __page_refcount;
 #ifdef CONFIG_MEMCG
 	unsigned long pt_memcg_data;
 #endif
@@ -452,7 +452,7 @@ TABLE_MATCH(compound_head, _pt_pad_1);
 TABLE_MATCH(mapping, __page_mapping);
 TABLE_MATCH(rcu_head, pt_rcu_head);
 TABLE_MATCH(page_type, __page_type);
-TABLE_MATCH(_refcount, _refcount);
+TABLE_MATCH(_refcount, __page_refcount);
 #ifdef CONFIG_MEMCG
 TABLE_MATCH(memcg_data, pt_memcg_data);
 #endif
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are

pgtable-fix-s390-ptdesc-field-comments.patch
pgtable-rename-ptdesc-_refcount-field-to-__page_refcount.patch

