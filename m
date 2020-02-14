From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 checkpatch-prefer-fallthrough-over-fallthrough-comments.patch added to -mm
 tree
Date: Thu, 13 Feb 2020 21:11:19 -0800
Message-ID: <20200214051119.FyloLcq2e%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgBNFLU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Feb 2020 00:11:20 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: prefer fallthrough; over fallthrough comments
has been added to the -mm tree.  Its filename is
     checkpatch-prefer-fallthrough-over-fallthrough-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-prefer-fallthrough-over-fallthrough-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-prefer-fallthrough-over-fallthrough-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2308,6 +2308,19 @@ sub pos_last_openparen {
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
 
@@ -2469,6 +2482,7 @@ sub process {
 		$sline =~ s/$;/ /g;	#with comments as spaces
 
 		my $rawline = $rawlines[$linenr - 1];
+		my $raw_comment = get_raw_comment($line, $rawline);
 
 # check if it's a mode change, rename or start of a patch
 		if (!$in_commit_log &&
@@ -6422,6 +6436,28 @@ sub process {
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

get_maintainer-remove-uses-of-p-for-maintainer-name.patch
string-add-stracpy-and-stracpy_pad-mechanisms.patch
checkpatch-remove-email-address-comment-from-email-address-comparisons.patch
checkpatch-prefer-fallthrough-over-fallthrough-comments.patch
