From: akpm@linux-foundation.org
Subject: + kernel-doc-bugfix-empty-line-in-example-section.patch added to -mm tree
Date: Mon, 01 Oct 2012 14:21:34 -0700
Message-ID: <20121001212135.5656D100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:55715 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab2JAVVg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 17:21:36 -0400
Received: by ghbz15 with SMTP id z15so705387ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 14:21:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: daniel.santos@pobox.com, mmarek@suse.cz, rdunlap@xenotime.net


The patch titled
     Subject: kernel-doc: bugfix - empty line in Example section
has been added to the -mm tree.  Its filename is
     kernel-doc-bugfix-empty-line-in-example-section.patch

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
Subject: kernel-doc: bugfix - empty line in Example section

If you have a section named "Example" that contains an empty line,
attempting to generate htmldocs give you the error:

/path/Documentation/DocBook/kernel-api.xml:3455: parser error : Opening and ending tag mismatch: programlisting line 3449 and para
   </para><para>
          ^
/path/Documentation/DocBook/kernel-api.xml:3473: parser error : Opening and ending tag mismatch: para line 3467 and programlisting
</programlisting></informalexample>
                 ^
/path/Documentation/DocBook/kernel-api.xml:3678: parser error : Opening and ending tag mismatch: programlisting line 3672 and para
   </para><para>
          ^
/path/Documentation/DocBook/kernel-api.xml:3701: parser error : Opening and ending tag mismatch: para line 3690 and programlisting
</programlisting></informalexample>
                 ^
unable to parse
/path/Documentation/DocBook/kernel-api.xml

Essentially, the script attempts to close a <programlisting> with a
closing tag for a <para> block.  This patch corrects the problem by
simply not outputting anything extra when we're dumping pre-formatted
text, since the empty line will be rendered correctly anyway.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kernel-doc |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN scripts/kernel-doc~kernel-doc-bugfix-empty-line-in-example-section scripts/kernel-doc
--- a/scripts/kernel-doc~kernel-doc-bugfix-empty-line-in-example-section
+++ a/scripts/kernel-doc
@@ -245,6 +245,7 @@ my $dohighlight = "";
 
 my $verbose = 0;
 my $output_mode = "man";
+my $output_preformatted = 0;
 my $no_doc_sections = 0;
 my %highlights = %highlights_man;
 my $blankline = $blankline_man;
@@ -486,7 +487,9 @@ sub output_highlight {
     }
     foreach $line (split "\n", $contents) {
 	if ($line eq ""){
-	    print $lineprefix, local_unescape($blankline);
+	    if (! $output_preformatted) {
+		print $lineprefix, local_unescape($blankline);
+	    }
 	} else {
 	    $line =~ s/\\\\\\/\&/g;
 	    if ($output_mode eq "man" && substr($line, 0, 1) eq ".") {
@@ -902,10 +905,12 @@ sub output_section_xml(%) {
 	print "<title>$section</title>\n";
 	if ($section =~ m/EXAMPLE/i) {
 	    print "<informalexample><programlisting>\n";
+	    $output_preformatted = 1;
 	} else {
 	    print "<para>\n";
 	}
 	output_highlight($args{'sections'}{$section});
+	$output_preformatted = 0;
 	if ($section =~ m/EXAMPLE/i) {
 	    print "</programlisting></informalexample>\n";
 	} else {
@@ -1208,10 +1213,12 @@ sub output_blockhead_xml(%) {
 	}
 	if ($section =~ m/EXAMPLE/i) {
 	    print "<example><para>\n";
+	    $output_preformatted = 1;
 	} else {
 	    print "<para>\n";
 	}
 	output_highlight($args{'sections'}{$section});
+	$output_preformatted = 0;
 	if ($section =~ m/EXAMPLE/i) {
 	    print "</para></example>\n";
 	} else {
@@ -1287,10 +1294,12 @@ sub output_function_gnome {
 	print "<simplesect>\n <title>$section</title>\n";
 	if ($section =~ m/EXAMPLE/i) {
 	    print "<example><programlisting>\n";
+	    $output_preformatted = 1;
 	} else {
 	}
 	print "<para>\n";
 	output_highlight($args{'sections'}{$section});
+	$output_preformatted = 0;
 	print "</para>\n";
 	if ($section =~ m/EXAMPLE/i) {
 	    print "</programlisting></example>\n";
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

