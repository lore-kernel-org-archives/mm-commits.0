Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364472B9C9
	for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2024 21:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713995734; cv=none; b=tddyCQ0xtRGAL4iO4AwI7v2ia/2F2COZXQMvNWqiNCXfnU+4r5F0d4OBQAxyJ7nRjk5sAYmLFtpHyiMqXyv0JKfw7ffa/9tseX2OcuOWz8X73HpPWBG/SqP52ANoHTiq9QgP2kIPr452mDvV25uShl5mhKyP7/Cl6N0jTQJHTi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713995734; c=relaxed/simple;
	bh=QsUdS95BKN0hZkWLcEow7IO54/9fhOT+KdCm8nr8YzA=;
	h=Date:To:From:Subject:Message-Id; b=n3FMfG0njaUXUTNCm3G3H7x+jLh9u4RbfrKph7q56ev/mxLz3GpFcreAjUi0SCmMEwZXT0ZM6XrFNzrkwzdn90tQIL6yEciSbMfb/5VW9O2c7UytsbstaUHKHu89b/IyEo54pDEIKEg9b6E0b6V9Hu8mqICu2DodCAHwTi8a09M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kTv3zsdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kTv3zsdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE545C113CD;
	Wed, 24 Apr 2024 21:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713995734;
	bh=QsUdS95BKN0hZkWLcEow7IO54/9fhOT+KdCm8nr8YzA=;
	h=Date:To:From:Subject:From;
	b=kTv3zsdkhBUSkwktgfBq8NEeAN+3peVH2we/7xOhRtDgfUsR1phsngpcgyxufvZw7
	 RNwj5EyWqIgyzJdlt86/xOmTbRIwjGn6W2eCnQvaSrFTsq8kTF8HbaI4iuTEFLhZ4P
	 76t6L9z03QJpkjTmXk4ZE/jl88Qnvjf3bXEHxhp4=
Date: Wed, 24 Apr 2024 14:55:33 -0700
To: mm-commits@vger.kernel.org,wens@csie.org,stefani@seibold.net,sean.wang@mediatek.com,sean@mess.org,samuel@sholland.org,robh@kernel.org,patrice.chotard@foss.st.com,mchehab@kernel.org,matthias.bgg@gmail.com,jernej.skrabec@gmail.com,hverkuil-cisco@xs4all.nl,angelogioacchino.delregno@collabora.com,alain.volmat@foss.st.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + media-stih-cec-add-missing-ioh.patch added to mm-nonmm-unstable branch
Message-Id: <20240424215533.DE545C113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: media: stih-cec: add missing io.h
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     media-stih-cec-add-missing-ioh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/media-stih-cec-add-missing-ioh.patch

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
Subject: media: stih-cec: add missing io.h
Date: Tue, 23 Apr 2024 22:23:09 +0300

In the driver the io.h is implied by others.  This is not good as it
prevents from cleanups done in other headers.  Add missing include.

Link: https://lkml.kernel.org/r/20240423192529.3249134-3-andriy.shevchenko@linux.intel.com
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

 drivers/media/cec/platform/sti/stih-cec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/cec/platform/sti/stih-cec.c~media-stih-cec-add-missing-ioh
+++ a/drivers/media/cec/platform/sti/stih-cec.c
@@ -6,6 +6,7 @@
  */
 #include <linux/clk.h>
 #include <linux/interrupt.h>
+#include <linux/io.h>
 #include <linux/kernel.h>
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
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

