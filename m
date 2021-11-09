Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42DE7C433F5
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CE4B6124D
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbhKICfw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79D8F61242;
        Tue,  9 Nov 2021 02:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425187;
        bh=Tz3tD+rX0z8SFJANsXhmGYRLV6rJbymlNuPpqV6qH64=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wuMULk6iEwIPfFiGgvFN7PV0I8yldiWJU/wdDXlyrefuE36CwBJ2Qk/izq416KfxE
         tFUOVirsbJhkViUPWpJ46dAzED+dv2bCNkFIr+1cvcM9M71ckEh1V7Pa0vQP9agNkD
         zlymTgfrGF8cA/HMZHUpBM52aM5Rtuh7LflT/Fh0=
Date:   Mon, 08 Nov 2021 18:33:06 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anitha.chrisanthus@intel.com,
        chenyu56@huawei.com, edmund.j.dea@intel.com,
        gregkh@linuxfoundation.org, joe@perches.com,
        john.stultz@linaro.org, linux-mm@kvack.org,
        lukas.bulwahn@gmail.com, mchehab+huawei@kernel.org,
        mm-commits@vger.kernel.org, nobuhiro1.iwamatsu@toshiba.co.jp,
        punit1.agrawal@toshiba.co.jp, ralf.ramsauer@oth-regensburg.de,
        robh+dt@kernel.org, sam@ravnborg.org,
        torvalds@linux-foundation.org, wilken.gottwalt@posteo.net
Subject:  [patch 32/87] MAINTAINERS: rectify entry for ALLWINNER
 HARDWARE SPINLOCK SUPPORT
Message-ID: <20211109023306.wjuav-jfH%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
