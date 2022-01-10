Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBFAC433F5
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jan 2022 22:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240011AbiAJWBv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jan 2022 17:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbiAJWBu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jan 2022 17:01:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E957C06173F
        for <mm-commits@vger.kernel.org>; Mon, 10 Jan 2022 14:01:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35068B81809
        for <mm-commits@vger.kernel.org>; Mon, 10 Jan 2022 22:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71CBC36AE9;
        Mon, 10 Jan 2022 22:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641852107;
        bh=7szPeFqfpN7TxKh8cdgwkuZ93hBYbz3wm18ha6ygGAA=;
        h=Date:From:To:Subject:From;
        b=n2mJp+v3NSyeWkn0ZVJ2kPE648Ns/PxeaUOwyrJEELQ0lYUiKPTEgFjb7LKRyncHM
         crf0MlNDyONhlFEdm2YUMz/LTITNd1/XFhaFijq/Wfru7mND6sAWwPFpj3WfxyQbI9
         cIZ6cOCYDhN/0D/Dphlg0rSgeZ5dVtr0fvcqOPKI=
Date:   Mon, 10 Jan 2022 14:01:47 -0800
From:   akpm@linux-foundation.org
To:     abaci@linux.alibaba.com, anton@tuxera.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        yang.lee@linux.alibaba.com
Subject:  + ntfs-fix-one-kernel-doc-comment.patch added to -mm tree
Message-ID: <20220110220147._LWvmz3Gf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/ntfs/attrib.c: fix one kernel-doc comment
has been added to the -mm tree.  Its filename is
     ntfs-fix-one-kernel-doc-comment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ntfs-fix-one-kernel-doc-comment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ntfs-fix-one-kernel-doc-comment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ntfs-fix-one-kernel-doc-comment.patch

