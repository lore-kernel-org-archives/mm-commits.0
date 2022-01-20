Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4643BC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377924AbiATVaX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377920AbiATVaX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:30:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3159DC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED254B81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F13BC340E0;
        Thu, 20 Jan 2022 21:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714220;
        bh=BgAAqFhJ1/vm/UPc7PPhcv65wU8nBVcYVP7IMvisMXc=;
        h=Date:From:To:Subject:From;
        b=FuqQqVoKhKMF0/aQbBQh0Fl1B1JVw2j8G93QEvWGVp3C8d06OZKjIbe2mTR4wJlJJ
         g19eHyI62XIB6Ui9AwQbjApmNOm+XJ+jE//EPdGG3i/ufoJfP0B4dOOkgEp/Fp9Meh
         cHtndUyyo5jNk9k4/wA2gmzqEHO0bW9P3NUFmzZA=
Date:   Thu, 20 Jan 2022 13:30:20 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged]
 get_maintainer-dont-remind-about-no-git-repo-when-nogit-is-used.patch
 removed from -mm tree
Message-ID: <20220120213020.Y8UKU0_jl%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: don't remind about no git repo when --nogit is used
has been removed from the -mm tree.  Its filename was
     get_maintainer-dont-remind-about-no-git-repo-when-nogit-is-used.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

sysctl-documentation-fix-table-format-warning.patch

