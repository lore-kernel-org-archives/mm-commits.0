From: akpm@linux-foundation.org
Subject: [merged] checkpatch-check-for-common-memset-parameter-issues-against-statments.patch removed from -mm tree
Date: Wed, 11 Jan 2012 13:31:05 -0800
Message-ID: <20120111213106.1E6705C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:44200 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934051Ab2AKVbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:31:08 -0500
Received: by eaad12 with SMTP id d12so32631eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:31:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@canonical.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: check for common memset parameter issues against statments
has been removed from the -mm tree.  Its filename was
     checkpatch-check-for-common-memset-parameter-issues-against-statments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: check for common memset parameter issues against statments

Move the memset checks over to work against the statement.  Also add
checks for 0 and 1 used as lengths.  Generally these indicate badly
ordered parameters.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-check-for-common-memset-parameter-issues-against-statments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-for-common-memset-parameter-issues-against-statments
+++ a/scripts/checkpatch.pl
@@ -3120,6 +3120,28 @@ sub process {
 			     "Avoid line continuations in quoted strings\n" . $herecurr);
 		}
 
+# Check for misused memsets
+		if (defined $stat && $stat =~ /\bmemset\s*\((.*)\)/s) {
+			my $args = $1;
+
+			# Flatten any parentheses and braces
+			while ($args =~ s/\([^\(\)]*\)/10/s ||
+			       $args =~ s/\{[^\{\}]*\}/10/s ||
+			       $args =~ s/\[[^\[\]]*\]/10/s)
+			{
+			}
+			# Extract the simplified arguments.
+			my ($ms_addr, $ms_val, $ms_size) =
+						split(/\s*,\s*/, $args);
+			if ($ms_size =~ /^(0x|)0$/i) {
+				ERROR("MEMSET",
+				      "memset size is 3rd argument, not the second.\n" . $herecurr);
+			} elsif ($ms_size =~ /^(0x|)1$/i) {
+				WARN("MEMSET",
+				     "single byte memset is suspicious. Swapped 2nd/3rd argument?\n" . $herecurr);
+			}
+		}
+
 # check for new externs in .c files.
 		if ($realfile =~ /\.c$/ && defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s+($Ident)(\s*)\(/s)
@@ -3291,12 +3313,6 @@ sub process {
 			WARN("EXPORTED_WORLD_WRITABLE",
 			     "Exporting world writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 		}
