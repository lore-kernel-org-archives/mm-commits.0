Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE04C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19BCF233F7
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727036AbgLPRKQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgLPRKQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:16 -0500
Date:   Wed, 16 Dec 2020 09:10:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138600;
        bh=mY8e90oI0uHJo1QvHwdF68mv/ccwh4bwvIBlMhIeHbw=;
        h=From:To:Subject:From;
        b=1GaYT7asCfdEvF5w8clFvi/QvtV+kWYaOatG4rbStCJu6f4k+uM9/oNVuvCd/3RyW
         K8S5L5yU73Bi5z35MAnPzrI5AsrOyx/aAjaRX3L8meK+gezFxnpo8qyAuX7MsSCM1H
         +wOGMvKty8tDcVZRfv3N6O7+XV3Fg9GP8k0x/F9k=
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-update-__attribute__sectionname-quote-removal.patch removed from
 -mm tree
Message-ID: <20201216171000.HNonD1br-%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: update __attribute__((section("name"))) quote removal
has been removed from the -mm tree.  Its filename was
     checkpatch-update-__attribute__sectionname-quote-removal.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: update __attribute__((section("name"))) quote removal

commit 33def8498fdd ("treewide: Convert macro and uses of
__section(foo) to __section("foo")") removed the stringification of the
section name and now requires quotes around the named section.

Update checkpatch to not remove any quotes when suggesting conversion
of __attribute__((section("name"))) to __section("name")

Miscellanea:

o Add section to the hash with __section replacement
o Remove separate test for __attribute__((section
o Remove the limitation on converting attributes containing only
  known, possible conversions.  Any unknown attribute types are now
  left as-is and known types are converted and moved before
  __attribute__ and removed from within the __attribute__((list...)).

[joe@perches.com: eliminate the separate test below the possible conversions loop]
  Link: https://lkml.kernel.org/r/58e9d55e933dc8fdc6af489f2ad797fa8eb13e44.camel@perches.com
Link: https://lkml.kernel.org/r/c04dd1c810e8d6a68e6a632e3191ae91651c8edf.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   47 ++++++++++++----------------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-update-__attribute__sectionname-quote-removal
+++ a/scripts/checkpatch.pl
@@ -6216,50 +6216,33 @@ sub process {
 				"noreturn"			=> "__noreturn",
 				"packed"			=> "__packed",
 				"pure"				=> "__pure",
+				"section"			=> "__section",
 				"used"				=> "__used"
 			);
 
-			my @conv_array = ();
-			my $conv_possible = 1;
-
 			while ($attr =~ /\s*(\w+)\s*(${balanced_parens})?/g) {
-				my $curr_attr = $1;
+				my $orig_attr = $1;
 				my $params = '';
 				$params = $2 if defined($2);
+				my $curr_attr = $orig_attr;
 				$curr_attr =~ s/^[\s_]+|[\s_]+$//g;
-
 				if (exists($attr_list{$curr_attr})) {
+					my $new = $attr_list{$curr_attr};
 					if ($curr_attr eq "format" && $params) {
 						$params =~ /^\s*\(\s*(\w+)\s*,\s*(.*)/;
-						push(@conv_array, "__$1\($2");
+						$new = "__$1\($2";
 					} else {
-						my $new = $attr_list{$curr_attr};
-						push(@conv_array, "$new$params");
+						$new = "$new$params";
+					}
+					if (WARN("PREFER_DEFINED_ATTRIBUTE_MACRO",
+						 "Prefer $new over __attribute__(($orig_attr$params))\n" . $herecurr) &&
+					    $fix) {
+						my $remove = "\Q$orig_attr\E" . '\s*' . "\Q$params\E" . '(?:\s*,\s*)?';
+						$fixed[$fixlinenr] =~ s/$remove//;
+						$fixed[$fixlinenr] =~ s/\b__attribute__/$new __attribute__/;
+						$fixed[$fixlinenr] =~ s/\}\Q$new\E/} $new/;
+						$fixed[$fixlinenr] =~ s/ __attribute__\s*\(\s*\(\s*\)\s*\)//;
 					}
-				} else {
-					$conv_possible = 0;
-					last;
-				}
-			}
-
-			if (scalar @conv_array > 0 && $conv_possible == 1) {
-				my $replace = join(' ', @conv_array);
-				if (WARN("PREFER_DEFINED_ATTRIBUTE_MACRO",
-				         "$replace is preferred over __attribute__(($attr))\n" . $herecurr) &&
-					$fix) {
-					$fixed[$fixlinenr] =~ s/\b__attribute__\s*\(\s*\(\s*\Q$attr\E\s*\)\s*\)/$replace/;
-					$fixed[$fixlinenr] =~ s/\}\Q$replace\E/} $replace/;
-				}
-			}
-
-			# Check for __attribute__ section, prefer __section
-			if ($attr =~ /^_*section_*\s*\(\s*("[^"]*")/) {
-				my $old = substr($attr, $-[1], $+[1] - $-[1]);
-				my $new = substr($old, 1, -1);
-				if (WARN("PREFER_DEFINED_ATTRIBUTE_MACRO",
-				         "__section($new) is preferred over __attribute__((section($old)))\n" . $herecurr) &&
-					$fix) {
-					$fixed[$fixlinenr] =~ s/\b__attribute__\s*\(\s*\(\s*_*section_*\s*\(\s*\Q$old\E\s*\)\s*\)\s*\)/__section($new)/;
 				}
 			}
 
_

Patches currently in -mm which might be from joe@perches.com are


