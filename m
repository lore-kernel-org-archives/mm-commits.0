From: akpm@linux-foundation.org
Subject: + kfifo-initialize-fifo-accordingly-to-c99-standard.patch added to -mm tree
Date: Wed, 28 Nov 2012 15:56:57 -0800
Message-ID: <20121128235658.61388820050@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:43862 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab2K1X47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 18:56:59 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so1173690vcd.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 15:56:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, stefani@seibold.net


The patch titled
     Subject: kfifo: initialize fifo accordingly to C99 standard
has been added to the -mm tree.  Its filename is
     kfifo-initialize-fifo-accordingly-to-c99-standard.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: kfifo: initialize fifo accordingly to C99 standard

When building a kernel with "make W=1" we will get a warning about missing
initializer.  It comes from kfifo usage style.  The DEFINE_KFIFO macro
doesn't initialize the buf[] field of the fifo structure.  Using C99
initialization fixes this.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stefani Seibold <stefani@seibold.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN include/linux/kfifo.h~kfifo-initialize-fifo-accordingly-to-c99-standard include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-initialize-fifo-accordingly-to-c99-standard
+++ a/include/linux/kfifo.h
@@ -155,8 +155,7 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PT
 #define DEFINE_KFIFO(fifo, type, size) \
 	DECLARE_KFIFO(fifo, type, size) = \
 	(typeof(fifo)) { \
-		{ \
-			{ \
+		.kfifo = { \
 			.in	= 0, \
 			.out	= 0, \
 			.mask	= __is_kfifo_ptr(&(fifo)) ? \
@@ -166,11 +165,9 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PT
 			.data	= __is_kfifo_ptr(&(fifo)) ? \
 				NULL : \
 				(fifo).buf, \
-			} \
 		} \
 	}
 
