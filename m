From: akpm@linux-foundation.org
Subject: + dma-debug-fix-check_unmap-null-pointer-dereference.patch added to -mm tree
Date: Thu, 20 Aug 2009 14:55:35 -0700
Message-ID: <200908202155.n7KLtZwb001792@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbZHTV4H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Aug 2009 17:56:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyle@redhat.com, joerg.roedel@amd.com, mchehab@infradead.org, mingo@elte.hu


The patch titled
     dma-debug: fix check_unmap null pointer dereference
has been added to the -mm tree.  Its filename is
     dma-debug-fix-check_unmap-null-pointer-dereference.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dma-debug: fix check_unmap null pointer dereference
From: Kyle McMartin <kyle@redhat.com>

While it's debatable whether or not a NULL device argument to the DMA API
functions is valid...  since it certainly isn't valid on devices with an
IOMMU...  dma-debug really shouldn't be dereferencing null pointers
either.

Guard against that in err_printk and the driver_filter functions.  A
Fedora rawhide user was seeing this in one of the dvb drivers resulting in
an oops on boot.

A patch has been sent for testing to the driver, but I feel the dma
debugging support should be fixed as well.  (There's still a pile of
legacy garbage in the kernel passing null pointers to dma_{alloc,free}_*. :(

Signed-off-by: Kyle McMartin <kyle@redhat.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/dma-debug.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN lib/dma-debug.c~dma-debug-fix-check_unmap-null-pointer-dereference lib/dma-debug.c
--- a/lib/dma-debug.c~dma-debug-fix-check_unmap-null-pointer-dereference
+++ a/lib/dma-debug.c
@@ -156,9 +156,13 @@ static bool driver_filter(struct device 
 		return true;
 
 	/* driver filter on and initialized */
-	if (current_driver && dev->driver == current_driver)
+	if (current_driver && dev && dev->driver == current_driver)
 		return true;
 
+	/* driver filter on, but we can't filter on a NULL device... */
+	if (!dev)
+		return false;
+
 	if (current_driver || !current_driver_name[0])
 		return false;
 
@@ -183,17 +187,17 @@ static bool driver_filter(struct device 
 	return ret;
 }
 
-#define err_printk(dev, entry, format, arg...) do {		\
-		error_count += 1;				\
-		if (driver_filter(dev) &&			\
-		    (show_all_errors || show_num_errors > 0)) {	\
-			WARN(1, "%s %s: " format,		\
-			     dev_driver_string(dev),		\
-			     dev_name(dev) , ## arg);		\
-			dump_entry_trace(entry);		\
-		}						\
-		if (!show_all_errors && show_num_errors > 0)	\
-			show_num_errors -= 1;			\
+#define err_printk(dev, entry, format, arg...) do {			\
+		error_count += 1;					\
+		if (driver_filter(dev) &&				\
+		    (show_all_errors || show_num_errors > 0)) {		\
+			WARN(1, "%s %s: " format,			\
+			     dev ? dev_driver_string(dev) : "NULL",	\
+			     dev ? dev_name(dev) : "NULL", ## arg);	\
+			dump_entry_trace(entry);			\
+		}							\
+		if (!show_all_errors && show_num_errors > 0)		\
+			show_num_errors -= 1;				\
 	} while (0);
 
 /*
_

Patches currently in -mm which might be from kyle@redhat.com are

origin.patch
dma-debug-fix-check_unmap-null-pointer-dereference.patch

