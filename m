From: akpm@linux-foundation.org
Subject: +
 gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file.patch
 added to -mm tree
Date: Wed, 18 Sep 2013 14:24:16 -0700
Message-ID: <523a1a00.zIiFPkrpAo9fnCt7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46595 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3IRVYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 17:24:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rusty@rustcorp.com.au, peter.oberparleiter@de.ibm.com, keescook@chromium.org, jstancek@redhat.com, arnd@arndb.de, agospoda@redhat.com, fhrbata@redhat.com

Subject: + gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file.patch added to -mm tree
To: fhrbata@redhat.com,agospoda@redhat.com,arnd@arndb.de,jstancek@redhat.com,keescook@chromium.org,peter.oberparleiter@de.ibm.com,rusty@rustcorp.com.au
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 14:24:16 -0700


The patch titled
     Subject: gcov: move gcov structs definitions to a gcc version specific file
has been added to the -mm tree.  Its filename is
     gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Frantisek Hrbata <fhrbata@redhat.com>
Subject: gcov: move gcov structs definitions to a gcc version specific file

Since also the gcov structures(gcov_info, gcov_fn_info, gcov_ctr_info) can
change between gcc releases, as shown in gcc 4.7, they cannot be defined
in a common header and need to be moved to a specific gcc implemention
file.  This also requires to make the gcov_info structure opaque for the
common code and to introduce simple helpers for accessing data inside
gcov_info.

Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>
Cc: Jan Stancek <jstancek@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andy Gospodarek <agospoda@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/base.c    |   26 ++++-----
 kernel/gcov/fs.c      |   27 +++++----
 kernel/gcov/gcc_3_4.c |  115 ++++++++++++++++++++++++++++++++++++++++
 kernel/gcov/gcov.h    |   65 +++-------------------
 4 files changed, 153 insertions(+), 80 deletions(-)

diff -puN kernel/gcov/base.c~gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file kernel/gcov/base.c
--- a/kernel/gcov/base.c~gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file
+++ a/kernel/gcov/base.c
@@ -20,7 +20,6 @@
 #include <linux/mutex.h>
 #include "gcov.h"
 
-static struct gcov_info *gcov_info_head;
 static int gcov_events_enabled;
 static DEFINE_MUTEX(gcov_lock);
 
@@ -34,7 +33,7 @@ void __gcov_init(struct gcov_info *info)
 
 	mutex_lock(&gcov_lock);
 	if (gcov_version == 0) {
-		gcov_version = info->version;
+		gcov_version = gcov_info_version(info);
 		/*
 		 * Printing gcc's version magic may prove useful for debugging
 		 * incompatibility reports.
@@ -45,8 +44,7 @@ void __gcov_init(struct gcov_info *info)
 	 * Add new profiling data structure to list and inform event
 	 * listener.
 	 */
-	info->next = gcov_info_head;
-	gcov_info_head = info;
+	gcov_info_link(info);
 	if (gcov_events_enabled)
 		gcov_event(GCOV_ADD, info);
 	mutex_unlock(&gcov_lock);
@@ -91,13 +89,15 @@ EXPORT_SYMBOL(__gcov_merge_delta);
  */
 void gcov_enable_events(void)
 {
-	struct gcov_info *info;
+	struct gcov_info *info = NULL;
 
 	mutex_lock(&gcov_lock);
 	gcov_events_enabled = 1;
+
 	/* Perform event callback for previously registered entries. */
-	for (info = gcov_info_head; info; info = info->next)
+	while ((info = gcov_info_next(info)))
 		gcov_event(GCOV_ADD, info);
+
 	mutex_unlock(&gcov_lock);
 }
 
@@ -112,25 +112,23 @@ static int gcov_module_notifier(struct n
 				void *data)
 {
 	struct module *mod = data;
-	struct gcov_info *info;
-	struct gcov_info *prev;
+	struct gcov_info *info = NULL;
+	struct gcov_info *prev = NULL;
 
 	if (event != MODULE_STATE_GOING)
 		return NOTIFY_OK;
 	mutex_lock(&gcov_lock);
-	prev = NULL;
+
 	/* Remove entries located in module from linked list. */
-	for (info = gcov_info_head; info; info = info->next) {
+	while ((info = gcov_info_next(info))) {
 		if (within(info, mod->module_core, mod->core_size)) {
-			if (prev)
-				prev->next = info->next;
-			else
-				gcov_info_head = info->next;
+			gcov_info_unlink(prev, info);
 			if (gcov_events_enabled)
 				gcov_event(GCOV_REMOVE, info);
 		} else
 			prev = info;
 	}
+
 	mutex_unlock(&gcov_lock);
 
 	return NOTIFY_OK;
diff -puN kernel/gcov/fs.c~gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file kernel/gcov/fs.c
--- a/kernel/gcov/fs.c~gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file
+++ a/kernel/gcov/fs.c
@@ -242,7 +242,7 @@ static struct gcov_node *get_node_by_nam
 
 	list_for_each_entry(node, &all_head, all) {
 		info = get_node_info(node);
-		if (info && (strcmp(info->filename, name) == 0))
+		if (info && (strcmp(gcov_info_filename(info), name) == 0))
 			return node;
 	}
 
@@ -279,7 +279,7 @@ static ssize_t gcov_seq_write(struct fil
 	seq = file->private_data;
 	info = gcov_iter_get_info(seq->private);
 	mutex_lock(&node_lock);
-	node = get_node_by_name(info->filename);
+	node = get_node_by_name(gcov_info_filename(info));
 	if (node) {
 		/* Reset counts or remove node for unloaded modules. */
 		if (node->num_loaded == 0)
@@ -376,8 +376,9 @@ static void add_links(struct gcov_node *
 	if (!node->links)
 		return;
 	for (i = 0; i < num; i++) {
-		target = get_link_target(get_node_info(node)->filename,
-					 &gcov_link[i]);
+		target = get_link_target(
+				gcov_info_filename(get_node_info(node)),
+				&gcov_link[i]);
 		if (!target)
 			goto out_err;
 		basename = strrchr(target, '/');
@@ -576,7 +577,7 @@ static void add_node(struct gcov_info *i
 	struct gcov_node *parent;
 	struct gcov_node *node;
 
-	filename = kstrdup(info->filename, GFP_KERNEL);
+	filename = kstrdup(gcov_info_filename(info), GFP_KERNEL);
 	if (!filename)
 		return;
 	parent = &root_node;
@@ -631,7 +632,7 @@ static void add_info(struct gcov_node *n
 	loaded_info = kcalloc(num + 1, sizeof(struct gcov_info *), GFP_KERNEL);
 	if (!loaded_info) {
 		pr_warning("could not add '%s' (out of memory)\n",
-			   info->filename);
+			   gcov_info_filename(info));
 		return;
 	}
 	memcpy(loaded_info, node->loaded_info,
@@ -645,7 +646,8 @@ static void add_info(struct gcov_node *n
 		 */
 		if (!gcov_info_is_compatible(node->unloaded_info, info)) {
 			pr_warning("discarding saved data for %s "
-				   "(incompatible version)\n", info->filename);
+				   "(incompatible version)\n",
+				   gcov_info_filename(info));
 			gcov_info_free(node->unloaded_info);
 			node->unloaded_info = NULL;
 		}
@@ -656,7 +658,7 @@ static void add_info(struct gcov_node *n
 		 */
 		if (!gcov_info_is_compatible(node->loaded_info[0], info)) {
 			pr_warning("could not add '%s' (incompatible "
-				   "version)\n", info->filename);
+				   "version)\n", gcov_info_filename(info));
 			kfree(loaded_info);
 			return;
 		}
@@ -692,7 +694,8 @@ static void save_info(struct gcov_node *
 		node->unloaded_info = gcov_info_dup(info);
 		if (!node->unloaded_info) {
 			pr_warning("could not save data for '%s' "
-				   "(out of memory)\n", info->filename);
+				   "(out of memory)\n",
+				   gcov_info_filename(info));
 		}
 	}
 }
@@ -708,7 +711,7 @@ static void remove_info(struct gcov_node
 	i = get_info_index(node, info);
 	if (i < 0) {
 		pr_warning("could not remove '%s' (not found)\n",
-			   info->filename);
+			   gcov_info_filename(info));
 		return;
 	}
 	if (gcov_persist)
@@ -735,7 +738,7 @@ void gcov_event(enum gcov_action action,
 	struct gcov_node *node;
 
 	mutex_lock(&node_lock);
-	node = get_node_by_name(info->filename);
+	node = get_node_by_name(gcov_info_filename(info));
 	switch (action) {
 	case GCOV_ADD:
 		if (node)
@@ -748,7 +751,7 @@ void gcov_event(enum gcov_action action,
 			remove_info(node, info);
 		else {
 			pr_warning("could not remove '%s' (not found)\n",
-				   info->filename);
+				   gcov_info_filename(info));
 		}
 		break;
 	}
diff -puN kernel/gcov/gcc_3_4.c~gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file kernel/gcov/gcc_3_4.c
--- a/kernel/gcov/gcc_3_4.c~gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file
+++ a/kernel/gcov/gcc_3_4.c
@@ -21,6 +21,121 @@
 #include <linux/vmalloc.h>
 #include "gcov.h"
 
+#define GCOV_COUNTERS		5
+
+static struct gcov_info *gcov_info_head;
+
+/**
+ * struct gcov_fn_info - profiling meta data per function
+ * @ident: object file-unique function identifier
+ * @checksum: function checksum
+ * @n_ctrs: number of values per counter type belonging to this function
+ *
+ * This data is generated by gcc during compilation and doesn't change
+ * at run-time.
+ */
+struct gcov_fn_info {
+	unsigned int ident;
+	unsigned int checksum;
+	unsigned int n_ctrs[0];
+};
+
+/**
+ * struct gcov_ctr_info - profiling data per counter type
+ * @num: number of counter values for this type
+ * @values: array of counter values for this type
+ * @merge: merge function for counter values of this type (unused)
+ *
+ * This data is generated by gcc during compilation and doesn't change
+ * at run-time with the exception of the values array.
+ */
+struct gcov_ctr_info {
+	unsigned int	num;
+	gcov_type	*values;
+	void		(*merge)(gcov_type *, unsigned int);
+};
+
+/**
+ * struct gcov_info - profiling data per object file
+ * @version: gcov version magic indicating the gcc version used for compilation
+ * @next: list head for a singly-linked list
+ * @stamp: time stamp
+ * @filename: name of the associated gcov data file
+ * @n_functions: number of instrumented functions
+ * @functions: function data
+ * @ctr_mask: mask specifying which counter types are active
+ * @counts: counter data per counter type
+ *
+ * This data is generated by gcc during compilation and doesn't change
+ * at run-time with the exception of the next pointer.
+ */
+struct gcov_info {
+	unsigned int			version;
+	struct gcov_info		*next;
+	unsigned int			stamp;
+	const char			*filename;
+	unsigned int			n_functions;
+	const struct gcov_fn_info	*functions;
+	unsigned int			ctr_mask;
+	struct gcov_ctr_info		counts[0];
+};
+
+/**
+ * gcov_info_filename - return info filename
+ * @info: profiling data set
+ */
+const char *gcov_info_filename(struct gcov_info *info)
+{
+	return info->filename;
+}
+
+/**
+ * gcov_info_version - return info version
+ * @info: profiling data set
+ */
+unsigned int gcov_info_version(struct gcov_info *info)
+{
+	return info->version;
+}
+
+/**
+ * gcov_info_next - return next profiling data set
+ * @info: profiling data set
+ *
+ * Returns next gcov_info following @info or first gcov_info in the chain if
+ * @info is %NULL.
+ */
+struct gcov_info *gcov_info_next(struct gcov_info *info)
+{
+	if (!info)
+		return gcov_info_head;
+
+	return info->next;
+}
+
+/**
+ * gcov_info_link - link/add profiling data set to the list
+ * @info: profiling data set
+ */
+void gcov_info_link(struct gcov_info *info)
+{
+	info->next = gcov_info_head;
+	gcov_info_head = info;
+}
+
+/**
+ * gcov_info_unlink - unlink/remove profiling data set from the list
+ * @prev: previous profiling data set
+ * @info: profiling data set
+ */
+void gcov_info_unlink(struct gcov_info *prev, struct gcov_info *info)
+{
+	if (prev)
+		prev->next = info->next;
+	else
+		gcov_info_head = info->next;
+}
+
 /* Symbolic links to be created for each profiling data file. */
 const struct gcov_link gcov_link[] = {
 	{ OBJ_TREE, "gcno" },	/* Link to .gcno file in $(objtree). */
diff -puN kernel/gcov/gcov.h~gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file kernel/gcov/gcov.h
--- a/kernel/gcov/gcov.h~gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file
+++ a/kernel/gcov/gcov.h
@@ -21,7 +21,6 @@
  * gcc and need to be kept as close to the original definition as possible to
  * remain compatible.
  */
-#define GCOV_COUNTERS		5
 #define GCOV_DATA_MAGIC		((unsigned int) 0x67636461)
 #define GCOV_TAG_FUNCTION	((unsigned int) 0x01000000)
 #define GCOV_TAG_COUNTER_BASE	((unsigned int) 0x01a10000)
@@ -34,60 +33,18 @@ typedef long gcov_type;
 typedef long long gcov_type;
 #endif
 
-/**
- * struct gcov_fn_info - profiling meta data per function
- * @ident: object file-unique function identifier
- * @checksum: function checksum
- * @n_ctrs: number of values per counter type belonging to this function
- *
- * This data is generated by gcc during compilation and doesn't change
- * at run-time.
- */
-struct gcov_fn_info {
-	unsigned int ident;
-	unsigned int checksum;
-	unsigned int n_ctrs[0];
-};
-
-/**
- * struct gcov_ctr_info - profiling data per counter type
- * @num: number of counter values for this type
- * @values: array of counter values for this type
- * @merge: merge function for counter values of this type (unused)
- *
- * This data is generated by gcc during compilation and doesn't change
- * at run-time with the exception of the values array.
- */
-struct gcov_ctr_info {
-	unsigned int	num;
-	gcov_type	*values;
-	void		(*merge)(gcov_type *, unsigned int);
-};
+/* Opaque gcov_info. The gcov structures can change as for example in gcc 4.7 so
+ * we cannot use full definition here and they need to be placed in gcc specific
+ * implementation of gcov. This also means no direct access to the members in
+ * generic code and usage of the interface below.*/
+struct gcov_info;
 
-/**
- * struct gcov_info - profiling data per object file
- * @version: gcov version magic indicating the gcc version used for compilation
- * @next: list head for a singly-linked list
- * @stamp: time stamp
- * @filename: name of the associated gcov data file
- * @n_functions: number of instrumented functions
- * @functions: function data
- * @ctr_mask: mask specifying which counter types are active
- * @counts: counter data per counter type
- *
- * This data is generated by gcc during compilation and doesn't change
- * at run-time with the exception of the next pointer.
- */
-struct gcov_info {
-	unsigned int			version;
-	struct gcov_info		*next;
-	unsigned int			stamp;
-	const char			*filename;
-	unsigned int			n_functions;
-	const struct gcov_fn_info	*functions;
-	unsigned int			ctr_mask;
-	struct gcov_ctr_info		counts[0];
-};
+/* Interface to access gcov_info data  */
+const char *gcov_info_filename(struct gcov_info *info);
+unsigned int gcov_info_version(struct gcov_info *info);
+struct gcov_info *gcov_info_next(struct gcov_info *info);
+void gcov_info_link(struct gcov_info *info);
+void gcov_info_unlink(struct gcov_info *prev, struct gcov_info *info);
 
 /* Base interface. */
 enum gcov_action {
_

Patches currently in -mm which might be from fhrbata@redhat.com are

gcov-move-gcov-structs-definitions-to-a-gcc-version-specific-file.patch
gcov-add-support-for-gcc-47-gcov-format.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-compile-specific-gcov-implementation-based-on-gcc-version.patch
kernel-add-support-for-init_array-constructors.patch

