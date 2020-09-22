Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36FAC4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C6E823600
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600796922;
	bh=1Z5Gg+Giu0GlH8fhz0Ma9MboDSFNZBT9qurKLBf2iC0=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=ad2vyxI6xIrateezpbrQV3FynRfzMEycIRLBTDmi2zmzsYJWTBRmKgAeHzhDKjiVJ
	 dvWxBPzlamZ7Ms1HeSL+OxEhJ7d6et2meO20IQZQfVsNcffqBvaGlua7o7YD4pLO+O
	 GMVKmRRijOnBUY9R4czKWpPn+Drz1JP96GaHeySg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIVRsm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbgIVRsi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:48:38 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2387823600;
        Tue, 22 Sep 2020 17:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600796917;
        bh=1Z5Gg+Giu0GlH8fhz0Ma9MboDSFNZBT9qurKLBf2iC0=;
        h=Date:From:To:Subject:From;
        b=m60n8mDLYR9dyE1VwN42/E7NcAEadQk/t71iJCsc3cwfdpzFZxCdtP82COb5ZSxnG
         nFvT/3jeNx53j1SfeHQuywa8+XKnwgdRI/hGnVdU/yecPoQ7UuJvhi4bNjXlmGvMQ1
         Py0rYdy9S6b11tVL1UZEZU4xq3B1cgNfWbcD6vXw=
Date:   Tue, 22 Sep 2020 10:48:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, dwaipayanray1@gmail.com
Subject:  +
 checkpatch-extend-author-signed-off-by-check-for-split-from-header.patch
 added to -mm tree
Message-ID: <20200922174836.VnjaI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: extend author Signed-off-by check for split From: header
has been added to the -mm tree.  Its filename is
     checkpatch-extend-author-signed-off-by-check-for-split-from-header.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-extend-author-signed-off-by-check-for-split-from-header.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-extend-author-signed-off-by-check-for-split-from-header.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: checkpatch: extend author Signed-off-by check for split From: header

Checkpatch did not handle cases where the author From: header was split
into multiple lines.  The author identity could not be resolved and
checkpatch generated a false NO_AUTHOR_SIGN_OFF warning.

A typical example is commit e33bcbab16d1 ("tee: add support for session's
client UUID generation").  When checkpatch was run on this commit, it
displayed:

"WARNING:NO_AUTHOR_SIGN_OFF: Missing Signed-off-by: line by nominal
patch author ''"

This was due to split header lines not being handled properly and the
author himself wrote in commit cd2614967d8b ("checkpatch: warn if missing
author Signed-off-by"):

"Split From: headers are not fully handled: only the first part
is compared."

Support split From: headers by correctly parsing the header extension
lines.  RFC 5322, Section-2.2.3 stated that each extended line must start
with a WSP character (a space or htab).  The solution was therefore to
concatenate the lines which start with a WSP to get the correct long
header.

Link: https://lore.kernel.org/linux-kernel-mentees/f5d8124e54a50480b0a9fa638787bc29b6e09854.camel@perches.com/
Link: https://lkml.kernel.org/r/20200921085436.63003-1-dwaipayanray1@gmail.com
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Reviewed-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Tested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-extend-author-signed-off-by-check-for-split-from-header
+++ a/scripts/checkpatch.pl
@@ -2681,6 +2681,10 @@ sub process {
 # Check the patch for a From:
 		if (decode("MIME-Header", $line) =~ /^From:\s*(.*)/) {
 			$author = $1;
+			my $curline = $linenr;
+			while(defined($rawlines[$curline]) && ($rawlines[$curline++] =~ /^[ \t]\s*(.*)/)) {
+				$author .= $1;
+			}
 			$author = encode("utf8", $author) if ($line =~ /=\?utf-8\?/i);
 			$author =~ s/"//g;
 			$author = reformat_email($author);
_

Patches currently in -mm which might be from dwaipayanray1@gmail.com are

checkpatch-extend-author-signed-off-by-check-for-split-from-header.patch

