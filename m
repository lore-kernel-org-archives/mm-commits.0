From: akpm@linux-foundation.org
Subject: + pnp-replace-strnicmp-with-strncasecmp.patch added to -mm tree
Date: Thu, 18 Sep 2014 14:36:22 -0700
Message-ID: <541b5056.opK6e8Kb8XVodryZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372AbaIRVgX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:36:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, rafael.j.wysocki@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: PNP: replace strnicmp with strncasecmp
has been added to the -mm tree.  Its filename is
     pnp-replace-strnicmp-with-strncasecmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/pnp-replace-strnicmp-with-strncasecmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/pnp-replace-strnicmp-with-strncasecmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: PNP: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/interface.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN drivers/pnp/interface.c~pnp-replace-strnicmp-with-strncasecmp drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-replace-strnicmp-with-strncasecmp
+++ a/drivers/pnp/interface.c
@@ -346,41 +346,41 @@ static ssize_t resources_store(struct de
 	}
 
 	buf = skip_spaces(buf);
-	if (!strnicmp(buf, "disable", 7)) {
+	if (!strncasecmp(buf, "disable", 7)) {
 		retval = pnp_disable_dev(dev);
 		goto done;
 	}
-	if (!strnicmp(buf, "activate", 8)) {
+	if (!strncasecmp(buf, "activate", 8)) {
 		retval = pnp_activate_dev(dev);
 		goto done;
 	}
-	if (!strnicmp(buf, "fill", 4)) {
+	if (!strncasecmp(buf, "fill", 4)) {
 		if (dev->active)
 			goto done;
 		retval = pnp_auto_config_dev(dev);
 		goto done;
 	}
-	if (!strnicmp(buf, "auto", 4)) {
+	if (!strncasecmp(buf, "auto", 4)) {
 		if (dev->active)
 			goto done;
 		pnp_init_resources(dev);
 		retval = pnp_auto_config_dev(dev);
 		goto done;
 	}
-	if (!strnicmp(buf, "clear", 5)) {
+	if (!strncasecmp(buf, "clear", 5)) {
 		if (dev->active)
 			goto done;
 		pnp_init_resources(dev);
 		goto done;
 	}
-	if (!strnicmp(buf, "get", 3)) {
+	if (!strncasecmp(buf, "get", 3)) {
 		mutex_lock(&pnp_res_mutex);
 		if (pnp_can_read(dev))
 			dev->protocol->get(dev);
 		mutex_unlock(&pnp_res_mutex);
 		goto done;
 	}
-	if (!strnicmp(buf, "set", 3)) {
+	if (!strncasecmp(buf, "set", 3)) {
 		resource_size_t start;
 		resource_size_t end;
 		unsigned long flags;
@@ -392,31 +392,31 @@ static ssize_t resources_store(struct de
 		mutex_lock(&pnp_res_mutex);
 		while (1) {
 			buf = skip_spaces(buf);
-			if (!strnicmp(buf, "io", 2)) {
+			if (!strncasecmp(buf, "io", 2)) {
 				buf = pnp_get_resource_value(buf + 2,
 							     IORESOURCE_IO,
 							     &start, &end,
 							     &flags);
 				pnp_add_io_resource(dev, start, end, flags);
-			} else if (!strnicmp(buf, "mem", 3)) {
+			} else if (!strncasecmp(buf, "mem", 3)) {
 				buf = pnp_get_resource_value(buf + 3,
 							     IORESOURCE_MEM,
 							     &start, &end,
 							     &flags);
 				pnp_add_mem_resource(dev, start, end, flags);
-			} else if (!strnicmp(buf, "irq", 3)) {
+			} else if (!strncasecmp(buf, "irq", 3)) {
 				buf = pnp_get_resource_value(buf + 3,
 							     IORESOURCE_IRQ,
 							     &start, NULL,
 							     &flags);
 				pnp_add_irq_resource(dev, start, flags);
-			} else if (!strnicmp(buf, "dma", 3)) {
+			} else if (!strncasecmp(buf, "dma", 3)) {
 				buf = pnp_get_resource_value(buf + 3,
 							     IORESOURCE_DMA,
 							     &start, NULL,
 							     &flags);
 				pnp_add_dma_resource(dev, start, flags);
-			} else if (!strnicmp(buf, "bus", 3)) {
+			} else if (!strncasecmp(buf, "bus", 3)) {
 				buf = pnp_get_resource_value(buf + 3,
 							     IORESOURCE_BUS,
 							     &start, &end,
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-next.patch
lib-string-remove-duplicated-function.patch
lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp.patch
arm-replace-strnicmp-with-strncasecmp.patch
block-replace-strnicmp-with-strncasecmp.patch
netfilter-replace-strnicmp-with-strncasecmp.patch
video-fbdev-replace-strnicmp-with-strncasecmp.patch
cifs-replace-strnicmp-with-strncasecmp.patch
ocfs2-replace-strnicmp-with-strncasecmp.patch
isofs-replace-strnicmp-with-strncasecmp.patch
batman-adv-replace-strnicmp-with-strncasecmp.patch
acpi-battery-replace-strnicmp-with-strncasecmp.patch
cpufreq-replace-strnicmp-with-strncasecmp.patch
cpuidle-replace-strnicmp-with-strncasecmp.patch
scsi-replace-strnicmp-with-strncasecmp.patch
ib_srpt-replace-strnicmp-with-strncasecmp.patch
input-edt-ft5x06-replace-strnicmp-with-strncasecmp.patch
altera-stapl-replace-strnicmp-with-strncasecmp.patch
thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch
pnp-replace-strnicmp-with-strncasecmp.patch
s390-cio-replace-strnicmp-with-strncasecmp.patch
staging-r8188eu-replace-strnicmp-with-strncasecmp.patch
thermal-replace-strnicmp-with-strncasecmp.patch
kdb-replace-strnicmp-with-strncasecmp.patch

