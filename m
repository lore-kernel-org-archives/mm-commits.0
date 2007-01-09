From: akpm@osdl.org
Subject: - qeth-fix-uaccess-handling-and-get-rid-of-unused-variable.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:29:10 -0800
Message-ID: <200701092029.l09KTAdY014356@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41117 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932419AbXAIU3e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:29:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, fpavlic@de.ibm.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     qeth: fix uaccess handling and get rid of unused variable
has been removed from the -mm tree.  Its filename was
     qeth-fix-uaccess-handling-and-get-rid-of-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: qeth: fix uaccess handling and get rid of unused variable
From: Heiko Carstens <heiko.carstens@de.ibm.com>

drivers/s390/net/qeth_main.c: In function `qeth_process_inbound_buffer':
drivers/s390/net/qeth_main.c:2563: warning: unused variable `vlan_addr'

include/asm/uaccess.h: In function `qeth_do_ioctl':
drivers/s390/net/qeth_main.c:4847: warning:
 ignoring return value of `copy_to_user'
drivers/s390/net/qeth_main.c:4849: warning:
 ignoring return value of `copy_to_user'
drivers/s390/net/qeth_main.c:4996: warning:
 ignoring return value of `copy_to_user'

Cc: Frank Pavlic <fpavlic@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/s390/net/qeth_main.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/s390/net/qeth_main.c~qeth-fix-uaccess-handling-and-get-rid-of-unused-variable drivers/s390/net/qeth_main.c
--- a/drivers/s390/net/qeth_main.c~qeth-fix-uaccess-handling-and-get-rid-of-unused-variable
+++ a/drivers/s390/net/qeth_main.c
@@ -2560,7 +2560,6 @@ qeth_process_inbound_buffer(struct qeth_
 	int offset;
 	int rxrc;
 	__u16 vlan_tag = 0;
-	__u16 *vlan_addr;
 
 	/* get first element of current buffer */
 	element = (struct qdio_buffer_element *)&buf->buffer->element[0];
@@ -4844,9 +4843,11 @@ qeth_arp_query(struct qeth_card *card, c
 			   "(0x%x/%d)\n",
 			   QETH_CARD_IFNAME(card), qeth_arp_get_error_cause(&rc),
 			   tmp, tmp);
-		copy_to_user(udata, qinfo.udata, 4);
+		if (copy_to_user(udata, qinfo.udata, 4))
+			rc = -EFAULT;
 	} else {
-		copy_to_user(udata, qinfo.udata, qinfo.udata_len);
+		if (copy_to_user(udata, qinfo.udata, qinfo.udata_len))
+			rc = -EFAULT;
 	}
 	kfree(qinfo.udata);
 	return rc;
@@ -4992,8 +4993,10 @@ qeth_snmp_command(struct qeth_card *card
 	if (rc)
 		PRINT_WARN("SNMP command failed on %s: (0x%x)\n",
 			   QETH_CARD_IFNAME(card), rc);
-	 else
-		copy_to_user(udata, qinfo.udata, qinfo.udata_len);
+	else {
+		if (copy_to_user(udata, qinfo.udata, qinfo.udata_len))
+			rc = -EFAULT;
+	}
 
 	kfree(ureq);
 	kfree(qinfo.udata);
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
fix-sparsemem-on-cell.patch
ehca-avoid-crash-on-kthread_create-failure.patch
ehca-fix-memleak-on-module-unloading.patch
git-s390.patch
