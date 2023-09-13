Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CE0EE020D
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 21:22:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjIMVWS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 17:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjIMVWQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 17:22:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD621739
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 14:22:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51E1C433C9;
        Wed, 13 Sep 2023 21:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694640132;
        bh=yaHMyO7fJJKmdyDwSLnGmyNKLzLD7R9PYIp13e6E9c8=;
        h=Date:To:From:Subject:From;
        b=ljP6rKb351MzDU+RgZ5UKXdNLtaZ2wheiBXN0v9W4BjO/rOrU+G6O+3qQDP0C095v
         k47uuHYVarqLFEBF28hrR9RE9rq1TDZeJsWcKG9G26t0gTEAbS+BJFXUO5BouNtDj+
         jFwPjpnEiK6NCCym4B8H2UnU2EqCenj7EoQnNxuc=
Date:   Wed, 13 Sep 2023 14:22:11 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        gustavoars@kernel.org, dwaipayanray1@gmail.com, apw@canonical.com,
        joe@perches.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch added to mm-nonmm-unstable branch
Message-Id: <20230913212211.D51E1C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add a couple new alloc functions to alloc with multiplies check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add a couple new alloc functions to alloc with multiplies check
Date: Wed, 13 Sep 2023 13:37:52 -0700

vmalloc() and vzalloc() functions have now 2-factor multiplication
argument forms vmalloc_array() and vcalloc(), correspondingly.

Add alloc-with-multiplies checks for these new functions.

Simplify the original codes repeated else to use a hash.

Link: https://github.com/KSPP/linux/issues/342

Link: https://lore.kernel.org/lkml/ZQCaO+tYycDxVLy7@work/
Link: https://lkml.kernel.org/r/edb667e19211652a32ef6069159bb85dbc3bcdfc.1694636817.git.joe@perches.com
Original-patch-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check
+++ a/scripts/checkpatch.pl
@@ -834,6 +834,16 @@ our %deprecated_apis = (
 #Create a search pattern for all these strings to speed up a loop below
 our $deprecated_apis_search = '(?:' . join('|', keys %deprecated_apis) . ')';
 
+our %alloc_with_multiply_apis = (
+	"kmalloc"		=> "kmalloc_array",
+	"kvmalloc"		=> "kvmalloc_array",
+	"vmalloc"		=> "vmalloc_array",
+	"kvzalloc"		=> "kvcalloc",
+	"kzalloc"		=> "kcalloc",
+	"vzalloc"		=> "vcalloc",
+);
+our $alloc_with_multiply_search = '(?:' . join('|', keys %alloc_with_multiply_apis) . ')';
+
 our $mode_perms_world_writable = qr{
 	S_IWUGO		|
 	S_IWOTH		|
@@ -7187,17 +7197,14 @@ sub process {
 			    "Prefer $3(sizeof(*$1)...) over $3($4...)\n" . $herecurr);
 		}
 
-# check for (kv|k)[mz]alloc with multiplies that could be kmalloc_array/kvmalloc_array/kvcalloc/kcalloc
+# check for various allocs with multiplies that should use safer functions
 		if ($perl_version_ok &&
 		    defined $stat &&
-		    $stat =~ /^\+\s*($Lval)\s*\=\s*(?:$balanced_parens)?\s*((?:kv|k)[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
+		    $stat =~ /^\+\s*($Lval)\s*\=\s*(?:$balanced_parens)?\s*($alloc_with_multiply_search)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
 			my $oldfunc = $3;
+			my $newfunc = $alloc_with_multiply_apis{$oldfunc};
 			my $a1 = $4;
 			my $a2 = $10;
-			my $newfunc = "kmalloc_array";
-			$newfunc = "kvmalloc_array" if ($oldfunc eq "kvmalloc");
-			$newfunc = "kvcalloc" if ($oldfunc eq "kvzalloc");
-			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
 			my $r1 = $a1;
 			my $r2 = $a2;
 			if ($a1 =~ /^sizeof\s*\S/) {
@@ -7213,7 +7220,7 @@ sub process {
 					 "Prefer $newfunc over $oldfunc with multiply\n" . $herectx) &&
 				    $cnt == 1 &&
 				    $fix) {
-					$fixed[$fixlinenr] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*((?:kv|k)[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
+					$fixed[$fixlinenr] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*($oldfunc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
 				}
 			}
 		}
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-simplify-creating-search-strings.patch
checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch

