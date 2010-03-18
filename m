From: akpm@linux-foundation.org
Subject: + arch-powerpc-platforms-pseries-use-kasprintf.patch added to -mm tree
Date: Thu, 18 Mar 2010 16:26:26 -0700
Message-ID: <201003182326.o2INQQfZ021886@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289Ab0CRX0m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 19:26:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, benh@kernel.crashing.org, nfont@austin.ibm.com


The patch titled
     arch/powerpc/platforms/pseries: use kasprintf
has been added to the -mm tree.  Its filename is
     arch-powerpc-platforms-pseries-use-kasprintf.patch

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
@@ -78,13 +78,12 @@ static struct device_node *dlpar_parse_c
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
 
@@ -409,15 +408,13 @@ static ssize_t dlpar_cpu_probe(const cha
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
drivers-acpi-use-kasprintf.patch
drivers-acpi-use-kasprintf-fix.patch
arch-x86-pci-use-kasprintf.patch
arch-arm-plat-pxa-dmac-correct-null-test.patch
arch-powerpc-platforms-pseries-use-kasprintf.patch
drivers-base-modulec-use-kasprintf.patch
drivers-mtd-use-kasprintf.patch
drivers-scsi-libsas-use-sam_good.patch
drivers-scsi-remove-unnecessary-null-test.patch
drivers-message-move-dereference-after-null-test.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-bfa-bfad_imc-eliminate-useless-code.patch
drivers-char-ppdevc-use-kasprintf.patch
drivers-edac-introduce-missing-kfree.patch

