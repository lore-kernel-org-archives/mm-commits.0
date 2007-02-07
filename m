From: akpm@linux-foundation.org
Subject: + com20020-build-fix.patch added to -mm tree
Date: Wed, 07 Feb 2007 15:14:17 -0800
Message-ID: <200702072314.l17NEHAf030738@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44574 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161482AbXBGXOd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 18:14:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, davem@davemloft.net, jeff@garzik.org, linux@dominikbrodowski.net, nielsen.esben@googlemail.com


The patch titled
     com20020 build fix
has been added to the -mm tree.  Its filename is
     com20020-build-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: com20020 build fix
From: Randy Dunlap <randy.dunlap@oracle.com>

Need to export com20020 symbols for com20020_cs also.

WARNING:  "com20020_found" [drivers/net/pcmcia/com20020_cs.ko] undefined!
WARNING:  "com20020_check" [drivers/net/pcmcia/com20020_cs.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Esben Nielsen <nielsen.esben@googlemail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/arcnet/com20020.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/net/arcnet/com20020.c~com20020-build-fix drivers/net/arcnet/com20020.c
--- a/drivers/net/arcnet/com20020.c~com20020-build-fix
+++ a/drivers/net/arcnet/com20020.c
@@ -338,7 +338,8 @@ static void com20020_set_mc_list(struct 
 }
 
 #if defined(CONFIG_ARCNET_COM20020_PCI_MODULE) || \
-    defined(CONFIG_ARCNET_COM20020_ISA_MODULE)
+    defined(CONFIG_ARCNET_COM20020_ISA_MODULE) || \
+    defined(CONFIG_ARCNET_COM20020_CS_MODULE)
 EXPORT_SYMBOL(com20020_check);
 EXPORT_SYMBOL(com20020_found);
 #endif
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-alsa.patch
update-readmedrm-bugzilla-7933.patch
qconf-immediately-update-integer-and-string-values-in-xconfig-display-take-2.patch
mtd-add-missing-kernel-doc-item.patch
git-ocfs2.patch
parisc-fix-module_param-iommu-permission.patch
git-scsi-misc.patch
ueagle-atmc-needs-schedh.patch
math-emu-setcc-avoid-gcc-extension.patch
typeof-__page_to_pfn-with-sparsemem=y.patch
docbook-html-correction-of-recursive-a-tags-in-html-output.patch
kernel-doc-allow-a-little-whitespace.patch
sysrq-alphabetize-command-keys-doc.patch
kernel-doc-allow-more-whitespace.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
docbook-add-edd-firmware-interfaces.patch
kernel-doc-fix-some-odd-spacing-issues.patch
com20020-build-fix.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
reiser4-use-null-for-pointers.patch
profile_likely-export-do_check_likely.patch
