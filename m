Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05DE3C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 02:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358174AbiATCIy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Jan 2022 21:08:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50752 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358178AbiATCIx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jan 2022 21:08:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47EA8B81C96
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 02:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CCAC004E1;
        Thu, 20 Jan 2022 02:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642644531;
        bh=OtUb3uQ7WP0FDp9c/ZhGH8jOVFb7HUVzJggNdKYkwrI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Kv7YacraVC0Pp44ceBx5a8a/mmfxOxjM1AdjfQCS8xN78S3hoFFHX746h47tq5hNf
         Nk6o3+ajxvYvFOweAouIxlCagSVnGe36C57UK3uLFuWfhndTLHT9oGINMeOwAoXatM
         Iu7fl4D6xxnosCoNmpKZsFfy9SjAOB7XXGWmMPPk=
Date:   Wed, 19 Jan 2022 18:08:50 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org
Subject:  [patch 21/55] get_maintainer: don't remind about no git
 repo when --nogit is used
Message-ID: <20220120020850.UfUC4fWu0%akpm@linux-foundation.org>
In-Reply-To: <20220119180714.9e187ce100e4510de3cd9f7d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
