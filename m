From: akpm@linux-foundation.org
Subject: - add-includes-to-scsi_transport_iscsih.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:58 -0700
Message-ID: <200710102110.l9ALAwFg025977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38508 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756583AbXJJVVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:21:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mst@dev.mellanox.co.il, michaelc@cs.wisc.edu, rdreier@cisco.com, mm-commits@vger.kernel.org


The patch titled
     add includes to scsi_transport_iscsi.h
has been removed from the -mm tree.  Its filename was
     add-includes-to-scsi_transport_iscsih.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: add includes to scsi_transport_iscsi.h
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>

scsi/scsi_transport_iscsi.h uses struct mutex and struct list_head,
so while linux/mutex.h and linux/list.h seem to be pulled in indirectly
by one of the headers it includes, the right thing
is to include linux/mutex.h and linus/list.h directly.

Signed-off-by: Michael S. Tsirkin <mst@dev.mellanox.co.il>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
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

git-infiniband.patch
git-scsi-misc.patch
