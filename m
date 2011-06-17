From: akpm@linux-foundation.org
Subject: + checkpatch-validate-signature-styles-and-to-and-cc-lines.patch added to -mm tree
Date: Fri, 17 Jun 2011 15:41:41 -0700
Message-ID: <201106172241.p5HMffKn005473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58654 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756614Ab1FQWls (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 18:41:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, anish198519851985@gmail.com, nbowler@elliptictech.com


The patch titled
     checkpatch: validate signature styles and To: and Cc: lines
has been added to the -mm tree.  Its filename is
     checkpatch-validate-signature-styles-and-to-and-cc-lines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: validate signature styles and To: and Cc: lines
From: Joe Perches <joe@perches.com>

Signatures have many forms and can sometimes cause problems if not in the
correct format when using git send-email or quilt.

Try to verify the signature tags and email addresses to use the generally
accepted "Signed-off-by: Full Name <email@domain.tld>" form.

Original idea by Anish Kumar <anish198519851985@gmail.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Anish Kumar <anish198519851985@gmail.com>
Cc: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |  125 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 116 insertions(+), 9 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-validate-signature-styles-and-to-and-cc-lines scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-validate-signature-styles-and-to-and-cc-lines
+++ a/scripts/checkpatch.pl
@@ -217,6 +217,16 @@ our $logFunctions = qr{(?x:
 	MODULE_[A-Z_]+
 )};
 
+our $signature_tags = qr{(?xi:
+	Signed-off-by:|
+	Acked-by:|
+	Tested-by:|
+	Reviewed-by:|
+	Reported-by:|
+	To:|
+	Cc:
+)};
+
 our @typeList = (
 	qr{void},
 	qr{(?:unsigned\s+)?char},
@@ -356,6 +366,76 @@ sub top_of_kernel_tree {
 	return 1;
 }
 
+sub parse_email {
+	my ($formatted_email) = @_;
+
+	my $name = "";
+	my $address = "";
+	my $comment = "";
+
+	if ($formatted_email =~ /^(.*)<(\S+\@\S+)>(.*)$/) {
+		$name = $1;
+		$address = $2;
+		$comment = $3 if defined $3;
+	} elsif ($formatted_email =~ /^\s*<(\S+\@\S+)>(.*)$/) {
+		$address = $1;
+		$comment = $2 if defined $2;
+	} elsif ($formatted_email =~ /(\S+\@\S+)(.*)$/) {
+		$address = $1;
+		$comment = $2 if defined $2;
+		$formatted_email =~ s/$address.*$//;
+		$name = $formatted_email;
+		$name =~ s/^\s+|\s+$//g;
+		$name =~ s/^\"|\"$//g;
+		# If there's a name left after stripping spaces and
+		# leading quotes, and the address doesn't have both
+		# leading and trailing angle brackets, the address
+		# is invalid. ie:
+		#   "joe smith joe@smith.com" bad
+		#   "joe smith <joe@smith.com" bad
+		if ($name ne "" && $address !~ /^<[^>]+>$/) {
+			$name = "";
+			$address = "";
+			$comment = "";
+		}
+	}
+
+	$name =~ s/^\s+|\s+$//g;
+	$name =~ s/^\"|\"$//g;
+	$address =~ s/^\s+|\s+$//g;
+	$address =~ s/^\<|\>$//g;
+
+	if ($name =~ /[^\w \-]/i) { ##has "must quote" chars
+		$name =~ s/(?<!\\)"/\\"/g; ##escape quotes
+		$name = "\"$name\"";
+	}
+
+	return ($name, $address, $comment);
+}
+
+sub format_email {
+	my ($name, $address) = @_;
+
+	my $formatted_email;
+
+	$name =~ s/^\s+|\s+$//g;
+	$name =~ s/^\"|\"$//g;
+	$address =~ s/^\s+|\s+$//g;
+
+	if ($name =~ /[^\w \-]/i) { ##has "must quote" chars
+		$name =~ s/(?<!\\)"/\\"/g; ##escape quotes
+		$name = "\"$name\"";
+	}
+
+	if ("$name" eq "") {
+		$formatted_email = "$address";
+	} else {
+		$formatted_email = "$name <$address>";
+	}
+
+	return $formatted_email;
+}
+
 sub expand_tabs {
 	my ($str) = @_;
 
@@ -1380,17 +1460,44 @@ sub process {
 			}
 		}
 
-#check the patch for a signoff:
+# Check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
-			# This is a signoff, if ugly, so do not double report.
 			$signoff++;
-			if (!($line =~ /^\s*Signed-off-by:/)) {
-				WARN("Signed-off-by: is the preferred form\n" .
-					$herecurr);
-			}
-			if ($line =~ /^\s*signed-off-by:\S/i) {
-				WARN("space required after Signed-off-by:\n" .
-					$herecurr);
+		}
+
+# Check signature styles
+		if ($line =~ /^(\s*)($signature_tags)(\s*)(.*)/) {
+			my $space_before = $1;
+			my $sign_off = $2;
+			my $space_after = $3;
+			my $email = $4;
+			my $ucfirst_sign_off = ucfirst(lc($sign_off));
+
+			if (defined $space_before && $space_before ne "") {
+				WARN("Do not use whitespace before $ucfirst_sign_off\n" . $herecurr);
+			}
+			if ($sign_off =~ /-by:$/i && $sign_off ne $ucfirst_sign_off) {
+				WARN("'$ucfirst_sign_off' is the preferred signature form\n" . $herecurr);
+			}
+			if (!defined $space_after || $space_after ne " ") {
+				WARN("Use a single space after $ucfirst_sign_off\n" . $herecurr);
+			}
+
+			my ($email_name, $email_address, $comment) = parse_email($email);
+			my $suggested_email = format_email(($email_name, $email_address));
+			if ($suggested_email eq "") {
+				ERROR("Unrecognized email address: '$email'\n" . $herecurr);
+			} else {
+				my $dequoted = $suggested_email;
+				$dequoted =~ s/^"//;
+				$dequoted =~ s/" </ </;
+				# Don't force email to have quotes
+				# Allow just an angle bracketed address
+				if ("$dequoted$comment" ne $email &&
+				    "<$email_address>$comment" ne $email &&
+				    "$suggested_email$comment" ne $email) {
+					WARN("email address '$email' might be better as '$suggested_email$comment'\n" . $herecurr);
+				}
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
drivers-use-kzalloc-kcalloc-instead-of-kmallocmemset-where-possible.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-__rcu-as-a-sparse-modifier.patch
checkpatch-validate-signature-styles-and-to-and-cc-lines.patch

