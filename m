Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9918C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DC63216C4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881651;
	bh=m2YBvfl9Ww8D7A/F5SVc5GJeJjhcJihNnaDJ+afmyAU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=LN+yvaXtP8WOMMIuZMVGcF57P2IAX0rYfdz8tQU08/5aS2HWgKDbWVzOklHlisOqT
	 UOKRYNwgP0hvtTUzjUTUJGg1qCYJpaVJwAOAC6KMh7VFUfMvwILlvdHxJnnW28kuAI
	 MYcNDy2Yj7qBaQNGPYsOD3MUtUPhTROIiICvQeq8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409229AbgJPUyK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:42052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409228AbgJPUyK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:54:10 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99EDE216C4;
        Fri, 16 Oct 2020 20:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881648;
        bh=m2YBvfl9Ww8D7A/F5SVc5GJeJjhcJihNnaDJ+afmyAU=;
        h=Date:From:To:Subject:From;
        b=sHrp97e4m9QTRIHZsg+Q2E/1Qc4UqlFCfdp+g+FCpiETaN8onzou0ph2VzMj/4G/A
         cKTRr+rqPMXaJQ80xIOLGykOTlT8q2vlSr1w8mq5fUWBj8CYP2wM8E5CFoCLHTXf+H
         7QmryoHLISYFvzK4Fs0SE7mc9fHVeSfsPQLOTbQ8=
Date:   Fri, 16 Oct 2020 13:54:08 -0700
From:   akpm@linux-foundation.org
To:     dwaipayanray1@gmail.com, joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 checkpatch-extend-author-signed-off-by-check-for-split-from-header.patch
 removed from -mm tree
Message-ID: <20201016205408.BG2GHbs5d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: extend author Signed-off-by check for split From: header
has been removed from the -mm tree.  Its filename was
     checkpatch-extend-author-signed-off-by-check-for-split-from-header.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from dwaipayanray1@gmail.com are


