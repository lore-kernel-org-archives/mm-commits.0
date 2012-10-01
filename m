From: akpm@linux-foundation.org
Subject: + kernel-doc-dont-mangle-whitespace-in-example-section.patch added to -mm tree
Date: Mon, 01 Oct 2012 14:21:38 -0700
Message-ID: <20121001212139.926FA20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:58693 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab2JAVVm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 17:21:42 -0400
Received: by wibhr7 with SMTP id hr7so1130wib.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 14:21:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.santos@pobox.com, mmarek@suse.cz, rdunlap@xenotime.net


The patch titled
     Subject: kernel-doc: don't mangle whitespace in Example section
has been added to the -mm tree.  Its filename is
     kernel-doc-dont-mangle-whitespace-in-example-section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -296,9 +296,10 @@ my $doc_special = "\@\%\$\&";
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
@@ -486,6 +487,9 @@ sub output_highlight {
 	$contents =~ s/\s+$//;
     }
     foreach $line (split "\n", $contents) {
+	if (! $output_preformatted) {
+	    $line =~ s/^\s*//;
+	}
 	if ($line eq ""){
 	    if (! $output_preformatted) {
 		print $lineprefix, local_unescape($blankline);
@@ -2344,7 +2348,7 @@ sub process_file($) {
 		    $descr= $1;
 		    $descr =~ s/^\s*//;
 		    $descr =~ s/\s*$//;
-		    $descr =~ s/\s+/ /;
+		    $descr =~ s/\s+/ /g;
 		    $declaration_purpose = xml_escape($descr);
 		    $in_purpose = 1;
 		} else {
@@ -2436,6 +2440,7 @@ sub process_file($) {
 		    # Continued declaration purpose
 		    chomp($declaration_purpose);
 		    $declaration_purpose .= " " . xml_escape($1);
+		    $declaration_purpose =~ s/\s+/ /g;
 		} else {
 		    $contents .= $1 . "\n";
 		}
_

Patches currently in -mm which might be from daniel.santos@pobox.com are

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
kernel-doc-bugfix-multi-line-macros.patch
kernel-doc-bugfix-empty-line-in-example-section.patch
kernel-doc-dont-mangle-whitespace-in-example-section.patch

