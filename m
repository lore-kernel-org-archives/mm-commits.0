Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066CCC433E1
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC14220772
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597794837;
	bh=HMXQ7BUHIzz0d76n5WjUS/Z4hprhgzF66AaG15LqGWk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=HQL+WVY/xuShXNJYxSU2k/33iUDnaJtxv2lz+/ytjpYJf3EwH4rypZKlGHSIq4FK5
	 qD4YJJNMgehWCsWl9DAIU5C0sTNb+iR/B5o1+kNnkJi4P69cUrBWqONweF2q5lbdtq
	 uJjP4oAFxtrVlKqVKOc9waAIX4CfzD4Dkc9RScks=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHRXx5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbgHRXx5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 19:53:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3D4A20709;
        Tue, 18 Aug 2020 23:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597794836;
        bh=HMXQ7BUHIzz0d76n5WjUS/Z4hprhgzF66AaG15LqGWk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=W6XIIqoT8B5giRS+bABOdOIANX6hpPOUvCHJgScjjyy+ymiZQF837lO6OT/EQufch
         poi9qHFeOVlAYQW0evMDhJH5MIG3RFZsfVPZ8Zydr49FfirXDlUUkuuDBm1cVWQtBH
         QJXGZYJP3ebI7ojuuc3WCfGWTACX11xoJEAiCg0U=
Date:   Tue, 18 Aug 2020 16:53:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     david@redhat.com, mm-commits@vger.kernel.org,
        yanfei.xu@windriver.com
Subject:  + mm-memory-fix-typo-in-__do_fault-comment.patch added to
 -mm tree
Message-ID: <20200818235356.YVOem3SjA%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory.c: fix typo in __do_fault() comment
has been added to the -mm tree.  Its filename is
     mm-memory-fix-typo-in-__do_fault-comment.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-fix-typo-in-__do_fault-comment.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-fix-typo-in-__do_fault-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yanfei Xu <yanfei.xu@windriver.com>
Subject: mm/memory.c: fix typo in __do_fault() comment

It's "pte_alloc_one", not "pte_alloc_pne". Let's fix that.

Link: http://lkml.kernel.org/r/20200818104339.5310-1-yanfei.xu@windriver.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-fix-typo-in-__do_fault-comment
+++ a/mm/memory.c
@@ -3446,7 +3446,7 @@ static vm_fault_t __do_fault(struct vm_f
 	 *				unlock_page(A)
 	 * lock_page(B)
 	 *				lock_page(B)
-	 * pte_alloc_pne
+	 * pte_alloc_one
 	 *   shrink_page_list
 	 *     wait_on_page_writeback(A)
 	 *				SetPageWriteback(B)
_

Patches currently in -mm which might be from yanfei.xu@windriver.com are

mm-memory-fix-typo-in-__do_fault-comment.patch

