Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96508C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EF3660E8B
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347925AbhIBV5t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347923AbhIBV5t (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:57:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 305996056B;
        Thu,  2 Sep 2021 21:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619810;
        bh=0WEpHpJtrMp2mQPHxZHpffhGxtMqBhTfmXF1/L0ayN0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ZhI898lZv2FkPCdoI6kG1ZdYbbFbqglRjHb7GYd8kK9qNE3mVTm7DCAgEV/+fO0aU
         TEmFv43vmudR0o43z61v6vG2kWUED9xJ6xZ+BYEGov2QRtN0fTh+TLFLCbmisp4Eqy
         CrqdO6UwubcpnfJnj5WK6X8I/vhr47jlVnYDTi3E=
Date:   Thu, 02 Sep 2021 14:56:49 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com,
        Liam.Howlett@Oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 128/212] remap_file_pages: Use vma_lookup()
 instead of find_vma()
Message-ID: <20210902215649.Oak625hS4%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: remap_file_pages: Use vma_lookup() instead of find_vma()

Using vma_lookup() verifies the start address is contained in the found vma.
This results in easier to read code.

Link: https://lkml.kernel.org/r/20210817135234.1550204-1-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/mmap.c~remap_file_pages-use-vma_lookup-instead-of-find_vma
+++ a/mm/mmap.c
@@ -2994,14 +2994,11 @@ SYSCALL_DEFINE5(remap_file_pages, unsign
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
-	vma = find_vma(mm, start);
+	vma = vma_lookup(mm, start);
 
 	if (!vma || !(vma->vm_flags & VM_SHARED))
 		goto out;
 
-	if (start < vma->vm_start)
-		goto out;
-
 	if (start + size > vma->vm_end) {
 		struct vm_area_struct *next;
 
_
