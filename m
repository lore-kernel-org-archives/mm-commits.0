Return-Path: <SRS0=lzHQ=BG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5198C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 19:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4A4620759
	for <mm-commits@archiver.kernel.org>; Mon, 27 Jul 2020 19:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595879926;
	bh=++mbjveb3iTEur2NKfkr976JMAvyXHPsMxMiCW+Bfvk=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=zHqhO1qbd0J7ywoHzFwG8mx4gUqn00MyyHh5v4V3kJN8yz4B/IrlmfquOy6/F3H+L
	 jCSnws4zXXnn+bBEIPqBDqutO7j5cKwEa3q6BFmqnFOrXW9E/i6H7Krf7TMIJVPgjT
	 IisQw4W7WBdJQCb+RUI2oWqOyvFPoUUBsXWGd39w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgG0T6q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Jul 2020 15:58:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728348AbgG0T6q (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 27 Jul 2020 15:58:46 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DD222072E;
        Mon, 27 Jul 2020 19:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595879925;
        bh=++mbjveb3iTEur2NKfkr976JMAvyXHPsMxMiCW+Bfvk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AoaaGRdatf19zQzCw06huu5hjVnpbe5mAAA7iMHH0he7vPzlHSZ3IUnzUXM9LQ/tm
         TzY/jfhztyoHpEFGesEtdyvnflpDv45k6fG/F8Y/aR/goQebLYNf5eBo4nS1P3A96H
         kWI0gGnGtmocZgMkxKfUSeygUv9SATx/CWnjPGD0=
Date:   Mon, 27 Jul 2020 12:58:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     joe@perches.com, mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  + checkpatch-add-test-for-repeated-words.patch added to
 -mm tree
Message-ID: <20200727195845.CZYQns9V9%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for repeated words
has been added to the -mm tree.  Its filename is
     checkpatch-add-test-for-repeated-words.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-test-for-repeated-words.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-test-for-repeated-words.patch

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
Subject: checkpatch: add test for repeated words

Try to avoid adding repeated words either on the same line or consecutive
comment lines in a block

e.g.:

duplicated word in comment block

	/*
	 * this is a comment block where the last word of the previous
	 * previous line is also the first word of the next line
	 */

and simple duplication

	/* test this this again */

Link: http://lkml.kernel.org/r/cda9b566ad67976e1acd62b053de50ee44a57250.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Inspired-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-test-for-repeated-words
+++ a/scripts/checkpatch.pl
@@ -591,6 +591,8 @@ our @mode_permission_funcs = (
 	["__ATTR", 2],
 );
 
+my $word_pattern = '\b[A-Z]?[a-z]{2,}\b';
+
 #Create a search pattern for all these functions to speed up a loop below
 our $mode_perms_search = "";
 foreach my $entry (@mode_permission_funcs) {
@@ -3345,6 +3347,42 @@ sub process {
 			}
 		}
 
+# check for repeated words separated by a single space
+		if ($rawline =~ /^\+/) {
+			while ($rawline =~ /\b($word_pattern) (?=($word_pattern))/g) {
+
+				my $first = $1;
+				my $second = $2;
+
+				if ($first =~ /(?:struct|union|enum)/) {
+					pos($rawline) += length($first) + length($second) + 1;
+					next;
+				}
+
+				next if ($first ne $second);
+				next if ($first eq 'long');
+
+				if (WARN("REPEATED_WORD",
+					 "Possible repeated word: '$first'\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\b$first $second\b/$first/;
+				}
+			}
+
+			# if it's a repeated word on consecutive lines in a comment block
+			if ($prevline =~ /$;+\s*$/ &&
+			    $prevrawline =~ /($word_pattern)\s*$/) {
+				my $last_word = $1;
+				if ($rawline =~ /^\+\s*\*\s*$last_word /) {
+					if (WARN("REPEATED_WORD",
+						 "Possible repeated word: '$last_word'\n" . $hereprev) &&
+					    $fix) {
+						$fixed[$fixlinenr] =~ s/(\+\s*\*\s*)$last_word /$1/;
+					}
+				}
+			}
+		}
+
 # check for space before tabs.
 		if ($rawline =~ /^\+/ && $rawline =~ / \t/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-test-git_dir-changes.patch
const_structscheckpatch-add-regulator_ops.patch
checkpatch-add-test-for-possible-misuse-of-is_enabled-without-config_.patch
checkpatch-add-fix-option-for-assign_in_if.patch
checkpatch-add-test-for-repeated-words.patch
nilfs2-convert-__nilfs_msg-to-integrate-the-level-and-format.patch
nilfs2-use-a-more-common-logging-style.patch

