Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB65C433ED
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 111C361249
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 04:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbhEIENl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 May 2021 00:13:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229453AbhEIENl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 May 2021 00:13:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5A2B6141D;
        Sun,  9 May 2021 04:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620533558;
        bh=9jxmAterFcW+wi3oBwYIhn3Tins9mJ0oobOtW45CcJA=;
        h=Date:From:To:Subject:From;
        b=gSBbhaY7dr55TnYSfB9Ajuv1sUEj0rG+wPeLT3GxEoI+ISN4ufp3KwqJxpdKQ271n
         Trjy1ae//uIngX9hMAbvK8gAQmnSRUF6LPUcD5Gcbq4cKQW8mjARjsZR6jZ8FoGv+n
         5G80x+VphY3itJ4/LhB6AKfY0QfkzC/dufcO6T2Q=
Date:   Sat, 08 May 2021 21:12:38 -0700
From:   akpm@linux-foundation.org
To:     chenli@uniontech.com, david@redhat.com, geert@linux-m68k.org,
        gerg@linux-m68k.org, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + nommu-remove-__gfp_highmem-in-vmalloc-vzalloc.patch
 added to -mm tree
Message-ID: <20210509041238.ClQbB8Yb7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: nommu: remove __GFP_HIGHMEM in vmalloc/vzalloc
has been added to the -mm tree.  Its filename is
     nommu-remove-__gfp_highmem-in-vmalloc-vzalloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/nommu-remove-__gfp_highmem-in-vmalloc-vzalloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/nommu-remove-__gfp_highmem-in-vmalloc-vzalloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Li <chenli@uniontech.com>
Subject: nommu: remove __GFP_HIGHMEM in vmalloc/vzalloc

mm/nommu.c:
void *__vmalloc(unsigned long size, gfp_t gfp_mask)
{
	/*
	 *  You can't specify __GFP_HIGHMEM with kmalloc() since kmalloc()
	 * returns only a logical address.
	 */
	return kmalloc(size, (gfp_mask | __GFP_COMP) & ~__GFP_HIGHMEM);
}

nommu's __vmalloc just uses kmalloc internally and elimitates
__GFP_HIGHMEM, so it makes no sense to add __GFP_HIGHMEM for nommu's
vmalloc/vzalloc.

Link: https://lkml.kernel.org/r/875z00rnp8.wl-chenli@uniontech.com
Signed-off-by: Chen Li <chenli@uniontech.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/nommu.c~nommu-remove-__gfp_highmem-in-vmalloc-vzalloc
+++ a/mm/nommu.c
@@ -223,7 +223,7 @@ long vread(char *buf, char *addr, unsign
  */
 void *vmalloc(unsigned long size)
 {
-       return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM);
+       return __vmalloc(size, GFP_KERNEL);
 }
 EXPORT_SYMBOL(vmalloc);
 
@@ -241,7 +241,7 @@ EXPORT_SYMBOL(vmalloc);
  */
 void *vzalloc(unsigned long size)
 {
-	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO);
+	return __vmalloc(size, GFP_KERNEL | __GFP_ZERO);
 }
 EXPORT_SYMBOL(vzalloc);
 
_

Patches currently in -mm which might be from chenli@uniontech.com are

nommu-remove-__gfp_highmem-in-vmalloc-vzalloc.patch

