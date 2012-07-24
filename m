From: akpm@linux-foundation.org
Subject: + drivers-message-i2o-i2o_configc-bound-allocation.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:23:38 -0700
Message-ID: <20120724212338.A330A100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:56364 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab2GXVXj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 17:23:39 -0400
Received: by qcqs25 with SMTP id s25so5820qcq.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:23:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com


The patch titled
     Subject: drivers/message/i2o/i2o_config.c: bound allocation
has been added to the -mm tree.  Its filename is
     drivers-message-i2o-i2o_configc-bound-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alan Cox <alan@linux.intel.com>
Subject: drivers/message/i2o/i2o_config.c: bound allocation

Fix a case where users can try to allocate arbitarily large amounts of
memory. 64K is overkill for a config request so apply an upper bound.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/i2o_config.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/message/i2o/i2o_config.c~drivers-message-i2o-i2o_configc-bound-allocation drivers/message/i2o/i2o_config.c
--- a/drivers/message/i2o/i2o_config.c~drivers-message-i2o-i2o_configc-bound-allocation
+++ a/drivers/message/i2o/i2o_config.c
@@ -188,6 +188,13 @@ static int i2o_cfg_parms(unsigned long a
 	if (!dev)
 		return -ENXIO;
 
+	/*
+	 * Stop users being able to try and allocate arbitary amounts
+	 * of DMA space. 64K is way more than sufficient for this.
+	 */
+	if (kcmd.oplen > 65536)
+		return -EMSGSIZE;
+
 	ops = memdup_user(kcmd.opbuf, kcmd.oplen);
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
_
Subject: Subject: drivers/message/i2o/i2o_config.c: bound allocation

Patches currently in -mm which might be from alan@linux.intel.com are

origin.patch
linux-next.patch
ppc-e500_tlb-memset-clears-nothing.patch
drivers-media-dvb-dvb-usb-az6007c-fix-incorrect-memcpy.patch
drivers-media-video-cx25821-cx25821-medusa-videoc-incorrect-check-on-decoder-type.patch
drivers-media-video-ov9640c-fix-missing-break.patch
fs-make-dumpable=2-require-fully-qualified-path.patch
coredump-warn-about-unsafe-suid_dumpable-core_pattern-combo.patch
kernel-sysc-avoid-argv_freenull.patch
drivers-message-i2o-i2o_procc-the-pointer-returned-from-chtostr-points-to-an-array-which-is-no-longer-valid.patch
drivers-message-i2o-i2o_configc-bound-allocation.patch

