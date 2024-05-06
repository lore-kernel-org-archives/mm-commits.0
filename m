Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC842CA5
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714958103; cv=none; b=Gbp56xVt8UKqo8HQi9QjwJNyKKh0WigoU4BVtMm1Fw37x1Vx+JRVBpQDGjc2SqU3LL8PXBmMublMdgrvO0eC7xmm5OOO+D0R2/xbNfuiQIM9fQbWG3Xv+0VlJMnCo618/lVwD3dhbeyLh+ZR5wZlrYOyoV8f93B/iUbW5IZgSKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714958103; c=relaxed/simple;
	bh=6QiKSnLh/v5A8TjDmQTpjjkKweHAkys1kVfwX1vXb8Y=;
	h=Date:To:From:Subject:Message-Id; b=gHP/sB6eq7IWPBNbK9UHriL/rOspVmV43eqzWHiiP24al4aRvwFHEZi9mxxZVCx/qD9GyQ2CrYh1i5npZzoGCkwfGpxJI1BiWXiTHW2OOBZeZI5WMRzNBBMfriMK1xMH1FAvP7qhwGoY5lCz0hzdPaIDDlDumtWSqB0FvpnnvbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WhuCmxSG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WhuCmxSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36026C113CC;
	Mon,  6 May 2024 01:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714958103;
	bh=6QiKSnLh/v5A8TjDmQTpjjkKweHAkys1kVfwX1vXb8Y=;
	h=Date:To:From:Subject:From;
	b=WhuCmxSGTG9BtTkecMVaHjfGZVMA+Cxv7YPkwsKus2LAqi4tsyipL7QVkH5cizrQk
	 IwfaEjVsd81liPxc6qi+55qy9kh5iooJ6aLKeBnwMtO8bnZr+E2uPn79ZMcyVR1Apl
	 I9h77fx01ulL/pCRqhaVMwCvrM74pu67SSKQdySM=
Date: Sun, 05 May 2024 18:15:02 -0700
To: mm-commits@vger.kernel.org,wens@csie.org,stefani@seibold.net,sean.wang@mediatek.com,sean@mess.org,samuel@sholland.org,robh@kernel.org,patrice.chotard@foss.st.com,mchehab@kernel.org,matthias.bgg@gmail.com,jernej.skrabec@gmail.com,hverkuil-cisco@xs4all.nl,angelogioacchino.delregno@collabora.com,alain.volmat@foss.st.com,andriy.shevchenko@linux.intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] media-stih-cec-add-missing-ioh.patch removed from -mm tree
Message-Id: <20240506011503.36026C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: media: stih-cec: add missing io.h
has been removed from the -mm tree.  Its filename was
     media-stih-cec-add-missing-ioh.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


