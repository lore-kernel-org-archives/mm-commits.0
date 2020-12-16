Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389C5C0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0468C23331
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgLPEpZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:45:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgLPEpZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:45:25 -0500
Date:   Tue, 15 Dec 2020 20:44:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093884;
        bh=8SfWDkAeVvFBZHTIpOED2nkBDYpIPG2s3k3XI0pAxOY=;
        h=From:To:Subject:In-Reply-To:From;
        b=I7SkVSNvytecb9D2CV4KeSE4KFuWGLUEcUFVUsS+pELyjA4fhIQY4iCxmiTIt11IF
         KzKgBK7H7epuRAkP+MyWEOynX94CE9BPRTYcqA4jxCr/1qEwmi04tQFHBSsY2hS3KV
         kRsNyV3EZpgUAHFUXfJOpoQSi+xowrVWONdJdPng=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 44/95] checkpatch: update
 __attribute__((section("name"))) quote removal
Message-ID: <20201216044443.0bDd7RfZz%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
