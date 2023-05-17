Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 027FAC7EE22
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 20:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjEQUBp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 16:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjEQUBn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 16:01:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CFF6A5F
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 13:01:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C0616340A
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 20:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5790C433EF;
        Wed, 17 May 2023 20:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684353701;
        bh=XZdEoWeesvM3GPtnTXkg9zAhDckgocQFdLoW1PXsKzI=;
        h=Date:To:From:Subject:From;
        b=LVcVf5g7ASZY/tsOuHf4hXVERAjVF5Ebfu/zAPh2Dw3loRJlGZErYOs3k1f+/8xJF
         cFuinvNM7So8uGxHT0ZAeVO74KQE+mfkhVN9DZp2Psd/Hd1KStDOVAqNPzTULkiIza
         +zvRW5ms581/G6TkkfCb9GH25uaeigr9vhSf7pj0=
Date:   Wed, 17 May 2023 13:01:40 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        phillip@squashfs.org.uk, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-dont-include-buffer_headh.patch added to mm-nonmm-unstable branch
Message-Id: <20230517200140.E5790C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: don't include buffer_head.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-dont-include-buffer_headh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-dont-include-buffer_headh.patch

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
From: Christoph Hellwig <hch@lst.de>
Subject: squashfs: don't include buffer_head.h
Date: Wed, 17 May 2023 09:16:22 +0200

Squashfs has stopped using buffers heads in 93e72b3c612adcaca1
("squashfs: migrate from ll_rw_block usage to BIO").

Link: https://lkml.kernel.org/r/20230517071622.245151-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c                     |    1 -
 fs/squashfs/decompressor.c              |    1 -
 fs/squashfs/decompressor_multi_percpu.c |    1 -
 3 files changed, 3 deletions(-)

--- a/fs/squashfs/block.c~squashfs-dont-include-buffer_headh
+++ a/fs/squashfs/block.c
@@ -18,7 +18,6 @@
 #include <linux/vfs.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/buffer_head.h>
 #include <linux/bio.h>
 
 #include "squashfs_fs.h"
--- a/fs/squashfs/decompressor.c~squashfs-dont-include-buffer_headh
+++ a/fs/squashfs/decompressor.c
@@ -11,7 +11,6 @@
 #include <linux/types.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/buffer_head.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
--- a/fs/squashfs/decompressor_multi_percpu.c~squashfs-dont-include-buffer_headh
+++ a/fs/squashfs/decompressor_multi_percpu.c
@@ -7,7 +7,6 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/percpu.h>
-#include <linux/buffer_head.h>
 #include <linux/local_lock.h>
 
 #include "squashfs_fs.h"
_

Patches currently in -mm which might be from hch@lst.de are

squashfs-dont-include-buffer_headh.patch

