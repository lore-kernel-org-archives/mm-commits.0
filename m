From: akpm@linux-foundation.org
Subject: + kernel-schedc-add-missing-attr-parameter.patch added to -mm tree
Date: Fri, 11 Jul 2008 11:38:30 -0700
Message-ID: <200807111844.m6BIiBok030852@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753851AbYGKSoi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 14:44:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: tiwai@suse.de, mingo@elte.hu, sfr@canb.auug.org.au


The patch titled
     kernel/sched.c: Add missing attr parameter
has been added to the -mm tree.  Its filename is
     kernel-schedc-add-missing-attr-parameter.patch

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

drivers-video-fsl-diu-fbc-fix-broken-fix.patch
linux-next.patch
alsa-correct-kcalloc-usage.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-pcxhr-soundcard-driver.patch
alsa-fix-a-const-pointer-usage-warning-in-the-digigram-mixart-soundcard-driver.patch
kernel-schedc-add-missing-attr-parameter.patch
kcalloc-remove-runtime-division.patch
pnp-set-the-pnp_card-dma_mask-for-use-by-isapnp-cards.patch
isa-set-24-bit-dma_mask-for-isa-devices.patch

