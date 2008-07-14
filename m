From: akpm@linux-foundation.org
Subject: - kernel-schedc-add-missing-attr-parameter.patch removed from -mm tree
Date: Mon, 14 Jul 2008 00:38:07 -0700
Message-ID: <200807140738.m6E7c7dL028893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755597AbYGNHjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 03:39:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tiwai@suse.de, mingo@elte.hu, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     kernel/sched.c: Add missing attr parameter
has been removed from the -mm tree.  Its filename was
     kernel-schedc-add-missing-attr-parameter.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/sched.c: Add missing attr parameter
From: Takashi Iwai <tiwai@suse.de>

The second attribute parameter is missing in sched_*_show() and
store() in kernel/sched.c, which has been added recently.

  CC      kernel/sched.o
kernel/sched.c:7743: warning: initialization from incompatible pointer type
kernel/sched.c:7743: warning: initialization from incompatible pointer type
kernel/sched.c:7757: warning: initialization from incompatible pointer type
kernel/sched.c:7757: warning: initialization from incompatible pointer type

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN kernel/sched.c~kernel-schedc-add-missing-attr-parameter kernel/sched.c
--- a/kernel/sched.c~kernel-schedc-add-missing-attr-parameter
+++ a/kernel/sched.c
@@ -7712,11 +7712,14 @@ static ssize_t sched_power_savings_store
 }
 
 #ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct sys_device *dev, char *page)
+static ssize_t sched_mc_power_savings_show(struct sys_device *dev,
+					   struct sysdev_attribute *attr,
+					   char *page)
 {
 	return sprintf(page, "%u\n", sched_mc_power_savings);
 }
 static ssize_t sched_mc_power_savings_store(struct sys_device *dev,
+					    struct sysdev_attribute *attr,
 					    const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 0);
@@ -7726,11 +7729,14 @@ static SYSDEV_ATTR(sched_mc_power_saving
 #endif
 
 #ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct sys_device *dev, char *page)
+static ssize_t sched_smt_power_savings_show(struct sys_device *dev,
+					    struct sysdev_attribute *attr,
+					    char *page)
 {
 	return sprintf(page, "%u\n", sched_smt_power_savings);
 }
 static ssize_t sched_smt_power_savings_store(struct sys_device *dev,
+					    struct sysdev_attribute *attr,
 					     const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 1);
_

Patches currently in -mm which might be from tiwai@suse.de are

origin.patch
linux-next.patch
alsa-correct-kcalloc-usage.patch
net-phy-fix-missing-exports-for-net-phy-mdio-bitbangc.patch
kernel-schedc-add-missing-attr-parameter.patch
kernel-schedc-add-missing-attr-parameter-fix.patch
kcalloc-remove-runtime-division.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch

