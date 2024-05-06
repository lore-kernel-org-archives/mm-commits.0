Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F992CA5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958104; cv=none; b=T6QFTGVFTG/ciGEoWZ00TQ4Ae7CXt2IkimCdD1fDu3U3iZB34hSba+4yPm4dta/VSEmJKq29YS7V38I+KXy5cigDtFTlFUIEur3JOdEgP2UChLqKgcWZWqtLko6onzF2nI+Ik/Z8hu9IGxCZJumommmckpUdDVWhv3Dx1Svqy9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958104; c=relaxed/simple;
	bh=wGu3BUHlWgzLNmfIxqNfvQ9kGc310bqS8fRa73YfGdQ=;
	h=Date:To:From:Subject:Message-Id; b=CXnkLhLEyUtJ1uBtoEVEwVaLkwHIJrEpdN0kWPNKAm/51koDsMIb/62O8CG5rjo4qxBXdzwUPKDpDpuvRUy/7bG7lQm8pdLgEVEG0ZxMKT9hOivTFmZGMFHLdBooEuPAW4/wsrkSXe8l8a3sbS2Ak+gFungH004bZ50c1lyZrsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VpSr2hHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VpSr2hHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561E9C113CC;
	Mon,  6 May 2024 01:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958104;
	bh=wGu3BUHlWgzLNmfIxqNfvQ9kGc310bqS8fRa73YfGdQ=;
	h=Date:To:From:Subject:From;
	b=VpSr2hHI2vwnwjS34w2PTt4LAIirYkwIFLVxAXFGeQ2EnJmWmz4OTZspvh+NnSFUF
	 zA6Xm6MhPzsAbmAJUMXYFtw3ChQqLFPPuzlCWabt+YzpxBNXY5w+k4lzIBif0APfQ4
	 hFh6mxqKomB8UNvaMzW6BwYDus9W74adl7G5wMCo=
Date: Sun, 05 May 2024 18:15:03 -0700
To: mm-commits@vger.kernel.org,wens@csie.org,stefani@seibold.net,sean.wang@mediatek.com,sean@mess.org,samuel@sholland.org,robh@kernel.org,patrice.chotard@foss.st.com,mchehab@kernel.org,matthias.bgg@gmail.com,jernej.skrabec@gmail.com,hverkuil-cisco@xs4all.nl,angelogioacchino.delregno@collabora.com,alain.volmat@foss.st.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kfifo-dont-use-proxy-headers.patch removed from -mm tree
Message-Id: <20240506011504.561E9C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kfifo: don't use "proxy" headers
has been removed from the -mm tree.  Its filename was
     kfifo-dont-use-proxy-headers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


