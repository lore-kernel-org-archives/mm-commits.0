Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10A6CC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE4196124D
	for <mm-commits@archiver.kernel.org>; Tue,  9 Nov 2021 02:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbhKICft (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Nov 2021 21:35:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:50918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhKICfs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Nov 2021 21:35:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F0FD61208;
        Tue,  9 Nov 2021 02:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636425183;
        bh=Hrm6PBTWjWKTL2LZYccbj3PlHHOfIS7b80jYUVRL2CU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=baxk0sH2dcNJmFK9O97A6LoIEbsQ4N7icecwWl6wWebkfh00a+vcnZq02X5JvvPTU
         4HuFVCbR3ULsIWzuJeddUhr1RDhn7qcv7esP1db9jy7/EBYtW7mDA8qHr/J6Jh1CrA
         v59thQORZQnHJAaAKn2ZkHvTnCJlC3MQlUzTSyw0=
Date:   Mon, 08 Nov 2021 18:33:02 -0800
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
Subject:  [patch 31/87] MAINTAINERS: rectify entry for INTEL KEEM
 BAY DRM DRIVER
Message-ID: <20211109023302.yhbXL15TL%akpm@linux-foundation.org>
In-Reply-To: <20211108183057.809e428e841088b657a975ec@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: MAINTAINERS: rectify entry for INTEL KEEM BAY DRM DRIVER

Commit ed794057b052 ("drm/kmb: Build files for KeemBay Display driver")
refers to the non-existing file intel,kmb_display.yaml in
./Documentation/devicetree/bindings/display/.

Commit 5a76b1ed73b9 ("dt-bindings: display: Add support for Intel KeemBay
Display") originating from the same patch series however adds the file
intel,keembay-display.yaml in that directory instead.

So, refer to intel,keembay-display.yaml in the INTEL KEEM BAY DRM DRIVER
section instead.

Link: https://lkml.kernel.org/r/20211026141902.4865-4-lukas.bulwahn@gmail.com
Fixes: ed794057b052 ("drm/kmb: Build files for KeemBay Display driver")
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
Cc: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Cc: Yu Chen <chenyu56@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-rectify-entry-for-intel-keem-bay-drm-driver
+++ a/MAINTAINERS
@@ -9530,7 +9530,7 @@ INTEL KEEM BAY DRM DRIVER
 M:	Anitha Chrisanthus <anitha.chrisanthus@intel.com>
 M:	Edmund Dea <edmund.j.dea@intel.com>
 S:	Maintained
-F:	Documentation/devicetree/bindings/display/intel,kmb_display.yaml
+F:	Documentation/devicetree/bindings/display/intel,keembay-display.yaml
 F:	drivers/gpu/drm/kmb/
 
 INTEL KEEM BAY OCS AES/SM4 CRYPTO DRIVER
_
