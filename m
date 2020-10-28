Return-Path: <SRS0=6wtZ=ED=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D78FC4363A
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 21:59:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C63FE2473C
	for <mm-commits@archiver.kernel.org>; Wed, 28 Oct 2020 21:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgJ1V7m (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 17:59:42 -0400
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:39056 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729325AbgJ1V7d (ORCPT
        <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 17:59:33 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id EC33F180A910F;
        Wed, 28 Oct 2020 21:59:31 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: tooth95_41075ac27288
X-Filterd-Recvd-Size: 5876
Received: from [192.168.0.160] (cpe-72-134-80-165.natsow.res.rr.com [72.134.80.165])
        (Authenticated sender: joe@perches.com)
        by omf12.hostedemail.com (Postfix) with ESMTPA;
        Wed, 28 Oct 2020 21:59:31 +0000 (UTC)
Message-ID: <58e9d55e933dc8fdc6af489f2ad797fa8eb13e44.camel@perches.com>
Subject: Re: +
 checkpatch-update-__attribute__sectionname-quote-removal.patch added to -mm
 tree
From:   Joe Perches <joe@perches.com>
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        mm-commits@vger.kernel.org
Date:   Wed, 28 Oct 2020 14:59:29 -0700
In-Reply-To: <20201028213703.p81-_FDqd%akpm@linux-foundation.org>
References: <20201028213703.p81-_FDqd%akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, 2020-10-28 at 14:37 -0700, akpm@linux-foundation.org wrote:
> The patch titled
>      Subject: checkpatch: update __attribute__((section("name"))) quote removal
> has been added to the -mm tree.  Its filename is
>      checkpatch-update-__attribute__sectionname-quote-removal.patch
> 
> This patch should soon appear at
>     https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-update-__attribute__sectionname-quote-removal.patch
> and later at
>     https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-update-__attribute__sectionname-quote-removal.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/process/submit-checklist.rst when testing your code ***
> 
> The -mm tree is included into linux-next and is updated
> there every 3-4 working days
> 
> ------------------------------------------------------
> From: Joe Perches <joe@perches.com>
> Subject: checkpatch: update __attribute__((section("name"))) quote removal
> 
> commit 33def8498fdd ("treewide: Convert macro and uses of
> __section(foo) to __section("foo")") removed the stringification of the
> section name and now requires quotes around the named section.
> 
> Update checkpatch to not remove any quotes when suggesting conversion
> of __attribute__((section("name"))) to __section("name")
> 
> Miscellanea:
> 
> o Add section to the hash with __section replacement
> o Remove separate test for __attribute__((section
> o Remove the limitation on converting attributes containing only
>   known, possible conversions.  Any unknown attribute types are now
>   left as-is and known types are converted and moved before
>   __attribute__ and removed from within the __attribute__((list...)).
> 
> Link: https://lkml.kernel.org/r/c04dd1c810e8d6a68e6a632e3191ae91651c8edf.camel@perches.com
> Signed-off-by: Joe Perches <joe@perches.com>
> Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This is a slightly shorter/better patch as it eliminates the separate
test below the possible conversions loop.

Can you substitute it please Andrew?
---
 scripts/checkpatch.pl | 47 +++++++++++++++--------------------------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7800a090e8fe..58095d9d8f34 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
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
 

