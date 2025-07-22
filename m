Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F57E286426
	for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2025 21:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753220460; cv=none; b=ra+9IHU5TDGnTOQ65rUqZp9xi2RrIhDK3pjE3K5SZTjGtaRrXVIBgSYfjwczIXgz6v2lYywnD0lhxj2BBBbZ6I3y99yw/5+dUMSGxWcXcdwiTKHaWdPLrCwfG4RYIO14Pan28tfVCZrl2d59vhLrrxPLQRpQ/L2Ib1D0NYjUit4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753220460; c=relaxed/simple;
	bh=HnNFPtZbfpU0GwhDfSK25Lo2nMsL0GXdOkVMbCmzWxA=;
	h=Date:To:From:Subject:Message-Id; b=CeNzKwbAjYNUghPKX/WFvRVMuCiLbIyOtbls2k6fWRUnkvykc47WJ+YVPnIjIqBdAzVkzmWAAalLCVqIE4OQudobTkdc/5GdAfDQhUDFTLqhHOTJo6vTo1H99OHXo80p2uLdAL0LqtnIzrvcDOW7o85lEik8MALrhvtaSLEEZCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aQ4UYpB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aQ4UYpB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B130DC4CEEB;
	Tue, 22 Jul 2025 21:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753220459;
	bh=HnNFPtZbfpU0GwhDfSK25Lo2nMsL0GXdOkVMbCmzWxA=;
	h=Date:To:From:Subject:From;
	b=aQ4UYpB0xqOMlSLJUxuDK65KX2YTxDhk2Tt4xGAar0iLGW9egVPXzE6FB4wRS15kp
	 6bghTl6diwj/51e9j+b5PrtKZVeebWs/y9zwMG79WMRpReD3PQaDuRoY2DOCTnUVx6
	 QrXNkIIeGQpAN8zdlt+rDeF/A9BdOnGXP9NOXKHk=
Date: Tue, 22 Jul 2025 14:40:59 -0700
To: mm-commits@vger.kernel.org,andriy.shevchenko@linux.intel.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + serial-8250_dw-fix-typo-notifer.patch added to mm-nonmm-unstable branch
Message-Id: <20250722214059.B130DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: serial: 8250_dw: fix typo "notifer"
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     serial-8250_dw-fix-typo-notifer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/serial-8250_dw-fix-typo-notifer.patch

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
From: WangYuli <wangyuli@uniontech.com>
Subject: serial: 8250_dw: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:29 +0800

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lkml.kernel.org/r/BD4804BF4FBA1648+20250722073431.21983-6-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/8250/8250_dw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_dw.c~serial-8250_dw-fix-typo-notifer
+++ a/drivers/tty/serial/8250/8250_dw.c
@@ -392,7 +392,7 @@ static void dw8250_set_termios(struct ua
 	rate = clk_round_rate(d->clk, newrate);
 	if (rate > 0) {
 		/*
-		 * Note that any clock-notifer worker will block in
+		 * Note that any clock-notifier worker will block in
 		 * serial8250_update_uartclk() until we are done.
 		 */
 		ret = clk_set_rate(d->clk, newrate);
_

Patches currently in -mm which might be from wangyuli@uniontech.com are

kvm-x86-fix-typo-notifer.patch
cxl-mce-fix-typo-notifer.patch
drm-xe-fix-typo-notifer.patch
net-mvneta-fix-typo-notifer.patch
wifi-brcmfmac-fix-typo-notifer.patch
serial-8250_dw-fix-typo-notifer.patch
xen-xenbus-fix-typo-notifer.patch
scripts-spellingtxt-add-notifernotifier-to-spellingtxt.patch

