Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D302B9C9
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713995736; cv=none; b=epybWyhXVD8yPfOXKOa+8A+r46oVt9bu95jAdCCsSUILIZto06clWHihh4xVmbqimxHEl+SQaHr9JvqoXHtV+Ur6yYbFAizAZJHT+wG/SO6C7UwimKS2AwNdfV2x2M7alhIqAO4zyZa2ESSWUYoQtKoDDGx5vYXaCzPVr8pZhFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713995736; c=relaxed/simple;
	bh=+8YHJXRAdDY75qzM4uhufkv3vgv5pPsItRU0KYFPvvw=;
	h=Date:To:From:Subject:Message-Id; b=V7dEL6QPK8L+w10EwgN8QARqxPa83GTiKHIHPQwI8mZSegUQrv+cq1e9lsK50/BIMmzZtVhkLBqjlFvMweTbIzffb5YTxHfX2tiD1QZVRL8h70YNcijAy9bGetTsDCfmL1dIw0YsejnXqaSv4gzwuKIf/nV8B92twMlM53ZhM5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L3z6FfLd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L3z6FfLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2DBC113CD;
	Wed, 24 Apr 2024 21:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713995735;
	bh=+8YHJXRAdDY75qzM4uhufkv3vgv5pPsItRU0KYFPvvw=;
	h=Date:To:From:Subject:From;
	b=L3z6FfLdMn+tra7TE/SOZZ+RViWtG5fHvemxOkKdmqKngftUXJBbnbvqKPzfamBb6
	 AJVoS8IsKuy2PHMmU7Xy3GLILijIuAHt3KF5N1kCUx1t6Q6GfseWbs+ZPb3CDADiAp
	 jQ7CFH9vx90zTtzLAH1+dNh3sLBH4QKljywWQ/lw=
Date: Wed, 24 Apr 2024 14:55:34 -0700
To: mm-commits@vger.kernel.org,wens@csie.org,stefani@seibold.net,sean.wang@mediatek.com,sean@mess.org,samuel@sholland.org,robh@kernel.org,patrice.chotard@foss.st.com,mchehab@kernel.org,matthias.bgg@gmail.com,jernej.skrabec@gmail.com,hverkuil-cisco@xs4all.nl,angelogioacchino.delregno@collabora.com,alain.volmat@foss.st.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kfifo-dont-use-proxy-headers.patch added to mm-nonmm-unstable branch
Message-Id: <20240424215535.8D2DBC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kfifo: don't use "proxy" headers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kfifo-dont-use-proxy-headers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfifo-dont-use-proxy-headers.patch

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
Subject: kfifo: don't use "proxy" headers
Date: Tue, 23 Apr 2024 22:23:10 +0300

Update header inclusions to follow IWYU (Include What You Use) principle.

Link: https://lkml.kernel.org/r/20240423192529.3249134-4-andriy.shevchenko@linux.intel.com
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

 include/linux/kfifo.h       |    9 +++++++--
 lib/kfifo.c                 |    8 ++++----
 samples/kfifo/dma-example.c |    3 ++-
 3 files changed, 13 insertions(+), 7 deletions(-)

--- a/include/linux/kfifo.h~kfifo-dont-use-proxy-headers
+++ a/include/linux/kfifo.h
@@ -36,10 +36,15 @@
  * to lock the reader.
  */
 
-#include <linux/kernel.h>
+#include <linux/array_size.h>
 #include <linux/spinlock.h>
 #include <linux/stddef.h>
-#include <linux/scatterlist.h>
+#include <linux/types.h>
+
+#include <asm/barrier.h>
+#include <asm/errno.h>
+
+struct scatterlist;
 
 struct __kfifo {
 	unsigned int	in;
--- a/lib/kfifo.c~kfifo-dont-use-proxy-headers
+++ a/lib/kfifo.c
@@ -5,13 +5,13 @@
  * Copyright (C) 2009/2010 Stefani Seibold <stefani@seibold.net>
  */
 
-#include <linux/kernel.h>
-#include <linux/export.h>
-#include <linux/slab.h>
 #include <linux/err.h>
+#include <linux/export.h>
+#include <linux/kfifo.h>
 #include <linux/log2.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
 #include <linux/uaccess.h>
-#include <linux/kfifo.h>
 
 /*
  * internal helper to calculate the unused elements in a fifo
--- a/samples/kfifo/dma-example.c~kfifo-dont-use-proxy-headers
+++ a/samples/kfifo/dma-example.c
@@ -6,8 +6,9 @@
  */
 
 #include <linux/init.h>
-#include <linux/module.h>
 #include <linux/kfifo.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
 
 /*
  * This module shows how to handle fifo dma operations.
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

