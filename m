Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99AA0C433EF
	for <mm-commits@archiver.kernel.org>; Thu,  6 Jan 2022 00:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343621AbiAFATJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jan 2022 19:19:09 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59432 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239471AbiAFATH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2022 19:19:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B6AAB81E7F
        for <mm-commits@vger.kernel.org>; Thu,  6 Jan 2022 00:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4C26C36AEB;
        Thu,  6 Jan 2022 00:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1641428344;
        bh=9u/pmR+9STe7VFkq2aPb9+bngPFxe/mmRt3PdYHdr5Q=;
        h=Date:From:To:Subject:From;
        b=yZ8HZROThp14HNj68/lX6OOj6gXOSNC0qx2p95it363PQOdO8TZhFrywzVmRtvIaU
         Yd6DcVIzP3OwbpVA3z3EMqsBGFZi0tSJ5pVWIK9Zgz7rRDzYeYE7fx7POHkI40bKRq
         nhRPEu0cdawwH4c06kby3VlMWbFY6YKzXwSSRjTw=
Date:   Wed, 05 Jan 2022 16:19:03 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  +
 get_maintainer-dont-remind-about-no-git-repo-when-nogit-is-used.patch added
 to -mm tree
Message-ID: <20220106001903.mRqYFiRTh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: don't remind about no git repo when --nogit is used
has been added to the -mm tree.  Its filename is
     get_maintainer-dont-remind-about-no-git-repo-when-nogit-is-used.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-dont-remind-about-no-git-repo-when-nogit-is-used.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-dont-remind-about-no-git-repo-when-nogit-is-used.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: get_maintainer: don't remind about no git repo when --nogit is used

When --nogit is used with scripts/get_maintainer.pl, the script spews 4
lines of unnecessary information (noise).  Do not print those lines when
--nogit is specified.

This change removes the printing of these 4 lines:

  ./scripts/get_maintainer.pl: No supported VCS found.  Add --nogit to options?
  Using a git repository produces better results.
  Try Linus Torvalds' latest git repository using:
  git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Link: https://lkml.kernel.org/r/20220102031424.3328-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/get_maintainer.pl~get_maintainer-dont-remind-about-no-git-repo-when-nogit-is-used
+++ a/scripts/get_maintainer.pl
@@ -1718,7 +1718,7 @@ sub vcs_exists {
     %VCS_cmds = %VCS_cmds_hg;
     return 2 if eval $VCS_cmds{"available"};
     %VCS_cmds = ();
-    if (!$printed_novcs) {
+    if (!$printed_novcs && $email_git) {
 	warn("$P: No supported VCS found.  Add --nogit to options?\n");
 	warn("Using a git repository produces better results.\n");
 	warn("Try Linus Torvalds' latest git repository using:\n");
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-mempolicy-fix-all-kernel-doc-warnings.patch
get_maintainer-dont-remind-about-no-git-repo-when-nogit-is-used.patch

