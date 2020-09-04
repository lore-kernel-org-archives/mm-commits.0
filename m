Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F69C31E5C
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C79132067C
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 18:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599243040;
	bh=S0IRB9rZYnDXlpQiBEaZm9ksG6uFwoIYXMHvq5lOLDM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=di5naF15NxkoklQDx8Egu1ExcjrWEa3F2dtGZLkgFOGuRtYlRFaGxCLJGvDxAS5Zt
	 7hn2WDuCtaBDemRcks05OFOENDrENfXo4W0+wZQZrPFDFB8d8zAOHTMNVpJyb2rhOG
	 /vTeR45nmzq83nhW3sXSmzBPkIN4eJt5ajxy0bCo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgIDSKk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 14:10:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:48132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgIDSKj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 14:10:39 -0400
Received: from X1 (unknown [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9784220578;
        Fri,  4 Sep 2020 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599241830;
        bh=S0IRB9rZYnDXlpQiBEaZm9ksG6uFwoIYXMHvq5lOLDM=;
        h=Date:From:To:Subject:From;
        b=WT3nIJ8MuZJxYDZV8OfHhevcgyGSh62HiKHn4IhpkM5GKXUoGpbxiDDM3zucEQjyk
         TFB9/1thmHCWHIzOvgqkdGZQ8bv+R4xy44nz9ZfK7wiVeosJRz6S29TpDxgeD9hK0w
         vVDFF6/g8omtK8PSNnDyNBQ3EhQfL55B3ydMVE1Y=
Date:   Fri, 04 Sep 2020 10:50:26 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, rd.dunlap@gmail.com,
        gregkh@linuxfoundation.org, elver@google.com, changbin.du@gmail.com
Subject:  +
 kcsan-kconfig-move-to-menu-generic-kernel-debugging-instruments.patch added
 to -mm tree
Message-ID: <20200904175026.5MsZx%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kcsan: kconfig: move to menu 'Generic Kernel Debugging Instruments'
has been added to the -mm tree.  Its filename is
     kcsan-kconfig-move-to-menu-generic-kernel-debugging-instruments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kcsan-kconfig-move-to-menu-generic-kernel-debugging-instruments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kcsan-kconfig-move-to-menu-generic-kernel-debugging-instruments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Changbin Du <changbin.du@gmail.com>
Subject: kcsan: kconfig: move to menu 'Generic Kernel Debugging Instruments'

This moves the KCSAN kconfig items under menu 'Generic Kernel Debugging
Instruments' where UBSAN resides.

Link: https://lkml.kernel.org/r/20200904152224.5570-1-changbin.du@gmail.com
Signed-off-by: Changbin Du <changbin.du@gmail.com>
Cc: Randy Dunlap <rd.dunlap@gmail.com>
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

kcsan-kconfig-move-to-menu-generic-kernel-debugging-instruments.patch

