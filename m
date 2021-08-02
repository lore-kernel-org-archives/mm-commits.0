Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD18C4338F
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 21:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F1F6A60FA0
	for <mm-commits@archiver.kernel.org>; Mon,  2 Aug 2021 21:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhHBVnk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 2 Aug 2021 17:43:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhHBVnj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Aug 2021 17:43:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9168F60F4B;
        Mon,  2 Aug 2021 21:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627940609;
        bh=fZQZwA1yuPmyPhHUmU8SRgL77y7nFTJlHWtsJKNmtBw=;
        h=Date:From:To:Subject:From;
        b=T+C8sPnFY1NyAQwoXfndB+KXQ9L2F4mSXQ5S5zZwS2CCfOoKI2VMRyENLAwpORCwN
         3ZItwMcyi8B9xt3/GlRuUf+HNKGZJM1DMWYonFjrBv27Mn3cgeUms4hggA5IcOOLu2
         P4G0Fv83LgMg6j8PRSASA4aV1l+a+OObRgAJEuAk=
Date:   Mon, 02 Aug 2021 14:43:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sjg@chromium.org, joe@perches.com
Subject:  + checkpatch-support-wide-strings.patch added to -mm tree
Message-ID: <20210802214329.2eMwR%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: support wide strings
has been added to the -mm tree.  Its filename is
     checkpatch-support-wide-strings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-support-wide-strings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-support-wide-strings.patch

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
Subject: checkpatch: support wide strings

Allow prefixing typical strings with L for wide strings and u for unicode
strings.

Link: https://lkml.kernel.org/r/20210801170733.1.I3f9784fd3c1007d08ec2e70b151d137687575495@changeid
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Simon Glass <sjg@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-support-wide-strings
+++ a/scripts/checkpatch.pl
@@ -501,7 +501,7 @@ our $Binary	= qr{(?i)0b[01]+$Int_type?};
 our $Hex	= qr{(?i)0x[0-9a-f]+$Int_type?};
 our $Int	= qr{[0-9]+$Int_type?};
 our $Octal	= qr{0[0-7]+$Int_type?};
-our $String	= qr{"[X\t]*"};
+our $String	= qr{(?:\b[Lu])?"[X\t]*"};
 our $Float_hex	= qr{(?i)0x[0-9a-f]+p-?[0-9]+[fl]?};
 our $Float_dec	= qr{(?i)(?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?};
 our $Float_int	= qr{(?i)[0-9]+e-?[0-9]+[fl]?};
@@ -6132,7 +6132,8 @@ sub process {
 		}
 
 # concatenated string without spaces between elements
-		if ($line =~ /$String[A-Za-z0-9_]/ || $line =~ /[A-Za-z0-9_]$String/) {
+		if ($line =~ /$String[A-Z_]/ ||
+		    ($line =~ /([A-Za-z0-9_]+)$String/ && $1 !~ /^[Lu]$/)) {
 			if (CHK("CONCATENATED_STRING",
 				"Concatenated strings should use spaces between elements\n" . $herecurr) &&
 			    $fix) {
@@ -6145,7 +6146,7 @@ sub process {
 		}
 
 # uncoalesced string fragments
-		if ($line =~ /$String\s*"/) {
+		if ($line =~ /$String\s*[Lu]?"/) {
 			if (WARN("STRING_FRAGMENTS",
 				 "Consecutive strings are generally better as a single string\n" . $herecurr) &&
 			    $fix) {
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-support-wide-strings.patch

