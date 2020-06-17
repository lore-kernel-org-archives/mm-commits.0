From: akpm@linux-foundation.org
Subject: +
 mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch added to -mm tree
Date: Wed, 17 Jun 2020 09:57:01 -0700
Message-ID: <20200617165701.N5Fq5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726540AbgFQQ5E (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 12:57:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, rientjes@google.com, penberg@kernel.org, keescook@chromium.org, jannh@google.com, iamjoonsoo.kim@lge.com, guro@fb.com, cl@linux.com, vbabka@suse.cz


The patch titled
     Subject: mm, slub: extend slub_debug syntax for multiple blocks
has been added to the -mm tree.  Its filename is
     mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: extend slub_debug syntax for multiple blocks

Patch series "slub_debug fixes and improvements".


The slub_debug kernel boot parameter can either apply a single set of
options to all caches or a list of caches.  There is a use case where
debugging is applied for all caches and then disabled at runtime for
specific caches, for performance and memory consumption reasons [1].  As
runtime changes are dangerous, extend the boot parameter syntax so that
multiple blocks of either global or slab-specific options can be
specified, with blocks delimited by ';'.  This will also support the use
case of [1] without runtime changes.

For details see the updated Documentation/vm/slub.rst

[1] https://lore.kernel.org/r/1383cd32-1ddc-4dac-b5f8-9c42282fa81c@codeaurora.org

Link: http://lkml.kernel.org/r/20200610163135.17364-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Jann Horn <jannh@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    2 
 Documentation/vm/slub.rst                       |   18 +
 mm/slub.c                                       |  179 +++++++++-----
 3 files changed, 146 insertions(+), 53 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-slub-extend-slub_debug-syntax-for-multiple-blocks
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4604,7 +4604,7 @@
 			fragmentation.  Defaults to 1 for systems with
 			more than 32MB of RAM, 0 otherwise.
 
-	slub_debug[=options[,slabs]]	[MM, SLUB]
+	slub_debug[=options[,slabs][;[options[,slabs]]...]	[MM, SLUB]
 			Enabling slub_debug allows one to determine the
 			culprit if slab objects become corrupted. Enabling
 			slub_debug can create guard zones around objects and
--- a/Documentation/vm/slub.rst~mm-slub-extend-slub_debug-syntax-for-multiple-blocks
+++ a/Documentation/vm/slub.rst
@@ -41,6 +41,11 @@ slub_debug=<Debug-Options>,<slab name1>,
 	Enable options only for select slabs (no spaces
 	after a comma)
 
+Multiple blocks of options for all slabs or selected slabs can be given, with
+blocks of options delimited by ';'. The last of "all slabs" blocks is applied
+to all slabs except those that match one of the "select slabs" block. Options
+of the first "select slabs" blocks that matches the slab's name are applied.
+
 Possible debug options are::
 
 	F		Sanity checks on (enables SLAB_DEBUG_CONSISTENCY_CHECKS
@@ -83,6 +88,19 @@ switch off debugging for such caches by
 
 	slub_debug=O
 
+You can apply different options to different list of slab names, using blocks
+of options. This will enable red zoning for dentry and user tracking for
+kmalloc. All other slabs will not get any debugging enabled::
+
+	slub_debug=Z,dentry;U,kmalloc-*
+
+You can also enable options (e.g. sanity checks and poisoning) for all caches
+except some that are deemed too performance critical and don't need to be
+debugged by specifying global debug options followed by a list of slab names
+with "-" as options::
+
+	slub_debug=FZ;-,zs_handle,zspage
+
 In case you forgot to enable debugging on the kernel command line: It is
 possible to enable debugging manually when the kernel is up. Look at the
 contents of::
--- a/mm/slub.c~mm-slub-extend-slub_debug-syntax-for-multiple-blocks
+++ a/mm/slub.c
@@ -499,7 +499,7 @@ static slab_flags_t slub_debug = DEBUG_D
 static slab_flags_t slub_debug;
 #endif
 
-static char *slub_debug_slabs;
+static char *slub_debug_string;
 static int disable_higher_order_debug;
 
 /*
@@ -1262,68 +1262,132 @@ out:
 	return ret;
 }
 
-static int __init setup_slub_debug(char *str)
+/*
+ * Parse a block of slub_debug options. Blocks are delimited by ';'
+ *
+ * @str:    start of block
+ * @flags:  returns parsed flags, or DEBUG_DEFAULT_FLAGS if none specified
+ * @slabs:  return start of list of slabs, or NULL when there's no list
+ * @init:   assume this is initial parsing and not per-kmem-create parsing
+ *
+ * returns the start of next block if there's any, or NULL
+ */
+char *
+parse_slub_debug_flags(char *str, slab_flags_t *flags, char **slabs, bool init)
 {
-	slub_debug = DEBUG_DEFAULT_FLAGS;
-	if (*str++ != '=' || !*str)
-		/*
-		 * No options specified. Switch on full debugging.
-		 */
-		goto out;
+	bool higher_order_disable = false;
 
-	if (*str == ',')
+	/* Skip any completely empty blocks */
+	while (*str && *str == ';')
+		str++;
+
+	if (*str == ',') {
 		/*
 		 * No options but restriction on slabs. This means full
 		 * debugging for slabs matching a pattern.
 		 */
+		*flags = DEBUG_DEFAULT_FLAGS;
 		goto check_slabs;
+	}
+	*flags = 0;
 
-	slub_debug = 0;
-	if (*str == '-')
-		/*
-		 * Switch off all debugging measures.
-		 */
-		goto out;
-
-	/*
-	 * Determine which debug features should be switched on
-	 */
-	for (; *str && *str != ','; str++) {
+	/* Determine which debug features should be switched on */
+	for (; *str && *str != ',' && *str != ';'; str++) {
 		switch (tolower(*str)) {
+		case '-':
+			*flags = 0;
+			break;
 		case 'f':
-			slub_debug |= SLAB_CONSISTENCY_CHECKS;
+			*flags |= SLAB_CONSISTENCY_CHECKS;
 			break;
 		case 'z':
-			slub_debug |= SLAB_RED_ZONE;
+			*flags |= SLAB_RED_ZONE;
 			break;
 		case 'p':
-			slub_debug |= SLAB_POISON;
+			*flags |= SLAB_POISON;
 			break;
 		case 'u':
-			slub_debug |= SLAB_STORE_USER;
+			*flags |= SLAB_STORE_USER;
 			break;
 		case 't':
-			slub_debug |= SLAB_TRACE;
+			*flags |= SLAB_TRACE;
 			break;
 		case 'a':
-			slub_debug |= SLAB_FAILSLAB;
+			*flags |= SLAB_FAILSLAB;
 			break;
 		case 'o':
 			/*
 			 * Avoid enabling debugging on caches if its minimum
 			 * order would increase as a result.
 			 */
-			disable_higher_order_debug = 1;
+			higher_order_disable = true;
 			break;
 		default:
-			pr_err("slub_debug option '%c' unknown. skipped\n",
-			       *str);
+			if (init)
+				pr_err("slub_debug option '%c' unknown. skipped\n", *str);
 		}
 	}
-
 check_slabs:
 	if (*str == ',')
-		slub_debug_slabs = str + 1;
+		*slabs = ++str;
+	else
+		*slabs = NULL;
+
+	/* Skip over the slab list */
+	while (*str && *str != ';')
+		str++;
+
+	/* Skip any completely empty blocks */
+	while (*str && *str == ';')
+		str++;
+
+	if (init && higher_order_disable)
+		disable_higher_order_debug = 1;
+
+	if (*str)
+		return str;
+	else
+		return NULL;
+}
+
+static int __init setup_slub_debug(char *str)
+{
+	slab_flags_t flags;
+	char *saved_str;
+	char *slab_list;
+	bool global_slub_debug_changed = false;
+	bool slab_list_specified = false;
+
+	slub_debug = DEBUG_DEFAULT_FLAGS;
+	if (*str++ != '=' || !*str)
+		/*
+		 * No options specified. Switch on full debugging.
+		 */
+		goto out;
+
+	saved_str = str;
+	while (str) {
+		str = parse_slub_debug_flags(str, &flags, &slab_list, true);
+
+		if (!slab_list) {
+			slub_debug = flags;
+			global_slub_debug_changed = true;
+		} else {
+			slab_list_specified = true;
+		}
+	}
+
+	/*
+	 * For backwards compatibility, a single list of flags with list of
+	 * slabs means debugging is only enabled for those slabs, so the global
+	 * slub_debug should be 0. We can extended that to multiple lists as
+	 * long as there is no option specifying flags without a slab list.
+	 */
+	if (slab_list_specified) {
+		if (!global_slub_debug_changed)
+			slub_debug = 0;
+		slub_debug_string = saved_str;
+	}
 out:
 	if ((static_branch_unlikely(&init_on_alloc) ||
 	     static_branch_unlikely(&init_on_free)) &&
@@ -1352,36 +1416,47 @@ slab_flags_t kmem_cache_flags(unsigned i
 {
 	char *iter;
 	size_t len;
+	char *next_block;
+	slab_flags_t block_flags;
 
 	/* If slub_debug = 0, it folds into the if conditional. */
-	if (!slub_debug_slabs)
+	if (!slub_debug_string)
 		return flags | slub_debug;
 
 	len = strlen(name);
-	iter = slub_debug_slabs;
-	while (*iter) {
-		char *end, *glob;
-		size_t cmplen;
-
-		end = strchrnul(iter, ',');
-
-		glob = strnchr(iter, end - iter, '*');
-		if (glob)
-			cmplen = glob - iter;
-		else
-			cmplen = max_t(size_t, len, (end - iter));
+	next_block = slub_debug_string;
+	/* Go through all blocks of debug options, see if any matches our slab's name */
+	while (next_block) {
+		next_block = parse_slub_debug_flags(next_block, &block_flags, &iter, false);
+		if (!iter)
+			continue;
+		/* Found a block that has a slab list, search it */
+		while (*iter) {
+			char *end, *glob;
+			size_t cmplen;
+
+			end = strchrnul(iter, ',');
+			if (next_block && next_block < end)
+				end = next_block - 1;
+
+			glob = strnchr(iter, end - iter, '*');
+			if (glob)
+				cmplen = glob - iter;
+			else
+				cmplen = max_t(size_t, len, (end - iter));
 
-		if (!strncmp(name, iter, cmplen)) {
-			flags |= slub_debug;
-			break;
-		}
+			if (!strncmp(name, iter, cmplen)) {
+				flags |= block_flags;
+				return flags;
+			}
 
-		if (!*end)
-			break;
-		iter = end + 1;
+			if (!*end || *end == ';')
+				break;
+			iter = end + 1;
+		}
 	}
 
-	return flags;
+	return slub_debug;
 }
 #else /* !CONFIG_SLUB_DEBUG */
 static inline void setup_object_debug(struct kmem_cache *s,
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch
mm-slub-make-some-slub_debug-related-attributes-read-only.patch
mm-slub-remove-runtime-allocation-order-changes.patch
mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch
mm-slub-make-reclaim_account-attribute-read-only.patch
mm-slub-introduce-static-key-for-slub_debug.patch
mm-slub-introduce-kmem_cache_debug_flags.patch
mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch
mm-slab-slub-move-and-improve-cache_from_obj.patch
