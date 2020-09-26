Return-Path: <SRS0=7eMQ=DD=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C6F2C4727E
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5654B221EB
	for <mm-commits@archiver.kernel.org>; Sat, 26 Sep 2020 01:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601085506;
	bh=INPQ+O5lewkVs3l1/aahQ81qvqEPkL0Rrx/WvrK149s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=NM7HW0O7ZgowUdp+XqRiPsvP9T9IBCt0IJByvC00J4DbqGPnd6tplQJz3NTb4R3sL
	 AUZVVjyJmU5k7rMboRmQazFU5z0hBFcFW4tM9DtJHRM/AKu3pOAZFPu7TJ7fwvNJeD
	 /BtbbHkDjzvhBKwk/pUqJeFQozFXQh38CDWP8PEI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbgIZB60 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Sep 2020 21:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:40756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729961AbgIZB6Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 25 Sep 2020 21:58:25 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6486520BED;
        Sat, 26 Sep 2020 01:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601085505;
        bh=INPQ+O5lewkVs3l1/aahQ81qvqEPkL0Rrx/WvrK149s=;
        h=Date:From:To:Subject:From;
        b=Oacnys7qX3r2uRZVjG4HGglfLztOyBZ7JCsy3QcWSCD8N62lb1jAxo+aivQR71meG
         DnZ+GaZBQ20S0E628OAras5Wts9Vk4Cnv8uA8aVpPxkbNpn+CWVVld0zz81R1A/75E
         ukRPPriei6Da6SlFW3JomrD6of7N7KEhzKvfE7yc=
Date:   Fri, 25 Sep 2020 18:58:25 -0700
From:   akpm@linux-foundation.org
To:     changbin.du@gmail.com, elver@google.com,
        gregkh@linuxfoundation.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org
Subject:  [merged]
 kcsan-kconfig-move-to-menu-generic-kernel-debugging-instruments.patch
 removed from -mm tree
Message-ID: <20200926015825.rL50GjVHL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcsan: kconfig: move to menu 'Generic Kernel Debugging Instruments'
has been removed from the -mm tree.  Its filename was
     kcsan-kconfig-move-to-menu-generic-kernel-debugging-instruments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Changbin Du <changbin.du@gmail.com>
Subject: kcsan: kconfig: move to menu 'Generic Kernel Debugging Instruments'

This moves the KCSAN kconfig items under menu 'Generic Kernel Debugging
Instruments' where UBSAN resides.

Link: https://lkml.kernel.org/r/20200904152224.5570-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/lib/Kconfig.debug~kcsan-kconfig-move-to-menu-generic-kernel-debugging-instruments
+++ a/lib/Kconfig.debug
@@ -520,8 +520,8 @@ config DEBUG_FS_ALLOW_NONE
 endchoice
 
 source "lib/Kconfig.kgdb"
-
 source "lib/Kconfig.ubsan"
+source "lib/Kconfig.kcsan"
 
 endmenu
 
@@ -1620,8 +1620,6 @@ config PROVIDE_OHCI1394_DMA_INIT
 
 source "samples/Kconfig"
 
-source "lib/Kconfig.kcsan"
-
 config ARCH_HAS_DEVMEM_IS_ALLOWED
 	bool
 
_

Patches currently in -mm which might be from changbin.du@gmail.com are


