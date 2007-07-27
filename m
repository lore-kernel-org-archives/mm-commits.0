From: akpm@linux-foundation.org
Subject: + add-includes-to-scsi_transport_iscsih.patch added to -mm tree
Date: Thu, 26 Jul 2007 21:57:50 -0700
Message-ID: <200707270457.l6R4vo3D006286@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752501AbXG0E7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Jul 2007 00:59:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mst@dev.mellanox.co.il, michaelc@cs.wisc.edu, rdreier@cisco.com


The patch titled
     add includes to scsi_transport_iscsi.h
has been added to the -mm tree.  Its filename is
     add-includes-to-scsi_transport_iscsih.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add includes to scsi_transport_iscsi.h
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>

scsi/scsi_transport_iscsi.h uses struct mutex and struct list_head,
so while linux/mutex.h and linux/list.h seem to be pulled in indirectly
by one of the headers it includes, the right thing
is to include linux/mutex.h and linus/list.h directly.

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/scsi/scsi_transport_iscsi.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/scsi/scsi_transport_iscsi.h~add-includes-to-scsi_transport_iscsih include/scsi/scsi_transport_iscsi.h
--- a/include/scsi/scsi_transport_iscsi.h~add-includes-to-scsi_transport_iscsih
+++ a/include/scsi/scsi_transport_iscsi.h
@@ -24,6 +24,8 @@
 #define SCSI_TRANSPORT_ISCSI_H
 
 #include <linux/device.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
 #include <scsi/iscsi_if.h>
 
 struct scsi_transport_template;
_

Patches currently in -mm which might be from mst@dev.mellanox.co.il are

add-includes-to-scsi_transport_iscsih.patch
