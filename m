Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771FEC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EC8D206D5
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633224;
	bh=GPiAFhe+Y4jkasMU63OAYkRdfycIhzjjWmaCk25pJfk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=daBY4msAZAGxqlZNFOaYUwU+c6UIRML+xFwEwSimKMhn2oQZ4QmudS5OItmM4n3Wk
	 J8ta0uh8Wj2TucLWdjlUss4EumJ0w1It+zCwZYXQB6hFOy4fotLrnKzpKl0oWHJrYD
	 AybkzA0pjnwhfiGzhXpOTSuBOUzhCDJdf0mxrhUU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgJMXxn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388135AbgJMXxh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:53:37 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57AD2208B3;
        Tue, 13 Oct 2020 23:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633216;
        bh=GPiAFhe+Y4jkasMU63OAYkRdfycIhzjjWmaCk25pJfk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Y5NE7FNbWeTzYH9JrcrDs3r1Xz7UoA3jFIF4huB3gM3d3y3+Q6zZIYH79Pq2ZlTWm
         0sFA/lPwTTvENbCCJGzyqF2qgmbky27L/I92oMk5SoN/78xVhc/RRFcTBs/hS0ZQ01
         JXusyO+mKpD9A3/IhBQTsqunyfGqqBzE9fDe+g3U=
Date:   Tue, 13 Oct 2020 16:53:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, richard.weiyang@linux.alibaba.com,
        torvalds@linux-foundation.org
Subject:  [patch 096/181] mm/mmap: leverage vma_rb_erase_ignore()
 to implement vma_rb_erase()
Message-ID: <20201013235335.4k0Ky2eMR%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
