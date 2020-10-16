Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E67C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1CEB208C7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817937;
	bh=rf0khsYeQtOXzPhddwjJ/PgJvnafZuV+h2EE5TsgeJI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=KqkF+HsQRtRTJSqABkw9AU8nJVVGM+Z7/5Ykx1F+bFxHicmjP7wlRhcFIKKC02y3Y
	 PmlU9Y516TsyZiFWaRToEZ7ViQzVvAuqTOw/eVuUI5F4IbdPTq99/U05XG3aYr5QX0
	 LlBeovDyJ25tYXxp3tNYz0Kowuqb9w2ntq17eNVM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389744AbgJPDMR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:48438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387864AbgJPDMR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:12:17 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 604D820878;
        Fri, 16 Oct 2020 03:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817936;
        bh=rf0khsYeQtOXzPhddwjJ/PgJvnafZuV+h2EE5TsgeJI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WM1HoS/tB1Ycd32GzFV2rCFMYlY/VN78dvmfrOEqZlcC8Qj34q1bjFeTmkWw7yAIC
         H9pJiK5y1fgWimb1OQUiUKRK9LLneOD3CDGlEow3nyiMrLpL8e35NFg/AcUPfSK+nN
         vO/5Pm0zUp6q9zN9HibYw/bT5bjvmhKm/AouCYPw=
Date:   Thu, 15 Oct 2020 20:12:15 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 129/156] checkpatch: extend author Signed-off-by
 check for split From: header
Message-ID: <20201016031215.lZEb0sjYg%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -2679,6 +2679,10 @@ sub process {
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
