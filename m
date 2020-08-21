Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0353AC433E1
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 00:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC48A207BB
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 00:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597970536;
	bh=OlGxIascbHIUZun41BFql3oNdYaebmCmIUt072WhhrM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=tNIc7412NY8889JfYqpsOkdzxkAF8joTTF6FJgoqucYdFQfgQN3wPUQKy5a3oEN3J
	 xOaPjlNqsjd0jaT2PVt8Oxt0Llf9sNqPTAVc4trPheVzYZ5wlZoLdIOorueXGIaNka
	 LNZdHn64ye7+scWd73O4ulJLEvoWilSeF+pWZXK8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgHUAmP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Aug 2020 20:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbgHUAmM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Aug 2020 20:42:12 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF7522087D;
        Fri, 21 Aug 2020 00:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597970532;
        bh=OlGxIascbHIUZun41BFql3oNdYaebmCmIUt072WhhrM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oxLmkQuvJRdiZDxiY5OHxzBOiaY/Su417hN6czHfJjEPqJEkspjDGBrRcnHPoiBzm
         wcAPhwKEIQ9McnXR+47hCY2RAKurR4xe5IPp1brYlIdnb1KWhBVK1Zg27lWxezTtop
         cRyyYi/F0JjlltFPlqMwGiait+F/+miw1GOeFDn4=
Date:   Thu, 20 Aug 2020 17:42:11 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dhowells@redhat.com,
        gregkh@linuxfoundation.org, jannh@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 06/11] romfs: fix uninitialized memory leak in
 romfs_dev_read()
Message-ID: <20200821004211.g7aXs16ZQ%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jann Horn <jannh@google.com>
Subject: romfs: fix uninitialized memory leak in romfs_dev_read()

romfs has a superblock field that limits the size of the filesystem; data
beyond that limit is never accessed.

romfs_dev_read() fetches a caller-supplied number of bytes from the
backing device.  It returns 0 on success or an error code on failure;
therefore, its API can't represent short reads, it's all-or-nothing.

However, when romfs_dev_read() detects that the requested operation would
cross the filesystem size limit, it currently silently truncates the
requested number of bytes.  This e.g.  means that when the content of a
file with size 0x1000 starts one byte before the filesystem size limit,
->readpage() will only fill a single byte of the supplied page while
leaving the rest uninitialized, leaking that uninitialized memory to
userspace.

Fix it by returning an error code instead of truncating the read when the
requested read operation would go beyond the end of the filesystem.

Link: http://lkml.kernel.org/r/20200818013202.2246365-1-jannh@google.com
Fixes: da4458bda237 ("NOMMU: Make it possible for RomFS to use MTD devices directly")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/storage.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/romfs/storage.c~romfs-fix-uninitialized-memory-leak-in-romfs_dev_read
+++ a/fs/romfs/storage.c
@@ -217,10 +217,8 @@ int romfs_dev_read(struct super_block *s
 	size_t limit;
 
 	limit = romfs_maxsize(sb);
-	if (pos >= limit)
+	if (pos >= limit || buflen > limit - pos)
 		return -EIO;
-	if (buflen > limit - pos)
-		buflen = limit - pos;
 
 #ifdef CONFIG_ROMFS_ON_MTD
 	if (sb->s_mtd)
_
