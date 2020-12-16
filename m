Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A995CC2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EBFC23339
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbgLPEp5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:45:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:51252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgLPEp4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:45:56 -0500
Date:   Tue, 15 Dec 2020 20:45:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093916;
        bh=qm+nIw9Z3U1EyY3rHCR/I9n4NJwYrOm+GggX4Plg0fI=;
        h=From:To:Subject:In-Reply-To:From;
        b=Xt9IXxKQyRCcgMP/y5KiUtOjfuyQCd50GiVpssDJfY4niEooR78y3k7tr3MVKUsRb
         n+zsPvFpxcqsePL6oM2F/Mgk8K8cNG5vK5T5fu0690KNbmg2JnFAo0OQ67PYISRnVC
         zqZVLsTpBgFzJ3lPm/vt+6RAlt8Q4XL1ZLIr7MMM=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        joe@perches.com, linux-mm@kvack.org, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 54/95] checkpatch: add warning for unnecessary use
 of %h[xudi] and %hh[xudi]
Message-ID: <20201216044515.ufcsvRhUI%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
