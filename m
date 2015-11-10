From: akpm@linux-foundation.org
Subject: [merged] cxgbi-fix-build-with-extra_cflags.patch removed from -mm tree
Date: Tue, 10 Nov 2015 12:33:14 -0800
Message-ID: <5642548a.AkPJbKvK6MloVNuH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbbKJUdO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Nov 2015 15:33:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, James.Bottomley@HansenPartnership.com, jthumshirn@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/cxgbi: fix build with EXTRA_CFLAGS
has been removed from the -mm tree.  Its filename was
     cxgbi-fix-build-with-extra_cflags.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiri Slaby <jslaby@suse.cz>
Subject: drivers/scsi/cxgbi: fix build with EXTRA_CFLAGS

EXTRA_CFLAGS are intended to be used on the command line, not by Kbuild. 
In case of cxgbi drivers, use of EXTRA_CFLAGS results in a compilation
failure:

drivers/scsi/cxgbi/cxgb4i/cxgb4i.c:24:21: fatal error: t4_regs.h: No such file or directory

when building like:

$ make drivers/scsi/cxgbi/ EXTRA_CFLAGS=-Wwhatever

Use ccflags-y instead of EXTRA_CFLAGS.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/cxgbi/cxgb3i/Kbuild |    2 +-
 drivers/scsi/cxgbi/cxgb4i/Kbuild |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/cxgbi/cxgb3i/Kbuild~cxgbi-fix-build-with-extra_cflags drivers/scsi/cxgbi/cxgb3i/Kbuild
--- a/drivers/scsi/cxgbi/cxgb3i/Kbuild~cxgbi-fix-build-with-extra_cflags
+++ a/drivers/scsi/cxgbi/cxgb3i/Kbuild
@@ -1,3 +1,3 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb3
+ccflags-y += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb3
 
 obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i.o
diff -puN drivers/scsi/cxgbi/cxgb4i/Kbuild~cxgbi-fix-build-with-extra_cflags drivers/scsi/cxgbi/cxgb4i/Kbuild
--- a/drivers/scsi/cxgbi/cxgb4i/Kbuild~cxgbi-fix-build-with-extra_cflags
+++ a/drivers/scsi/cxgbi/cxgb4i/Kbuild
@@ -1,3 +1,3 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
+ccflags-y += -I$(srctree)/drivers/net/ethernet/chelsio/cxgb4
 
 obj-$(CONFIG_SCSI_CXGB4_ISCSI) += cxgb4i.o
_

Patches currently in -mm which might be from jslaby@suse.cz are


