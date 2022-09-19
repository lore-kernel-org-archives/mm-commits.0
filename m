Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3FEECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 19 Sep 2022 21:14:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiISVOw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Sep 2022 17:14:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiISVOv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Sep 2022 17:14:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FA313D32
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 14:14:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7E05FCE12FF
        for <mm-commits@vger.kernel.org>; Mon, 19 Sep 2022 21:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB0BC433C1;
        Mon, 19 Sep 2022 21:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663622086;
        bh=JUR2AIXfXJowzbs1Z/oMphbq0ftIWxcxfbrardR6m3I=;
        h=Date:To:From:Subject:From;
        b=JBzEgSokZAU7MGvjKsCqHg93G7RmBGWzNO6kFpAWMmpCovHfB/AS4uTzu9wCndpbo
         vSP/laAKMDXqVb/mxl9hv+id6+C+tEPBafnfFyKnI5G8g5PyaV8U1cpuGkc5B3A9J9
         Vnf5kqIDugfKAPh1g0cLGxGb8D1YPb49uxF8q8ck=
Date:   Mon, 19 Sep 2022 14:14:37 -0700
To:     mm-commits@vger.kernel.org, linux@armlinux.org.uk, arnd@arndb.de,
        ardb@kernel.org, lukas.bulwahn@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-drop-entry-to-removed-file-in-arm-riscpc-architecture.patch added to mm-hotfixes-unstable branch
Message-Id: <20220919211445.EDB0BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: drop entry to removed file in ARM/RISCPC ARCHITECTURE
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-drop-entry-to-removed-file-in-arm-riscpc-architecture.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-drop-entry-to-removed-file-in-arm-riscpc-architecture.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

maintainers-drop-entry-to-removed-file-in-arm-riscpc-architecture.patch
proc-make-config-proc_children-depend-on-proc_fs.patch

