Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201FAEE49B0
	for <mm-commits@archiver.kernel.org>; Thu, 24 Aug 2023 23:26:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239412AbjHXX0H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238207AbjHXXZu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Aug 2023 19:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F80A8
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 16:25:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0826262FBC
        for <mm-commits@vger.kernel.org>; Thu, 24 Aug 2023 23:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60B1BC433C8;
        Thu, 24 Aug 2023 23:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692919547;
        bh=CQDsTFDpG60DruY9yU899Q4OlGhqp7vurn/v28pae0c=;
        h=Date:To:From:Subject:From;
        b=grlgPJK1IhILwNpXE/sB2EbWiTOMr95gPRAIImmKK1sDMJ7d5zyYjk+J1Mp6ptnp9
         cpwN1N2lbNsXLQ2apOYwQQ1s2mpIqky4Ks7rACE+dN+raWemST9KYd+ZYhw3SDtBtL
         W/06gmWX+xwDWKz0KnBdPrxeXcIAczzrELhvxpBQ=
Date:   Thu, 24 Aug 2023 16:25:46 -0700
To:     mm-commits@vger.kernel.org, gregkh@linuxfoundation.org,
        adobriyan@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] char-shrink-character-devices-devlist-array.patch removed from -mm tree
Message-Id: <20230824232547.60B1BC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: drivers/char/mem.c: shrink character device's devlist[] array
has been removed from the -mm tree.  Its filename was
     char-shrink-character-devices-devlist-array.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: drivers/char/mem.c: shrink character device's devlist[] array
Date: Mon, 21 Aug 2023 17:54:05 +0300

Merge padding, shrinking "struct memdev" from 32 bytes to 24 bytes
on 64-bit.

Link: https://lkml.kernel.org/r/fe4d62ab-2427-4635-b9f4-467853fb63e3@p183
Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/char/mem.c~char-shrink-character-devices-devlist-array
+++ a/drivers/char/mem.c
@@ -692,23 +692,23 @@ static const struct file_operations full
 
 static const struct memdev {
 	const char *name;
-	umode_t mode;
 	const struct file_operations *fops;
 	fmode_t fmode;
+	umode_t mode;
 } devlist[] = {
 #ifdef CONFIG_DEVMEM
-	 [DEVMEM_MINOR] = { "mem", 0, &mem_fops, FMODE_UNSIGNED_OFFSET },
+	[DEVMEM_MINOR] = { "mem", &mem_fops, FMODE_UNSIGNED_OFFSET, 0 },
 #endif
-	 [3] = { "null", 0666, &null_fops, FMODE_NOWAIT },
+	[3] = { "null", &null_fops, FMODE_NOWAIT, 0666 },
 #ifdef CONFIG_DEVPORT
-	 [4] = { "port", 0, &port_fops, 0 },
+	[4] = { "port", &port_fops, 0, 0 },
 #endif
-	 [5] = { "zero", 0666, &zero_fops, FMODE_NOWAIT },
-	 [7] = { "full", 0666, &full_fops, 0 },
-	 [8] = { "random", 0666, &random_fops, FMODE_NOWAIT },
-	 [9] = { "urandom", 0666, &urandom_fops, FMODE_NOWAIT },
+	[5] = { "zero", &zero_fops, FMODE_NOWAIT, 0666 },
+	[7] = { "full", &full_fops, 0, 0666 },
+	[8] = { "random", &random_fops, FMODE_NOWAIT, 0666 },
+	[9] = { "urandom", &urandom_fops, FMODE_NOWAIT, 0666 },
 #ifdef CONFIG_PRINTK
-	[11] = { "kmsg", 0644, &kmsg_fops, 0 },
+	[11] = { "kmsg", &kmsg_fops, 0, 0644 },
 #endif
 };
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are


