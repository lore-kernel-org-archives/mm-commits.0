Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D64C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A70F9233FE
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgLPRKf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:60336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbgLPRKf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:35 -0500
Date:   Wed, 16 Dec 2020 09:10:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138619;
        bh=C+RqBM0PtU4lmxHBzIG8Y7dc8qsKILEdwx/cpBI4nj0=;
        h=From:To:Subject:From;
        b=GNQbgTGyjmd+zgCs4jDyCGcSZdsC462yvy7u7UwT0zJXD6CHPZxYibKlmFTnlepc0
         hsFVaq06FHd/arZfaLfzs/XmUYMdvakxZyMk7MBH4Xf8BmMHL9SOWhaoJw2pfIaIJh
         A/L+m6K9dULiaWsGxOO7EwJQXiSrZva1Zi2NW7gI=
From:   akpm@linux-foundation.org
To:     joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, yashsri421@gmail.com
Subject:  [merged]
 checkpatch-add-fix-option-for-logical_continuations.patch removed from -mm
 tree
Message-ID: <20201216171019.8P0hNLuSJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add fix option for LOGICAL_CONTINUATIONS
has been removed from the -mm tree.  Its filename was
     checkpatch-add-fix-option-for-logical_continuations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aditya Srivastava <yashsri421@gmail.com>
Subject: checkpatch: add fix option for LOGICAL_CONTINUATIONS

Currently, checkpatch warns if logical continuations are placed at the
start of a line and not at the end of previous line.

E.g., running checkpatch on commit 3485507fc272 ("staging: bcm2835-camera:
Reduce length of enum names") reports:

CHECK:LOGICAL_CONTINUATIONS: Logical continuations should be on the
previous line
+	if (!ret
+	    && camera_port ==

Provide a simple fix by inserting logical operator at the last
non-comment, non-whitespace char of the previous line and removing from
current line, if both the lines are additions(ie start with '+')

Link: https://lkml.kernel.org/r/20201123102818.24364-1-yashsri421@gmail.com
Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-fix-option-for-logical_continuations
+++ a/scripts/checkpatch.pl
@@ -3545,8 +3545,16 @@ sub process {
 
 # check for && or || at the start of a line
 		if ($rawline =~ /^\+\s*(&&|\|\|)/) {
-			CHK("LOGICAL_CONTINUATIONS",
-			    "Logical continuations should be on the previous line\n" . $hereprev);
+			my $operator = $1;
+			if (CHK("LOGICAL_CONTINUATIONS",
+				"Logical continuations should be on the previous line\n" . $hereprev) &&
+			    $fix && $prevrawline =~ /^\+/) {
+				# insert logical operator at last non-comment, non-whitepsace char on previous line
+				$prevline =~ /[\s$;]*$/;
+				my $line_end = substr($prevrawline, $-[0]);
+				$fixed[$fixlinenr - 1] =~ s/\Q$line_end\E$/ $operator$line_end/;
+				$fixed[$fixlinenr] =~ s/\Q$operator\E\s*//;
+			}
 		}
 
 # check indentation starts on a tab stop
_

Patches currently in -mm which might be from yashsri421@gmail.com are


