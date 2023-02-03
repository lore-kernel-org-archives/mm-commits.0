Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F815C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbjBCGv3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231989AbjBCGvM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD78360BF
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99D1561DBB
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01618C4339B;
        Fri,  3 Feb 2023 06:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407063;
        bh=TqO1/STFmqcfXxqVEqu/KpJkJNEg8sGneGEX6lCJoa8=;
        h=Date:To:From:Subject:From;
        b=qCiT8fvcYAfjvBXWJjJrP5qYeR8FTC5zBsioFKsQ0nImNCTCi4VTHuSYn3atgr1Kd
         YXyXBLZ1wBRYAhZSUFdB6kmvKMUFpntvM6EmQj8CRgkMaC7NxjczPXIRZ3QFAxyC5u
         upkRyTaleBfdjqsbKy49UEhmDviAopqOR0QgtEF8=
Date:   Thu, 02 Feb 2023 22:51:02 -0800
To:     mm-commits@vger.kernel.org, hch@lst.de, gregkh@linuxfoundation.org,
        rdunlap@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] freevxfs-fix-kernel-doc-warnings.patch removed from -mm tree
Message-Id: <20230203065103.01618C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: freevxfs: fix kernel-doc warnings
has been removed from the -mm tree.  Its filename was
     freevxfs-fix-kernel-doc-warnings.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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


