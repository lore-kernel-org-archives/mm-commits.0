Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0086C636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbjBCGwN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:52:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjBCGv3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83408CAA1
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 96B0EB8298A
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B9DC4339B;
        Fri,  3 Feb 2023 06:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407074;
        bh=fo3N1JAngoW6OJxhuESbmeZMwR4FKXgUjPU1Flg1W9M=;
        h=Date:To:From:Subject:From;
        b=HM83Wfi3gJq/WHQjuHoZppjUSYaVjV0mqVAaDWNIiMfNdlB/wjnYqOavwB+TbLyFY
         sxwx8AxjXX4cP20DYsedLIJxIb5IayDMdPQf5PpLFKWesQhe3ywBDtTkLn4ry3qQVp
         l+7S9iw4VUgdzCDOMza8X9XfE4OB0gSU+33D5I+U=
Date:   Thu, 02 Feb 2023 22:51:13 -0800
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        kai@dev.carbon-project.org, joe@perches.com,
        dwaipayanray1@gmail.com, apw@canonical.com, linux@leemhuis.info,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-use-proper-way-for-show-problematic-line.patch removed from -mm tree
Message-Id: <20230203065114.39B9DC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: use proper way for show problematic line
has been removed from the -mm tree.  Its filename was
     checkpatch-use-proper-way-for-show-problematic-line.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Thorsten Leemhuis <linux@leemhuis.info>
Subject: checkpatch: use proper way for show problematic line
Date: Fri, 20 Jan 2023 13:35:20 +0100

Instead of using an unnecessarily complicated approach to print a line
that is warned about, use `$herecurr` instead, just like everywhere else
in checkpatch.

While at it, remove a superfluous space in one of the changed lines, too. 
In a unmodified line also remove a superfluous check for a space before a
signed-off-by tag, to me consistent with the check at the start of the
section.

All three problems were found by Joe Perches during review of new code
inspired by the code modified here.

Link: https://lkml.kernel.org/r/a6d455c5196219b2095c2ac3645498052845f32e.1674217480.git.linux@leemhuis.info
Signed-off-by: Thorsten Leemhuis <linux@leemhuis.info>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Kai Wasserbäch <kai@dev.carbon-project.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/checkpatch.pl~checkpatch-use-proper-way-for-show-problematic-line
+++ a/scripts/checkpatch.pl
@@ -3144,17 +3144,17 @@ sub process {
 			if ($sign_off =~ /^co-developed-by:$/i) {
 				if ($email eq $author) {
 					WARN("BAD_SIGN_OFF",
-					      "Co-developed-by: should not be used to attribute nominal patch author '$author'\n" . "$here\n" . $rawline);
+					      "Co-developed-by: should not be used to attribute nominal patch author '$author'\n" . $herecurr);
 				}
 				if (!defined $lines[$linenr]) {
 					WARN("BAD_SIGN_OFF",
-					     "Co-developed-by: must be immediately followed by Signed-off-by:\n" . "$here\n" . $rawline);
-				} elsif ($rawlines[$linenr] !~ /^\s*signed-off-by:\s*(.*)/i) {
+					     "Co-developed-by: must be immediately followed by Signed-off-by:\n" . $herecurr);
+				} elsif ($rawlines[$linenr] !~ /^signed-off-by:\s*(.*)/i) {
 					WARN("BAD_SIGN_OFF",
-					     "Co-developed-by: must be immediately followed by Signed-off-by:\n" . "$here\n" . $rawline . "\n" .$rawlines[$linenr]);
+					     "Co-developed-by: must be immediately followed by Signed-off-by:\n" . $herecurr . $rawlines[$linenr] . "\n");
 				} elsif ($1 ne $email) {
 					WARN("BAD_SIGN_OFF",
-					     "Co-developed-by and Signed-off-by: name/email do not match \n" . "$here\n" . $rawline . "\n" .$rawlines[$linenr]);
+					     "Co-developed-by and Signed-off-by: name/email do not match\n" . $herecurr . $rawlines[$linenr] . "\n");
 				}
 			}
 
_

Patches currently in -mm which might be from linux@leemhuis.info are


