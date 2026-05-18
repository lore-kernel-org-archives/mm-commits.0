Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B14A30BB8D
	for <mm-commits@vger.kernel.org>; Mon, 18 May 2026 22:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779145144; cv=none; b=ddinIHT7zI+wgM4JK6GblaYvCQHU85aodmp5hRuJDe8B4OJqN4QyWgXf7e937Sl/ZS35GUqo3gL75XEUQG0Cc0iu+Cv6kULFk0oM9/sRkuQq/C/+y4etWeVTWXh5w9en5NmhxEcfe2PuIBz8YUVO2i8REwwHfIgB/SPm94UA7Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779145144; c=relaxed/simple;
	bh=laOKMJo2tlzPNk9ShWE320pca8DRYaPFUoRql224ZAs=;
	h=Date:To:From:Subject:Message-Id; b=Rm74VKgpAecyk9T5J4VSfsSPnv8T6pRJqVMuCpRaSVDOOqLNZyfKJrQZ7V0ka8UUhsXDoKdC038bUUyWty3rKvaAfQDgJ3RWw/Xeq+8aSlsfcYNyvoO5o3ucnICOssJ8EYUUNJHnFcdWYzVaQ/JQqePeJFu2xfGA7j0BLDYOauw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BCVgAFlq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BCVgAFlq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2A7C2BCB7;
	Mon, 18 May 2026 22:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779145143;
	bh=laOKMJo2tlzPNk9ShWE320pca8DRYaPFUoRql224ZAs=;
	h=Date:To:From:Subject:From;
	b=BCVgAFlqqvhXjonJOvemIWgwZSUhBn2rW6wXGkA+n5wCGJc3rPSb2zfklifA/8/pR
	 3PTqoUmQKquQU5mI+6bcuUWTNjpz1lG1FWIeTG0d3FoCs733iP9M9UvGVV3ki1dDmX
	 9wc3TaD+K19aRiWSwYB3hWNiKKViYm14TKAakEhY=
Date: Mon, 18 May 2026 15:59:03 -0700
To: mm-commits@vger.kernel.org,ehristev@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-change-email-for-eugen-hristev.patch added to mm-hotfixes-unstable branch
Message-Id: <20260518225903.BC2A7C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS, mailmap: change email for Eugen Hristev
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-change-email-for-eugen-hristev.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-change-email-for-eugen-hristev.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Eugen Hristev <ehristev@kernel.org>
Subject: MAINTAINERS, mailmap: change email for Eugen Hristev
Date: Sat, 25 Apr 2026 16:06:48 +0300

Replace old bouncing emails with ehristev@kernel.org

Link: https://lore.kernel.org/20260425-eh-mailmap-v1-1-58788d401eef@kernel.org
Signed-off-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    5 +++--
 MAINTAINERS |   12 ++++++------
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/.mailmap~maintainers-mailmap-change-email-for-eugen-hristev
+++ a/.mailmap
@@ -263,8 +263,9 @@ Enric Balletbo i Serra <eballetbo@kernel
 Enric Balletbo i Serra <eballetbo@kernel.org> <eballetbo@iseebcn.com>
 Erik Kaneda <erik.kaneda@intel.com> <erik.schmauss@intel.com>
 Ethan Carter Edwards <ethan@ethancedwards.com> Ethan Edwards <ethancarteredwards@gmail.com>
-Eugen Hristev <eugen.hristev@linaro.org> <eugen.hristev@microchip.com>
-Eugen Hristev <eugen.hristev@linaro.org> <eugen.hristev@collabora.com>
+Eugen Hristev <ehristev@kernel.org> <eugen.hristev@microchip.com>
+Eugen Hristev <ehristev@kernel.org> <eugen.hristev@linaro.org>
+Eugen Hristev <ehristev@kernel.org> <eugen.hristev@collabora.com>
 Evgeniy Polyakov <johnpol@2ka.mipt.ru>
 Ezequiel Garcia <ezequiel@vanguardiasur.com.ar> <ezequiel@collabora.com>
 Faith Ekstrand <faith.ekstrand@collabora.com> <jason@jlekstrand.net>
--- a/MAINTAINERS~maintainers-mailmap-change-email-for-eugen-hristev
+++ a/MAINTAINERS
@@ -10826,7 +10826,7 @@ F:	include/linux/generic-radix-tree.h
 F:	lib/generic-radix-tree.c
 
 GENERIC RESISTIVE TOUCHSCREEN ADC DRIVER
-M:	Eugen Hristev <eugen.hristev@microchip.com>
+M:	Eugen Hristev <ehristev@kernel.org>
 L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/input/touchscreen/resistive-adc-touch.c
@@ -17336,7 +17336,7 @@ F:	Documentation/devicetree/bindings/sou
 F:	sound/soc/atmel
 
 MICROCHIP CSI2DC DRIVER
-M:	Eugen Hristev <eugen.hristev@microchip.com>
+M:	Eugen Hristev <ehristev@kernel.org>
 L:	linux-media@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/media/microchip,csi2dc.yaml
@@ -17363,7 +17363,7 @@ F:	drivers/i2c/busses/i2c-at91-*.c
 F:	drivers/i2c/busses/i2c-at91.h
 
 MICROCHIP ISC DRIVER
-M:	Eugen Hristev <eugen.hristev@microchip.com>
+M:	Eugen Hristev <ehristev@kernel.org>
 L:	linux-media@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/media/atmel,isc.yaml
@@ -17375,7 +17375,7 @@ F:	drivers/staging/media/deprecated/atme
 F:	include/linux/atmel-isc-media.h
 
 MICROCHIP ISI DRIVER
-M:	Eugen Hristev <eugen.hristev@microchip.com>
+M:	Eugen Hristev <ehristev@kernel.org>
 L:	linux-media@vger.kernel.org
 S:	Supported
 F:	drivers/media/platform/atmel/atmel-isi.c
@@ -17565,7 +17565,7 @@ F:	Documentation/devicetree/bindings/dis
 F:	drivers/gpu/drm/bridge/microchip-lvds.c
 
 MICROCHIP SAMA5D2-COMPATIBLE ADC DRIVER
-M:	Eugen Hristev <eugen.hristev@microchip.com>
+M:	Eugen Hristev <ehristev@kernel.org>
 L:	linux-iio@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/iio/adc/atmel,sama5d2-adc.yaml
@@ -24116,7 +24116,7 @@ F:	drivers/mmc/host/sdhci*
 
 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) MICROCHIP DRIVER
 M:	Aubin Constans <aubin.constans@microchip.com>
-R:	Eugen Hristev <eugen.hristev@collabora.com>
+R:	Eugen Hristev <ehristev@kernel.org>
 L:	linux-mmc@vger.kernel.org
 S:	Supported
 F:	drivers/mmc/host/sdhci-of-at91.c
_

Patches currently in -mm which might be from ehristev@kernel.org are

maintainers-mailmap-change-email-for-eugen-hristev.patch

