Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E04E2B9C9
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713995732; cv=none; b=eM8sn+y+GXXi0CV6IvwdhFKVp4x7hSKWwoifcQ2lVlDh8OsdYhClCVrpJ/vQO5CnNyfK7YV7165+1vYz5DGoIDLdCpVIceLoc/EsMTi5Fafr/CRkaqVbX9gM9ppjXDmZZtMZpWjhTLlIFF3Rah9ubpIGvK/y5INWZn+nZuZ3IGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713995732; c=relaxed/simple;
	bh=lYa09eALFjIbAaZNy+No3tofeve2LRYb6XFhvyxZwU4=;
	h=Date:To:From:Subject:Message-Id; b=cIG5vqlbTS3PEiEWK0SjowtZSalNzxv1EAw7T6Pzbd2kK4Nw62SYvKT9B4+euuRusCnWjalHplBLXnnv+QOyE3GaO1bi+kjhXiJX0qbGOobCY2aKxeYBzxO9SxP5A13p34+/10wBMEZxgTLg50eFyfrBofKPhBP7sfJ9KvyxB8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Iy2Fq0nZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Iy2Fq0nZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5310C113CD;
	Wed, 24 Apr 2024 21:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713995731;
	bh=lYa09eALFjIbAaZNy+No3tofeve2LRYb6XFhvyxZwU4=;
	h=Date:To:From:Subject:From;
	b=Iy2Fq0nZvdXLHYKKjc31zeFFjz37mvyChJJ1xQxxavDhFa2OFZ34g4EwV5zL848bv
	 xLY1xR3/maxcJ9mUubBhQoMvHyCbi1+zd/0sPho9ahpBA3jMJXusnPhgIEdbV7cL4L
	 eaKISNxA81ihrLhuyj2HptAByxbnz6LIvu/0bzSo=
Date: Wed, 24 Apr 2024 14:55:30 -0700
To: mm-commits@vger.kernel.org,wens@csie.org,stefani@seibold.net,sean.wang@mediatek.com,sean@mess.org,samuel@sholland.org,robh@kernel.org,patrice.chotard@foss.st.com,mchehab@kernel.org,matthias.bgg@gmail.com,jernej.skrabec@gmail.com,hverkuil-cisco@xs4all.nl,angelogioacchino.delregno@collabora.com,alain.volmat@foss.st.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + media-rc-add-missing-ioh.patch added to mm-nonmm-unstable branch
Message-Id: <20240424215531.C5310C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: media: rc: add missing io.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     media-rc-add-missing-ioh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/media-rc-add-missing-ioh.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: media: rc: add missing io.h
Date: Tue, 23 Apr 2024 22:23:08 +0300

Patch series "kfifo: Clean up kfifo.h", v2.

To reduce dependency hell a degree, clean up kfifo.h (mainly getting rid
of kernel.h in the global header).  


This patch (of 3):

In many remote control drivers the io.h is implied by others.  This is not
good as it prevents from cleanups done in other headers.  Add missing
include.

Link: https://lkml.kernel.org/r/20240423192529.3249134-1-andriy.shevchenko@linux.intel.com
Link: https://lkml.kernel.org/r/20240423192529.3249134-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alain Volmat <alain.volmat@foss.st.com>
Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Patrice Chotard <patrice.chotard@foss.st.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Samuel Holland <samuel@sholland.org>
Cc: Sean Wang <sean.wang@mediatek.com>
Cc: Sean Young <sean@mess.org>
Cc: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/rc/mtk-cir.c   |    1 +
 drivers/media/rc/serial_ir.c |    1 +
 drivers/media/rc/st_rc.c     |    1 +
 drivers/media/rc/sunxi-cir.c |    1 +
 4 files changed, 4 insertions(+)

--- a/drivers/media/rc/mtk-cir.c~media-rc-add-missing-ioh
+++ a/drivers/media/rc/mtk-cir.c
@@ -8,6 +8,7 @@
 #include <linux/clk.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/io.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/reset.h>
--- a/drivers/media/rc/serial_ir.c~media-rc-add-missing-ioh
+++ a/drivers/media/rc/serial_ir.c
@@ -18,6 +18,7 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/serial_reg.h>
 #include <linux/types.h>
--- a/drivers/media/rc/st_rc.c~media-rc-add-missing-ioh
+++ a/drivers/media/rc/st_rc.c
@@ -6,6 +6,7 @@
 #include <linux/kernel.h>
 #include <linux/clk.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
--- a/drivers/media/rc/sunxi-cir.c~media-rc-add-missing-ioh
+++ a/drivers/media/rc/sunxi-cir.c
@@ -12,6 +12,7 @@
 
 #include <linux/clk.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

mm-page_alloc-consolidate-free-page-accounting-fix-4.patch
xarray-use-bits_per_longs.patch
xarray-dont-use-proxy-headers.patch
devres-switch-to-use-dev_err_probe-for-unification.patch
devres-dont-use-proxy-headers.patch
media-rc-add-missing-ioh.patch
media-stih-cec-add-missing-ioh.patch
kfifo-dont-use-proxy-headers.patch

