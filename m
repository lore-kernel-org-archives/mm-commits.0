Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C00B5C433E0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 22:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85CF822513
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 22:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbhADWSH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 17:18:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:45600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhADWSH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 17:18:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B85722518;
        Mon,  4 Jan 2021 22:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609798621;
        bh=VCrhPj50/oAl40mM2L68WLNnRaooTPF4qoa0Ljw3SaI=;
        h=Date:From:To:Subject:From;
        b=XkggV8IRz78ct/onl0slwUn73oeHo2UzRKAE2Yuzen3QEseeD4mxWA0sg15ZomGQw
         9j89VRudjgARijxSiwxKvrdhnWCzz8kZr8YFrFIM/po0Tv4dAk70IrzirUhM3fhu+b
         wQf3bOmYNnEbIB+WtuprurQnnFtAt9gka33jFgYM=
Date:   Mon, 04 Jan 2021 14:17:01 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, johannes.czekay@fau.de,
        mm-commits@vger.kernel.org, nicolai.fischer@fau.de
Subject:  [to-be-updated]
 checkpatch-kconfig-enforce-block-indentation.patch removed from -mm tree
Message-ID: <20210104221701.YM-7K4fPn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: kconfig: enforce block indentation
has been removed from the -mm tree.  Its filename was
     checkpatch-kconfig-enforce-block-indentation.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Nicolai Fischer <nicolai.fischer@fau.de>
Subject: checkpatch: kconfig: enforce block indentation

Adds a new warning to checkpatch in case a new Kconfig block is not
indented one sigle tab more than the keyword which starts it.

Link: https://lkml.kernel.org/r/20210103075015.23946-6-nicolai.fischer@fau.de
Co-developed-by: Johannes Czekay <johannes.czekay@fau.de>
Signed-off-by: Johannes Czekay <johannes.czekay@fau.de>
Signed-off-by: Nicolai Fischer <nicolai.fischer@fau.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-kconfig-enforce-block-indentation
+++ a/scripts/checkpatch.pl
@@ -3306,7 +3306,8 @@ sub process {
 		    # 'choice' is usually the last thing on the line (though
 		    # Kconfig supports named choices), so use a word boundary
 		    # (\b) rather than a whitespace character (\s)
-		    $line =~ /^\+\s*(?:config|menuconfig|choice)\b/) {
+		    $line =~ /^\+(\s*)(?:config|menuconfig|choice)\b/) {
+			my $base_indent = $1;
 			my $length = 0;
 			my $cnt = $realcnt;
 			my $ln = $linenr + 1;
@@ -3315,6 +3316,7 @@ sub process {
 			my $is_end = 0;
 			my $help_indent;
 			my $help_stat_real;
+			my $block_stat_real;
 			for (; $cnt > 0 && defined $lines[$ln - 1]; $ln++) {
 				$f = $lines[$ln - 1];
 				$cnt-- if ($lines[$ln - 1] !~ /^-/);
@@ -3323,7 +3325,10 @@ sub process {
 				next if ($f =~ /^-/);
 				last if (!$file && $f =~ /^\@\@/);
 
-				if ($lines[$ln - 1] =~ /^\+\s*(?:bool|tristate|int|hex|string|prompt)\s*(?:["'].*)?$/) {
+				if ($lines[$ln - 1] =~ /^\+(\s*)(?:bool|tristate|int|hex|string|prompt)\s*(?:["'].*)?$/) {
+					if ($1 !~ /^$base_indent\t$/) {
+						$block_stat_real = get_stat_real($linenr, $ln);
+					}
 					$is_start = 1;
 				} elsif ($lines[$ln - 1] =~ /^\+(\s*)help$/) {
 					$help_indent = $1;
@@ -3358,6 +3363,10 @@ sub process {
 				WARN("CONFIG_DESCRIPTION",
 				     "please write a paragraph ($length/$min_conf_desc_length lines) that describes the config symbol fully\n" . $herecurr);
 			}
+			if ($is_start && $is_end && defined $block_stat_real) {
+				WARN("CONFIG_DESCRIPTION",
+				     "please indent the block a single tab more than the start\n" . "$here\n$block_stat_real\n");
+			}
 			if ($is_start && $is_end && defined $help_stat_real) {
 				WARN("CONFIG_DESCRIPTION",
 				     "please indent the help text two spaces more than the keyword\n" . "$here\n$help_stat_real\n");
_

Patches currently in -mm which might be from nicolai.fischer@fau.de are


