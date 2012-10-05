From: akpm@linux-foundation.org
Subject: [merged] kernel-doc-bugfix-multi-line-macros.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:18:54 -0700
Message-ID: <20121005201855.1BFBB200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:51688 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2JEUS5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:18:57 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so138460fae.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:18:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, mmarek@suse.cz, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-doc: bugfix - multi-line macros
has been removed from the -mm tree.  Its filename was
     kernel-doc-bugfix-multi-line-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: kernel-doc: bugfix - multi-line macros

Prior to this patch the following code breaks:

/**
 * multiline_example - this breaks kernel-doc
 */
 #define multiline_example( \
myparam)

Producing this error:

Error(somefile.h:983): cannot understand prototype: 'multiline_example( \ '

This patch fixes the issue by appending all lines ending in a blackslash
(optionally followed by whitespace), removing the backslash and any
whitespace after it prior to appending (just like the C pre-processor
would).

This fixes a break in kerel-doc introduced by the additions to rbtree.h.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/kernel-doc~kernel-doc-bugfix-multi-line-macros scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-bugfix-multi-line-macros
+++ a/scripts/kernel-doc
@@ -2046,6 +2046,9 @@ sub process_file($) {
 
     $section_counter = 0;
     while (<IN>) {
+	while (s/\\\s*$//) {
+	    $_ .= <IN>;
+	}
 	if ($state == 0) {
 	    if (/$doc_start/o) {
 		$state = 1;		# next line is always the function name
_

Patches currently in -mm which might be from daniel.santos@pobox.com are

origin.patch
rbtree-reference-documentation-rbtreetxt-for-usage-instructions.patch
rbtree-empty-nodes-have-no-color.patch
rbtree-fix-incorrect-rbtree-node-insertion-in-fs-proc-proc_sysctlc.patch
rbtree-move-some-implementation-details-from-rbtreeh-to-rbtreec.patch
rbtree-performance-and-correctness-test.patch
rbtree-break-out-of-rb_insert_color-loop-after-tree-rotation.patch
rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary.patch
rbtree-low-level-optimizations-in-rb_insert_color.patch
rbtree-adjust-node-color-in-__rb_erase_color-only-when-necessary.patch
rbtree-optimize-case-selection-logic-in-__rb_erase_color.patch
rbtree-low-level-optimizations-in-__rb_erase_color.patch
rbtree-coding-style-adjustments.patch
rbtree-optimize-fetching-of-sibling-node.patch
mm-interval-tree-updates.patch
mm-anon-rmap-remove-anon_vma_moveto_tail.patch
mm-anon-rmap-replace-same_anon_vma-linked-list-with-an-interval-tree.patch
mm-rmap-remove-vma_address-check-for-address-inside-vma.patch
mm-add-config_debug_vm_rb-build-option.patch
mm-avoid-taking-rmap-locks-in-move_ptes.patch

