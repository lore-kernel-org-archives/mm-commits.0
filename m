From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?checkpatch-remove-email-address-comment-from-email-address-c?=
 =?US-ASCII?Q?omparisons.patch?= removed from -mm tree
Date: Tue, 07 Apr 2020 19:01:25 -0700
Message-ID: <20200408020125.85pEGIPJM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726443AbgDHCB1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org, peterz@infradead.org


The patch titled
     Subject: checkpatch: remove email address comment from email address comparisons
has been removed from the -mm tree.  Its filename was
     checkpatch-remove-email-address-comment-from-email-address-comparisons.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: remove email address comment from email address comparisons

About 2% of the last 100K commits have email addresses that include an
RFC2822 compliant comment like:

	Peter Zijlstra (Intel) <peterz@infradead.org>

checkpatch currently does a comparison of the complete name and address to
the submitted author to determine if the author has signed-off and emits a
warning if the exact email names and addresses do not match.

Unfortunately, the author email address can be written without the comment
like:

	Peter Zijlstra <peterz@infradead.org>

Add logic to compare the comment stripped email addresses to avoid this
warning.

Link: http://lkml.kernel.org/r/ebaa2f7c8f94e25520981945cddcc1982e70e072.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-remove-email-address-comment-from-email-address-comparisons
+++ a/scripts/checkpatch.pl
@@ -1118,6 +1118,7 @@ sub parse_email {
 	my ($formatted_email) = @_;
 
 	my $name = "";
+	my $name_comment = "";
 	my $address = "";
 	my $comment = "";
 
@@ -1150,6 +1151,10 @@ sub parse_email {
 
 	$name = trim($name);
 	$name =~ s/^\"|\"$//g;
+	$name =~ s/(\s*\([^\)]+\))\s*//;
+	if (defined($1)) {
+		$name_comment = trim($1);
+	}
 	$address = trim($address);
 	$address =~ s/^\<|\>$//g;
 
@@ -1158,7 +1163,7 @@ sub parse_email {
 		$name = "\"$name\"";
 	}
 
-	return ($name, $address, $comment);
+	return ($name, $name_comment, $address, $comment);
 }
 
 sub format_email {
@@ -1184,6 +1189,23 @@ sub format_email {
 	return $formatted_email;
 }
 
+sub reformat_email {
+	my ($email) = @_;
+
+	my ($email_name, $name_comment, $email_address, $comment) = parse_email($email);
+	return format_email($email_name, $email_address);
+}
+
+sub same_email_addresses {
+	my ($email1, $email2) = @_;
+
+	my ($email1_name, $name1_comment, $email1_address, $comment1) = parse_email($email1);
+	my ($email2_name, $name2_comment, $email2_address, $comment2) = parse_email($email2);
+
+	return $email1_name eq $email2_name &&
+	       $email1_address eq $email2_address;
+}
+
 sub which {
 	my ($bin) = @_;
 
@@ -2604,17 +2626,16 @@ sub process {
 			$author = $1;
 			$author = encode("utf8", $author) if ($line =~ /=\?utf-8\?/i);
 			$author =~ s/"//g;
+			$author = reformat_email($author);
 		}
 
 # Check the patch for a signoff:
-		if ($line =~ /^\s*signed-off-by:/i) {
+		if ($line =~ /^\s*signed-off-by:\s*(.*)/i) {
 			$signoff++;
 			$in_commit_log = 0;
 			if ($author ne '') {
-				my $l = $line;
-				$l =~ s/"//g;
-				if ($l =~ /^\s*signed-off-by:\s*\Q$author\E/i) {
-				    $authorsignoff = 1;
+				if (same_email_addresses($1, $author)) {
+					$authorsignoff = 1;
 				}
 			}
 		}
@@ -2664,7 +2685,7 @@ sub process {
 				}
 			}
 
-			my ($email_name, $email_address, $comment) = parse_email($email);
+			my ($email_name, $name_comment, $email_address, $comment) = parse_email($email);
 			my $suggested_email = format_email(($email_name, $email_address));
 			if ($suggested_email eq "") {
 				ERROR("BAD_SIGN_OFF",
@@ -2675,9 +2696,7 @@ sub process {
 				$dequoted =~ s/" </ </;
 				# Don't force email to have quotes
 				# Allow just an angle bracketed address
-				if ("$dequoted$comment" ne $email &&
-				    "<$email_address>$comment" ne $email &&
-				    "$suggested_email$comment" ne $email) {
+				if (!same_email_addresses($email, $suggested_email)) {
 					WARN("BAD_SIGN_OFF",
 					     "email address '$email' might be better as '$suggested_email$comment'\n" . $herecurr);
 				}
_

Patches currently in -mm which might be from joe@perches.com are
