From: akpm@linux-foundation.org
Subject: [merged] kernel-doc-dont-mangle-whitespace-in-example-section.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:19:01 -0700
Message-ID: <20121005201901.C9D881E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:60924 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2JEUTC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:19:02 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so236358ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:19:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.santos@pobox.com, mmarek@suse.cz, rdunlap@xenotime.net, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-doc: don't mangle whitespace in Example section
has been removed from the -mm tree.  Its filename was
     kernel-doc-dont-mangle-whitespace-in-example-section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daniel Santos <daniel.santos@pobox.com>
Subject: kernel-doc: don't mangle whitespace in Example section

A section with the name "Example" (case-insensitive) has a special meaning
to kernel-doc.  These sections are output using mono-type fonts.  However,
leading whitespace is stripped, thus robbing a lot of meaning from this,
as indented code examples will be mangled.

This patch preserves the leading whitespace for "Example" sections.  More
accurately, it preserves it for all sections, but removes it later if the
section isn't an "Example" section.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN scripts/kernel-doc~kernel-doc-dont-mangle-whitespace-in-example-section scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-dont-mangle-whitespace-in-example-section
+++ a/scripts/kernel-doc
@@ -281,9 +281,10 @@ my $doc_special = "\@\%\$\&";
 my $doc_start = '^/\*\*\s*$'; # Allow whitespace at end of comment start.
 my $doc_end = '\*/';
 my $doc_com = '\s*\*\s*';
+my $doc_com_body = '\s*\* ?';
 my $doc_decl = $doc_com . '(\w+)';
 my $doc_sect = $doc_com . '([' . $doc_special . ']?[\w\s]+):(.*)';
-my $doc_content = $doc_com . '(.*)';
+my $doc_content = $doc_com_body . '(.*)';
 my $doc_block = $doc_com . 'DOC:\s*(.*)?';
 
 my %constants;
@@ -460,6 +461,9 @@ sub output_highlight {
 #   print STDERR "contents af:$contents\n";
 
     foreach $line (split "\n", $contents) {
+	if (! $output_preformatted) {
+	    $line =~ s/^\s*//;
+	}
 	if ($line eq ""){
 	    if (! $output_preformatted) {
 		print $lineprefix, local_unescape($blankline);
@@ -2085,7 +2089,7 @@ sub process_file($) {
 		    $descr= $1;
 		    $descr =~ s/^\s*//;
 		    $descr =~ s/\s*$//;
-		    $descr =~ s/\s+/ /;
+		    $descr =~ s/\s+/ /g;
 		    $declaration_purpose = xml_escape($descr);
 		    $in_purpose = 1;
 		} else {
@@ -2177,6 +2181,7 @@ sub process_file($) {
 		    # Continued declaration purpose
 		    chomp($declaration_purpose);
 		    $declaration_purpose .= " " . xml_escape($1);
+		    $declaration_purpose =~ s/\s+/ /g;
 		} else {
 		    $contents .= $1 . "\n";
 		}
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

