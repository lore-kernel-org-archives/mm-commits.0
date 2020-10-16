Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4C7C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD50620657
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881549;
	bh=KKWuX46IQLVjqZx9BsCtBfufGqe87AP5C+QDXisT63Y=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=QJZQn2DLs4Q8PWLI/32M8jl0rgRmTYGhFtCx9x8A/fahOCBsEWcr0aNmH4+1/Erd1
	 twd8Vi5ZquW/LL1LILLJF96MlWbua3nHpGP0rxldraB9eKC2veW9DgSJ0yoDTb2KhM
	 GnHseH28EorVMq+vl/eYi4PuMJSO1NRPzlZvx7JM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408723AbgJPUw3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408456AbgJPUw3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:52:29 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 944332064B;
        Fri, 16 Oct 2020 20:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881548;
        bh=KKWuX46IQLVjqZx9BsCtBfufGqe87AP5C+QDXisT63Y=;
        h=Date:From:To:Subject:From;
        b=QLtcdXQ+svFI5eJjxAvNrlhEScVfI/BclDzhMO/n6ILNYtZDKIPtQu7CiCi2+8Fu4
         FXrx2LryCKYrRjwo2nE1z/BEMuiNrqEwpVC6ciRE74Crct3VehchwVhMkDrfeRHlW0
         RG1IXxNso0+1fzkyIrXhvvvCfi0jOW+EQOnvZyag=
Date:   Fri, 16 Oct 2020 13:52:28 -0700
From:   akpm@linux-foundation.org
To:     hch@lst.de, jlbec@evilplan.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  [merged]
 fs-configfs-delete-repeated-words-in-comments.patch removed from -mm tree
Message-ID: <20201016205228.C5ye8V6tK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: configfs: delete repeated words in comments
has been removed from the -mm tree.  Its filename was
     fs-configfs-delete-repeated-words-in-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are


