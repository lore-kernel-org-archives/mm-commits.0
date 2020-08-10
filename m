Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A6BC433DF
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 784FE2075D
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026893;
	bh=2liunJZPPdqTOXHuz718bS2M5/pZQVWWsM2iuxbrirc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=kdhRpDoAxbGZm4paYxIKdnyciyulH+C32H9JZoe+EJsxD3MuUYJ0eS99EVtWsl/Yn
	 AS6jYkPanqquppRr5zIVOJ5mOgSbUkrie2a8AVKHFmndGGy0rTh/73uKfsS8AoDl59
	 fkokg/4D/SCZdYhz+MH5c2s82nK8vL2nDv50WIbQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgHJCex (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:34:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCex (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:34:53 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A665A206CD;
        Mon, 10 Aug 2020 02:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026891;
        bh=2liunJZPPdqTOXHuz718bS2M5/pZQVWWsM2iuxbrirc=;
        h=Date:From:To:Subject:From;
        b=1VT4APJzaNI9vdjMxy32FyXmBW8pcfkiLL5qceiJnGUaJNH0XC6meTqHv5Ciqhc1z
         QOoWTJQ0o4OTnsV+iV25jsgElo36XX/yqJGYSdEL3EDi3cVCAuEOCEYVJVExsg3rOr
         fX66edDuCA9I30l38GfLVuUS1iufjLEYNpyJGU9Q=
Date:   Sun, 09 Aug 2020 19:34:50 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jannh@google.com, keescook@chromium.org,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz, vjitta@codeaurora.org
Subject:  [merged]
 mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch removed from -mm
 tree
Message-ID: <20200810023450.axOOeILwj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: extend slub_debug syntax for multiple blocks
has been removed from the -mm tree.  Its filename was
     mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[weiyongjun1@huawei.com: make parse_slub_debug_flags() static]
  Link: http://lkml.kernel.org/r/20200702150522.4940-1-weiyongjun1@huawei.com
Link: http://lkml.kernel.org/r/20200610163135.17364-2-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
@@ -4689,7 +4689,7 @@
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
+static char *
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


