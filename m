From: akpm@linux-foundation.org
Subject: + use-sysdev_class-in-schedc.patch added to -mm tree
Date: Mon, 14 Jul 2008 00:39:05 -0700
Message-ID: <200807140739.m6E7d5Gv028910@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316AbYGNHj5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 03:39:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, Valdis.Kletnieks@vt.edu, mingo@elte.hu, sfr@canb.auug.org.au


The patch titled
     Use sysdev_class* in sched.c
has been added to the -mm tree.  Its filename is
     use-sysdev_class-in-schedc.patch

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
Subject: Use sysdev_class* in sched.c
From: Takashi Iwai <tiwai@suse.de>

The power_saving* attributes are really sysdev_class stuff, so we must
create them via sysdev_class_create_file().  The parameters of callback
functions must be also fixed.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: <Valdis.Kletnieks@vt.edu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN kernel/sched.c~use-sysdev_class-in-schedc kernel/sched.c
--- a/kernel/sched.c~use-sysdev_class-in-schedc
+++ a/kernel/sched.c
@@ -7732,31 +7732,35 @@ static ssize_t sched_power_savings_store
 }
 
 #ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct sys_device *dev, char *page)
+static ssize_t sched_mc_power_savings_show(struct sysdev_class *cls,
+					   char *page)
 {
 	return sprintf(page, "%u\n", sched_mc_power_savings);
 }
-static ssize_t sched_mc_power_savings_store(struct sys_device *dev,
+static ssize_t sched_mc_power_savings_store(struct sysdev_class *cls,
 					    const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
-		   sched_mc_power_savings_store);
+static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644,
+			 sched_mc_power_savings_show,
+			 sched_mc_power_savings_store);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct sys_device *dev, char *page)
+static ssize_t sched_smt_power_savings_show(struct sysdev_class *cls,
+					    char *page)
 {
 	return sprintf(page, "%u\n", sched_smt_power_savings);
 }
-static ssize_t sched_smt_power_savings_store(struct sys_device *dev,
+static ssize_t sched_smt_power_savings_store(struct sysdv_class *cls,
 					     const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 1);
 }
-static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
-		   sched_smt_power_savings_store);
+static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
+			 sched_smt_power_savings_show,
+			 sched_smt_power_savings_store);
 #endif
 
 int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
@@ -7765,13 +7769,13 @@ int sched_create_sysfs_power_savings_ent
 
 #ifdef CONFIG_SCHED_SMT
 	if (smt_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_smt_power_savings.attr);
+		err = sysdev_class_create_file(cls,
+					       &attr_sched_smt_power_savings);
 #endif
 #ifdef CONFIG_SCHED_MC
 	if (!err && mc_capable())
-		err = sysfs_create_file(&cls->kset.kobj,
-					&attr_sched_mc_power_savings.attr);
+		err = sysdev_class_create_file(cls,
+					       &attr_sched_mc_power_savings);
 #endif
 	return err;
 }
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
alsa-correct-kcalloc-usage.patch
net-phy-fix-missing-exports-for-net-phy-mdio-bitbangc.patch
use-sysdev_class-in-schedc.patch
kcalloc-remove-runtime-division.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch

