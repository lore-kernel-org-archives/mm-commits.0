From: akpm@linux-foundation.org
Subject: + pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled.patch added to -mm tree
Date: Thu, 03 Feb 2011 12:16:37 -0800
Message-ID: <201102032016.p13KGbFZ022362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab1BCURe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 15:17:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, bjorn.helgaas@hp.com, hpa@zytor.com, linux@arm.linux.org.uk, mingo@redhat.com, tglx@linutronix.de, tony.luck@intel.com


The patch titled
     pnp: only assign IORESOURCE_DMA if CONFIG_ISA_DMA_API is enabled
has been added to the -mm tree.  Its filename is
     pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: only assign IORESOURCE_DMA if CONFIG_ISA_DMA_API is enabled
From: David Rientjes <rientjes@google.com>

IORESOURCE_DMA cannot be assigned without utilizing the interface
provided by CONFIG_ISA_DMA_API, specifically request_dma() and
free_dma().  Thus, there's a strict dependency on the config option and
limits IORESOURCE_DMA only to architectures that support ISA-style DMA.

ia64 is not one of those architectures, so pnp_check_dma() no longer
needs to be special-cased for that architecture.

pnp_assign_resources() will now return -EINVAL if IORESOURCE_DMA is
attempted on such a kernel.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/base.h     |    2 ++
 drivers/pnp/manager.c  |    7 ++++++-
 drivers/pnp/resource.c |    7 ++-----
 3 files changed, 10 insertions(+), 6 deletions(-)

diff -puN drivers/pnp/base.h~pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled drivers/pnp/base.h
--- a/drivers/pnp/base.h~pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled
+++ a/drivers/pnp/base.h
@@ -142,7 +142,9 @@ void __pnp_remove_device(struct pnp_dev 
 int pnp_check_port(struct pnp_dev *dev, struct resource *res);
 int pnp_check_mem(struct pnp_dev *dev, struct resource *res);
 int pnp_check_irq(struct pnp_dev *dev, struct resource *res);
+#ifdef CONFIG_ISA_DMA_API
 int pnp_check_dma(struct pnp_dev *dev, struct resource *res);
+#endif
 
 char *pnp_resource_type_name(struct resource *res);
 void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
diff -puN drivers/pnp/manager.c~pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled
+++ a/drivers/pnp/manager.c
@@ -171,6 +171,7 @@ __add:
 	return 0;
 }
 
+#ifdef CONFIG_ISA_DMA_API
 static int pnp_assign_dma(struct pnp_dev *dev, struct pnp_dma *rule, int idx)
 {
 	struct resource *res, local_res;
@@ -210,6 +211,7 @@ __add:
 	pnp_add_dma_resource(dev, res->start, res->flags);
 	return 0;
 }
+#endif /* CONFIG_ISA_DMA_API */
 
 void pnp_init_resources(struct pnp_dev *dev)
 {
@@ -234,7 +236,8 @@ static void pnp_clean_resource_table(str
 static int pnp_assign_resources(struct pnp_dev *dev, int set)
 {
 	struct pnp_option *option;
-	int nport = 0, nmem = 0, nirq = 0, ndma = 0;
+	int nport = 0, nmem = 0, nirq = 0;
+	int ndma __maybe_unused = 0;
 	int ret = 0;
 
 	pnp_dbg(&dev->dev, "pnp_assign_resources, try dependent set %d\n", set);
@@ -256,9 +259,11 @@ static int pnp_assign_resources(struct p
 		case IORESOURCE_IRQ:
 			ret = pnp_assign_irq(dev, &option->u.irq, nirq++);
 			break;
+#ifdef CONFIG_ISA_DMA_API
 		case IORESOURCE_DMA:
 			ret = pnp_assign_dma(dev, &option->u.dma, ndma++);
 			break;
+#endif
 		default:
 			ret = -EINVAL;
 			break;
diff -puN drivers/pnp/resource.c~pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled drivers/pnp/resource.c
--- a/drivers/pnp/resource.c~pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled
+++ a/drivers/pnp/resource.c
@@ -409,9 +409,9 @@ int pnp_check_irq(struct pnp_dev *dev, s
 	return 1;
 }
 
+#ifdef CONFIG_ISA_DMA_API
 int pnp_check_dma(struct pnp_dev *dev, struct resource *res)
 {
-#ifndef CONFIG_IA64
 	int i;
 	struct pnp_dev *tdev;
 	struct resource *tres;
@@ -466,11 +466,8 @@ int pnp_check_dma(struct pnp_dev *dev, s
 	}
 
 	return 1;
-#else
-	/* IA64 does not have legacy DMA */
-	return 0;
-#endif
 }
+#endif /* CONFIG_ISA_DMA_API */
 
 unsigned long pnp_resource_type(struct resource *res)
 {
_

Patches currently in -mm which might be from rientjes@google.com are

x86-numa-add-error-handling-for-bad-cpu-to-node-mappings.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
pnp-only-assign-ioresource_dma-if-config_isa_dma_api-is-enabled.patch
x86-only-compile-8237a-if-config_isa_dma_api-is-enabled.patch
x86-only-compile-floppy-driver-if-config_isa_dma_api-is-enabled.patch
x86-allow-config_isa_dma_api-to-be-disabled.patch
jbd-remove-dependency-on-__gfp_nofail.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch

