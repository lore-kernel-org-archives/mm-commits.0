Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D9E1C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E342123407
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbgLPRKW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgLPRKW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:22 -0500
Date:   Wed, 16 Dec 2020 09:10:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138606;
        bh=wYM+GGRBY4VjpilpOICNJp3FPlobpw5MyD3PYhvQRwE=;
        h=From:To:Subject:From;
        b=ZHE7KXtWp9GIjvhfI+vOoP+sm5rzCm46eCAXNpTTJiUG7Jt2X33JtuEwmF5o3dAM6
         LmLVI3NlUJpwUk56LBOJFA/IecuQUnTkYAjO+ShICr6pqUvqCkJQ9Cy9Q1xwiqPFUW
         hBQHb23bSLtpTnhfUaG2uo1u0WEeUo94F55I7oqg=
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  [merged] checkpatch-improve-email-parsing.patch removed
 from -mm tree
Message-ID: <20201216171006.7sNKIp26-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve email parsing
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-email-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: checkpatch: improve email parsing

checkpatch doesn't report warnings for many common mistakes in emails. 
Some of which are trailing commas and incorrect use of email comments.

At the same time several false positives are reported due to incorrect
handling of mail comments.  The most common of which is due to the
pattern:

<stable@vger.kernel.org> # X.X

Improve email parsing in checkpatch.

Some general email rules are defined:

- Multiple name comments should not be allowed.
- Comments inside address should not be allowed.
- In general comments should be enclosed within parentheses.
  Relaxation is given to comments beginning with #.
- Stable addresses should not begin with a name.
- Comments in stable addresses should begin only
  with a #.

Improvements to parsing:

- Detect and report unexpected content after email.
- Quoted names are excluded from comment parsing.
- Trailing dots, commas or quotes in email are removed during
  formatting. Correspondingly a BAD_SIGN_OFF warning
  is emitted.
- Improperly quoted email like '"name <address>"' are now
  warned about.

In addition, added fixes for all the possible rules.

Link: https://lore.kernel.org/linux-kernel-mentees/6c275d95c3033422addfc256a30e6ae3dd37941d.camel@perches.com/
Link: https://lore.kernel.org/linux-kernel-mentees/20201105200857.GC1333458@kroah.com/
Link: https://lkml.kernel.org/r/20201108100632.75340-1-dwaipayanray1@gmail.com
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  108 +++++++++++++++++++++++++++++++++-------
 1 file changed, 91 insertions(+), 17 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-improve-email-parsing
+++ a/scripts/checkpatch.pl
@@ -1159,6 +1159,7 @@ sub parse_email {
 	my ($formatted_email) = @_;
 
 	my $name = "";
+	my $quoted = "";
 	my $name_comment = "";
 	my $address = "";
 	my $comment = "";
@@ -1190,14 +1191,20 @@ sub parse_email {
 		}
 	}
 
-	$comment = trim($comment);
-	$name = trim($name);
-	$name =~ s/^\"|\"$//g;
-	if ($name =~ s/(\s*\([^\)]+\))\s*//) {
-		$name_comment = trim($1);
+	# Extract comments from names excluding quoted parts
+	# "John D. (Doe)" - Do not extract
+	if ($name =~ s/\"(.+)\"//) {
+		$quoted = $1;
+	}
+	while ($name =~ s/\s*($balanced_parens)\s*/ /) {
+		$name_comment .= trim($1);
 	}
+	$name =~ s/^[ \"]+|[ \"]+$//g;
+	$name = trim("$quoted $name");
+
 	$address = trim($address);
 	$address =~ s/^\<|\>$//g;
+	$comment = trim($comment);
 
 	if ($name =~ /[^\w \-]/i) { ##has "must quote" chars
 		$name =~ s/(?<!\\)"/\\"/g; ##escape quotes
@@ -1212,17 +1219,20 @@ sub format_email {
 
 	my $formatted_email;
 
-	$name_comment = trim($name_comment);
-	$comment = trim($comment);
-	$name = trim($name);
-	$name =~ s/^\"|\"$//g;
+	$name =~ s/^[ \"]+|[ \"]+$//g;
 	$address = trim($address);
+	$address =~ s/(?:\.|\,|\")+$//; ##trailing commas, dots or quotes
 
 	if ($name =~ /[^\w \-]/i) { ##has "must quote" chars
 		$name =~ s/(?<!\\)"/\\"/g; ##escape quotes
 		$name = "\"$name\"";
 	}
 
+	$name_comment = trim($name_comment);
+	$name_comment = " $name_comment" if ($name_comment ne "");
+	$comment = trim($comment);
+	$comment = " $comment" if ($comment ne "");
+
 	if ("$name" eq "") {
 		$formatted_email = "$address";
 	} else {
@@ -1240,15 +1250,11 @@ sub reformat_email {
 }
 
 sub same_email_addresses {
-	my ($email1, $email2, $match_comment) = @_;
+	my ($email1, $email2) = @_;
 
 	my ($email1_name, $name1_comment, $email1_address, $comment1) = parse_email($email1);
 	my ($email2_name, $name2_comment, $email2_address, $comment2) = parse_email($email2);
 
-	if ($match_comment != 1) {
-		return $email1_name eq $email2_name &&
-		       $email1_address eq $email2_address;
-	}
 	return $email1_name eq $email2_name &&
 	       $email1_address eq $email2_address &&
 	       $name1_comment eq $name2_comment &&
@@ -2711,7 +2717,7 @@ sub process {
 			$signoff++;
 			$in_commit_log = 0;
 			if ($author ne ''  && $authorsignoff != 1) {
-				if (same_email_addresses($1, $author, 1)) {
+				if (same_email_addresses($1, $author)) {
 					$authorsignoff = 1;
 				} else {
 					my $ctx = $1;
@@ -2807,9 +2813,77 @@ sub process {
 				$dequoted =~ s/" </ </;
 				# Don't force email to have quotes
 				# Allow just an angle bracketed address
-				if (!same_email_addresses($email, $suggested_email, 0)) {
+				if (!same_email_addresses($email, $suggested_email)) {
+					if (WARN("BAD_SIGN_OFF",
+						 "email address '$email' might be better as '$suggested_email'\n" . $herecurr) &&
+					    $fix) {
+						$fixed[$fixlinenr] =~ s/\Q$email\E/$suggested_email/;
+					}
+				}
+
+				# Address part shouldn't have comments
+				my $stripped_address = $email_address;
+				$stripped_address =~ s/\([^\(\)]*\)//g;
+				if ($email_address ne $stripped_address) {
+					if (WARN("BAD_SIGN_OFF",
+						 "address part of email should not have comments: '$email_address'\n" . $herecurr) &&
+					    $fix) {
+						$fixed[$fixlinenr] =~ s/\Q$email_address\E/$stripped_address/;
+					}
+				}
+
+				# Only one name comment should be allowed
+				my $comment_count = () = $name_comment =~ /\([^\)]+\)/g;
+				if ($comment_count > 1) {
 					WARN("BAD_SIGN_OFF",
-					     "email address '$email' might be better as '$suggested_email'\n" . $herecurr);
+					     "Use a single name comment in email: '$email'\n" . $herecurr);
+				}
+
+
+				# stable@vger.kernel.org or stable@kernel.org shouldn't
+				# have an email name. In addition commments should strictly
+				# begin with a #
+				if ($email =~ /^.*stable\@(?:vger\.)?kernel\.org/i) {
+					if (($comment ne "" && $comment !~ /^#.+/) ||
+					    ($email_name ne "")) {
+						my $cur_name = $email_name;
+						my $new_comment = $comment;
+						$cur_name =~ s/[a-zA-Z\s\-\"]+//g;
+
+						# Remove brackets enclosing comment text
+						# and # from start of comments to get comment text
+						$new_comment =~ s/^\((.*)\)$/$1/;
+						$new_comment =~ s/^\[(.*)\]$/$1/;
+						$new_comment =~ s/^[\s\#]+|\s+$//g;
+
+						$new_comment = trim("$new_comment $cur_name") if ($cur_name ne $new_comment);
+						$new_comment = " # $new_comment" if ($new_comment ne "");
+						my $new_email = "$email_address$new_comment";
+
+						if (WARN("BAD_STABLE_ADDRESS_STYLE",
+							 "Invalid email format for stable: '$email', prefer '$new_email'\n" . $herecurr) &&
+						    $fix) {
+							$fixed[$fixlinenr] =~ s/\Q$email\E/$new_email/;
+						}
+					}
+				} elsif ($comment ne "" && $comment !~ /^(?:#.+|\(.+\))$/) {
+					my $new_comment = $comment;
+
+					# Extract comment text from within brackets or
+					# c89 style /*...*/ comments
+					$new_comment =~ s/^\[(.*)\]$/$1/;
+					$new_comment =~ s/^\/\*(.*)\*\/$/$1/;
+
+					$new_comment = trim($new_comment);
+					$new_comment =~ s/^[^\w]$//; # Single lettered comment with non word character is usually a typo
+					$new_comment = "($new_comment)" if ($new_comment ne "");
+					my $new_email = format_email($email_name, $name_comment, $email_address, $new_comment);
+
+					if (WARN("BAD_SIGN_OFF",
+						 "Unexpected content after email: '$email', should be: '$new_email'\n" . $herecurr) &&
+					    $fix) {
+						$fixed[$fixlinenr] =~ s/\Q$email\E/$new_email/;
+					}
 				}
 			}
 
_

Patches currently in -mm which might be from dwaipayanray1@gmail.com are


