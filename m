Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5067C2D0A8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BDD12193E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601339505;
	bh=9+5y6hDQFI/HZ1AZ4TnvXAGI77bRYlI7jSB4rgelSn8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=S2p67FiT2C72jTJExBbBIX/9WyPXTQ135oYsBVgX2gbg8LDx9n1riyiDNkPmmtju4
	 A4Nk3k1IU8q8SBByGz5rGTYqUKKxZdH3BT/b688w1VGvJl4Z5gz6imSdVPSxW4YN62
	 1Vkj3leh8lUXsdztG4UyS2rya5duhdZvoAH4Afbk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgI2Abp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 20:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726379AbgI2Abo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 20:31:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A97432184D;
        Tue, 29 Sep 2020 00:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601339502;
        bh=9+5y6hDQFI/HZ1AZ4TnvXAGI77bRYlI7jSB4rgelSn8=;
        h=Date:From:To:Subject:From;
        b=MPnBWJqsldrRfuU3z/HV68zKlJ2BvXA+Mkhg4xvg+KwrlELvxus+8MVJOHVRjPxg/
         OzNmaSVLmkvxguYKOafNX1ytEUw9hN+Tb9QwzVJUYqjhWd0Bzu0Gd/yFMtczHWk66D
         AyJ04XaZRU6d1A6g5fzFJxJV8EwSmxegEZk//DK0=
Date:   Mon, 28 Sep 2020 17:31:42 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        sh_def@163.com
Subject:  + mm-vmallocc-fix-the-comment-of-find_vm_area.patch added
 to -mm tree
Message-ID: <20200929003142.ris1VDW5N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: fix the comment of find_vm_area
has been added to the -mm tree.  Its filename is
     mm-vmallocc-fix-the-comment-of-find_vm_area.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmallocc-fix-the-comment-of-find_vm_area.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmallocc-fix-the-comment-of-find_vm_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hui Su <sh_def@163.com>
Subject: mm/vmalloc.c: fix the comment of find_vm_area

Fix the comment of find_vm_area() and get_vm_area()

Link: https://lkml.kernel.org/r/20200927153034.GA199877@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmallocc-fix-the-comment-of-find_vm_area
+++ a/mm/vmalloc.c
@@ -2133,7 +2133,7 @@ struct vm_struct *get_vm_area_caller(uns
  * It is up to the caller to do all required locking to keep the returned
  * pointer valid.
  *
- * Return: pointer to the found area or %NULL on faulure
+ * Return: the area descriptor on success or %NULL on failure.
  */
 struct vm_struct *find_vm_area(const void *addr)
 {
@@ -2154,7 +2154,7 @@ struct vm_struct *find_vm_area(const voi
  * This function returns the found VM area, but using it is NOT safe
  * on SMP machines, except for its size or flags.
  *
- * Return: pointer to the found area or %NULL on faulure
+ * Return: the area descriptor on success or %NULL on failure.
  */
 struct vm_struct *remove_vm_area(const void *addr)
 {
_

Patches currently in -mm which might be from sh_def@163.com are

mmkmemleak-testc-move-kmemleak-testc-to-samples-dir.patch
mm-vmallocc-update-the-comment-in-__vmalloc_area_node.patch
mm-vmallocc-fix-the-comment-of-find_vm_area.patch
mm-vmscan-fix-comments-for-isolate_lru_page.patch
mm-fix-some-comments-in-page_allocc-and-mempolicyc.patch

