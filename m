Return-Path: <SRS0=PDaU=DO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E3FC4363C
	for <mm-commits@archiver.kernel.org>; Wed,  7 Oct 2020 21:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 569052087D
	for <mm-commits@archiver.kernel.org>; Wed,  7 Oct 2020 21:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602105300;
	bh=5l8q3Xx0Z1dJ09B75h/He6LPhfqtUKeURA+V5A5HVkE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JO4QKknePX/wfYT5XAXnNtrHhoC8PnUE+w/iiN5adyIWa8aBkUXNCPuDqcVsSeaQY
	 lBa+G3y/PH3LSe978lIHij5jQkol2opkfQN0D285eou/FHZ+q6Z2IMiufysrVAVHaY
	 pkqZd3cDeeYP6mpxL/i3+Gf03AAtWXcmekyrrX2Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728292AbgJGVPA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Oct 2020 17:15:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727821AbgJGVO7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Oct 2020 17:14:59 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D77102083B;
        Wed,  7 Oct 2020 21:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602105298;
        bh=5l8q3Xx0Z1dJ09B75h/He6LPhfqtUKeURA+V5A5HVkE=;
        h=Date:From:To:Subject:From;
        b=Ki4/0DVUeLPf4Uk3njLhUBSlWQYnKjijgQ/xa/Jz3DneDZLMy3XhRwKyH7KHlBfnt
         005jnWDb94LjQVXOO0yekxp1bN0/Bj+wh047PDk0TTUuLfb1rCZvn3Jc6FCn5o2/JZ
         vigLBDX9HIFAx+weZqsE1zv7wddyN484myQCSTTw=
Date:   Wed, 07 Oct 2020 14:14:57 -0700
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  +
 checkpatch-add-new-warnings-to-author-signoff-checks.patch added to -mm
 tree
Message-ID: <20201007211457.jNSvMIVbn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add new warnings to author signoff checks.
has been added to the -mm tree.  Its filename is
     checkpatch-add-new-warnings-to-author-signoff-checks.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-new-warnings-to-author-signoff-checks.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-new-warnings-to-author-signoff-checks.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: checkpatch: add new warnings to author signoff checks.

The author signed-off-by checks are currently very vague.  Cases like same
name or same address are not handled separately.

For example, running checkpatch on commit be6577af0cef ("parisc: Add
atomic64_set_release() define to avoid CPU soft lockups"), gives:

WARNING: Missing Signed-off-by: line by nominal patch author
'John David Anglin <dave.anglin@bell.net>'

The signoff line was:
"Signed-off-by: Dave Anglin <dave.anglin@bell.net>"

Clearly the author has signed off but with a slightly different version
of his name. A more appropriate warning would have been to point out
at the name mismatch instead.

Previously, the values assumed by $authorsignoff were either 0 or 1
to indicate whether a proper sign off by author is present.
Extended the checks to handle four new cases.

$authorsignoff values now denote the following:

0: Missing sign off by patch author.

1: Sign off present and identical.

2: Addresses and names match, but comments differ.
   "James Watson(JW) <james@gmail.com>", "James Watson <james@gmail.com>"

3: Addresses match, but names are different.
   "James Watson <james@gmail.com>", "James <james@gmail.com>"

4: Names match, but addresses are different.
   "James Watson <james@watson.com>", "James Watson <james@gmail.com>"

5: Names match, addresses excluding subaddress details (RFC 5233) match.
   "James Watson <james@gmail.com>", "James Watson <james+a@gmail.com>"

Also introduced a new message type FROM_SIGN_OFF_MISMATCH
for cases 2, 3, 4 and 5.

Link: https://lore.kernel.org/linux-kernel-mentees/c1ca28e77e8e3bfa7aadf3efa8ed70f97a9d369c.camel@perches.com/
Link: https://lkml.kernel.org/r/20201007192029.551744-1-dwaipayanray1@gmail.com
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   93 +++++++++++++++++++++++++++++++++-------
 1 file changed, 77 insertions(+), 16 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-new-warnings-to-author-signoff-checks
+++ a/scripts/checkpatch.pl
@@ -1183,10 +1183,10 @@ sub parse_email {
 		}
 	}
 
+	$comment = trim($comment);
 	$name = trim($name);
 	$name =~ s/^\"|\"$//g;
-	$name =~ s/(\s*\([^\)]+\))\s*//;
-	if (defined($1)) {
+	if ($name =~ s/(\s*\([^\)]+\))\s*//) {
 		$name_comment = trim($1);
 	}
 	$address = trim($address);
@@ -1201,10 +1201,12 @@ sub parse_email {
 }
 
 sub format_email {
-	my ($name, $address) = @_;
+	my ($name, $name_comment, $address, $comment) = @_;
 
 	my $formatted_email;
 
+	$name_comment = trim($name_comment);
+	$comment = trim($comment);
 	$name = trim($name);
 	$name =~ s/^\"|\"$//g;
 	$address = trim($address);
@@ -1217,9 +1219,9 @@ sub format_email {
 	if ("$name" eq "") {
 		$formatted_email = "$address";
 	} else {
-		$formatted_email = "$name <$address>";
+		$formatted_email = "$name$name_comment <$address>";
 	}
-
+	$formatted_email .= "$comment";
 	return $formatted_email;
 }
 
@@ -1227,17 +1229,23 @@ sub reformat_email {
 	my ($email) = @_;
 
 	my ($email_name, $name_comment, $email_address, $comment) = parse_email($email);
-	return format_email($email_name, $email_address);
+	return format_email($email_name, $name_comment, $email_address, $comment);
 }
 
 sub same_email_addresses {
-	my ($email1, $email2) = @_;
+	my ($email1, $email2, $match_comment) = @_;
 
 	my ($email1_name, $name1_comment, $email1_address, $comment1) = parse_email($email1);
 	my ($email2_name, $name2_comment, $email2_address, $comment2) = parse_email($email2);
 
+	if ($match_comment != 1) {
+		return $email1_name eq $email2_name &&
+		       $email1_address eq $email2_address;
+	}
 	return $email1_name eq $email2_name &&
-	       $email1_address eq $email2_address;
+	       $email1_address eq $email2_address &&
+	       $name1_comment eq $name2_comment &&
+	       $comment1 eq $comment2;
 }
 
 sub which {
@@ -2367,6 +2375,7 @@ sub process {
 	my $signoff = 0;
 	my $author = '';
 	my $authorsignoff = 0;
+	my $author_sob = '';
 	my $is_patch = 0;
 	my $is_binding_patch = -1;
 	my $in_header_lines = $file ? 0 : 1;
@@ -2694,9 +2703,37 @@ sub process {
 		if ($line =~ /^\s*signed-off-by:\s*(.*)/i) {
 			$signoff++;
 			$in_commit_log = 0;
-			if ($author ne '') {
-				if (same_email_addresses($1, $author)) {
+			if ($author ne ''  && $authorsignoff != 1) {
+				if (same_email_addresses($1, $author, 1)) {
 					$authorsignoff = 1;
+				} else {
+					my $ctx = $1;
+					my ($email_name, $email_comment, $email_address, $comment1) = parse_email($ctx);
+					my ($author_name, $author_comment, $author_address, $comment2) = parse_email($author);
+
+					if ($email_address eq $author_address && $email_name eq $author_name) {
+						$author_sob = $ctx;
+						$authorsignoff = 2;
+					} elsif ($email_address eq $author_address) {
+						$author_sob = $ctx;
+						$authorsignoff = 3;
+					} elsif ($email_name eq $author_name) {
+						$author_sob = $ctx;
+						$authorsignoff = 4;
+
+						my $address1 = $email_address;
+						my $address2 = $author_address;
+
+						if ($address1 =~ /(\S+)\+\S+(\@.*)/) {
+							$address1 = "$1$2";
+						}
+						if ($address2 =~ /(\S+)\+\S+(\@.*)/) {
+							$address2 = "$1$2";
+						}
+						if ($address1 eq $address2) {
+							$authorsignoff = 5;
+						}
+					}
 				}
 			}
 		}
@@ -2753,7 +2790,7 @@ sub process {
 			}
 
 			my ($email_name, $name_comment, $email_address, $comment) = parse_email($email);
-			my $suggested_email = format_email(($email_name, $email_address));
+			my $suggested_email = format_email(($email_name, $name_comment, $email_address, $comment));
 			if ($suggested_email eq "") {
 				ERROR("BAD_SIGN_OFF",
 				      "Unrecognized email address: '$email'\n" . $herecurr);
@@ -2763,9 +2800,9 @@ sub process {
 				$dequoted =~ s/" </ </;
 				# Don't force email to have quotes
 				# Allow just an angle bracketed address
-				if (!same_email_addresses($email, $suggested_email)) {
+				if (!same_email_addresses($email, $suggested_email, 0)) {
 					WARN("BAD_SIGN_OFF",
-					     "email address '$email' might be better as '$suggested_email$comment'\n" . $herecurr);
+					     "email address '$email' might be better as '$suggested_email'\n" . $herecurr);
 				}
 			}
 
@@ -6945,9 +6982,33 @@ sub process {
 		if ($signoff == 0) {
 			ERROR("MISSING_SIGN_OFF",
 			      "Missing Signed-off-by: line(s)\n");
-		} elsif (!$authorsignoff) {
-			WARN("NO_AUTHOR_SIGN_OFF",
-			     "Missing Signed-off-by: line by nominal patch author '$author'\n");
+		} elsif ($authorsignoff != 1) {
+			# authorsignoff values:
+			# 0 -> missing sign off
+			# 1 -> sign off identical
+			# 2 -> names and addresses match, comments mismatch
+			# 3 -> addresses match, names different
+			# 4 -> names match, addresses different
+			# 5 -> names match, addresses excluding subaddress details (refer RFC 5233) match
+
+			my $sob_msg = "'From: $author' != 'Signed-off-by: $author_sob'";
+
+			if ($authorsignoff == 0) {
+				ERROR("NO_AUTHOR_SIGN_OFF",
+				      "Missing Signed-off-by: line by nominal patch author '$author'\n");
+			} elsif ($authorsignoff == 2) {
+				CHK("FROM_SIGN_OFF_MISMATCH",
+				    "From:/Signed-off-by: email comments mismatch: $sob_msg\n");
+			} elsif ($authorsignoff == 3) {
+				WARN("FROM_SIGN_OFF_MISMATCH",
+				     "From:/Signed-off-by: email name mismatch: $sob_msg\n");
+			} elsif ($authorsignoff == 4) {
+				WARN("FROM_SIGN_OFF_MISMATCH",
+				     "From:/Signed-off-by: email address mismatch: $sob_msg\n");
+			} elsif ($authorsignoff == 5) {
+				WARN("FROM_SIGN_OFF_MISMATCH",
+				     "From:/Signed-off-by: email subaddress mismatch: $sob_msg\n");
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from dwaipayanray1@gmail.com are

checkpatch-extend-author-signed-off-by-check-for-split-from-header.patch
checkpatch-fix-multi-statement-macro-checks-for-while-blocks.patch
checkpatch-add-new-warnings-to-author-signoff-checks.patch

