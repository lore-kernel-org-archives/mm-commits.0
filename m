Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6738C04A6A
	for <mm-commits@archiver.kernel.org>; Tue,  8 Aug 2023 19:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233205AbjHHTy0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Aug 2023 15:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbjHHTyF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Aug 2023 15:54:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C506A7A
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 11:04:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D4D629A2
        for <mm-commits@vger.kernel.org>; Tue,  8 Aug 2023 18:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92939C433C8;
        Tue,  8 Aug 2023 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691517884;
        bh=c4hz5jFYFDUjaHHZeKIxuDLfXmS5/itbwTDPcV8IgtA=;
        h=Date:To:From:Subject:From;
        b=dNonTzHGE8cB4mNxdRZECByYntU/axVh/2wnU1cxT2XHQHeTh5A2nsFlKRKYlEGpS
         hog3FKdKHUwAHbBOWockzpck0uA+ALMHl64UkWIwAi/imwG1SQaj90AIOjW/zeLbO0
         SpqdutF9VIEiuYvOeBgD1iPwHNP7uVyp9WjBlKfg=
Date:   Tue, 08 Aug 2023 11:04:44 -0700
To:     mm-commits@vger.kernel.org, jim.cromie@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-reword-long-line-warning-about-commit-msg.patch added to mm-nonmm-unstable branch
Message-Id: <20230808180444.92939C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: reword long-line warning about commit-msg
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-reword-long-line-warning-about-commit-msg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-reword-long-line-warning-about-commit-msg.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Jim Cromie <jim.cromie@gmail.com>
Subject: checkpatch: reword long-line warning about commit-msg
Date: Mon, 7 Aug 2023 21:30:19 -0600

Reword the warning to complain about line length 1st, since thats
whats actually tested.

Link: https://lkml.kernel.org/r/20230808033019.21911-3-jim.cromie@gmail.com
Cc: apw@canonical.com
Cc: joe@perches.com
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-reword-long-line-warning-about-commit-msg
+++ a/scripts/checkpatch.pl
@@ -3272,7 +3272,7 @@ sub process {
 					# A Fixes:, link or signature tag line
 		      $commit_log_possible_stack_dump)) {
 			WARN("COMMIT_LOG_LONG_LINE",
-			     "Possible unwrapped commit description (prefer a maximum 75 chars per line)\n" . $herecurr);
+			     "Prefer a maximum 75 chars per line (possible unwrapped commit description?)\n" . $herecurr);
 			$commit_log_long_line = 1;
 		}
 
_

Patches currently in -mm which might be from jim.cromie@gmail.com are

checkpatch-special-case-extern-struct-in-c.patch
checkpatch-reword-long-line-warning-about-commit-msg.patch

