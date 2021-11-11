Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E3F0C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0759C61361
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbhKKCyy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:54:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234548AbhKKCyy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:54:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 892096135E;
        Thu, 11 Nov 2021 02:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599126;
        bh=6N37ZNQ0n/EahVvlO2FyvrIKaVDhZys8jU56R49jRP0=;
        h=Date:From:To:Subject:From;
        b=e9SFTFnk1QLEguEkf5kEcAoRZCHj4vDG5tATBE6KStel8JZR7ITLBLJWbVghY213H
         hmm/rtjCiDkxFNaBM/Wer8tc4OQgMh0u+Dg7rVvFFobl6IYv2NE7vsE61NnIwOmznk
         Ez3Gy23Gj9AbcFllbLBV5lBHYhV9v0VEgZ0QsZrk=
Date:   Wed, 10 Nov 2021 18:52:05 -0800
From:   akpm@linux-foundation.org
To:     anitha.chrisanthus@intel.com, chenyu56@huawei.com,
        edmund.j.dea@intel.com, gregkh@linuxfoundation.org,
        joe@perches.com, john.stultz@linaro.org, lukas.bulwahn@gmail.com,
        mchehab+huawei@kernel.org, mm-commits@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, punit1.agrawal@toshiba.co.jp,
        ralf.ramsauer@oth-regensburg.de, robh+dt@kernel.org,
        sam@ravnborg.org, wilken.gottwalt@posteo.net
Subject:  [merged]
 maintainers-rectify-entry-for-allwinner-hardware-spinlock-support.patch
 removed from -mm tree
Message-ID: <20211111025205.sbjgLzEQx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: rectify entry for ALLWINNER HARDWARE SPINLOCK SUPPORT
has been removed from the -mm tree.  Its filename was
     maintainers-rectify-entry-for-allwinner-hardware-spinlock-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: MAINTAINERS: rectify entry for ALLWINNER HARDWARE SPINLOCK SUPPORT

Commit f9e784dcb63f ("dt-bindings: hwlock: add sun6i_hwspinlock") adds
Documentation/devicetree/bindings/hwlock/allwinner,sun6i-a31-hwspinlock.yaml,
but the related commit 3c881e05c814 ("hwspinlock: add sun6i hardware
spinlock support") adds a file reference to
allwinner,sun6i-hwspinlock.yaml instead.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains:

  warning: no file matches  F:  Documentation/devicetree/bindings/hwlock/allwinner,sun6i-hwspinlock.yaml

Rectify this file reference in ALLWINNER HARDWARE SPINLOCK SUPPORT.

Link: https://lkml.kernel.org/r/20211026141902.4865-5-lukas.bulwahn@gmail.com
Reviewed-by: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Anitha Chrisanthus <anitha.chrisanthus@intel.com>
Cc: Edmund Dea <edmund.j.dea@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc: Punit Agrawal <punit1.agrawal@toshiba.co.jp>
Cc: Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Yu Chen <chenyu56@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-rectify-entry-for-allwinner-hardware-spinlock-support
+++ a/MAINTAINERS
@@ -761,7 +761,7 @@ F:	drivers/crypto/allwinner/
 ALLWINNER HARDWARE SPINLOCK SUPPORT
 M:	Wilken Gottwalt <wilken.gottwalt@posteo.net>
 S:	Maintained
-F:	Documentation/devicetree/bindings/hwlock/allwinner,sun6i-hwspinlock.yaml
+F:	Documentation/devicetree/bindings/hwlock/allwinner,sun6i-a31-hwspinlock.yaml
 F:	drivers/hwspinlock/sun6i_hwspinlock.c
 
 ALLWINNER THERMAL DRIVER
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are


