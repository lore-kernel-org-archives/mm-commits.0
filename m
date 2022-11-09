Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C678C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiKIBiw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiKIBid (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:38:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E483214D2A
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A21F3B81CD8
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E32C433D6;
        Wed,  9 Nov 2022 01:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957906;
        bh=fDsYL218P56p0kLadgUOQyhHFvLylS1R5otssL88KDA=;
        h=Date:To:From:Subject:From;
        b=qX6q2kXDLgOXbyHAY38cqYaJwma9bJQuqz683JxaBjFn79A+my11b9W346wDhzw0W
         nfkRVF8EjIXoNPezgBqDCjNGcPpEEOCaRdTrZD7z6d/PUtvb8szE6IMEoU+9LyB5rn
         EU6Jsc7MQK2rTIua8sxfotTjwPCw8lEX+cS+fuLQ=
Date:   Tue, 08 Nov 2022 17:38:25 -0800
To:     mm-commits@vger.kernel.org, hughd@google.com,
        thomas.weissschuh@amadeus.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tmpfs-ensure-o_largefile-with-generic_file_open.patch removed from -mm tree
Message-Id: <20221109013826.41E32C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tmpfs: ensure O_LARGEFILE with generic_file_open()
has been removed from the -mm tree.  Its filename was
     tmpfs-ensure-o_largefile-with-generic_file_open.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thomas Weißschuh <thomas.weissschuh@amadeus.com>
Subject: tmpfs: ensure O_LARGEFILE with generic_file_open()
Date: Wed, 28 Sep 2022 12:45:35 +0200

Without this check open() will open large files on tmpfs although
O_LARGEFILE was not specified.  This is inconsistent with other
filesystems.  Also it will later result in EOVERFLOW on stat() or EFBIG on
write().

Link: https://lore.kernel.org/lkml/76bedae6-22ea-4abc-8c06-b424ceb39217@t-8ch.de/
Link: https://lkml.kernel.org/r/20220928104535.61186-1-linux@weissschuh.net
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@amadeus.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/shmem.c~tmpfs-ensure-o_largefile-with-generic_file_open
+++ a/mm/shmem.c
@@ -3902,6 +3902,7 @@ EXPORT_SYMBOL(shmem_aops);
 
 static const struct file_operations shmem_file_operations = {
 	.mmap		= shmem_mmap,
+	.open		= generic_file_open,
 	.get_unmapped_area = shmem_get_unmapped_area,
 #ifdef CONFIG_TMPFS
 	.llseek		= shmem_file_llseek,
_

Patches currently in -mm which might be from thomas.weissschuh@amadeus.com are


