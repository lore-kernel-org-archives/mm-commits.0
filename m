Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DBDC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 01:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiAVBN0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Jan 2022 20:13:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbiAVBNZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jan 2022 20:13:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD46C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 17:13:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CF57B808D1
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 01:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA146C340E1;
        Sat, 22 Jan 2022 01:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642814002;
        bh=DcBYcZ4GmqvM7E5mNZGg3+J8w/I3t89jZiM84fQgROY=;
        h=Date:From:To:Subject:From;
        b=DZhjNFl7u+/LZwdF8D/Tcu4axxpSQSnFHlWgWfnzqvcqNPCjFd6Z78vc+tsGLdAxi
         l6ZzSGzcAdDwvG9AtSjL6xnkRhdeDZJEQ9Bi3EsSR6NZOheuRhVuMwrtvKdzeWQF90
         z6PlBJPROGiRkhzu5aZPyOaP+zdngyMN709j9vms=
Date:   Fri, 21 Jan 2022 17:13:22 -0800
From:   akpm@linux-foundation.org
To:     mcgrof@kernel.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  [folded-merged]
 firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3.patch removed
 from -mm tree
Message-ID: <20220122011322.i92baDSJ1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3
has been removed from the -mm tree.  Its filename was
     firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3.patch

This patch was dropped because it was folded into firmware_loader-move-firmware-sysctl-to-its-own-files.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3

akpm sucks

Link: https://lkml.kernel.org/r/20211201160626.401d828d@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_loader/fallback_table.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/firmware_loader/fallback_table.c~firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3
+++ a/drivers/base/firmware_loader/fallback_table.c
@@ -57,13 +57,13 @@ int register_firmware_config_sysctl(void
 		return -ENOMEM;
 	return 0;
 }
-EXPORT_SYMBOL_NS_GPL(register_firmware_config_sysctl);
+EXPORT_SYMBOL_NS_GPL(register_firmware_config_sysctl, FIRMWARE_LOADER_PRIVATE);
 
 void unregister_firmware_config_sysctl(void)
 {
 	unregister_sysctl_table(firmware_config_sysct_table_header);
 	firmware_config_sysct_table_header = NULL;
 }
-EXPORT_SYMBOL_NS_GPL(unregister_firmware_config_sysctl);
+EXPORT_SYMBOL_NS_GPL(unregister_firmware_config_sysctl, FIRMWARE_LOADER_PRIVATE);
 
 #endif /* CONFIG_SYSCTL */
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

firmware_loader-move-firmware-sysctl-to-its-own-files.patch

