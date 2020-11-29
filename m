Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CA5C3E8C5
	for <mm-commits@archiver.kernel.org>; Sun, 29 Nov 2020 23:51:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAD5B206F1
	for <mm-commits@archiver.kernel.org>; Sun, 29 Nov 2020 23:51:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zb6N5QF1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgK2Xvc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 29 Nov 2020 18:51:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:40988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbgK2Xvb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 29 Nov 2020 18:51:31 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCCB0206D8;
        Sun, 29 Nov 2020 23:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606693851;
        bh=B/EiwXUdqasiREQ2muClxnMXiYe3h910tUtSP3Vrf5Y=;
        h=Date:From:To:Subject:From;
        b=Zb6N5QF1tcUx5DcVMyRVeBq4DwHfmrzXeP/bkHXRu2+33cdHAl3eHtUV+wFNxomrP
         5Swxw2rJ5SsAlIdkqplW3ImXaYBww4yOXaALQBB6jcO3k0TqUiS2jpL7DiYxRtzlvh
         Usz2vwxMlPENUoEU8rhXmqagsSqNgYj6o3+1sKlU=
Date:   Sun, 29 Nov 2020 15:50:50 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, yashsri421@gmail.com
Subject:  +
 checkpatch-add-fix-option-for-logical_continuations.patch added to -mm tree
Message-ID: <20201129235050.DFL8PHGAS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add fix option for LOGICAL_CONTINUATIONS
has been added to the -mm tree.  Its filename is
     checkpatch-add-fix-option-for-logical_continuations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-fix-option-for-logical_continuations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-fix-option-for-logical_continuations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-fix-false-positives-in-repeated_word-warning.patch
checkpatch-add-fix-option-for-gerrit_change_id.patch
checkpatch-avoid-commit_log_long_line-warning-for-signature-tags.patch
checkpatch-add-fix-option-for-assignment_continuations.patch
checkpatch-add-fix-option-for-logical_continuations.patch

