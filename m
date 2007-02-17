From: akpm@linux-foundation.org
Subject: - fix-scsi-scsi_transporth-compile-error.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:51 -0800
Message-ID: <200702170716.l1H7GpmE021746@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51182 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946516AbXBQHQ5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eike-kernel@sf-tec.de, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     Fix scsi/scsi_transport.h compile error
has been removed from the -mm tree.  Its filename was
     fix-scsi-scsi_transporth-compile-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix scsi/scsi_transport.h compile error
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

scsi_transport.h defines the inline function scsi_transport_device_data() that
dereferences a pointer of "struct scsi_device *".  Since the struct is not
known by the header this might break compilation.

Include scsi/scsi_device.h to not rely on users doing the correct magic
include order.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/scsi/scsi_transport.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/scsi/scsi_transport.h~fix-scsi-scsi_transporth-compile-error include/scsi/scsi_transport.h
--- a/include/scsi/scsi_transport.h~fix-scsi-scsi_transporth-compile-error
+++ a/include/scsi/scsi_transport.h
@@ -22,6 +22,7 @@
 
 #include <linux/transport_class.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
 
 struct scsi_transport_template {
 	/* the attribute containers */
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

origin.patch
git-scsi-misc.patch
