Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489EEC2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15BBF233EB
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbgLPRKi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:59886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgLPRKi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:38 -0500
Date:   Wed, 16 Dec 2020 09:10:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138622;
        bh=MixLG367mN3kLnbtew7TlfkqF9VYfE3x4JdtakUo07o=;
        h=From:To:Subject:From;
        b=WXVGTThMVpD4D7ZEck3aprRvdZ80Btvut30N9C3//nunU8eWNGeHBTdJ5agSbzRIh
         ONEJ/Qv/vWED/v1Mmp9kOf5J/QC/7G9NB4PXmzTww1HszDphtgdWupXp8VARDHQZW/
         wvJCpK9bUp9xb0YoFEfdIUisH2zsMCKJcV64kyiQ=
From:   akpm@linux-foundation.org
To:     joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, yashsri421@gmail.com
Subject:  [merged]
 checkpatch-add-fix-and-improve-warning-msg-for-non-standard-signature.patch
 removed from -mm tree
Message-ID: <20201216171022.ba_LyxqIb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add fix and improve warning msg for non-standard signature
has been removed from the -mm tree.  Its filename was
     checkpatch-add-fix-and-improve-warning-msg-for-non-standard-signature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aditya Srivastava <yashsri421@gmail.com>
Subject: checkpatch: add fix and improve warning msg for non-standard signature

Currently checkpatch warns for BAD_SIGN_OFF on non-standard signature
styles.

A large number of these warnings occur because of typo mistakes in
signature tags.  An evaluation over v4.13..v5.8 showed that out of 539
warnings due to non-standard signatures, 87 are due to typo mistakes.

Following are the standard signature tags which are often incorrectly
used, along with their individual counts of incorrect use (over
v4.13..v5.8):

 Reviewed-by: 42
 Signed-off-by: 25
 Reported-by: 6
 Acked-by: 4
 Tested-by: 4
 Suggested-by: 4

Provide a fix by calculating levenshtein distance for the signature tag
with all the standard signatures and suggest a fix with a signature, whose
edit distance is less than or equal to 2 with the misspelled signature.

Out of the 86 mispelled signatures fixed with this approach, 85 were found
to be good corrections and 1 was bad correction.

Following was found to be a bad correction:
 Tweeted-by (count: 1) => Tested-by

Link: https://lkml.kernel.org/r/20201128204333.7054-1-yashsri421@gmail.com
Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   71 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-fix-and-improve-warning-msg-for-non-standard-signature
+++ a/scripts/checkpatch.pl
@@ -506,6 +506,64 @@ our $signature_tags = qr{(?xi:
 	Cc:
 )};
 
+sub edit_distance_min {
+	my (@arr) = @_;
+	my $len = scalar @arr;
+	if ((scalar @arr) < 1) {
+		# if underflow, return
+		return;
+	}
+	my $min = $arr[0];
+	for my $i (0 .. ($len-1)) {
+		if ($arr[$i] < $min) {
+			$min = $arr[$i];
+		}
+	}
+	return $min;
+}
+
+sub get_edit_distance {
+	my ($str1, $str2) = @_;
+	$str1 = lc($str1);
+	$str2 = lc($str2);
+	$str1 =~ s/-//g;
+	$str2 =~ s/-//g;
+	my $len1 = length($str1);
+	my $len2 = length($str2);
+	# two dimensional array storing minimum edit distance
+	my @distance;
+	for my $i (0 .. $len1) {
+		for my $j (0 .. $len2) {
+			if ($i == 0) {
+				$distance[$i][$j] = $j;
+			} elsif ($j == 0) {
+				$distance[$i][$j] = $i;
+			} elsif (substr($str1, $i-1, 1) eq substr($str2, $j-1, 1)) {
+				$distance[$i][$j] = $distance[$i - 1][$j - 1];
+			} else {
+				my $dist1 = $distance[$i][$j - 1]; #insert distance
+				my $dist2 = $distance[$i - 1][$j]; # remove
+				my $dist3 = $distance[$i - 1][$j - 1]; #replace
+				$distance[$i][$j] = 1 + edit_distance_min($dist1, $dist2, $dist3);
+			}
+		}
+	}
+	return $distance[$len1][$len2];
+}
+
+sub find_standard_signature {
+	my ($sign_off) = @_;
+	my @standard_signature_tags = (
+		'Signed-off-by:', 'Co-developed-by:', 'Acked-by:', 'Tested-by:',
+		'Reviewed-by:', 'Reported-by:', 'Suggested-by:'
+	);
+	foreach my $signature (@standard_signature_tags) {
+		return $signature if (get_edit_distance($sign_off, $signature) <= 2);
+	}
+
+	return "";
+}
+
 our @typeListMisordered = (
 	qr{char\s+(?:un)?signed},
 	qr{int\s+(?:(?:un)?signed\s+)?short\s},
@@ -2773,8 +2831,17 @@ sub process {
 			my $ucfirst_sign_off = ucfirst(lc($sign_off));
 
 			if ($sign_off !~ /$signature_tags/) {
-				WARN("BAD_SIGN_OFF",
-				     "Non-standard signature: $sign_off\n" . $herecurr);
+				my $suggested_signature = find_standard_signature($sign_off);
+				if ($suggested_signature eq "") {
+					WARN("BAD_SIGN_OFF",
+					     "Non-standard signature: $sign_off\n" . $herecurr);
+				} else {
+					if (WARN("BAD_SIGN_OFF",
+						 "Non-standard signature: '$sign_off' - perhaps '$suggested_signature'?\n" . $herecurr) &&
+					    $fix) {
+						$fixed[$fixlinenr] =~ s/$sign_off/$suggested_signature/;
+					}
+				}
 			}
 			if (defined $space_before && $space_before ne "") {
 				if (WARN("BAD_SIGN_OFF",
_

Patches currently in -mm which might be from yashsri421@gmail.com are


