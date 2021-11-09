Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED876C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB28161381
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbhKIChr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:37:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:53230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236920AbhKIChq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:37:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 685A76134F;
        Tue,  9 Nov 2021 02:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425301;
        bh=yInGZq7FMd7w+J7mnV6k7zh9nk38h4vr+ErVtpuyYgU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=mWjq1IufO/bnx8Eg/B7lvJh1HQuJy1PCY8khOdmKQ4jFoUre5XYmHE6b3yDxtSz1l
         G3RI+xVlFf6Nif3B/bCx+NHCdjbJaFdDwk6iE7xmeIfj8rGnZ9g2YipzsDn5cYqLWM
         UJWFWC6bz/c33+SqlPaPPbshon2VLN4QdB/S6OWI=
Date:   Mon, 08 Nov 2021 18:35:01 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, konishi.ryusuke@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, wangqing@vivo.com
Subject:  [patch 67/87] nilfs2: remove filenames from file comments
Message-ID: <20211109023501.l-jWOkzza%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: remove filenames from file comments

Remove filenames that are not particularly useful in file comments, and
suppress checkpatch warnings "WARNING: It's generally not useful to have
the filename in the file".

Link: https://lkml.kernel.org/r/1635151862-11547-3-git-send-email-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Qing Wang <wangqing@vivo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/alloc.c     |    2 +-
 fs/nilfs2/alloc.h     |    2 +-
 fs/nilfs2/bmap.c      |    2 +-
 fs/nilfs2/bmap.h      |    2 +-
 fs/nilfs2/btnode.c    |    2 +-
 fs/nilfs2/btnode.h    |    2 +-
 fs/nilfs2/btree.c     |    2 +-
 fs/nilfs2/btree.h     |    2 +-
 fs/nilfs2/cpfile.c    |    2 +-
 fs/nilfs2/cpfile.h    |    2 +-
 fs/nilfs2/dat.c       |    2 +-
 fs/nilfs2/dat.h       |    2 +-
 fs/nilfs2/dir.c       |    2 +-
 fs/nilfs2/direct.c    |    2 +-
 fs/nilfs2/direct.h    |    2 +-
 fs/nilfs2/file.c      |    2 +-
 fs/nilfs2/gcinode.c   |    2 +-
 fs/nilfs2/ifile.c     |    2 +-
 fs/nilfs2/ifile.h     |    2 +-
 fs/nilfs2/inode.c     |    2 +-
 fs/nilfs2/ioctl.c     |    2 +-
 fs/nilfs2/mdt.c       |    2 +-
 fs/nilfs2/mdt.h       |    2 +-
 fs/nilfs2/namei.c     |    2 +-
 fs/nilfs2/nilfs.h     |    2 +-
 fs/nilfs2/page.c      |    2 +-
 fs/nilfs2/page.h      |    2 +-
 fs/nilfs2/recovery.c  |    2 +-
 fs/nilfs2/segbuf.c    |    2 +-
 fs/nilfs2/segbuf.h    |    2 +-
 fs/nilfs2/segment.c   |    2 +-
 fs/nilfs2/segment.h   |    2 +-
 fs/nilfs2/sufile.c    |    2 +-
 fs/nilfs2/sufile.h    |    2 +-
 fs/nilfs2/super.c     |    2 +-
 fs/nilfs2/sysfs.c     |    2 +-
 fs/nilfs2/sysfs.h     |    2 +-
 fs/nilfs2/the_nilfs.c |    2 +-
 fs/nilfs2/the_nilfs.h |    2 +-
 39 files changed, 39 insertions(+), 39 deletions(-)

--- a/fs/nilfs2/alloc.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/alloc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * alloc.c - NILFS dat/inode allocator
+ * NILFS dat/inode allocator
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/alloc.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/alloc.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * alloc.h - persistent object (dat entry/disk inode) allocator/deallocator
+ * Persistent object (dat entry/disk inode) allocator/deallocator
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/bmap.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/bmap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * bmap.c - NILFS block mapping.
+ * NILFS block mapping.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/bmap.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/bmap.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * bmap.h - NILFS block mapping.
+ * NILFS block mapping.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/btnode.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/btnode.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * btnode.c - NILFS B-tree node cache
+ * NILFS B-tree node cache
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/btnode.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/btnode.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * btnode.h - NILFS B-tree node cache
+ * NILFS B-tree node cache
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/btree.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/btree.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * btree.c - NILFS B-tree.
+ * NILFS B-tree.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/btree.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/btree.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * btree.h - NILFS B-tree.
+ * NILFS B-tree.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/cpfile.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/cpfile.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * cpfile.c - NILFS checkpoint file.
+ * NILFS checkpoint file.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/cpfile.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/cpfile.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * cpfile.h - NILFS checkpoint file.
+ * NILFS checkpoint file.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/dat.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/dat.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * dat.c - NILFS disk address translation.
+ * NILFS disk address translation.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/dat.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/dat.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * dat.h - NILFS disk address translation.
+ * NILFS disk address translation.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/dir.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/dir.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * dir.c - NILFS directory entry operations
+ * NILFS directory entry operations
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/direct.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/direct.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * direct.c - NILFS direct block pointer.
+ * NILFS direct block pointer.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/direct.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/direct.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * direct.h - NILFS direct block pointer.
+ * NILFS direct block pointer.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/file.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/file.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * file.c - NILFS regular file handling primitives including fsync().
+ * NILFS regular file handling primitives including fsync().
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/gcinode.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/gcinode.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * gcinode.c - dummy inodes to buffer blocks for garbage collection
+ * Dummy inodes to buffer blocks for garbage collection
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/ifile.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/ifile.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * ifile.c - NILFS inode file
+ * NILFS inode file
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/ifile.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/ifile.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * ifile.h - NILFS inode file
+ * NILFS inode file
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/inode.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/inode.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * inode.c - NILFS inode operations.
+ * NILFS inode operations.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/ioctl.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/ioctl.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * ioctl.c - NILFS ioctl operations.
+ * NILFS ioctl operations.
  *
  * Copyright (C) 2007, 2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/mdt.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/mdt.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * mdt.c - meta data file for NILFS
+ * Meta data file for NILFS
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/mdt.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/mdt.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * mdt.h - NILFS meta data file prototype and definitions
+ * NILFS meta data file prototype and definitions
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/namei.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/namei.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * namei.c - NILFS pathname lookup operations.
+ * NILFS pathname lookup operations.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/nilfs.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/nilfs.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * nilfs.h - NILFS local header file.
+ * NILFS local header file.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/page.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/page.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * page.c - buffer/page management specific to NILFS
+ * Buffer/page management specific to NILFS
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/page.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/page.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * page.h - buffer/page management specific to NILFS
+ * Buffer/page management specific to NILFS
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/recovery.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/recovery.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * recovery.c - NILFS recovery logic
+ * NILFS recovery logic
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/segbuf.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/segbuf.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * segbuf.c - NILFS segment buffer
+ * NILFS segment buffer
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/segbuf.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/segbuf.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * segbuf.h - NILFS Segment buffer prototypes and definitions
+ * NILFS Segment buffer prototypes and definitions
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/segment.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/segment.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * segment.c - NILFS segment constructor.
+ * NILFS segment constructor.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/segment.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/segment.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * segment.h - NILFS Segment constructor prototypes and definitions
+ * NILFS Segment constructor prototypes and definitions
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/sufile.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/sufile.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * sufile.c - NILFS segment usage file.
+ * NILFS segment usage file.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/sufile.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/sufile.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * sufile.h - NILFS segment usage file.
+ * NILFS segment usage file.
  *
  * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/super.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/super.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * super.c - NILFS module and super block management.
+ * NILFS module and super block management.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/sysfs.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/sysfs.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * sysfs.c - sysfs support implementation.
+ * Sysfs support implementation.
  *
  * Copyright (C) 2005-2014 Nippon Telegraph and Telephone Corporation.
  * Copyright (C) 2014 HGST, Inc., a Western Digital Company.
--- a/fs/nilfs2/sysfs.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/sysfs.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * sysfs.h - sysfs support declarations.
+ * Sysfs support declarations.
  *
  * Copyright (C) 2005-2014 Nippon Telegraph and Telephone Corporation.
  * Copyright (C) 2014 HGST, Inc., a Western Digital Company.
--- a/fs/nilfs2/the_nilfs.c~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/the_nilfs.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * the_nilfs.c - the_nilfs shared structure.
+ * the_nilfs shared structure.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
--- a/fs/nilfs2/the_nilfs.h~nilfs2-remove-filenames-from-file-comments
+++ a/fs/nilfs2/the_nilfs.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
 /*
- * the_nilfs.h - the_nilfs shared structure.
+ * the_nilfs shared structure.
  *
  * Copyright (C) 2005-2008 Nippon Telegraph and Telephone Corporation.
  *
_
