From: akpm@osdl.org
Subject: - iscsi-fix-crypto_alloc_hash-error-check.patch removed from -mm tree
Date: Sun, 07 Jan 2007 00:00:57 -0800
Message-ID: <200701070800.l0780vR4013237@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41114 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932497AbXAGIBH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 7 Jan 2007 03:01:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, James.Bottomley@steeleye.com, dmitry_yus@yahoo.com, itn780@yahoo.com, michaelc@cs.wisc.edu, mm-commits@vger.kernel.org


The patch titled
     iscsi: fix crypto_alloc_hash() error check
has been removed from the -mm tree.  Its filename was
     iscsi-fix-crypto_alloc_hash-error-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: iscsi: fix crypto_alloc_hash() error check
From: Akinobu Mita <akinobu.mita@gmail.com>

The return value of crypto_alloc_hash() should be checked by
IS_ERR().

Cc: Dmitry Yusupov <dmitry_yus@yahoo.com>
Cc: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/iscsi_tcp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/iscsi_tcp.c~iscsi-fix-crypto_alloc_hash-error-check drivers/scsi/iscsi_tcp.c
--- a/drivers/scsi/iscsi_tcp.c~iscsi-fix-crypto_alloc_hash-error-check
+++ a/drivers/scsi/iscsi_tcp.c
@@ -1777,13 +1777,13 @@ iscsi_tcp_conn_create(struct iscsi_cls_s
 	tcp_conn->tx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						  CRYPTO_ALG_ASYNC);
 	tcp_conn->tx_hash.flags = 0;
-	if (!tcp_conn->tx_hash.tfm)
+	if (IS_ERR(tcp_conn->tx_hash.tfm))
 		goto free_tcp_conn;
 
 	tcp_conn->rx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						  CRYPTO_ALG_ASYNC);
 	tcp_conn->rx_hash.flags = 0;
-	if (!tcp_conn->rx_hash.tfm)
+	if (IS_ERR(tcp_conn->rx_hash.tfm))
 		goto free_tx_tfm;
 
 	return cls_conn;
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

powerpc-use-is_init.patch
git-dvb.patch
ehca-fix-do_mmap-error-check.patch
ehca-avoid-crash-on-kthread_create-failure.patch
ehca-fix-memleak-on-module-unloading.patch
git-input.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-scsi-rc-fixes.patch
git-watchdog.patch
