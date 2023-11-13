Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15888C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 13 Nov 2023 17:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjKMRbj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Nov 2023 12:31:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjKMRbi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Nov 2023 12:31:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C111A5
        for <mm-commits@vger.kernel.org>; Mon, 13 Nov 2023 09:31:35 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A200C433C8;
        Mon, 13 Nov 2023 17:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699896695;
        bh=h9GiXMk8a50z5oqTi3S/SRz4jNutpQ4amZTbw6d2ZxU=;
        h=Date:To:From:Subject:From;
        b=JLCufR/nr9MjzSC0VVHlo2LvxVe6cXMx7SuM5uHx55PLvCXJMt8hB4Y+OR59br3i+
         WyhMiNwkoADhw36770626xvIi0HkqJC/DhGcqSU7Q/tcGT2iU9Vxlqzqn9vcZd+5jg
         zetv0ZSIM/kJOAyGeQGfcA0Nexle2GyUb2UkQPNk=
Date:   Mon, 13 Nov 2023 09:31:34 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        p.raghav@samsung.com, mcgrof@kernel.org, lkp@intel.com,
        konishi.ryusuke@gmail.com, hare@suse.de, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] buffer-fix-grow_buffers-for-block-size-page_size-fix.patch removed from -mm tree
Message-Id: <20231113173135.2A200C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer-fix-grow_buffers-for-block-size-page_size-fix
has been removed from the -mm tree.  Its filename was
     buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: buffer-fix-grow_buffers-for-block-size-page_size-fix
Date: Mon Nov 13 09:08:21 AM PST 2023

hexagon wants __muloti4 so use a shift

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311121240.AN8GbAbe-lkp@intel.com/
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/buffer.c~buffer-fix-grow_buffers-for-block-size-page_size-fix
+++ a/fs/buffer.c
@@ -1099,7 +1099,7 @@ static bool grow_buffers(struct block_de
 	}
 
 	/* Create a folio with the proper size buffers */
-	return grow_dev_folio(bdev, block, pos / PAGE_SIZE, size, gfp);
+	return grow_dev_folio(bdev, block, pos >> PAGE_SHIFT, size, gfp);
 }
 
 static struct buffer_head *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-fix-for-negative-counter-nr_file_hugepages-fix.patch
mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-add-folio_zero_tail-and-use-it-in-ext4-fix.patch
mm-add-folio_fill_tail-and-use-it-in-iomap-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

