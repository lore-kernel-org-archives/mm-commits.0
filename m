From: akpm@linux-foundation.org
Subject: + cxgbi-fix-build-with-extra_cflags.patch added to -mm tree
Date: Tue, 06 Oct 2015 13:00:25 -0700
Message-ID: <56142859.FbiaOPk0v+r7zsvK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbbJFUA0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2015 16:00:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jslaby@suse.cz, James.Bottomley@HansenPartnership.com, jthumshirn@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/cxgbi: fix build with EXTRA_CFLAGS
has been added to the -mm tree.  Its filename is
     cxgbi-fix-build-with-extra_cflags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cxgbi-fix-build-with-extra_cflags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cxgbi-fix-build-with-extra_cflags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

cxgbi-fix-build-with-extra_cflags.patch

