Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35754C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347563AbiATVXN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:23:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34592 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237238AbiATVXK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:23:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71BCF60EFA
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA49C340E0;
        Thu, 20 Jan 2022 21:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713789;
        bh=qQv6HgeZ16oG8UQ8bYXlsgk4CyS8tOez6hhUV68BYqM=;
        h=Date:From:To:Subject:From;
        b=NnKzO1JKEFRCYqo9WHPPPHv8qcE/RDvwaWxKPEaosMn2tCsTLQJoz/D0UrvlX7H46
         siVDuHTSj2cXuGpA6NOHad84BI2LxeNQKJngQb/XFkIJ9Z8N9otmhqUvLa2xGxcX60
         Ws503J8l1+mCX7zBN7id57+//0z9q3C03tjsD0D0=
Date:   Thu, 20 Jan 2022 13:23:09 -0800
From:   akpm@linux-foundation.org
To:     abaci@linux.alibaba.com, anton@tuxera.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        yang.lee@linux.alibaba.com
Subject:  [merged] ntfs-fix-one-kernel-doc-comment.patch removed
 from -mm tree
Message-ID: <20220120212309.34Ou9N-OB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ntfs/attrib.c: fix one kernel-doc comment
has been removed from the -mm tree.  Its filename was
     ntfs-fix-one-kernel-doc-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: fs/ntfs/attrib.c: fix one kernel-doc comment

/**
 * attrib.c - NTFS attribute operations.  Part of the Linux-NTFS

The comments for the file should not be in kernel-doc format, which causes
it to be incorrectly identified for function ntfs_map_runlist_nolock(),
causing some warnings found by running scripts/kernel-doc.

fs/ntfs/attrib.c:25: warning: Incorrect use of kernel-doc format:  *
ntfs_map_runlist_nolock - map (a part of) a runlist of an ntfs inode
fs/ntfs/attrib.c:71: warning: Function parameter or member 'ni' not
described in 'ntfs_map_runlist_nolock'
fs/ntfs/attrib.c:71: warning: Function parameter or member 'vcn' not
described in 'ntfs_map_runlist_nolock'
fs/ntfs/attrib.c:71: warning: Function parameter or member 'ctx' not
described in 'ntfs_map_runlist_nolock'
fs/ntfs/attrib.c:71: warning: expecting prototype for attrib.c - NTFS
attribute operations.  Part of the Linux(). Prototype was for
ntfs_map_runlist_nolock() instead

Link: https://lkml.kernel.org/r/20220106015145.67067-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Anton Altaparmakov <anton@tuxera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/attrib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ntfs/attrib.c~ntfs-fix-one-kernel-doc-comment
+++ a/fs/ntfs/attrib.c
@@ -1,5 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
-/**
+/*
  * attrib.c - NTFS attribute operations.  Part of the Linux-NTFS project.
  *
  * Copyright (c) 2001-2012 Anton Altaparmakov and Tuxera Inc.
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are


