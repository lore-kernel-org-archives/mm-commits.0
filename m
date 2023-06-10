Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 777DFC7EE2F
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjFJApM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjFJApJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:45:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B761B3A9A
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:45:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 97D57651DD
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E68C433D2;
        Sat, 10 Jun 2023 00:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686357908;
        bh=uR8Vf3Iy6yezJ0kt6wpfg65bWfBFBDygRa7A25ep/kg=;
        h=Date:To:From:Subject:From;
        b=QZmg6xivAFCSW3TTiiqnHHDJGpjFrtP7kA0qE4BvZLljPMXhrMpKWnzqbz9C5zKBE
         wLVwy5oDxJYXvck63LsdGGap/cIFiY8aM/alV4cdKkB7b9q3LlER6kw/Qdxe23GiIM
         Ir505Tk/jsnqUJ8mB7I55YK4fZ5noZhFUgL8VXqA=
Date:   Fri, 09 Jun 2023 17:45:07 -0700
To:     mm-commits@vger.kernel.org, p.raghav@samsung.com,
        phillip@squashfs.org.uk, hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-dont-include-buffer_headh.patch removed from -mm tree
Message-Id: <20230610004507.F3E68C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: don't include buffer_head.h
has been removed from the -mm tree.  Its filename was
     squashfs-dont-include-buffer_headh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


