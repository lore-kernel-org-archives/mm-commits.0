From: akpm@linux-foundation.org
Subject: - make-module_sect_attrs-private-to-kernel-modulec.patch removed from -mm tree
Date: Mon, 17 Mar 2008 21:17:11 -0700
Message-ID: <200803180417.m2I4HBNL013726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48863 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751388AbYCRERr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Mar 2008 00:17:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbeulich@novell.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     modules: make module_sect_attrs private to kernel/module.c
has been removed from the -mm tree.  Its filename was
     make-module_sect_attrs-private-to-kernel-modulec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: modules: make module_sect_attrs private to kernel/module.c
From: "Jan Beulich" <jbeulich@novell.com>

No-one else is using these afaics.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |   17 -----------------
 kernel/module.c        |   16 +++++++++++++++-
 2 files changed, 15 insertions(+), 18 deletions(-)

diff -puN include/linux/module.h~make-module_sect_attrs-private-to-kernel-modulec include/linux/module.h
--- a/include/linux/module.h~make-module_sect_attrs-private-to-kernel-modulec
+++ a/include/linux/module.h
@@ -229,23 +229,6 @@ enum module_state
 	MODULE_STATE_GOING,
 };
 
-/* Similar stuff for section attributes. */
-struct module_sect_attr
-{
-	struct module_attribute mattr;
-	char *name;
-	unsigned long address;
-};
-
-struct module_sect_attrs
-{
-	struct attribute_group grp;
-	int nsections;
-	struct module_sect_attr attrs[0];
-};
-
-struct module_param_attrs;
-
 struct module
 {
 	enum module_state state;
diff -puN kernel/module.c~make-module_sect_attrs-private-to-kernel-modulec kernel/module.c
--- a/kernel/module.c~make-module_sect_attrs-private-to-kernel-modulec
+++ a/kernel/module.c
@@ -991,6 +991,20 @@ static unsigned long resolve_symbol(Elf_
  * J. Corbet <corbet@lwn.net>
  */
 #if defined(CONFIG_KALLSYMS) && defined(CONFIG_SYSFS)
+struct module_sect_attr
+{
+	struct module_attribute mattr;
+	char *name;
+	unsigned long address;
+};
+
+struct module_sect_attrs
+{
+	struct attribute_group grp;
+	unsigned int nsections;
+	struct module_sect_attr attrs[0];
+};
+
 static ssize_t module_sect_show(struct module_attribute *mattr,
 				struct module *mod, char *buf)
 {
@@ -1001,7 +1015,7 @@ static ssize_t module_sect_show(struct m
 
 static void free_sect_attrs(struct module_sect_attrs *sect_attrs)
 {
-	int section;
+	unsigned int section;
 
 	for (section = 0; section < sect_attrs->nsections; section++)
 		kfree(sect_attrs->attrs[section].name);
_

Patches currently in -mm which might be from jbeulich@novell.com are

lib-swiotlbc-avoid-endless-loops-fix.patch
git-x86.patch
lib-swiotlbc-cleanups.patch
make-module_sect_attrs-private-to-kernel-modulec.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
fix-verify_export_symbols.patch

