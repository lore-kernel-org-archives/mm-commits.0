From: akpm@linux-foundation.org
Subject: +
 drivers-iio-inkernc-fix-iio_convert_raw_to_processed_unlocked.patch added
 to -mm tree
Date: Mon, 01 Jul 2013 15:21:00 -0700
Message-ID: <51d200cc.oPqe25qFium7aNhC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab3GAWVB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jul 2013 18:21:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, jic23@cam.ac.uk, alexandre.belloni@free-electrons.com

Subject: + drivers-iio-inkernc-fix-iio_convert_raw_to_processed_unlocked.patch added to -mm tree
To: alexandre.belloni@free-electrons.com,jic23@cam.ac.uk,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 01 Jul 2013 15:21:00 -0700


The patch titled
     Subject: drivers/iio/inkern.c: fix iio_convert_raw_to_processed_unlocked()
has been added to the -mm tree.  Its filename is
     drivers-iio-inkernc-fix-iio_convert_raw_to_processed_unlocked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-iio-inkernc-fix-iio_convert_raw_to_processed_unlocked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-iio-inkernc-fix-iio_convert_raw_to_processed_unlocked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
drivers-iio-inkernc-fix-iio_convert_raw_to_processed_unlocked.patch

