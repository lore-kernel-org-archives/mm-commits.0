From: akpm@linux-foundation.org
Subject: [merged] arch-powerpc-platforms-pseries-use-kasprintf.patch removed from -mm tree
Date: Thu, 08 Apr 2010 11:13:02 -0400
Message-ID: <201004081814.o38IEUV2032336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932981Ab0DHSOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Apr 2010 14:14:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, benh@kernel.crashing.org, nfont@austin.ibm.com, mm-commits@vger.kernel.org


The patch titled
     arch/powerpc/platforms/pseries: use kasprintf
has been removed from the -mm tree.  Its filename was
     arch-powerpc-platforms-pseries-use-kasprintf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/powerpc/platforms/pseries: use kasprintf
From: Julia Lawall <julia@diku.dk>

kasprintf combines kmalloc and sprintf, and takes care of the size
calculation itself.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression a,flag;
expression list args;
statement S;
@@

  a =
-  \(kmalloc\|kzalloc\)(...,flag)
+  kasprintf(flag,args)
  <... when != a
  if (a == NULL || ...) S
  ...>
- sprintf(a,args);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Acked-by: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/dlpar.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff -puN arch/powerpc/platforms/pseries/dlpar.c~arch-powerpc-platforms-pseries-use-kasprintf arch/powerpc/platforms/pseries/dlpar.c
--- a/arch/powerpc/platforms/pseries/dlpar.c~arch-powerpc-platforms-pseries-use-kasprintf
+++ a/arch/powerpc/platforms/pseries/dlpar.c
@@ -79,13 +79,12 @@ static struct device_node *dlpar_parse_c
 	 * prepend this to the full_name.
 	 */
 	name = (char *)ccwa + ccwa->name_offset;
-	dn->full_name = kmalloc(strlen(name) + 2, GFP_KERNEL);
+	dn->full_name = kasprintf(GFP_KERNEL, "/%s", name);
 	if (!dn->full_name) {
 		kfree(dn);
 		return NULL;
 	}
 
-	sprintf(dn->full_name, "/%s", name);
 	return dn;
 }
 
@@ -410,15 +409,13 @@ static ssize_t dlpar_cpu_probe(const cha
 	 * directory of the device tree.  CPUs actually live in the
 	 * cpus directory so we need to fixup the full_name.
 	 */
-	cpu_name = kzalloc(strlen(dn->full_name) + strlen("/cpus") + 1,
-			   GFP_KERNEL);
+	cpu_name = kasprintf(GFP_KERNEL, "/cpus%s", dn->full_name);
 	if (!cpu_name) {
 		dlpar_free_cc_nodes(dn);
 		rc = -ENOMEM;
 		goto out;
 	}
 
-	sprintf(cpu_name, "/cpus%s", dn->full_name);
 	kfree(dn->full_name);
 	dn->full_name = cpu_name;
 
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
drivers-scsi-qla2xxx-qla_attrc-add-missing-unlock.patch
drivers-serial-pmac_zilogc-add-missing-unlock.patch
drivers-usb-gadget-s3c-hsotgc-add-missing-unlock.patch
drivers-acpi-use-kasprintf.patch
drivers-acpi-use-kasprintf-fix.patch
arch-x86-pci-use-kasprintf.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
drivers-media-video-avoid-null-dereference.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-char-ppdevc-use-kasprintf.patch
drivers-edac-introduce-missing-kfree.patch

