From: akpm@linux-foundation.org
Subject: + sfi-fix-section-mismatch-warnings-in-sfi_corec.patch added to -mm tree
Date: Wed, 30 Sep 2009 16:09:55 -0700
Message-ID: <200909302309.n8UN9t7Q021437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754235AbZI3XKv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 19:10:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rakib.mullick@gmail.com, feng.tang@intel.com, lenb@kernel.org


The patch titled
     sfi: fix section mismatch warnings in sfi_core.c
has been added to the -mm tree.  Its filename is
     sfi-fix-section-mismatch-warnings-in-sfi_corec.patch

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
Subject: sfi: fix section mismatch warnings in sfi_core.c
From: Rakib Mullick <rakib.mullick@gmail.com>

The function sfi_map_memory/sfi_unmap_memory uses
early_ioremap/early_iounmap respectively, which refers to a __init
function.  And function sfi_check_table also refers to a __init function
sfi_verify_table.  Since the references are valid, so use __ref to get rid
of the warnings.

 We were warned by the following warnings:

  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0xb6ba3a): Section mismatch in reference from
the function sfi_map_memory() to the function
.init.text:early_ioremap()
The function sfi_map_memory() references
the function __init early_ioremap().
This is often because sfi_map_memory lacks a __init
annotation or the annotation of early_ioremap is wrong.

WARNING: vmlinux.o(.text+0xb6bab6): Section mismatch in reference from
the function sfi_unmap_memory() to the function
.init.text:early_iounmap()
The function sfi_unmap_memory() references
the function __init early_iounmap().
This is often because sfi_unmap_memory lacks a __init
annotation or the annotation of early_iounmap is wrong.

WARNING: vmlinux.o(.text+0xb6be30): Section mismatch in reference from
the function sfi_check_table() to the function
.init.text:sfi_verify_table()
The function sfi_check_table() references
the function __init sfi_verify_table().
This is often because sfi_check_table lacks a __init
annotation or the annotation of sfi_verify_table is wrong.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/sfi/sfi_core.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff -puN drivers/sfi/sfi_core.c~sfi-fix-section-mismatch-warnings-in-sfi_corec drivers/sfi/sfi_core.c
--- a/drivers/sfi/sfi_core.c~sfi-fix-section-mismatch-warnings-in-sfi_corec
+++ a/drivers/sfi/sfi_core.c
@@ -90,7 +90,11 @@ static struct sfi_table_simple *syst_va 
  */
 static u32 sfi_use_ioremap __read_mostly;
 
-static void __iomem *sfi_map_memory(u64 phys, u32 size)
+/*
+ * sfi_un/map_memory calls early_ioremap/iounmap which is a __init function
+ * and introduces section mismatch. So use __ref to make it calm.
+ */
+static void __iomem * __ref sfi_map_memory(u64 phys, u32 size)
 {
 	if (!phys || !size)
 		return NULL;
@@ -101,7 +105,7 @@ static void __iomem *sfi_map_memory(u64 
 		return early_ioremap(phys, size);
 }
 
-static void sfi_unmap_memory(void __iomem *virt, u32 size)
+static void __ref sfi_unmap_memory(void __iomem *virt, u32 size)
 {
 	if (!virt || !size)
 		return;
@@ -213,12 +217,17 @@ static int sfi_table_check_key(struct sf
  *    the mapped virt address will be returned, and the virt space
  *    will be released by call sfi_put_table() later
  *
+ * This two cases are from two different functions with two different
+ * sections and causes section mismatch warning. So use __ref to tell
+ * modpost not to make any noise.
+ *
  * Return value:
  *	NULL:			when can't find a table matching the key
  *	ERR_PTR(error):		error value
  *	virt table address:	when a matched table is found
  */
-struct sfi_table_header *sfi_check_table(u64 pa, struct sfi_table_key *key)
+struct sfi_table_header *
+ __ref sfi_check_table(u64 pa, struct sfi_table_key *key)
 {
 	struct sfi_table_header *th;
 	void *ret = NULL;
_

Patches currently in -mm which might be from rakib.mullick@gmail.com are

linux-next.patch
sfi-fix-section-mismatch-warnings-in-sfi_corec.patch

