Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A522DC3526B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81CB223428
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgLPRLF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726839AbgLPRLF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:11:05 -0500
Date:   Wed, 16 Dec 2020 09:10:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138624;
        bh=1blFqyKEzUXPgJpzq1mrunD+i7yyLNHNotc2hA5BsRk=;
        h=From:To:Subject:From;
        b=aGaowGRRUGQCu5TqSAWpjbr5hgMHic5xeYjw6kMoOVT6XY8fo0HR7qYFjfC7JaqKI
         tAkZM+qWKWDptfLGf+vnx22mQNlJ83F9VMtmn7N+9W1G1c0UL7pYKso+Q43EIsvbmN
         krzP7gC/mEHz08dYA90DSc/mV2WK/yNhssa18Xnc=
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-add-warning-for-unnecessary-use-of-%h-and-%hh.patch removed from
 -mm tree
Message-ID: <20201216171024.en0piRj07%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add warning for unnecessary use of %h[xudi] and %hh[xudi]
has been removed from the -mm tree.  Its filename was
     checkpatch-add-warning-for-unnecessary-use-of-%h-and-%hh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: checkpatch: add warning for unnecessary use of %h[xudi] and %hh[xudi]

Modifiers %h and %hh should never be used.

Commit cbacb5ab0aa0 ("docs: printk-formats: Stop encouraging use
of unnecessary %h[xudi] and %hh[xudi]") specifies that:

"Standard integer promotion is already done and %hx and %hhx is useless
so do not encourage the use of %hh[xudi] or %h[xudi]."

"The "h" and "hh" things should never be used. The only reason for them
being used if you have an "int", but you want to print it out as a
"char" (and honestly, that is a really bad reason, you'd be better off
just using a proper cast to make the code more obvious)."

Add a new check to emit a warning on finding an unneeded use of %h or
%hh modifier.

Also add a fix option to the check.

Link: https://lore.kernel.org/lkml/4910042649a4f3ab22fac93191b8c1fa0a2e17c3.camel@perches.com/
Link: https://lkml.kernel.org/r/20201128200046.78739-1-dwaipayanray1@gmail.com
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-unnecessary-use-of-%h-and-%hh
+++ a/scripts/checkpatch.pl
@@ -6102,6 +6102,28 @@ sub process {
 			     "Avoid logging continuation uses where feasible\n" . $herecurr);
 		}
 
+# check for unnecessary use of %h[xudi] and %hh[xudi] in logging functions
+		if (defined $stat &&
+		    $line =~ /\b$logFunctions\s*\(/ &&
+		    index($stat, '"') >= 0) {
+			my $lc = $stat =~ tr@\n@@;
+			$lc = $lc + $linenr;
+			my $stat_real = get_stat_real($linenr, $lc);
+			pos($stat_real) = index($stat_real, '"');
+			while ($stat_real =~ /[^\"%]*(%[\#\d\.\*\-]*(h+)[idux])/g) {
+				my $pspec = $1;
+				my $h = $2;
+				my $lineoff = substr($stat_real, 0, $-[1]) =~ tr@\n@@;
+				if (WARN("UNNECESSARY_MODIFIER",
+					 "Integer promotion: Using '$h' in '$pspec' is unnecessary\n" . "$here\n$stat_real\n") &&
+				    $fix && $fixed[$fixlinenr + $lineoff] =~ /^\+/) {
+					my $nspec = $pspec;
+					$nspec =~ s/h//g;
+					$fixed[$fixlinenr + $lineoff] =~ s/\Q$pspec\E/$nspec/;
+				}
+			}
+		}
+
 # check for mask then right shift without a parentheses
 		if ($perl_version_ok &&
 		    $line =~ /$LvalOrFunc\s*\&\s*($LvalOrFunc)\s*>>/ &&
_

Patches currently in -mm which might be from dwaipayanray1@gmail.com are


