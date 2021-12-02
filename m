Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5556AC433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Dec 2021 04:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355487AbhLBEm5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 1 Dec 2021 23:42:57 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42142 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355360AbhLBEmy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 1 Dec 2021 23:42:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 81B9BCE1DC7
        for <mm-commits@vger.kernel.org>; Thu,  2 Dec 2021 04:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2239C00446;
        Thu,  2 Dec 2021 04:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638419966;
        bh=cGM1zlK1x8+IojTTssbhJ0oL0NpK1bItIkz9cMG4i/4=;
        h=Date:From:To:Subject:From;
        b=xz9FVoeWeuyjTRHb1giB+JmQt3VPN6WLzfYBT/j5O6MRqePFYdqTzOR5VnQlrYkZv
         scnUd4KEh4iP2FAmNZxr25YYh5HeWBKirN8VXlAVW6X0aBz7+ijZoR5D2CufIdGlg0
         h1MX7J3vl2jfCcKThCsu5iL4BQrQS95Mr5srcvyI=
Date:   Wed, 01 Dec 2021 20:39:26 -0800
From:   akpm@linux-foundation.org
To:     mcgrof@kernel.org, mm-commits@vger.kernel.org, sfr@canb.auug.org.au
Subject:  +
 firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3.patch added to
 -mm tree
Message-ID: <20211202043926.Yal5diQ05%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3
has been added to the -mm tree.  Its filename is
     firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

firmware_loader-move-firmware-sysctl-to-its-own-files-fix-3.patch

