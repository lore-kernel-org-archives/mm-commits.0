Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31ECBEEAA72
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 19:59:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjINUAC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 16:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjINUAC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 16:00:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CC526B8
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 12:59:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940BEC433C7;
        Thu, 14 Sep 2023 19:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694721597;
        bh=myCqjqFxw+Sn5Nt3/rip8gddGJ/PmQxcD9g8xDeHhAk=;
        h=Date:To:From:Subject:From;
        b=RUbRNKlforUwxGWXMtshnz1qdKEHYhHOcsO5336nfAgpw95nGHvSqdHSIfd9ITUcD
         JjceFy7lDc0/pa+znFGietKHDdeWX/R51Wl3o8rO8OZVac2HcyXSSNJ8z013wYHZj/
         g3uQVn+nhZm9apz/nvW1a1Qek1pV/aLnob+4iqXE=
Date:   Thu, 14 Sep 2023 12:59:57 -0700
To:     mm-commits@vger.kernel.org, gustavoars@kernel.org, joe@perches.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch removed from -mm tree
Message-Id: <20230914195957.940BEC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: add a couple new alloc functions to alloc with multiplies check
has been removed from the -mm tree.  Its filename was
     checkpatch-add-a-couple-new-alloc-functions-to-alloc-with-multiplies-check.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add a couple new alloc functions to alloc with multiplies check
Date: Wed, 13 Sep 2023 18:41:47 -0700

vmalloc() and vzalloc() functions have now 2-factor multiplication
argument forms vmalloc_array() and vcalloc(), correspondingly.

Add alloc-with-multiplies checks for these new functions.

Simplify the original codes repeated else to use a hash.

Link: https://github.com/KSPP/linux/issues/342
Link: https://lkml.kernel.org/r/edb667e19211652a32ef6069159bb85dbc3bcdff.1694636817.git.joe@perches.com
Original-patch-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Co-developed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
  Link: https://lore.kernel.org/lkml/ZQCaO+tYycDxVLy7@work/
Signed-off-by: Joe Perches <joe@perches.com>
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
+		    $stat =~ /^\+\s*($Lval)\s*\=\s*(?:$balanced_parens)?\s*($alloc_with_multiply_search)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/) {
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


