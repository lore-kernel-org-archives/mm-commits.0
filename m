From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:11 -0800
Message-ID: <58b5e2bf.pDwsN8X2LUFfp4yZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52602 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbdB1Uvg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "an union" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "an union" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  an union||a union

Link: http://lkml.kernel.org/r/1481573103-11329-5-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/media/uapi/dvb/dvb-frontend-parameters.rst  |    4 ++--
 arch/x86/include/asm/desc_defs.h                          |    2 +-
 drivers/acpi/acpica/dbconvert.c                           |    2 +-
 drivers/acpi/acpica/nspredef.c                            |    2 +-
 drivers/acpi/acpica/nsxfeval.c                            |    4 ++--
 drivers/staging/lustre/lustre/include/lustre/lustre_idl.h |    2 +-
 include/linux/dcache.h                                    |    4 ++--
 include/media/v4l2-ctrls.h                                |    4 ++--
 include/xen/interface/grant_table.h                       |    2 +-
 scripts/spelling.txt                                      |    1 +
 sound/pci/ice1712/wm8766.c                                |    2 +-
 sound/pci/ice1712/wm8776.c                                |    2 +-
 tools/perf/util/probe-finder.c                            |    4 ++--
 tools/perf/util/sort.h                                    |    2 +-
 14 files changed, 19 insertions(+), 18 deletions(-)

diff -puN Documentation/media/uapi/dvb/dvb-frontend-parameters.rst~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
--- a/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/Documentation/media/uapi/dvb/dvb-frontend-parameters.rst
@@ -9,7 +9,7 @@ frontend parameters
 The kind of parameters passed to the frontend device for tuning depend
 on the kind of hardware you are using.
 
-The struct ``dvb_frontend_parameters`` uses an union with specific
+The struct ``dvb_frontend_parameters`` uses a union with specific
 per-system parameters. However, as newer delivery systems required more
 data, the structure size weren't enough to fit, and just extending its
 size would break the existing applications. So, those parameters were
@@ -23,7 +23,7 @@ So, newer applications should use
 instead, in order to be able to support the newer System Delivery like
 DVB-S2, DVB-T2, DVB-C2, ISDB, etc.
 
-All kinds of parameters are combined as an union in the
+All kinds of parameters are combined as a union in the
 FrontendParameters structure:
 
 
diff -puN arch/x86/include/asm/desc_defs.h~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances arch/x86/include/asm/desc_defs.h
--- a/arch/x86/include/asm/desc_defs.h~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/arch/x86/include/asm/desc_defs.h
@@ -15,7 +15,7 @@
  * FIXME: Accessing the desc_struct through its fields is more elegant,
  * and should be the one valid thing to do. However, a lot of open code
  * still touches the a and b accessors, and doing this allow us to do it
- * incrementally. We keep the signature as a struct, rather than an union,
+ * incrementally. We keep the signature as a struct, rather than a union,
  * so we can get rid of it transparently in the future -- glommer
  */
 /* 8 byte segment descriptor */
diff -puN drivers/acpi/acpica/dbconvert.c~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances drivers/acpi/acpica/dbconvert.c
--- a/drivers/acpi/acpica/dbconvert.c~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/drivers/acpi/acpica/dbconvert.c
@@ -242,7 +242,7 @@ acpi_status acpi_db_convert_to_package(c
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Convert a typed and tokenized string to an union acpi_object. Typing:
+ * DESCRIPTION: Convert a typed and tokenized string to a union acpi_object. Typing:
  *              1) String objects were surrounded by quotes.
  *              2) Buffer objects were surrounded by parentheses.
  *              3) Package objects were surrounded by brackets "[]".
diff -puN drivers/acpi/acpica/nspredef.c~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances drivers/acpi/acpica/nspredef.c
--- a/drivers/acpi/acpica/nspredef.c~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/drivers/acpi/acpica/nspredef.c
@@ -323,7 +323,7 @@ acpi_ns_check_reference(struct acpi_eval
 
 	/*
 	 * Check the reference object for the correct reference type (opcode).
-	 * The only type of reference that can be converted to an union acpi_object is
+	 * The only type of reference that can be converted to a union acpi_object is
 	 * a reference to a named object (reference class: NAME)
 	 */
 	if (return_object->reference.class == ACPI_REFCLASS_NAME) {
diff -puN drivers/acpi/acpica/nsxfeval.c~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances drivers/acpi/acpica/nsxfeval.c
--- a/drivers/acpi/acpica/nsxfeval.c~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/drivers/acpi/acpica/nsxfeval.c
@@ -495,9 +495,9 @@ static void acpi_ns_resolve_references(s
 	/*
 	 * Two types of references are supported - those created by Index and
 	 * ref_of operators. A name reference (AML_NAMEPATH_OP) can be converted
-	 * to an union acpi_object, so it is not dereferenced here. A ddb_handle
+	 * to a union acpi_object, so it is not dereferenced here. A ddb_handle
 	 * (AML_LOAD_OP) cannot be dereferenced, nor can it be converted to
-	 * an union acpi_object.
+	 * a union acpi_object.
 	 */
 	switch (info->return_object->reference.class) {
 	case ACPI_REFCLASS_INDEX:
diff -puN drivers/staging/lustre/lustre/include/lustre/lustre_idl.h~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1704,7 +1704,7 @@ struct ost_lvb {
  *   lquota data structures
  */
 
-/* The lquota_id structure is an union of all the possible identifier types that
+/* The lquota_id structure is a union of all the possible identifier types that
  * can be used with quota, this includes:
  * - 64-bit user ID
  * - 64-bit group ID
diff -puN include/linux/dcache.h~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances include/linux/dcache.h
--- a/include/linux/dcache.h~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/include/linux/dcache.h
@@ -562,7 +562,7 @@ static inline struct dentry *d_backing_d
  * @inode: inode to select the dentry from multiple layers (can be NULL)
  * @flags: open flags to control copy-up behavior
  *
- * If dentry is on an union/overlay, then return the underlying, real dentry.
+ * If dentry is on a union/overlay, then return the underlying, real dentry.
  * Otherwise return the dentry itself.
  *
  * See also: Documentation/filesystems/vfs.txt
@@ -581,7 +581,7 @@ static inline struct dentry *d_real(stru
  * d_real_inode - Return the real inode
  * @dentry: The dentry to query
  *
- * If dentry is on an union/overlay, then return the underlying, real inode.
+ * If dentry is on a union/overlay, then return the underlying, real inode.
  * Otherwise return d_inode().
  */
 static inline struct inode *d_real_inode(const struct dentry *dentry)
diff -puN include/media/v4l2-ctrls.h~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances include/media/v4l2-ctrls.h
--- a/include/media/v4l2-ctrls.h~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/include/media/v4l2-ctrls.h
@@ -174,10 +174,10 @@ typedef void (*v4l2_ctrl_notify_fnc)(str
  *		not freed when the control is deleted. Should this be needed
  *		then a new internal bitfield can be added to tell the framework
  *		to free this pointer.
- * @p_cur:	The control's current value represented via an union with
+ * @p_cur:	The control's current value represented via a union with
  *		provides a standard way of accessing control types
  *		through a pointer.
- * @p_new:	The control's new value represented via an union with provides
+ * @p_new:	The control's new value represented via a union with provides
  *		a standard way of accessing control types
  *		through a pointer.
  */
diff -puN include/xen/interface/grant_table.h~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances include/xen/interface/grant_table.h
--- a/include/xen/interface/grant_table.h~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/include/xen/interface/grant_table.h
@@ -181,7 +181,7 @@ struct grant_entry_header {
 };
 
 /*
- * Version 2 of the grant entry structure, here is an union because three
+ * Version 2 of the grant entry structure, here is a union because three
  * different types are suppotted: full_page, sub_page and transitive.
  */
 union grant_entry_v2 {
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -86,6 +86,7 @@ alue||value
 ambigious||ambiguous
 amoung||among
 amout||amount
+an union||a union
 an user||a user
 an userspace||a userspace
 analysator||analyzer
diff -puN sound/pci/ice1712/wm8766.c~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances sound/pci/ice1712/wm8766.c
--- a/sound/pci/ice1712/wm8766.c~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/sound/pci/ice1712/wm8766.c
@@ -254,7 +254,7 @@ static int snd_wm8766_ctl_put(struct snd
 	int n = kcontrol->private_value;
 	u16 val, regval1, regval2;
 
-	/* this also works for enum because value is an union */
+	/* this also works for enum because value is a union */
 	regval1 = ucontrol->value.integer.value[0];
 	regval2 = ucontrol->value.integer.value[1];
 	if (wm->ctl[n].flags & WM8766_FLAG_INVERT) {
diff -puN sound/pci/ice1712/wm8776.c~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances sound/pci/ice1712/wm8776.c
--- a/sound/pci/ice1712/wm8776.c~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/sound/pci/ice1712/wm8776.c
@@ -528,7 +528,7 @@ static int snd_wm8776_ctl_put(struct snd
 	int n = kcontrol->private_value;
 	u16 val, regval1, regval2;
 
-	/* this also works for enum because value is an union */
+	/* this also works for enum because value is a union */
 	regval1 = ucontrol->value.integer.value[0];
 	regval2 = ucontrol->value.integer.value[1];
 	if (wm->ctl[n].flags & WM8776_FLAG_INVERT) {
diff -puN tools/perf/util/probe-finder.c~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances tools/perf/util/probe-finder.c
--- a/tools/perf/util/probe-finder.c~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/tools/perf/util/probe-finder.c
@@ -464,7 +464,7 @@ static int convert_variable_fields(Dwarf
 		/* Verify it is a data structure  */
 		tag = dwarf_tag(&type);
 		if (tag != DW_TAG_structure_type && tag != DW_TAG_union_type) {
-			pr_warning("%s is not a data structure nor an union.\n",
+			pr_warning("%s is not a data structure nor a union.\n",
 				   varname);
 			return -EINVAL;
 		}
@@ -479,7 +479,7 @@ static int convert_variable_fields(Dwarf
 	} else {
 		/* Verify it is a data structure  */
 		if (tag != DW_TAG_structure_type && tag != DW_TAG_union_type) {
-			pr_warning("%s is not a data structure nor an union.\n",
+			pr_warning("%s is not a data structure nor a union.\n",
 				   varname);
 			return -EINVAL;
 		}
diff -puN tools/perf/util/sort.h~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances tools/perf/util/sort.h
--- a/tools/perf/util/sort.h~scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances
+++ a/tools/perf/util/sort.h
@@ -108,7 +108,7 @@ struct hist_entry {
 		/*
 		 * Since perf diff only supports the stdio output, TUI
 		 * fields are only accessed from perf report (or perf
-		 * top).  So make it an union to reduce memory usage.
+		 * top).  So make it a union to reduce memory usage.
 		 */
 		struct hist_entry_diff	diff;
 		struct /* for TUI */ {
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch

