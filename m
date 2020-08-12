Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE656C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FC0F206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196118;
	bh=V/u/vr/b+etufjuRRQ7P+B9ek7ucUbEMdCvZy7i74KI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=lXVrVQIgn6jGiQxcDLSRgqn4DpVbyuJr14hw28Nd9OCvdn10VjZ1cmOl8+Czk3x68
	 FpyyPJEIX9iurkSa6ubwG5kv4G7hxmuZh6GEy7YZuWpsxKgq1U5JeoAXTpAvycoRzO
	 QcfIQJbMk03V8xI9wzegWGX0c7pEOQFttLsk6fBI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgHLBfS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726430AbgHLBfS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:35:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6105C206B2;
        Wed, 12 Aug 2020 01:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196116;
        bh=V/u/vr/b+etufjuRRQ7P+B9ek7ucUbEMdCvZy7i74KI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kf3stt5zkE44j/YjLCHSt3+LXa4JrdrBt2tv9XCElD1qb7x6I7xbUFbfLpRrCkbFX
         qxdbpuUwW1j9rjQuabiOtD0RlomSa5OFxZ78xRCkguX8Iog9pE+xX17Z8qCLVd8vD+
         a6X+LQQtWThX9c00JzeHUEIeGyYqYEF9ntG1kpLM=
Date:   Tue, 11 Aug 2020 18:35:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 095/165] checkpatch: add test for repeated words
Message-ID: <20200812013516.nZt5osokp%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
