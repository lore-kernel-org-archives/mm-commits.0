Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E53C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9DBF20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816602;
	bh=v31I0Hntz+xKGi3x0IKHUhPWMSVLSjvaw6fiwxhez+0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Mee1bWrSzPgsjjn1jpSsaLg0ST1zjoJiuFnwhVEm3QCjScSNXR4iIqrO0LNFpCvCv
	 S+FkVz2b6J5EHlL+YfMLIQIaznqOKpgXSv6AFCT4YFAwX5JgQJ2FH1flEYVJPRFFdM
	 elJpnEKSAqqg9Rs3tv3zHW768ii3j+gQkCCHG29o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404393AbgJPCuB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:50:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404125AbgJPCuB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:50:01 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A661E20E65;
        Fri, 16 Oct 2020 02:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816601;
        bh=v31I0Hntz+xKGi3x0IKHUhPWMSVLSjvaw6fiwxhez+0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ts9aYWMj8vXSb0+MZfIZks+vM4xMuNDKA6yfmRPchdVdj/hdlTFtIGDVX2UGfTM3E
         hoDLPy4bHXAZ0bgc1mmKmsCk4u9/OaQrCmzIyCX0Hbv2aJ4+xspDwJtj6pkBpxvBLH
         iKxbNg8oABZA0KN6iINzMT/9pgZ+TLS26+UIp/tA=
Date:   Thu, 15 Oct 2020 19:50:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 143/156] ramfs: fix nommu mmap with gaps in the
 page cache
Message-ID: <20201016025000.TP1DS3-C6%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>
Subject: ramfs: fix nommu mmap with gaps in the page cache

ramfs needs to check that pages are both physically contiguous and
contiguous in the file.  If the page cache happens to have, eg, page A for
index 0 of the file, no page for index 1, and page A+1 for index 2, then
an mmap of the first two pages of the file will succeed when it should
fail.

Link: https://lkml.kernel.org/r/20200914122239.GO6583@casper.infradead.org
Fixes: 642fb4d1f1dd ("[PATCH] NOMMU: Provide shared-writable mmap support on ramfs")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-nommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ramfs/file-nommu.c~ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache
+++ a/fs/ramfs/file-nommu.c
@@ -224,7 +224,7 @@ static unsigned long ramfs_nommu_get_unm
 	if (!pages)
 		goto out_free;
 
-	nr = find_get_pages(inode->i_mapping, &pgoff, lpages, pages);
+	nr = find_get_pages_contig(inode->i_mapping, pgoff, lpages, pages);
 	if (nr != lpages)
 		goto out_free_pages; /* leave if some pages were missing */
 
_
