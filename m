Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AA0BC433F5
	for <mm-commits@archiver.kernel.org>; Sat,  1 Oct 2022 01:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiJABrX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Sep 2022 21:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiJABrW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Sep 2022 21:47:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E097154448
        for <mm-commits@vger.kernel.org>; Fri, 30 Sep 2022 18:47:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92F82612A8
        for <mm-commits@vger.kernel.org>; Sat,  1 Oct 2022 01:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD015C433D6;
        Sat,  1 Oct 2022 01:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664588839;
        bh=apK8Gml1q6S6KKB5qpdRn2aThY35Cj8urcd2/8E1r60=;
        h=Date:To:From:Subject:From;
        b=VXCLsFnMFl08wfGNccO3KW0D5sJA6wwL+NRSoi0Dl4n2BI7ohUgnJhGSlFy33piWA
         gA3MrKnxDbwaMR6tNdIQQ6iJwXiRp5HddFsHC7EGH3z1LTMTrjuDQyHEsXFbJ+K46+
         FZiJxCf08kWVUKg+VMRAtNGHa8P3F/wL7Es5biXI=
Date:   Fri, 30 Sep 2022 18:47:18 -0700
To:     mm-commits@vger.kernel.org, linux@armlinux.org.uk, arnd@arndb.de,
        ardb@kernel.org, lukas.bulwahn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-drop-entry-to-removed-file-in-arm-riscpc-architecture.patch removed from -mm tree
Message-Id: <20221001014719.CD015C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: drop entry to removed file in ARM/RISCPC ARCHITECTURE
has been removed from the -mm tree.  Its filename was
     maintainers-drop-entry-to-removed-file-in-arm-riscpc-architecture.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: MAINTAINERS: drop entry to removed file in ARM/RISCPC ARCHITECTURE
Date: Mon, 19 Sep 2022 09:52:55 +0200

Commit c1fe8d054c0a ("ARM: riscpc: use GENERIC_IRQ_MULTI_HANDLER") removes
arch/arm/include/asm/hardware/entry-macro-iomd.S, but missed to adjust
MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken reference.

Drop the file entry to the removed file in ARM/RISCPC ARCHITECTURE.

Link: https://lkml.kernel.org/r/20220919075255.386-1-lukas.bulwahn@gmail.com
Fixes: c1fe8d054c0a ("ARM: riscpc: use GENERIC_IRQ_MULTI_HANDLER")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 -
 1 file changed, 1 deletion(-)

--- a/MAINTAINERS~maintainers-drop-entry-to-removed-file-in-arm-riscpc-architecture
+++ a/MAINTAINERS
@@ -2670,7 +2670,6 @@ M:	Russell King <linux@armlinux.org.uk>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 W:	http://www.armlinux.org.uk/
-F:	arch/arm/include/asm/hardware/entry-macro-iomd.S
 F:	arch/arm/include/asm/hardware/ioc.h
 F:	arch/arm/include/asm/hardware/iomd.h
 F:	arch/arm/include/asm/hardware/memc.h
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

proc-make-config-proc_children-depend-on-proc_fs.patch
ia64-update-config-files.patch

