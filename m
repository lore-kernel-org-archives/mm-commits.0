Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A26AC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiANWDb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45246 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiANWDa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DCF661FD7
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE36C36AE9;
        Fri, 14 Jan 2022 22:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197809;
        bh=qUC9HiRVD4PD7AiKof2Jd3v5ns4F17ZMp58gBOozCsc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AM7fM0iLS3sQ/YsnmUtr11ynLSIwAbYA6QeKJTFLO1MRhtQfSznKprEtnRzTOypYg
         YBlG0ykQpUKUL7yJD/dzlnRk+QUL220uicKHV8yv6GDB60FsYxO9Muhg9ju0h9Igp/
         cRd7OvBswLZRedERJBYk1xmSKpsZ/0V1icXKfsew=
Date:   Fri, 14 Jan 2022 14:03:28 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     abaci@linux.alibaba.com, akpm@linux-foundation.org,
        anton@tuxera.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org,
        yang.lee@linux.alibaba.com
Subject:  [patch 012/146] fs/ntfs/attrib.c: fix one kernel-doc
 comment
Message-ID: <20220114220328.-PVS4dlKr%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
