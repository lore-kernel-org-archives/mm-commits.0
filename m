Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B10C77B7D
	for <mm-commits@archiver.kernel.org>; Thu, 18 May 2023 21:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjERVeF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 18 May 2023 17:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbjERVdu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 18 May 2023 17:33:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FBFD1BC7
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 14:33:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E203864A0B
        for <mm-commits@vger.kernel.org>; Thu, 18 May 2023 21:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47160C4339B;
        Thu, 18 May 2023 21:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684445594;
        bh=0s/AKsb7nMFU/FSI/pafiwTJFAR5i5C1cADrCcTQT4o=;
        h=Date:To:From:Subject:From;
        b=0sV1GCTGDKBGqxR7ty1Mf6Wrynx0chtFe6ccdFuna1jWJVll92UTLPdH6c6O0nTcV
         DpZdbH3aaj1Ai49WQhDg1m+Nhdegjxnnq0fYeiA/It3lFlB3WI6IV7pSHtYKoJVIVk
         p8GdtLjsJHpRcaH4FcZ8O8WteQ9KrmsVIX2kg0sY=
Date:   Thu, 18 May 2023 14:33:13 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-set-sysctl_lowmem_reserve_ratio-storage-class-specifier-to-static.patch added to mm-unstable branch
Message-Id: <20230518213314.47160C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: set sysctl_lowmem_reserve_ratio storage-class-specifier to static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-set-sysctl_lowmem_reserve_ratio-storage-class-specifier-to-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-set-sysctl_lowmem_reserve_ratio-storage-class-specifier-to-static.patch

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
From: Tom Rix <trix@redhat.com>
Subject: mm: page_alloc: set sysctl_lowmem_reserve_ratio storage-class-specifier to static
Date: Thu, 18 May 2023 10:11:19 -0400

smatch reports
mm/page_alloc.c:247:5: warning: symbol
  'sysctl_lowmem_reserve_ratio' was not declared. Should it be static?

This variable is only used in its defining file, so it should be static

Link: https://lkml.kernel.org/r/20230518141119.927074-1-trix@redhat.com
Signed-off-by: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-set-sysctl_lowmem_reserve_ratio-storage-class-specifier-to-static
+++ a/mm/page_alloc.c
@@ -244,7 +244,7 @@ static void __free_pages_ok(struct page
  * TBD: should special case ZONE_DMA32 machines here - in those we normally
  * don't need any ZONE_NORMAL reservation
  */
-int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES] = {
+static int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES] = {
 #ifdef CONFIG_ZONE_DMA
 	[ZONE_DMA] = 256,
 #endif
_

Patches currently in -mm which might be from trix@redhat.com are

mm-page_alloc-set-sysctl_lowmem_reserve_ratio-storage-class-specifier-to-static.patch

