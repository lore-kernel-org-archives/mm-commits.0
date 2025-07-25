Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F15A2E36EC
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409823; cv=none; b=XiqmKhZ+ISbrQ/DDmEsGZc3FfpzMfHXCm0P1uk4UT/gsNORevMQDqp3JmTzRWOmiSqg6VU+zyCNdBrfbrciLALuzf6FHPvHKj8garLlolvRlhM0exgA4iZu6rS4gMFLxcqL4HVh0dH1W6ML/+jkWs17lcuDhoznDRtA1vYEIQx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409823; c=relaxed/simple;
	bh=DKFFjbnuK0l0AYv38WbzABYPtWWPLQS2NsE15titRuk=;
	h=Date:To:From:Subject:Message-Id; b=CkTwJ/D2iSRgFyAUkyEQVcUw6fS+XiIQpK4+dYQEoLOX+b284VEdhAJAoJyrCPkKHVrUV4A4Y2QcrlDhgNXVBR0lNgLz/t64aNxRMFVp9cOSvIYkjB41YpZM38DvfUC8AuvVq87ly0LGfudg6DmQwiumaKopvJ3rioRhg6Iialo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kMwB68Tm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kMwB68Tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BDDAC4CEED;
	Fri, 25 Jul 2025 02:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409822;
	bh=DKFFjbnuK0l0AYv38WbzABYPtWWPLQS2NsE15titRuk=;
	h=Date:To:From:Subject:From;
	b=kMwB68Tm/xps8mgmHUH1eMjVBRHEsspz7S1O0bWBM0+j6EuVDxO/H/DmUtbD9Tpux
	 39PGtU2UWvBCHdcxH0kfM0zjU+lC9DiuB8l/3y8tFvQUZ9lFiBTfiUL5wIZbM4PUnU
	 kQsWJlXJjqQIMiM7cG9V1sALgCpVXSe1J912K9LQ=
Date: Thu, 24 Jul 2025 19:17:02 -0700
To: mm-commits@vger.kernel.org,gregkh@linuxfoundation.org,andriy.shevchenko@linux.intel.com,wangyuli@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] serial-8250_dw-fix-typo-notifer.patch removed from -mm tree
Message-Id: <20250725021702.9BDDAC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: serial: 8250_dw: fix typo "notifer"
has been removed from the -mm tree.  Its filename was
     serial-8250_dw-fix-typo-notifer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: WangYuli <wangyuli@uniontech.com>
Subject: serial: 8250_dw: fix typo "notifer"
Date: Tue, 22 Jul 2025 15:34:29 +0800

There is a spelling mistake of 'notifer' in the comment which
should be 'notifier'.

Link: https://lkml.kernel.org/r/BD4804BF4FBA1648+20250722073431.21983-6-wangyuli@uniontech.com
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
xen-xenbus-fix-typo-notifer.patch
scripts-spellingtxt-add-notifernotifier-to-spellingtxt.patch

