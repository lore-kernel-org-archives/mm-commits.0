Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12A2FC433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7EC321D81
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881694;
	bh=mnEWkWntKkGUIfkze0SVI4mYarkh2EvqzDpq9/7hZ0I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=vZWT+6XE/KBoh81oHVZzqKo2iQavr6xTSwGk6+M1vG5x0EoTmj23YFVok3i24u/is
	 ysP+mOBhQMHAYA8zgLFOw7b6G1Efm91C77BKJpWh0DjtT98ba5xe8VzsU76k44/RkF
	 bggAAkkoz/l7Cj6fH91dCCFrDA3i6+yOm+XKCHxM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409430AbgJPUyy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:54:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732596AbgJPUyy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:54:54 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CC7F2076C;
        Fri, 16 Oct 2020 20:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881693;
        bh=mnEWkWntKkGUIfkze0SVI4mYarkh2EvqzDpq9/7hZ0I=;
        h=Date:From:To:Subject:From;
        b=SCNNg341HJhvRLl6OBJeuvwlHoVk0xbJaVomWCw7e2dljtNn+ANBEmz3Sc7NfD50e
         hBmhYl2btfW4QQbvOv2QkgzheimEdYvzSYbPQuQrUTkZ+yHhUmZANJCD5z9jyWJzSG
         Flrlg3OQ39Qa5F930uQ9Gm+n3deXLJLPLg7TjZ+I=
Date:   Fri, 16 Oct 2020 13:54:53 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, raven@themaw.net, willy@infradead.org
Subject:  [merged] harden-autofs-ioctl-table.patch removed from -mm
 tree
Message-ID: <20201016205453.kTow3LWV3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: harden ioctl table
has been removed from the -mm tree.  Its filename was
     harden-autofs-ioctl-table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Matthew Wilcox <willy@infradead.org>
Subject: autofs: harden ioctl table

The table of ioctl functions should be marked const in order to put them
in read-only memory, and we should use array_index_nospec() to avoid
speculation disclosing the contents of kernel memory to userspace.

Link: https://lkml.kernel.org/r/20200818122203.GO17456@casper.infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/dev-ioctl.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/autofs/dev-ioctl.c~harden-autofs-ioctl-table
+++ a/fs/autofs/dev-ioctl.c
@@ -8,6 +8,7 @@
 #include <linux/compat.h>
 #include <linux/syscalls.h>
 #include <linux/magic.h>
+#include <linux/nospec.h>
 
 #include "autofs_i.h"
 
@@ -563,7 +564,7 @@ out:
 
 static ioctl_fn lookup_dev_ioctl(unsigned int cmd)
 {
-	static ioctl_fn _ioctls[] = {
+	static const ioctl_fn _ioctls[] = {
 		autofs_dev_ioctl_version,
 		autofs_dev_ioctl_protover,
 		autofs_dev_ioctl_protosubver,
@@ -581,7 +582,10 @@ static ioctl_fn lookup_dev_ioctl(unsigne
 	};
 	unsigned int idx = cmd_idx(cmd);
 
-	return (idx >= ARRAY_SIZE(_ioctls)) ? NULL : _ioctls[idx];
+	if (idx >= ARRAY_SIZE(_ioctls))
+		return NULL;
+	idx = array_index_nospec(idx, ARRAY_SIZE(_ioctls));
+	return _ioctls[idx];
 }
 
 /* ioctl dispatcher */
_

Patches currently in -mm which might be from willy@infradead.org are

mm-update-the-documentation-for-vfree.patch

