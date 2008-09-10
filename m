From: akpm@linux-foundation.org
Subject: + nec-fix-suspend-and-resume-for-isa-pnp-cards.patch added to -mm tree
Date: Wed, 10 Sep 2008 14:17:37 -0700
Message-ID: <200809102117.m8ALHbR6026647@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43182 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479AbYIJVS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Sep 2008 17:18:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, alan@lxorguk.ukuu.org.uk, anemo@mba.ocn.ne.jp, jeff@garzik.org, p_gortmaker@yahoo.com


The patch titled
     ne.c: fix suspend and resume for ISA PnP cards
has been added to the -mm tree.  Its filename is
     nec-fix-suspend-and-resume-for-isa-pnp-cards.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ne.c: fix suspend and resume for ISA PnP cards
From: David Fries <david@fries.net>

A call to pnp_stop_dev and pnp_start_dev now shuts down and initializes
plug and play devices for suspend and resume.

Signed-off-by: David Fries <david@fries.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ne.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/net/ne.c~nec-fix-suspend-and-resume-for-isa-pnp-cards drivers/net/ne.c
--- a/drivers/net/ne.c~nec-fix-suspend-and-resume-for-isa-pnp-cards
+++ a/drivers/net/ne.c
@@ -876,8 +876,12 @@ static int ne_drv_suspend(struct platfor
 {
 	struct net_device *dev = platform_get_drvdata(pdev);
 
-	if (netif_running(dev))
+	if (netif_running(dev)) {
+		struct pnp_dev *idev = (struct pnp_dev *)ei_status.priv;
 		netif_device_detach(dev);
+		if (idev)
+			pnp_stop_dev(idev);
+	}
 	return 0;
 }
 
@@ -886,6 +890,9 @@ static int ne_drv_resume(struct platform
 	struct net_device *dev = platform_get_drvdata(pdev);
 
 	if (netif_running(dev)) {
+		struct pnp_dev *idev = (struct pnp_dev *)ei_status.priv;
+		if (idev)
+			pnp_start_dev(idev);
 		ne_reset_8390(dev);
 		NS8390p_init(dev, 1);
 		netif_device_attach(dev);
_

Patches currently in -mm which might be from david@fries.net are

nec-fix-rmmod-platform-driver-improvements.patch
nec-fix-suspend-and-resume-for-isa-pnp-cards.patch
w1-fix-deadlocks-and-remove-w1_control_thread.patch
w1-abort-search-early-on-on-exit.patch
w1-dont-delay-search-start.patch
w1-w1_process-block-or-sleep.patch
w1-feature-enable-hardware-strong-pullup.patch
w1-feature-w1_thermc-use-strong-pullup-and-documentation.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-recode-w1_slave_found-logic.patch
w1-new-module-parameter-search_count.patch
w1-document-add-remove-search_count-and-pullup.patch
w1-w1_slave_read_id-read-bug-use-device_attribute.patch
w1-w1_therm-fix-user-buffer-overflow-and-cat.patch
w1-w1_family-remove-unused-variable-need_exit.patch
w1-w1_therm-consistent-mutex-access-code-cleanup.patch
w1-w1_intc-use-first-available-master-number.patch
w1-w1c-s-printk-dev_dbg.patch
w1-w1_ioc-reset-comments-and-msleep.patch
w1-ds1wmc-msleep-for-reset.patch
w1-ds2490c-correct-print-message.patch
w1-ds2490c-add-support-for-strong-pullup.patch
w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch
w1-ds2490c-disable-bit-read-and-write.patch
w1-ds2490c-simplify-and-fix-ds_touch_bit.patch
w1-ds2490c-ds_dump_status-rework.patch
w1-ds2490c-ds_reset-remove-ds_wait_status.patch
w1-ds2490c-reset-ds2490-in-init.patch
w1-ds2490c-magic-number-work.patch
w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch
w1-documentation-w1-masters-ds2490-update.patch
w1-ds2490c-optimize-ds_set_pullup.patch

