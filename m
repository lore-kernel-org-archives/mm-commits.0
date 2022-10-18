Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95ADDC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 18 Oct 2022 01:03:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiJRBDP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Oct 2022 21:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiJRBDO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2022 21:03:14 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8CC79694
        for <mm-commits@vger.kernel.org>; Mon, 17 Oct 2022 18:03:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id F37DECE180B
        for <mm-commits@vger.kernel.org>; Tue, 18 Oct 2022 01:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE7EC43470;
        Tue, 18 Oct 2022 01:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666054990;
        bh=cAws4Rrfpr6xp/cYKKLVk1JqJKzg9F4OQI0/+kCQmX8=;
        h=Date:To:From:Subject:From;
        b=GVzlFAgdp7UsFEj9vnYyeAfkq2mftcHymtHC5FpPz6iNle6x25L1IF+meDCrcE3Ia
         FvNENrfkvKe1tfjkDhTlhZOOfwSPIOZOWilhUzp5PxZIp+bJPIaitR7s547jFJxA8v
         vBC7cQ/Kr7/oN06qj8t/r9EZCJwkD4UnZskN1PLY=
Date:   Mon, 17 Oct 2022 18:03:09 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com,
        thomas.weissschuh@amadeus.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tmpfs-ensure-o_largefile-with-generic_file_open.patch added to mm-unstable branch
Message-Id: <20221018010310.1EE7EC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: ensure O_LARGEFILE with generic_file_open()
has been added to the -mm mm-unstable branch.  Its filename is
     tmpfs-ensure-o_largefile-with-generic_file_open.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tmpfs-ensure-o_largefile-with-generic_file_open.patch

This patch will later appear in the mm-unstable branch at
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
@@ -3885,6 +3885,7 @@ EXPORT_SYMBOL(shmem_aops);
 
 static const struct file_operations shmem_file_operations = {
 	.mmap		= shmem_mmap,
+	.open		= generic_file_open,
 	.get_unmapped_area = shmem_get_unmapped_area,
 #ifdef CONFIG_TMPFS
 	.llseek		= shmem_file_llseek,
_

Patches currently in -mm which might be from thomas.weissschuh@amadeus.com are

tmpfs-ensure-o_largefile-with-generic_file_open.patch

