Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4821E2CA5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958102; cv=none; b=eJQHQdEOyLWd4Y5MOX2VeehVQsRMWQJ8dnnTzdoeJrcttQAJOZxU5GG6XglFA2Fnxrkd/xM0wphkoXh7lad6WNhffQziFHKP9rOyqbeoAhRIPBxV4NtatdqeMENL2rJVKwwjE8qJXZ7/q5QmN8+3qIKZA+Et1UJ10I/qNKFVUO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958102; c=relaxed/simple;
	bh=xoQQGT3IwgoF6ITaJGEvh6kHdT3KOcuY4e+chTMuG0g=;
	h=Date:To:From:Subject:Message-Id; b=ijc22Foqr+7LLlv57+wFXwjhNhhzwIEnMfs5hGMRpepD6WRDrO3fvI+ceDTW56JW0YDIiwLk1ysVleEJ5nJksN5xj9mtPaC+QcMv1NWW3Njk08HTT/m5hQYVz74QU4HWsfjCq/m/7JX0sUkC6YantDWXSMen+o+ovADSaSAIsT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ByCyHc+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ByCyHc+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FC53C113CC;
	Mon,  6 May 2024 01:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958102;
	bh=xoQQGT3IwgoF6ITaJGEvh6kHdT3KOcuY4e+chTMuG0g=;
	h=Date:To:From:Subject:From;
	b=ByCyHc+4X0NFusKUaV0hMcG+o5PWsDO33G+0rOnT/GfBa8Qc6zggFDVvO4Zzxwe0U
	 rFJ1imTd1+qnP0BzuN5ampD4mOJxS9jOyaB6yLg9dgak02Jr698sE9iM5FLTFS972/
	 5M7B+qYxZraNZZaDmB9cB1IVBz6sa2u2Z6iGw/JE=
Date: Sun, 05 May 2024 18:15:01 -0700
To: mm-commits@vger.kernel.org,wens@csie.org,stefani@seibold.net,sean.wang@mediatek.com,sean@mess.org,samuel@sholland.org,robh@kernel.org,patrice.chotard@foss.st.com,mchehab@kernel.org,matthias.bgg@gmail.com,jernej.skrabec@gmail.com,hverkuil-cisco@xs4all.nl,angelogioacchino.delregno@collabora.com,alain.volmat@foss.st.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] media-rc-add-missing-ioh.patch removed from -mm tree
Message-Id: <20240506011502.0FC53C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: media: rc: add missing io.h
has been removed from the -mm tree.  Its filename was
     media-rc-add-missing-ioh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


