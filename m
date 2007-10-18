From: akpm@linux-foundation.org
Subject: - add-sys-module-name-notes.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:54:37 -0700
Message-ID: <200710180654.l9I6sbji030536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39074 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761212AbXJRHih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:38:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Add /sys/module/name/notes
has been removed from the -mm tree.  Its filename was
     add-sys-module-name-notes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add /sys/module/name/notes
From: Roland McGrath <roland@redhat.com>

This patch adds the /sys/module/<name>/notes/ magic directory, which has a
file for each allocated SHT_NOTE section that appears in <name>.ko.  This
is the counterpart for each module of /sys/kernel/notes for vmlinux. 
Reading this delivers the contents of the module's SHT_NOTE sections.  This
lets userland easily glean any detailed information about that module's
build that was stored there at compile time (e.g.  by ld --build-id).

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    3 +
 kernel/module.c        |  106 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 109 insertions(+)

diff -puN include/linux/module.h~add-sys-module-name-notes include/linux/module.h
--- a/include/linux/module.h~add-sys-module-name-notes
+++ a/include/linux/module.h
@@ -343,6 +343,9 @@ struct module
 
 	/* Section attributes */
 	struct module_sect_attrs *sect_attrs;
+
+	/* Notes attributes */
+	struct module_notes_attrs *notes_attrs;
 #endif
 
 	/* Per-cpu data. */
diff -puN kernel/module.c~add-sys-module-name-notes kernel/module.c
--- a/kernel/module.c~add-sys-module-name-notes
+++ a/kernel/module.c
@@ -20,6 +20,7 @@
 #include <linux/moduleloader.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
+#include <linux/sysfs.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -1047,6 +1048,100 @@ static void remove_sect_attrs(struct mod
 	}
 }
 
+/*
+ * /sys/module/foo/notes/.section.name gives contents of SHT_NOTE sections.
+ */
+
+struct module_notes_attrs {
+	struct kobject *dir;
+	unsigned int notes;
+	struct bin_attribute attrs[0];
+};
+
+static ssize_t module_notes_read(struct kobject *kobj,
+				 struct bin_attribute *bin_attr,
+				 char *buf, loff_t pos, size_t count)
+{
+	/*
+	 * The caller checked the pos and count against our size.
+	 */
+	memcpy(buf, bin_attr->private + pos, count);
+	return count;
+}
+
+static void free_notes_attrs(struct module_notes_attrs *notes_attrs,
+			     unsigned int i)
+{
+	if (notes_attrs->dir) {
+		while (i-- > 0)
+			sysfs_remove_bin_file(notes_attrs->dir,
+					      &notes_attrs->attrs[i]);
+		kobject_del(notes_attrs->dir);
+	}
+	kfree(notes_attrs);
+}
+
+static void add_notes_attrs(struct module *mod, unsigned int nsect,
+			    char *secstrings, Elf_Shdr *sechdrs)
+{
+	unsigned int notes, loaded, i;
+	struct module_notes_attrs *notes_attrs;
+	struct bin_attribute *nattr;
+
+	/* Count notes sections and allocate structures.  */
+	notes = 0;
+	for (i = 0; i < nsect; i++)
+		if ((sechdrs[i].sh_flags & SHF_ALLOC) &&
+		    (sechdrs[i].sh_type == SHT_NOTE))
+			++notes;
+
+	if (notes == 0)
+		return;
+
+	notes_attrs = kzalloc(sizeof(*notes_attrs)
+			      + notes * sizeof(notes_attrs->attrs[0]),
+			      GFP_KERNEL);
+	if (notes_attrs == NULL)
+		return;
+
+	notes_attrs->notes = notes;
+	nattr = &notes_attrs->attrs[0];
+	for (loaded = i = 0; i < nsect; ++i) {
+		if (!(sechdrs[i].sh_flags & SHF_ALLOC))
+			continue;
+		if (sechdrs[i].sh_type == SHT_NOTE) {
+			nattr->attr.name = mod->sect_attrs->attrs[loaded].name;
+			nattr->attr.mode = S_IRUGO;
+			nattr->size = sechdrs[i].sh_size;
+			nattr->private = (void *) sechdrs[i].sh_addr;
+			nattr->read = module_notes_read;
+			++nattr;
+		}
+		++loaded;
+	}
+
+	notes_attrs->dir = kobject_add_dir(&mod->mkobj.kobj, "notes");
+	if (!notes_attrs->dir)
+		goto out;
+
+	for (i = 0; i < notes; ++i)
+		if (sysfs_create_bin_file(notes_attrs->dir,
+					  &notes_attrs->attrs[i]))
+			goto out;
+
+	mod->notes_attrs = notes_attrs;
+	return;
+
+  out:
+	free_notes_attrs(notes_attrs, i);
+}
+
+static void remove_notes_attrs(struct module *mod)
+{
+	if (mod->notes_attrs)
+		free_notes_attrs(mod->notes_attrs, mod->notes_attrs->notes);
+}
+
 #else
 
 static inline void add_sect_attrs(struct module *mod, unsigned int nsect,
@@ -1057,6 +1152,15 @@ static inline void add_sect_attrs(struct
 static inline void remove_sect_attrs(struct module *mod)
 {
 }
+
+static inline void add_notes_attrs(struct module *mod, unsigned int nsect,
+				   char *sectstrings, Elf_Shdr *sechdrs)
+{
+}
+
+static inline void remove_notes_attrs(struct module *mod)
+{
+}
 #endif /* CONFIG_KALLSYMS */
 
 #ifdef CONFIG_SYSFS
@@ -1191,6 +1295,7 @@ static void free_module(struct module *m
 {
 	/* Delete from various lists */
 	stop_machine_run(__unlink_module, mod, NR_CPUS);
+	remove_notes_attrs(mod);
 	remove_sect_attrs(mod);
 	mod_kobject_remove(mod);
 
@@ -1918,6 +2023,7 @@ static struct module *load_module(void _
 	if (err < 0)
 		goto arch_cleanup;
 	add_sect_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
+	add_notes_attrs(mod, hdr->e_shnum, secstrings, sechdrs);
 
 	/* Size of section 0 is 0, so this works well if no unwind info. */
 	mod->unwind_info = unwind_add_table(mod,
_

Patches currently in -mm which might be from roland@redhat.com are

origin.patch
x86_64-use-linux-elfcore-compath.patch
fix-tsk-exit_state-usage-resend.patch
