Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331FCC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiATCJm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358208AbiATCJg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:09:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5133DC061574
        for <mm-commits@vger.kernel.org>; Wed, 19 Jan 2022 18:09:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E325161522
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D16EC004E1;
        Thu, 20 Jan 2022 02:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644575;
        bh=sAL76XRTrSytbbGOteVozggk1C8KbZQOYLjr3IQVaNI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=XNvSHOLROi4EMcJlKmgWClLBWlwHKf7WLscqNbCFEV88ZOMzJhapgAPUiX40ORDlC
         3mO61aEUXiEwM9q4wX5GlTTWubohnBh2M2+l6cGqzhSLrcQHiULGSDDnSxJVN/phBb
         6mE2HDPDrUqSTsiITiEaJvWlGGuIASbmE076+oI0=
Date:   Wed, 19 Jan 2022 18:09:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, apw@canonical.com,
        dwaipayanray1@gmail.com, joe@perches.com, linux-mm@kvack.org,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 35/55] checkpatch: improve Kconfig help test
Message-ID: <20220120020934.hdVjEwq4j%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve Kconfig help test

The Kconfig help test erroneously counts patch context lines as part of
the help text.

Fix that and improve the message block output.

Link: https://lkml.kernel.org/r/06c0cdc157ae1502e8e9eb3624b9ea995cf11e7a.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   52 ++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-improve-kconfig-help-test
+++ a/scripts/checkpatch.pl
@@ -3479,47 +3479,47 @@ sub process {
 		    # Kconfig supports named choices), so use a word boundary
 		    # (\b) rather than a whitespace character (\s)
 		    $line =~ /^\+\s*(?:config|menuconfig|choice)\b/) {
-			my $length = 0;
-			my $cnt = $realcnt;
-			my $ln = $linenr + 1;
-			my $f;
-			my $is_start = 0;
-			my $is_end = 0;
-			for (; $cnt > 0 && defined $lines[$ln - 1]; $ln++) {
-				$f = $lines[$ln - 1];
-				$cnt-- if ($lines[$ln - 1] !~ /^-/);
-				$is_end = $lines[$ln - 1] =~ /^\+/;
+			my $ln = $linenr;
+			my $needs_help = 0;
+			my $has_help = 0;
+			my $help_length = 0;
+			while (defined $lines[$ln]) {
+				my $f = $lines[$ln++];
 
 				next if ($f =~ /^-/);
-				last if (!$file && $f =~ /^\@\@/);
+				last if ($f !~ /^[\+ ]/);	# !patch context
 
-				if ($lines[$ln - 1] =~ /^\+\s*(?:bool|tristate|prompt)\s*["']/) {
-					$is_start = 1;
-				} elsif ($lines[$ln - 1] =~ /^\+\s*(?:---)?help(?:---)?$/) {
-					$length = -1;
+				if ($f =~ /^\+\s*(?:bool|tristate|prompt)\s*["']/) {
+					$needs_help = 1;
+					next;
+				}
+				if ($f =~ /^\+\s*help\s*$/) {
+					$has_help = 1;
+					next;
 				}
 
-				$f =~ s/^.//;
-				$f =~ s/#.*//;
-				$f =~ s/^\s+//;
-				next if ($f =~ /^$/);
+				$f =~ s/^.//;	# strip patch context [+ ]
+				$f =~ s/#.*//;	# strip # directives
+				$f =~ s/^\s+//;	# strip leading blanks
+				next if ($f =~ /^$/);	# skip blank lines
 
+				# At the end of this Kconfig block:
 				# This only checks context lines in the patch
 				# and so hopefully shouldn't trigger false
 				# positives, even though some of these are
 				# common words in help texts
-				if ($f =~ /^\s*(?:config|menuconfig|choice|endchoice|
-						  if|endif|menu|endmenu|source)\b/x) {
-					$is_end = 1;
+				if ($f =~ /^(?:config|menuconfig|choice|endchoice|
+					       if|endif|menu|endmenu|source)\b/x) {
 					last;
 				}
-				$length++;
+				$help_length++ if ($has_help);
 			}
-			if ($is_start && $is_end && $length < $min_conf_desc_length) {
+			if ($needs_help &&
+			    $help_length < $min_conf_desc_length) {
+				my $stat_real = get_stat_real($linenr, $ln - 1);
 				WARN("CONFIG_DESCRIPTION",
-				     "please write a paragraph that describes the config symbol fully\n" . $herecurr);
+				     "please write a help paragraph that fully describes the config symbol\n" . "$here\n$stat_real\n");
 			}
-			#print "is_start<$is_start> is_end<$is_end> length<$length>\n";
 		}
 
 # check MAINTAINERS entries
_
