From: akpm@linux-foundation.org
Subject: - net-ath5k-remove-sysctls.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:58:30 -0700
Message-ID: <200708242058.l7OKwUVi014307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52880 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758465AbXHXVH5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:07:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Net: ath5k, remove sysctls
has been removed from the -mm tree.  Its filename was
     net-ath5k-remove-sysctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Net: ath5k, remove sysctls
From: Jiri Slaby <jirislaby@gmail.com>

Syscalls were buggy and defunct in later kernels (due to sysctl check).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/ath5k_base.c |   23 ++++++++---------------
 1 files changed, 8 insertions(+), 15 deletions(-)

diff -puN drivers/net/wireless/ath5k_base.c~net-ath5k-remove-sysctls drivers/net/wireless/ath5k_base.c
--- a/drivers/net/wireless/ath5k_base.c~net-ath5k-remove-sysctls
+++ a/drivers/net/wireless/ath5k_base.c
@@ -2440,21 +2440,13 @@ static struct pci_driver ath_pci_drv_id 
 	.resume		= ath_pci_resume,
 };
 
-/*
- * Static (i.e. global) sysctls.  Note that the hal sysctls
- * are located under ours by sharing the setting for DEV_ATH.
- */
-enum {
-	DEV_ATH		= 9,			/* XXX known by hal */
-};
-
 static int mincalibrate = 1;
 static int maxcalibrate = INT_MAX / 1000;
 #define	CTL_AUTO	-2	/* cannot be CTL_ANY or CTL_NONE */
 
 static ctl_table ath_static_sysctls[] = {
 #if AR_DEBUG
-	{ .ctl_name	= CTL_AUTO,
+	{
 	  .procname	= "debug",
 	  .mode		= 0644,
 	  .data		= &ath_debug,
@@ -2462,28 +2454,28 @@ static ctl_table ath_static_sysctls[] = 
 	  .proc_handler	= proc_dointvec
 	},
 #endif
-	{ .ctl_name	= CTL_AUTO,
+	{
 	  .procname	= "countrycode",
 	  .mode		= 0444,
 	  .data		= &countrycode,
 	  .maxlen	= sizeof(countrycode),
 	  .proc_handler	= proc_dointvec
 	},
-	{ .ctl_name	= CTL_AUTO,
+	{
 	  .procname	= "outdoor",
 	  .mode		= 0444,
 	  .data		= &outdoor,
 	  .maxlen	= sizeof(outdoor),
 	  .proc_handler	= proc_dointvec
 	},
-	{ .ctl_name	= CTL_AUTO,
+	{
 	  .procname	= "xchanmode",
 	  .mode		= 0444,
 	  .data		= &xchanmode,
 	  .maxlen	= sizeof(xchanmode),
 	  .proc_handler	= proc_dointvec
 	},
-	{ .ctl_name	= CTL_AUTO,
+	{
 	  .procname	= "calibrate",
 	  .mode		= 0644,
 	  .data		= &ath_calinterval,
@@ -2495,14 +2487,15 @@ static ctl_table ath_static_sysctls[] = 
 	{ 0 }
 };
 static ctl_table ath_ath_table[] = {
-	{ .ctl_name	= DEV_ATH,
+	{
 	  .procname	= "ath",
 	  .mode		= 0555,
 	  .child	= ath_static_sysctls
 	}, { 0 }
 };
 static ctl_table ath_root_table[] = {
-	{ .ctl_name	= CTL_DEV,
+	{
+	  .ctl_name	= CTL_DEV,
 	  .procname	= "dev",
 	  .mode		= 0555,
 	  .child	= ath_ath_table
_

Patches currently in -mm which might be from jirislaby@gmail.com are

git-wireless.patch
net-add-ath5k-wireless-driver-fix.patch
epcac-reformat-comments-and-coding-style-improvements.patch
char-mxser_new-upgrade-to-110.patch
char-mxser_new-move-to-pci_vdevice.patch
char-mxser_new-remove-useless-comments-in-mxser_cards.patch
mxser-remove-commented-crap.patch
char-moxa-fix-and-optimise-empty-timer.patch
char-cyclades-remove-bottom-half-processing.patch
char-cyclades-make-the-isr-code-readable.patch
char-cyclades-move-spin_lock-to-one-place.patch
char-cyclades-fix-some-w-warnings.patch
char-moxa-cleanup-prints.patch
char-moxa-function-names-cleanup.patch
char-moxa-remove-sleep_on.patch
fs-select-remove-unused-macros.patch
cyber2000fb-rename-bit-macro.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
s2io-rename-bit-macro.patch
amba-pl011-rename-bit-macro.patch
define-first-set-of-bit-macros.patch
get-rid-of-input-bit-duplicate-defines.patch
define-global-bit-macro.patch
flashpoint-use-bit-instead-of-bitw.patch
shrink_slab-handle-bad-shrinkers.patch
