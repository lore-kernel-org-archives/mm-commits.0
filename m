From: akpm@linux-foundation.org
Subject: +
 checkpatch-remove-email-address-comment-from-email-address-comparisons.patch
 added to -mm tree
Date: Mon, 10 Feb 2020 14:27:24 -0800
Message-ID: <20200210222724.8AACu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727385AbgBJW1Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 10 Feb 2020 17:27:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, peterz@infradead.org, joe@perches.com


The patch titled
     Subject: checkpatch: remove email address comment from email address comparisons
has been added to the -mm tree.  Its filename is
     checkpatch-remove-email-address-comment-from-email-address-comparisons.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-remove-email-address-comment-from-email-address-comparisons.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-remove-email-address-comment-from-email-address-comparisons.patch

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
@@ -1132,6 +1132,7 @@ sub parse_email {
 	my ($formatted_email) = @_;
 
 	my $name = "";
+	my $name_comment = "";
 	my $address = "";
 	my $comment = "";
 
@@ -1164,6 +1165,10 @@ sub parse_email {
 
 	$name = trim($name);
 	$name =~ s/^\"|\"$//g;
+	$name =~ s/(\s*\([^\)]+\))\s*//;
+	if (defined($1)) {
+		$name_comment = trim($1);
+	}
 	$address = trim($address);
 	$address =~ s/^\<|\>$//g;
 
@@ -1172,7 +1177,7 @@ sub parse_email {
 		$name = "\"$name\"";
 	}
 
-	return ($name, $address, $comment);
+	return ($name, $name_comment, $address, $comment);
 }
 
 sub format_email {
@@ -1198,6 +1203,23 @@ sub format_email {
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
 
@@ -2618,17 +2640,16 @@ sub process {
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
@@ -2678,7 +2699,7 @@ sub process {
 				}
 			}
 
-			my ($email_name, $email_address, $comment) = parse_email($email);
+			my ($email_name, $name_comment, $email_address, $comment) = parse_email($email);
 			my $suggested_email = format_email(($email_name, $email_address));
 			if ($suggested_email eq "") {
 				ERROR("BAD_SIGN_OFF",
@@ -2689,9 +2710,7 @@ sub process {
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

get_maintainer-remove-uses-of-p-for-maintainer-name.patch
string-add-stracpy-and-stracpy_pad-mechanisms.patch
checkpatch-remove-email-address-comment-from-email-address-comparisons.patch
