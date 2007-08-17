From: akpm@linux-foundation.org
Subject: + pnp-fix-up-after-lindent.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:39:09 -0700
Message-ID: <200708171839.l7HId9A4023920@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52065 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756996AbXHQSk4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:40:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, lenb@kernel.org, perex@suse.cz


The patch titled
     PNP: fix up after Lindent
has been added to the -mm tree.  Its filename is
     pnp-fix-up-after-lindent.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: PNP: fix up after Lindent
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

More manual fixups after Lindent.  No functional change.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/card.c             |   16 ++++++++--------
 drivers/pnp/driver.c           |    2 +-
 drivers/pnp/interface.c        |    9 +++++----
 drivers/pnp/isapnp/core.c      |   15 ++++++---------
 drivers/pnp/manager.c          |    4 ++--
 drivers/pnp/pnpacpi/core.c     |    4 ++--
 drivers/pnp/pnpacpi/rsparser.c |    1 +
 drivers/pnp/pnpbios/core.c     |    1 +
 drivers/pnp/pnpbios/proc.c     |    2 +-
 drivers/pnp/pnpbios/rsparser.c |    9 +++++----
 10 files changed, 32 insertions(+), 31 deletions(-)

diff -puN drivers/pnp/card.c~pnp-fix-up-after-lindent drivers/pnp/card.c
--- a/drivers/pnp/card.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/card.c
@@ -25,13 +25,13 @@ static const struct pnp_card_device_id *
 				int found;
 				struct pnp_dev *dev;
 
-				if (i == PNP_MAX_DEVICES
-				    || !*drv_id->devs[i].id)
+				if (i == PNP_MAX_DEVICES ||
+				    !*drv_id->devs[i].id)
 					return drv_id;
 				found = 0;
 				card_for_each_dev(card, dev) {
-					if (compare_pnp_id
-					    (dev->id, drv_id->devs[i].id)) {
+					if (compare_pnp_id(dev->id,
+						   drv_id->devs[i].id)) {
 						found = 1;
 						break;
 					}
@@ -183,7 +183,7 @@ static int pnp_interface_attach_card(str
 
 	return 0;
 
-      err_name:
+err_name:
 	device_remove_file(&card->dev, &dev_attr_name);
 	return rc;
 }
@@ -321,10 +321,10 @@ struct pnp_dev *pnp_request_card_device(
 		pos = pos->next;
 	}
 
-      done:
+done:
 	return NULL;
 
-      found:
+found:
 	dev->card_link = clink;
 	dev->dev.driver = &drv->link.driver;
 	if (pnp_bus_type.probe(&dev->dev))
@@ -334,7 +334,7 @@ struct pnp_dev *pnp_request_card_device(
 
 	return dev;
 
-      err_out:
+err_out:
 	dev->dev.driver = NULL;
 	dev->card_link = NULL;
 	return NULL;
diff -puN drivers/pnp/driver.c~pnp-fix-up-after-lindent drivers/pnp/driver.c
--- a/drivers/pnp/driver.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/driver.c
@@ -118,7 +118,7 @@ static int pnp_device_probe(struct devic
 		goto fail;
 	return error;
 
-      fail:
+fail:
 	pnp_device_detach(pnp_dev);
 	return error;
 }
diff -puN drivers/pnp/interface.c~pnp-fix-up-after-lindent drivers/pnp/interface.c
--- a/drivers/pnp/interface.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/interface.c
@@ -459,7 +459,8 @@ pnp_set_current_resources(struct device 
 		up(&pnp_res_mutex);
 		goto done;
 	}
-      done:
+
+done:
 	if (retval < 0)
 		return retval;
 	return count;
@@ -499,10 +500,10 @@ int pnp_interface_attach_device(struct p
 
 	return 0;
 
-      err_res:
+err_res:
 	device_remove_file(&dev->dev, &dev_attr_resources);
-      err_opt:
+err_opt:
 	device_remove_file(&dev->dev, &dev_attr_options);
-      err:
+err:
 	return rc;
 }
diff -puN drivers/pnp/isapnp/core.c~pnp-fix-up-after-lindent drivers/pnp/isapnp/core.c
--- a/drivers/pnp/isapnp/core.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/isapnp/core.c
@@ -335,7 +335,7 @@ static int __init isapnp_isolate(void)
 		} else if (iteration > 1) {
 			break;
 		}
-	      __next:
+__next:
 		if (csn == 255)
 			break;
 		checksum = 0x6a;
@@ -733,7 +733,7 @@ static int __init isapnp_create_device(s
 			       "isapnp: unexpected or unknown tag type 0x%x for logical device %i (device %i), ignored\n",
 			       type, dev->number, card->number);
 		}
-	      __skip:
+__skip:
 		if (size > 0)
 			isapnp_skip_bytes(size);
 	}
@@ -788,7 +788,7 @@ static void __init isapnp_parse_resource
 			       "isapnp: unexpected or unknown tag type 0x%x for device %i, ignored\n",
 			       type, card->number);
 		}
-	      __skip:
+__skip:
 		if (size > 0)
 			isapnp_skip_bytes(size);
 	}
@@ -940,9 +940,6 @@ EXPORT_SYMBOL(isapnp_protocol);
 EXPORT_SYMBOL(isapnp_present);
 EXPORT_SYMBOL(isapnp_cfg_begin);
 EXPORT_SYMBOL(isapnp_cfg_end);
-#if 0
-EXPORT_SYMBOL(isapnp_read_byte);
-#endif
 EXPORT_SYMBOL(isapnp_write_byte);
 
 static int isapnp_read_resources(struct pnp_dev *dev,
@@ -993,6 +990,7 @@ static int isapnp_get_resources(struct p
 				struct pnp_resource_table *res)
 {
 	int ret;
+
 	pnp_init_resource_table(res);
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	ret = isapnp_read_resources(dev, res);
@@ -1148,13 +1146,12 @@ static int __init isapnp_init(void)
 			}
 		}
 	}
-	if (cards) {
+	if (cards)
 		printk(KERN_INFO
 		       "isapnp: %i Plug & Play card%s detected total\n", cards,
 		       cards > 1 ? "s" : "");
-	} else {
+	else
 		printk(KERN_INFO "isapnp: No Plug & Play card found\n");
-	}
 
 	isapnp_proc_init();
 	return 0;
diff -puN drivers/pnp/manager.c~pnp-fix-up-after-lindent drivers/pnp/manager.c
--- a/drivers/pnp/manager.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/manager.c
@@ -390,7 +390,7 @@ static int pnp_assign_resources(struct p
 	up(&pnp_res_mutex);
 	return 1;
 
-      fail:
+fail:
 	pnp_clean_resource_table(&dev->res);
 	up(&pnp_res_mutex);
 	return 0;
@@ -444,7 +444,7 @@ int pnp_manual_config_dev(struct pnp_dev
 	kfree(bak);
 	return 0;
 
-      fail:
+fail:
 	dev->res = *bak;
 	up(&pnp_res_mutex);
 	kfree(bak);
diff -puN drivers/pnp/pnpacpi/core.c~pnp-fix-up-after-lindent drivers/pnp/pnpacpi/core.c
--- a/drivers/pnp/pnpacpi/core.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/pnpacpi/core.c
@@ -248,9 +248,9 @@ static int __init pnpacpi_add_device(str
 	num++;
 
 	return AE_OK;
-      err1:
+err1:
 	kfree(dev_id);
-      err:
+err:
 	kfree(dev);
 	return -EINVAL;
 }
diff -puN drivers/pnp/pnpacpi/rsparser.c~pnp-fix-up-after-lindent drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -35,6 +35,7 @@
 static int irq_flags(int triggering, int polarity)
 {
 	int flag;
+
 	if (triggering == ACPI_LEVEL_SENSITIVE) {
 		if (polarity == ACPI_ACTIVE_LOW)
 			flag = IORESOURCE_IRQ_LOWLEVEL;
diff -puN drivers/pnp/pnpbios/core.c~pnp-fix-up-after-lindent drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/pnpbios/core.c
@@ -591,6 +591,7 @@ subsys_initcall(pnpbios_init);
 static int __init pnpbios_thread_init(void)
 {
 	struct task_struct *task;
+
 #if defined(CONFIG_PPC_MERGE)
 	if (check_legacy_ioport(PNPBIOS_BASE))
 		return 0;
diff -puN drivers/pnp/pnpbios/proc.c~pnp-fix-up-after-lindent drivers/pnp/pnpbios/proc.c
--- a/drivers/pnp/pnpbios/proc.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/pnpbios/proc.c
@@ -213,7 +213,7 @@ static int proc_write_node(struct file *
 		goto out;
 	}
 	ret = count;
-      out:
+out:
 	kfree(node);
 	return ret;
 }
diff -puN drivers/pnp/pnpbios/rsparser.c~pnp-fix-up-after-lindent drivers/pnp/pnpbios/rsparser.c
--- a/drivers/pnp/pnpbios/rsparser.c~pnp-fix-up-after-lindent
+++ a/drivers/pnp/pnpbios/rsparser.c
@@ -238,7 +238,7 @@ static unsigned char *pnpbios_parse_allo
 			break;
 
 		default:	/* an unkown tag */
-		      len_err:
+len_err:
 			printk(KERN_ERR
 			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
 			       tag, len);
@@ -298,6 +298,7 @@ static void pnpbios_parse_fixed_mem32_op
 					     struct pnp_option *option)
 {
 	struct pnp_mem *mem;
+
 	mem = kzalloc(sizeof(struct pnp_mem), GFP_KERNEL);
 	if (!mem)
 		return;
@@ -468,7 +469,7 @@ static unsigned char *pnpbios_parse_reso
 			return p + 2;
 
 		default:	/* an unkown tag */
-		      len_err:
+len_err:
 			printk(KERN_ERR
 			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
 			       tag, len);
@@ -562,7 +563,7 @@ static unsigned char *pnpbios_parse_comp
 			break;
 
 		default:	/* an unkown tag */
-		      len_err:
+len_err:
 			printk(KERN_ERR
 			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
 			       tag, len);
@@ -756,7 +757,7 @@ static unsigned char *pnpbios_encode_all
 			break;
 
 		default:	/* an unkown tag */
-		      len_err:
+len_err:
 			printk(KERN_ERR
 			       "PnPBIOS: Unknown tag '0x%x', length '%d'.\n",
 			       tag, len);
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
move-free-pages-between-lists-on-steal.patch
convert-ill-defined-log2-to-ilog2.patch
tpm_tis-fix-interrupt-probing.patch
pnp-fix-up-after-lindent.patch
pnpacpi-simplify-irq_flags.patch
pnpacpi-remove-unnecessary-casts-of-void.patch
isapnp-removed-unused-isapnp_detected-and-isapnp_debug.patch
pnp-remove-module-infrastructure.patch
pnp-remove-null-pointer-checks.patch
