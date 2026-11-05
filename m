Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900269;
	b=tIF8NbS13PkvKT6D9F7p7XD380LSVM1BCRVCOD5OFD/kF1A1OGlpUqIuJz+6waD3rdPt
	 0Z+3Lg+5Hi7i0srZ5tQzNqQozqpdW+CiEbTIykU3JxCjo/PwTLW0QUjw9tbV2T56ScMio
	 S82WZoigCB1csGgNNcU3+MLroyvZ2/mscZn7+92dRmMdLG9TIhZNtFCVRElyscrU/9v93
	 uIpUTC9w5yfRmTbJcTksjifM/4Dz0Wxebih6KrglUQIjy2wlHD78kI683DZiAd8DMaVP5
	 1D0nNXjBK/10t9dO6QQSXeh+xTaXHHlAnU1FlXyEzDmGfHuH5dNtTxV+b7dC7W95U0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900269;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=0zBa7I5Rx3HExBy3oLaTLurAlOJJapdgJFdmk++yhKo=;
	b=ybD0a/GuUGc6IDmfqEdjWsSQmjUZS3Mr4dZtgDoZAaxBNrIzqWOYCTjgseiUmvRJSJKo
	 kAgRK9DFMpaFkvUHJrd8D8Q6qtrCYY5SxBvAFl6uz20/KvlJYqIk4lpi08aiDHBPsUxI3
	 7zpA0i8KJiRYeFN/GB6BvTmKOd7tWKJXERhWu5aPZIQLBYdN+8riJcxMs1f5Hs1pbVCCZ
	 qNX/9ArNWDuLkQn4obAY+nqnKR7y3WDP/SXr68gupqL6y/TSCJgQZ7BT4O2S7ykU4coCc
	 XPpkpcl5RqNYkiTENSIGJlv1DVIoW7UBVDpD9gkwhzKl7vgq7bZ5bDJsv4g5yiZEGcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=I14SrLy6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F078606A326
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 17:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=I14SrLy6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAEBD1F000C1;
	Thu,  5 Nov 2026 17:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793900268;
	bh=0zBa7I5Rx3HExBy3oLaTLurAlOJJapdgJFdmk++yhKo=;
	h=Date:To:From:Subject;
	b=I14SrLy6PTon+R0CJ8lEN0o9qeMOhH0a0xhBSO0CaluIqTE92oM2iSQGHbXCHq3re
	 gWioENUcryCTp5o7HgmkCnv5vVALP7EzqP4BzX/QLYY23s8D3BqpNdmHFXMKSLRgGH
	 gIS3kryR0D6JQRPdxEMKCZ+sWgTMTxESU5q+p3ck=
Date: Thu, 05 Nov 2026 09:37:48 -0800
To: mm-commits@vger.kernel.org,vkoul@kernel.org,mporter@kernel.crashing.org,
	error27@gmail.com,alex.bou9@gmail.com,Frank.Li@nxp.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + rapidio-tsi721-include-dmaengine-private-header.patch added to mm-nonmm-unstable branch
Message-Id: <20261105173748.BAEBD1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: rapidio/tsi721: include dmaengine private header
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     rapidio-tsi721-include-dmaengine-private-header.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/rapidio-tsi721-include-dmaengine-private-header.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Frank Li <Frank.Li@nxp.com>
Subject: rapidio/tsi721: include dmaengine private header
Date: Thu,  5 Nov 2026 12:05:08 -0500

tsi721 is a DMA engine provider and already includes the provider API
header through tsi721_dma.c.  However, it also accesses internal DMA
engine data structures that are declared in dmaengine.h.

Include the DMA engine private header directly, matching the existing
usage in tsi721_dma.c.

No functional change intended.  Prepare to make struct dma_device private
to the DMA engine provider.

Link: https://lore.kernel.org/20261105170511.1262005-1-Frank.Li@oss.nxp.com
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Vinod Koul <vkoul@kernel.org>
---

 drivers/rapidio/devices/tsi721.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rapidio/devices/tsi721.c~rapidio-tsi721-include-dmaengine-private-header
+++ a/drivers/rapidio/devices/tsi721.c
@@ -21,6 +21,7 @@
 #include <linux/kfifo.h>
 #include <linux/delay.h>
 
+#include "../../dma/dmaengine.h"
 #include "tsi721.h"
 
 #ifdef DEBUG
_

Patches currently in -mm which might be from Frank.Li@nxp.com are

rapidio-use-dmaengine_desc_set_callback.patch
rapidio-tsi721-include-dmaengine-private-header.patch

