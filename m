Return-Path: <SRS0=1Kf1=EE=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46EE5C5517A
	for <mm-commits@archiver.kernel.org>; Thu, 29 Oct 2020 02:11:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEF5320747
	for <mm-commits@archiver.kernel.org>; Thu, 29 Oct 2020 02:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603937501;
	bh=zK3uGgb/ssXXGoNQjO/bplA/ttAnW5r2HtNlzz/ArBk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=lu+7rFEchrunqOPsg7HbpAkv9wbnpPj4qP7nEO4phNESM+OXaLAXuaDeh+U456wm3
	 X8/qjOG5EFjy8wasJvIfpOI/BffyfZbhyRpjuegxLvBgzf6qJaGYP/JORlvZbTGOXG
	 bQIi+yTBOV5cmvb4LUaBcsnvpLxUtmsmUTPW4RNA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgJ2CLj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Oct 2020 22:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:35154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgJ1VhF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 28 Oct 2020 17:37:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D357F24844;
        Wed, 28 Oct 2020 21:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603921024;
        bh=zK3uGgb/ssXXGoNQjO/bplA/ttAnW5r2HtNlzz/ArBk=;
        h=Date:From:To:Subject:From;
        b=WvWjEmdSFKmO1N0NXCCi9T9gjQAMVUhje0ktvPHtHSWCE8w12kF55ttnRqeoVdI2I
         9zAjK0iw9gH7UFqG46bce4GiwDNChsNeZWr8McFJuM8BHYqQQXlc+E7rr7HIlIHb3d
         x43Ep4ACvnCaCu8Lg/Dq2bup2UWcCr+LIhBcGnZo=
Date:   Wed, 28 Oct 2020 14:37:03 -0700
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  +
 checkpatch-update-__attribute__sectionname-quote-removal.patch added to -mm
 tree
Message-ID: <20201028213703.p81-_FDqd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: update __attribute__((section("name"))) quote removal
has been added to the -mm tree.  Its filename is
     checkpatch-update-__attribute__sectionname-quote-removal.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-update-__attribute__sectionname-quote-removal.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-update-__attribute__sectionname-quote-removal.patch

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

Link: https://lkml.kernel.org/r/c04dd1c810e8d6a68e6a632e3191ae91651c8edf.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   46 +++++++++++++---------------------------
 1 file changed, 16 insertions(+), 30 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-update-__attribute__sectionname-quote-removal
+++ a/scripts/checkpatch.pl
@@ -6216,51 +6216,37 @@ sub process {
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
 				}
 			}
 
-			# Check for __attribute__ section, prefer __section
-			if ($attr =~ /^_*section_*\s*\(\s*("[^"]*")/) {
-				my $old = substr($attr, $-[1], $+[1] - $-[1]);
-				my $new = substr($old, 1, -1);
-				if (WARN("PREFER_DEFINED_ATTRIBUTE_MACRO",
-				         "__section($new) is preferred over __attribute__((section($old)))\n" . $herecurr) &&
-					$fix) {
-					$fixed[$fixlinenr] =~ s/\b__attribute__\s*\(\s*\(\s*_*section_*\s*\(\s*\Q$old\E\s*\)\s*\)\s*\)/__section($new)/;
-				}
+			if (show_type("PREFER_DEFINED_ATTRIBUTE_MACRO") && $fix) {
+				$fixed[$fixlinenr] =~ s/ __attribute__\s*\(\s*\(\s*\)\s*\)//;
 			}
 
 			# Check for __attribute__ unused, prefer __always_unused or __maybe_unused
_

Patches currently in -mm which might be from joe@perches.com are

mm-zswap-make-struct-kernel_param_ops-definitions-const.patch
checkpatch-prefer-static-const-declarations.patch
checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch
checkpatch-update-__attribute__sectionname-quote-removal.patch

