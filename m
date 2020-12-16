Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7CB5C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BEFD2310F
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbgLPEMo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:12:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgLPEMn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:12:43 -0500
Date:   Tue, 15 Dec 2020 20:12:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608091923;
        bh=/RDLSiwF9+WlCa/UKmWpU/pawoo7Ef6DGqZl66AigS8=;
        h=From:To:Subject:From;
        b=LuAyM8njwFCHzLB8eUKRelLpzU73488wvBd6O+3Gc9XM1r8v+mt3Y/mlNTrqYHzk9
         5rAEPEAMN5WXMcndLurbQCPrDDJSFZAtjF7yE2MdN7x/KD93wHS89bGXtD4Dt9PX6J
         kCW2Ktbb26M7iYIejYdchy/czmVUhhP+akR4SOLc=
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 checkpatch-update-__attribute__sectionname-quote-removal-v2.patch removed
 from -mm tree
Message-ID: <20201216041202.Fqtb9qtJx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch-update-__attribute__sectionname-quote-removal-v2
has been removed from the -mm tree.  Its filename was
     checkpatch-update-__attribute__sectionname-quote-removal-v2.patch

This patch was dropped because it was folded into checkpatch-update-__attribute__sectionname-quote-removal.patch

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch-update-__attribute__sectionname-quote-removal-v2

This is a slightly shorter/better patch as it eliminates the separate
test below the possible conversions loop.

Link: https://lkml.kernel.org/r/58e9d55e933dc8fdc6af489f2ad797fa8eb13e44.camel@perches.com
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-update-__attribute__sectionname-quote-removal-v2
+++ a/scripts/checkpatch.pl
@@ -6241,14 +6241,11 @@ sub process {
 						$fixed[$fixlinenr] =~ s/$remove//;
 						$fixed[$fixlinenr] =~ s/\b__attribute__/$new __attribute__/;
 						$fixed[$fixlinenr] =~ s/\}\Q$new\E/} $new/;
+						$fixed[$fixlinenr] =~ s/ __attribute__\s*\(\s*\(\s*\)\s*\)//;
 					}
 				}
 			}
 
-			if (show_type("PREFER_DEFINED_ATTRIBUTE_MACRO") && $fix) {
-				$fixed[$fixlinenr] =~ s/ __attribute__\s*\(\s*\(\s*\)\s*\)//;
-			}
-
 			# Check for __attribute__ unused, prefer __always_unused or __maybe_unused
 			if ($attr =~ /^_*unused/) {
 				WARN("PREFER_DEFINED_ATTRIBUTE_MACRO",
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-prefer-static-const-declarations.patch
checkpatch-allow-fix-removal-of-unnecessary-break-statements.patch
checkpatch-update-__attribute__sectionname-quote-removal.patch
checkpatch-add-__alias-and-__weak-to-suggested-__attribute__-conversions.patch
checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning.patch
checkpatch-add-printk_once-and-printk_ratelimit-to-prefer-pr_level-warning-fix.patch

