Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE21C54EBD
	for <mm-commits@archiver.kernel.org>; Tue, 10 Jan 2023 00:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbjAJA4s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Jan 2023 19:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235410AbjAJA4r (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2023 19:56:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843833FCAB
        for <mm-commits@vger.kernel.org>; Mon,  9 Jan 2023 16:56:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B9A1614AC
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 00:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44773C433F0;
        Tue, 10 Jan 2023 00:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673312205;
        bh=x44o/NEuMTYQ3dl8cMwywkLgJGTaxD/xdaL5rrPQ/EM=;
        h=Date:To:From:Subject:From;
        b=to4L2eqSN5hMbldszPtlwfCnVBafBXkFmfqO8DePYIrKgpPO4SlwOakJY1n/sJgwZ
         bdig7/EclUNOIR9x77MRwXnnHDIN+RTIije0TEuGQxHoY7u0l8z9KJ0KribLPE6nZl
         GAGLGc/TOSZk55n+2c5eC1lN2VMHTilnxrCuw9D8=
Date:   Mon, 09 Jan 2023 16:56:44 -0800
To:     mm-commits@vger.kernel.org, hch@infradead.org,
        gregkh@linuxfoundation.org, rdunlap@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + freevxfs-fix-kernel-doc-warnings.patch added to mm-nonmm-unstable branch
Message-Id: <20230110005645.44773C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: freevxfs: fix kernel-doc warnings
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     freevxfs-fix-kernel-doc-warnings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/freevxfs-fix-kernel-doc-warnings.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: freevxfs: fix kernel-doc warnings
Date: Sun, 8 Jan 2023 18:29:15 -0800

Fix multiple kernel-doc warnings in freevxfs:

fs/freevxfs/vxfs_subr.c:45: warning: Function parameter or member 'mapping' not described in 'vxfs_get_page'
fs/freevxfs/vxfs_subr.c:45: warning: Excess function parameter 'ip' description in 'vxfs_get_page'
2 warnings
fs/freevxfs/vxfs_subr.c:101: warning: expecting prototype for vxfs_get_block(). Prototype was for vxfs_getblk() instead
fs/freevxfs/vxfs_super.c:184: warning: expecting prototype for vxfs_read_super(). Prototype was for vxfs_fill_super() instead

Link: https://lkml.kernel.org/r/20230109022915.17504-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_subr.c  |    6 +++---
 fs/freevxfs/vxfs_super.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/freevxfs/vxfs_subr.c~freevxfs-fix-kernel-doc-warnings
+++ a/fs/freevxfs/vxfs_subr.c
@@ -31,7 +31,7 @@ vxfs_put_page(struct page *pp)
 
 /**
  * vxfs_get_page - read a page into memory.
- * @ip:		inode to read from
+ * @mapping:	mapping to read from
  * @n:		page number
  *
  * Description:
@@ -81,14 +81,14 @@ vxfs_bread(struct inode *ip, int block)
 }
 
 /**
- * vxfs_get_block - locate buffer for given inode,block tuple 
+ * vxfs_getblk - locate buffer for given inode,block tuple
  * @ip:		inode
  * @iblock:	logical block
  * @bp:		buffer skeleton
  * @create:	%TRUE if blocks may be newly allocated.
  *
  * Description:
- *   The vxfs_get_block function fills @bp with the right physical
+ *   The vxfs_getblk function fills @bp with the right physical
  *   block and device number to perform a lowlevel read/write on
  *   it.
  *
--- a/fs/freevxfs/vxfs_super.c~freevxfs-fix-kernel-doc-warnings
+++ a/fs/freevxfs/vxfs_super.c
@@ -165,7 +165,7 @@ static int vxfs_try_sb_magic(struct supe
 }
 
 /**
- * vxfs_read_super - read superblock into memory and initialize filesystem
+ * vxfs_fill_super - read superblock into memory and initialize filesystem
  * @sbp:		VFS superblock (to fill)
  * @dp:			fs private mount data
  * @silent:		do not complain loudly when sth is wrong
_

Patches currently in -mm which might be from rdunlap@infradead.org are

lib-win_minmax-use-notation-for-regular-comments.patch
freevxfs-fix-kernel-doc-warnings.patch

