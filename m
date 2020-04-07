From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 130/166] checkpatch: prefer fallthrough; over
 fallthrough comments
Date: Mon, 06 Apr 2020 20:10:58 -0700
Message-ID: <20200407031058.33akz8Ow7%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbgDGDK7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:10:59 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
