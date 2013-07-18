From: akpm@linux-foundation.org
Subject: [merged]
 drivers-iio-inkernc-fix-iio_convert_raw_to_processed_unlocked.patch removed from -mm tree
Date: Thu, 18 Jul 2013 13:33:05 -0700
Message-ID: <51e85101.JRbB0mRES1pH++jI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab3GRUdG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jul 2013 16:33:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, jic23@cam.ac.uk, alexandre.belloni@free-electrons.com

Subject: [merged] drivers-iio-inkernc-fix-iio_convert_raw_to_processed_unlocked.patch removed from -mm tree
To: alexandre.belloni@free-electrons.com,jic23@cam.ac.uk,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 18 Jul 2013 13:33:05 -0700


The patch titled
     Subject: drivers/iio/inkern.c: fix iio_convert_raw_to_processed_unlocked()
has been removed from the -mm tree.  Its filename was
     drivers-iio-inkernc-fix-iio_convert_raw_to_processed_unlocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: drivers/iio/inkern.c: fix iio_convert_raw_to_processed_unlocked()

When reading IIO_CHAN_INFO_OFFSET, the return value of iio_channel_read() for
success will be IIO_VAL*, checking for 0 is not correct.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: <stable@vger.kernel.org>	[3.10.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/iio/inkern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/iio/inkern.c~drivers-iio-inkernc-fix-iio_convert_raw_to_processed_unlocked drivers/iio/inkern.c
--- a/drivers/iio/inkern.c~drivers-iio-inkernc-fix-iio_convert_raw_to_processed_unlocked
+++ a/drivers/iio/inkern.c
@@ -451,7 +451,7 @@ static int iio_convert_raw_to_processed_
 	int ret;
 
 	ret = iio_channel_read(chan, &offset, NULL, IIO_CHAN_INFO_OFFSET);
-	if (ret == 0)
+	if (ret >= 0)
 		raw64 += offset;
 
 	scale_type = iio_channel_read(chan, &scale_val, &scale_val2,
_

Patches currently in -mm which might be from alexandre.belloni@free-electrons.com are

linux-next.patch

