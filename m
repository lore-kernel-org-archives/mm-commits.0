Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00498C2BBCA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF5592333E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgLPEpe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:45:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbgLPEpe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:45:34 -0500
Date:   Tue, 15 Dec 2020 20:45:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093919;
        bh=VOb4/zTithhGZA9XBPvlDZHEWsbBmjS10QHgxMwLpng=;
        h=From:To:Subject:In-Reply-To:From;
        b=mn8zWftDklQvyOQfoRDOAu+L1yVbDmTBaalv+03N6HlpJM5VlWKxr5p9yYrl2DHmS
         uZu/n+cSScxxyJBOGwhvHnbYROUCeN9z0BZptctfwo928V7twP/dUYYtoG6iKN8bGy
         pwdKW4U5aUeeuSRlwHV/FmUwqtWoXcrbCB1Lwowo=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dwaipayanray1@gmail.com,
        joe@perches.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yepeilin.cs@gmail.com
Subject:  [patch 55/95] checkpatch: add warning for lines starting
 with a '#' in commit log
Message-ID: <20201216044518.TGyBrn5SZ%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Dwaipayan Ray <dwaipayanray1@gmail.com>
Subject: checkpatch: add warning for lines starting with a '#' in commit log

Commit log lines starting with '#' are dropped by git as comments.
Add a check to emit a warning for these lines.

Also add a --fix option to insert a space before the leading '#' in
such lines.

Link: https://lkml.kernel.org/r/20201202205740.127986-1-dwaipayanray1@gmail.com
Signed-off-by: Dwaipayan Ray <dwaipayanray1@gmail.com>
Suggested-by: Joe Perches <joe@perches.com>
Suggested-by: Peilin Ye <yepeilin.cs@gmail.com>
Tested-by: Peilin Ye <yepeilin.cs@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-add-warning-for-lines-starting-with-a-in-commit-log
+++ a/scripts/checkpatch.pl
@@ -3033,6 +3033,15 @@ sub process {
 			$commit_log_possible_stack_dump = 0;
 		}
 
+# Check for lines starting with a #
+		if ($in_commit_log && $line =~ /^#/) {
+			if (WARN("COMMIT_COMMENT_SYMBOL",
+				 "Commit log lines starting with '#' are dropped by git as comments\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$fixlinenr] =~ s/^/ /;
+			}
+		}
+
 # Check for git id commit length and improperly formed commit descriptions
 		if ($in_commit_log && !$commit_log_possible_stack_dump &&
 		    $line !~ /^\s*(?:Link|Patchwork|http|https|BugLink|base-commit):/i &&
_
