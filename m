Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C358EC433DF
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 20:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A52572083B
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 20:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597868061;
	bh=OI4QYrK7wLEbw+sPsLD74EWAvGjQ2p2fiBfkt6+SbHU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=v6dD597gXGQEfK2qcdNI1zhOOSYeu0mRcOP2TdLIa0/hG4qR1mnwTrY2XRmLSj9Zb
	 Vlhj+xN4t26GwpStz0z66H2WEPE/Ise5sKCW0XjqbY7O+HEhlhAGGPA7DcekGhC8Y9
	 CQ8pH7fzqb7Jo5zyevt+VoVgCycntFXlIZWJ0VLU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHSUOV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 16:14:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSUOU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 16:14:20 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D37FA207FF;
        Wed, 19 Aug 2020 20:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597868060;
        bh=OI4QYrK7wLEbw+sPsLD74EWAvGjQ2p2fiBfkt6+SbHU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=B2SKphUUT0ePvx/56hGCfxm/fBml5nmIpY+d3J8GIquvcY13PpxhVjlj0IIr8E9SM
         L55GkzaSXDE7MyjPm1cE1EBGDXHJOptJpAmZnopt7xVYgOo46Tm5HgCT6jcOhD7h9S
         Tn/TdC9sOpZx8cJGzOO5YsdfbdRFQSuKg+UO31VU=
Date:   Wed, 19 Aug 2020 13:14:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        richard.weiyang@linux.alibaba.com
Subject:  +
 mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch added
 to -mm tree
Message-ID: <20200819201419.8vudp9h50%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmap: leverage vma_rb_erase_ignore() to implement vma_rb_erase()
has been added to the -mm tree.  Its filename is
     mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@linux.alibaba.com>
Subject: mm/mmap: leverage vma_rb_erase_ignore() to implement vma_rb_erase()

These two functions share the same logic except ignore a different vma.

Let's reuse the code.

Link: https://lkml.kernel.org/r/20200809232057.23477-2-richard.weiyang@linux.alibaba.com
Signed-off-by: Wei Yang <richard.weiyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/mm/mmap.c~mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase
+++ a/mm/mmap.c
@@ -474,8 +474,12 @@ static __always_inline void vma_rb_erase
 {
 	/*
 	 * All rb_subtree_gap values must be consistent prior to erase,
-	 * with the possible exception of the "next" vma being erased if
-	 * next->vm_start was reduced.
+	 * with the possible exception of
+	 *
+	 * a. the "next" vma being erased if next->vm_start was reduced in
+	 *    __vma_adjust() -> __vma_unlink()
+	 * b. the vma being erased in detach_vmas_to_be_unmapped() ->
+	 *    vma_rb_erase()
 	 */
 	validate_mm_rb(root, ignore);
 
@@ -485,13 +489,7 @@ static __always_inline void vma_rb_erase
 static __always_inline void vma_rb_erase(struct vm_area_struct *vma,
 					 struct rb_root *root)
 {
-	/*
-	 * All rb_subtree_gap values must be consistent prior to erase,
-	 * with the possible exception of the vma being erased.
-	 */
-	validate_mm_rb(root, vma);
-
-	__vma_rb_erase(vma, root);
+	vma_rb_erase_ignore(vma, root, vma);
 }
 
 /*
_

Patches currently in -mm which might be from richard.weiyang@linux.alibaba.com are

mm-mmap-rename-__vma_unlink_common-to-__vma_unlink.patch
mm-mmap-leverage-vma_rb_erase_ignore-to-implement-vma_rb_erase.patch
mm-page_reporting-drop-stale-list-head-check-in-page_reporting_cycle.patch

