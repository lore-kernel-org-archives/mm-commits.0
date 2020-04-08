From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-prefer-fallthrough-over-fallthrough-comments.patch removed from
 -mm tree
Date: Tue, 07 Apr 2020 19:01:32 -0700
Message-ID: <20200408020132.4oTJqijwP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgDHCBd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: prefer fallthrough; over fallthrough comments
has been removed from the -mm tree.  Its filename was
     checkpatch-prefer-fallthrough-over-fallthrough-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: prefer fallthrough; over fallthrough comments

commit 294f69e662d1 ("compiler_attributes.h: Add 'fallthrough' pseudo
keyword for switch/case use") added the pseudo keyword so add a test for
it to checkpatch.

Warn on a patch or use --strict for files.

Link: http://lkml.kernel.org/r/8b6c1b9031ab9f3cdebada06b8d46467f1492d68.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-prefer-fallthrough-over-fallthrough-comments
+++ a/scripts/checkpatch.pl
@@ -2294,6 +2294,19 @@ sub pos_last_openparen {
 	return length(expand_tabs(substr($line, 0, $last_openparen))) + 1;
 }
 
+sub get_raw_comment {
+	my ($line, $rawline) = @_;
+	my $comment = '';
+
+	for my $i (0 .. (length($line) - 1)) {
+		if (substr($line, $i, 1) eq "$;") {
+			$comment .= substr($rawline, $i, 1);
+		}
+	}
+
+	return $comment;
+}
+
 sub process {
 	my $filename = shift;
 
@@ -2455,6 +2468,7 @@ sub process {
 		$sline =~ s/$;/ /g;	#with comments as spaces
 
 		my $rawline = $rawlines[$linenr - 1];
+		my $raw_comment = get_raw_comment($line, $rawline);
 
 # check if it's a mode change, rename or start of a patch
 		if (!$in_commit_log &&
@@ -6408,6 +6422,28 @@ sub process {
 			}
 		}
 
+# check for /* fallthrough */ like comment, prefer fallthrough;
+		my @fallthroughs = (
+			'fallthrough',
+			'@fallthrough@',
+			'lint -fallthrough[ \t]*',
+			'intentional(?:ly)?[ \t]*fall(?:(?:s | |-)[Tt]|t)hr(?:ough|u|ew)',
+			'(?:else,?\s*)?FALL(?:S | |-)?THR(?:OUGH|U|EW)[ \t.!]*(?:-[^\n\r]*)?',
+			'Fall(?:(?:s | |-)[Tt]|t)hr(?:ough|u|ew)[ \t.!]*(?:-[^\n\r]*)?',
+			'fall(?:s | |-)?thr(?:ough|u|ew)[ \t.!]*(?:-[^\n\r]*)?',
+		    );
+		if ($raw_comment ne '') {
+			foreach my $ft (@fallthroughs) {
+				if ($raw_comment =~ /$ft/) {
+					my $msg_level = \&WARN;
+					$msg_level = \&CHK if ($file);
+					&{$msg_level}("PREFER_FALLTHROUGH",
+						      "Prefer 'fallthrough;' over fallthrough comment\n" . $herecurr);
+					last;
+				}
+			}
+		}
+
 # check for switch/default statements without a break;
 		if ($perl_version_ok &&
 		    defined $stat &&
_

Patches currently in -mm which might be from joe@perches.com are
