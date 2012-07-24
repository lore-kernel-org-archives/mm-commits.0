From: akpm@linux-foundation.org
Subject: + drivers-misc-lkdtmc-fix-missing-allocation-failure-check.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:26:38 -0700
Message-ID: <20120724212639.000A520004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:63722 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753929Ab2GXV0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jul 2012 17:26:41 -0400
Received: by lagr15 with SMTP id r15so665lag.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:26:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, rucsoftsec@gmail.com


The patch titled
     Subject: drivers/misc/lkdtm.c: fix missing allocation failure check
has been added to the -mm tree.  Its filename is
     drivers-misc-lkdtmc-fix-missing-allocation-failure-check.patch

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
Subject: drivers/misc/lkdtm.c: fix missing allocation failure check

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=44691

Reported-by: <rucsoftsec@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lkdtm.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/misc/lkdtm.c~drivers-misc-lkdtmc-fix-missing-allocation-failure-check drivers/misc/lkdtm.c
--- a/drivers/misc/lkdtm.c~drivers-misc-lkdtmc-fix-missing-allocation-failure-check
+++ a/drivers/misc/lkdtm.c
@@ -477,6 +477,8 @@ static ssize_t lkdtm_debugfs_read(struct
 	int i, n, out;
 
 	buf = (char *)__get_free_page(GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
 
 	n = snprintf(buf, PAGE_SIZE, "Available crash types:\n");
 	for (i = 0; i < ARRAY_SIZE(cp_type); i++)
_
Subject: Subject: drivers/misc/lkdtm.c: fix missing allocation failure check

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
taskstats-check-nla_reserve-return.patch
drivers-misc-lkdtmc-fix-missing-allocation-failure-check.patch

