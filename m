Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB056C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05F0520897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816436;
	bh=ayeeIzIGJjnBy9Q8Fn5YVuP3M0trEPEoA5t423PX3is=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=wT2ohqKXOyNEyCbir6TjOpAKj16gBYIR9aTN9O6RMyzG3Oupc4sbPMfMIvj5HxV1z
	 XRocofkyVdbtXQRwmbJYy0LFEMgHixqQd/CwyGWar+GH7rO2KJ7muTs0n4NZ6UJl65
	 3iVnr2OO8KYCLb8YL9CZzYB+nbSMZJDtnIYKPUi4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404344AbgJPCrP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:34868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404339AbgJPCrP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:47:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 746FA20B1F;
        Fri, 16 Oct 2020 02:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816433;
        bh=ayeeIzIGJjnBy9Q8Fn5YVuP3M0trEPEoA5t423PX3is=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0spxcJEQDwnhAJzAZu/6AZvEWYqHffTr9YEcyx644sBTfW2NzhIA3X04M1L0H7zIl
         5ZS0PsaYCQMSEr8S7qyG7SHPRe6CmEJiELNCmCqsS5TUZPyLbM1tC9Vn1dsLA+Tpcv
         L5o/HUNyGNzfOl/VBv80DGu3DCoFrOlC3ioPTakc=
Date:   Thu, 15 Oct 2020 19:47:13 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hch@lst.de, jlbec@evilplan.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 095/156] fs: configfs: delete repeated words in
 comments
Message-ID: <20201016024713.VhwK7GQC6%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: fs: configfs: delete repeated words in comments

Drop duplicated words {the, that} in comments.

Link: https://lkml.kernel.org/r/20200811021826.25032-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/dir.c  |    2 +-
 fs/configfs/file.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/configfs/dir.c~fs-configfs-delete-repeated-words-in-comments
+++ a/fs/configfs/dir.c
@@ -1168,7 +1168,7 @@ EXPORT_SYMBOL(configfs_depend_item);
 
 /*
  * Release the dependent linkage.  This is much simpler than
- * configfs_depend_item() because we know that that the client driver is
+ * configfs_depend_item() because we know that the client driver is
  * pinned, thus the subsystem is pinned, and therefore configfs is pinned.
  */
 void configfs_undepend_item(struct config_item *target)
--- a/fs/configfs/file.c~fs-configfs-delete-repeated-words-in-comments
+++ a/fs/configfs/file.c
@@ -267,7 +267,7 @@ flush_write_buffer(struct file *file, st
  *	There is no easy way for us to know if userspace is only doing a partial
  *	write, so we don't support them. We expect the entire buffer to come
  *	on the first write.
- *	Hint: if you're writing a value, first read the file, modify only the
+ *	Hint: if you're writing a value, first read the file, modify only
  *	the value you're changing, then write entire buffer back.
  */
 
_
