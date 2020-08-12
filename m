Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63789C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 404862078B
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266271;
	bh=PulSu00/+EfUe8UOsWt6z4iG8BlGuIPsoXwtVoFIqUI=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=o9HtmJIRnuqDezS0Sh7XPUAzkT/YjLjz6mqzFYF2jwf8lyrGuB9hUxmPAbNrEZZfZ
	 lyv2MAPEpwxbrVatkKsaLEsQFgHo5om47zqP67SS5rGPVG5vVyUlxnZs3M8qJaS6aG
	 HKHrBRF+UE/N1hOvznqGnW6cdFdFxy6UyASSqiTk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgHLVEb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHLVEa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:04:30 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AD3820774;
        Wed, 12 Aug 2020 21:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266269;
        bh=PulSu00/+EfUe8UOsWt6z4iG8BlGuIPsoXwtVoFIqUI=;
        h=Date:From:To:Subject:From;
        b=ZLfsLTdmj1cXd/c1cEFMBPISN/YCDbNY+ycVPlH/Nk9ZAOXebSXl0qM9InL4q8+jx
         oJN4QzhiMM2IYbyIbso+gN5Wi1ePgKjrIxz9ByOHg/1PCfcj3AmMwlrzxuAjWOTt1N
         WAFamvHXNHu5Y5KHRhtOWYP/stwGaXh8BlfgZrck=
Date:   Wed, 12 Aug 2020 14:04:29 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged] checkpatch-add-test-for-repeated-words.patch
 removed from -mm tree
Message-ID: <20200812210429._SBYjmMqx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add test for repeated words
has been removed from the -mm tree.  Its filename was
     checkpatch-add-test-for-repeated-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -588,6 +588,8 @@ our @mode_permission_funcs = (
 	["__ATTR", 2],
 );
 
+my $word_pattern = '\b[A-Z]?[a-z]{2,}\b';
+
 #Create a search pattern for all these functions to speed up a loop below
 our $mode_perms_search = "";
 foreach my $entry (@mode_permission_funcs) {
@@ -3312,6 +3314,42 @@ sub process {
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

