From: akpm@linux-foundation.org
Subject: + drivers-misc-ti-st-st_corec-missing-null-check.patch added to -mm tree
Date: Tue, 24 Jul 2012 14:29:46 -0700
Message-ID: <20120724212947.26CDB100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:64865 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab2GXV3s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jul 2012 17:29:48 -0400
Received: by vcqp1 with SMTP id p1so4784vcq.1
        for <mm-commits@vger.kernel.org>; Tue, 24 Jul 2012 14:29:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, pavan_savoy@ti.com, rucsoftsec@gmail.com


The patch titled
     Subject: drivers/misc/ti-st/st_core.c: missing NULL check
has been added to the -mm tree.  Its filename is
     drivers-misc-ti-st-st_corec-missing-null-check.patch

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
Subject: drivers/misc/ti-st/st_core.c: missing NULL check

Addresses https://bugzilla.kernel.org/show_bug.cgi?44431

Reported-by: <rucsoftsec@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/ti-st/st_core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/misc/ti-st/st_core.c~drivers-misc-ti-st-st_corec-missing-null-check drivers/misc/ti-st/st_core.c
--- a/drivers/misc/ti-st/st_core.c~drivers-misc-ti-st-st_corec-missing-null-check
+++ a/drivers/misc/ti-st/st_core.c
@@ -349,6 +349,11 @@ void st_int_recv(void *disc_data,
 			st_gdata->rx_skb = alloc_skb(
 					st_gdata->list[type]->max_frame_size,
 					GFP_ATOMIC);
+			if (st_gdata->rx_skb == NULL) {
+				pr_err("out of memory: dropping\n");
+				goto done;
+			}
+
 			skb_reserve(st_gdata->rx_skb,
 					st_gdata->list[type]->reserve);
 			/* next 2 required for BT only */
_
Subject: Subject: drivers/misc/ti-st/st_core.c: missing NULL check

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
drivers-misc-ti-st-st_corec-missing-null-check.patch
drivers-message-i2o-i2o_procc-the-pointer-returned-from-chtostr-points-to-an-array-which-is-no-longer-valid.patch
drivers-message-i2o-i2o_configc-bound-allocation.patch
taskstats-check-nla_reserve-return.patch
drivers-misc-lkdtmc-fix-missing-allocation-failure-check.patch

