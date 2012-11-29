From: akpm@linux-foundation.org
Subject: [failures] kfifo-initialize-fifo-accordingly-to-c99-standard.patch removed from -mm tree
Date: Wed, 28 Nov 2012 17:01:48 -0800
Message-ID: <20121129015152.9D52620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:44907 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171Ab2K2Bv5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 20:51:57 -0500
Received: by mail-lb0-f202.google.com with SMTP id i15so983136lbo.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 17:51:55 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, gregkh@linuxfoundation.org, stefani@seibold.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kfifo: initialize fifo accordingly to C99 standard
has been removed from the -mm tree.  Its filename was
     kfifo-initialize-fifo-accordingly-to-c99-standard.patch

This patch was dropped because it had testing failures

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
 
