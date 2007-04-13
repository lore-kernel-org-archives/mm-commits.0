From: akpm@linux-foundation.org
Subject: + kernel-doc-fix-plisth-comments.patch added to -mm tree
Date: Fri, 13 Apr 2007 11:48:05 -0700
Message-ID: <200704131848.l3DIm5kW006769@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45821 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133AbXDMSsr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 14:48:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, dwalker@mvista.com, inaky.perez-gonzalez@intel.com, oleg@tv-sign.ru, tglx@linutronix.de


The patch titled
     kernel-doc: fix plist.h comments
has been added to the -mm tree.  Its filename is
     kernel-doc-fix-plisth-comments.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-doc: fix plist.h comments
From: Randy Dunlap <randy.dunlap@oracle.com>

Make kernel-doc comments match macro names.
Correct parameter names in a few places.
Remove '#' from beginning of kernel-doc comment macro names.
Remove extra (erroneous) blank lines in kernel-doc.

Warning(plist.h:100): Cannot understand  * #PLIST_HEAD_INIT - static struct plist_head initializer on line 100 - I thought it was a doc line
Warning(plist.h:112): Cannot understand  * #PLIST_NODE_INIT - static struct plist_node initializer on line 112 - I thought it was a doc line
Warning(plist.h:103): No description found for parameter '_lock'
Warning(plist.h:129): No description found for parameter 'lock'
Warning(plist.h:158): No description found for parameter 'pos'
Warning(plist.h:169): No description found for parameter 'pos'
Warning(plist.h:169): No description found for parameter 'n'
Warning(plist.h:179): No description found for parameter 'mem'

This still leaves one warning & one error that need attention:
Error(plist.h:219): cannot understand prototype: '('
Warning(plist.h): no structured comments found

Acked-by: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/plist.h |   54 +++++++++++++++++-----------------------
 1 files changed, 23 insertions(+), 31 deletions(-)

diff -puN include/linux/plist.h~kernel-doc-fix-plisth-comments include/linux/plist.h
--- a/include/linux/plist.h~kernel-doc-fix-plisth-comments
+++ a/include/linux/plist.h
@@ -97,9 +97,9 @@ struct plist_node {
 #endif
 
 /**
- * #PLIST_HEAD_INIT - static struct plist_head initializer
- *
+ * PLIST_HEAD_INIT - static struct plist_head initializer
  * @head:	struct plist_head variable name
+ * @_lock:	lock to initialize for this list
  */
 #define PLIST_HEAD_INIT(head, _lock)			\
 {							\
@@ -109,8 +109,7 @@ struct plist_node {
 }
 
 /**
- * #PLIST_NODE_INIT - static struct plist_node initializer
- *
+ * PLIST_NODE_INIT - static struct plist_node initializer
  * @node:	struct plist_node variable name
  * @__prio:	initial node priority
  */
@@ -122,8 +121,8 @@ struct plist_node {
 
 /**
  * plist_head_init - dynamic struct plist_head initializer
- *
  * @head:	&struct plist_head pointer
+ * @lock:	list spinlock, remembered for debugging
  */
 static inline void
 plist_head_init(struct plist_head *head, spinlock_t *lock)
@@ -137,7 +136,6 @@ plist_head_init(struct plist_head *head,
 
 /**
  * plist_node_init - Dynamic struct plist_node initializer
- *
  * @node:	&struct plist_node pointer
  * @prio:	initial node priority
  */
@@ -152,49 +150,46 @@ extern void plist_del(struct plist_node 
 
 /**
  * plist_for_each - iterate over the plist
- *
- * @pos1:	the type * to use as a loop counter.
- * @head:	the head for your list.
+ * @pos:	the type * to use as a loop counter
+ * @head:	the head for your list
  */
 #define plist_for_each(pos, head)	\
 	 list_for_each_entry(pos, &(head)->node_list, plist.node_list)
 
 /**
- * plist_for_each_entry_safe - iterate over a plist of given type safe
- * against removal of list entry
+ * plist_for_each_safe - iterate safely over a plist of given type
+ * @pos:	the type * to use as a loop counter
+ * @n:	another type * to use as temporary storage
+ * @head:	the head for your list
  *
- * @pos1:	the type * to use as a loop counter.
- * @n1:	another type * to use as temporary storage
- * @head:	the head for your list.
+ * Iterate over a plist of given type, safe against removal of list entry.
  */
 #define plist_for_each_safe(pos, n, head)	\
 	 list_for_each_entry_safe(pos, n, &(head)->node_list, plist.node_list)
 
 /**
  * plist_for_each_entry	- iterate over list of given type
- *
- * @pos:	the type * to use as a loop counter.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
+ * @pos:	the type * to use as a loop counter
+ * @head:	the head for your list
+ * @mem:	the name of the list_struct within the struct
  */
 #define plist_for_each_entry(pos, head, mem)	\
 	 list_for_each_entry(pos, &(head)->node_list, mem.plist.node_list)
 
 /**
- * plist_for_each_entry_safe - iterate over list of given type safe against
- * removal of list entry
- *
- * @pos:	the type * to use as a loop counter.
+ * plist_for_each_entry_safe - iterate safely over list of given type
+ * @pos:	the type * to use as a loop counter
  * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @m:		the name of the list_struct within the struct.
+ * @head:	the head for your list
+ * @m:		the name of the list_struct within the struct
+ *
+ * Iterate over list of given type, safe against removal of list entry.
  */
 #define plist_for_each_entry_safe(pos, n, head, m)	\
 	list_for_each_entry_safe(pos, n, &(head)->node_list, m.plist.node_list)
 
 /**
  * plist_head_empty - return !0 if a plist_head is empty
- *
  * @head:	&struct plist_head pointer
  */
 static inline int plist_head_empty(const struct plist_head *head)
@@ -204,7 +199,6 @@ static inline int plist_head_empty(const
 
 /**
  * plist_node_empty - return !0 if plist_node is not on a list
- *
  * @node:	&struct plist_node pointer
  */
 static inline int plist_node_empty(const struct plist_node *node)
@@ -216,10 +210,9 @@ static inline int plist_node_empty(const
 
 /**
  * plist_first_entry - get the struct for the first entry
- *
- * @ptr:	the &struct plist_head pointer.
- * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_struct within the struct.
+ * @head:	the &struct plist_head pointer
+ * @type:	the type of the struct this is embedded in
+ * @member:	the name of the list_struct within the struct
  */
 #ifdef CONFIG_DEBUG_PI_LIST
 # define plist_first_entry(head, type, member)	\
@@ -234,7 +227,6 @@ static inline int plist_node_empty(const
 
 /**
  * plist_first - return the first node (and thus, highest priority)
- *
  * @head:	the &struct plist_head pointer
  *
  * Assumes the plist is _not_ empty.
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

fix-kernel-oops-with-badly-formatted-module-option.patch
kernel-doc-fix-plisth-comments.patch
git-acpi.patch
git-drm.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
git-netdev-all.patch
8250_pci-fix-pci-must_checks.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
fix-mtrr-sections.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
kprobes-fix-sparse-null-warning.patch
header-cleaning-dont-include-smp_lockh-when-not-used.patch
expose-range-checking-functions-from-arch-specific.patch
expose-range-checking-functions-from-arch-specific-update.patch
parport_serial-fix-pci-must_checks.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
kernel-doc-handle-arrays-with-arithmetic-expressions-as.patch
generate-main-index-page-when-building-htmldocs.patch
alphabetically-sorted-entries-in.patch
kernel-doc-html-mode-struct-highlights.patch
ext4-use-null-for-pointers.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
s3fb-fix-pci-must_checks.patch
profile-likely-unlikely-macros.patch
