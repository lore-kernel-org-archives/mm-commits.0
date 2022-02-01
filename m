Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54214C433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Feb 2022 00:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiBAAzY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 19:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiBAAzX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 19:55:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE40EC061714
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 16:55:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C3666116C
        for <mm-commits@vger.kernel.org>; Tue,  1 Feb 2022 00:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9BFC340E8;
        Tue,  1 Feb 2022 00:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643676922;
        bh=RXLIQf9uvzsZNNf3A9aEKigNNhHcPCi1BKJsAUT/H/M=;
        h=Date:To:From:Subject:From;
        b=ntp2ygul1K0GzcWjvw+mRO4kTbymiQicLCgES2XejBfFLL+v9O+ZWRkw2ycq1BkUB
         MjnEFGofurNBJ4rZiJspmH6/iM0AWDpwCWWi2/UpckXtWqP6C4J71t6++mZWDtdsuz
         eWw0qjnR6z8bHW67f/KkmrU5S8sLgGmZEn7PISJM=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 16:55:21 -0800
Date:   Mon, 31 Jan 2022 16:55:21 -0800
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        dwaipayanray1@gmail.com, joe@perches.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-prefer-module_licensegpl-over-module_licensegpl-v2.patch added to -mm tree
Message-Id: <20220201005521.AB9BFC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: prefer MODULE_LICENSE("GPL") over MODULE_LICENSE("GPL v2")
has been added to the -mm tree.  Its filename is
     checkpatch-prefer-module_licensegpl-over-module_licensegpl-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-prefer-module_licensegpl-over-module_licensegpl-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-prefer-module_licensegpl-over-module_licensegpl-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: prefer MODULE_LICENSE("GPL") over MODULE_LICENSE("GPL v2")

There is no effective difference.

Given the large number of uses of "GPL v2", emit this message only for
patches as a trivial treeside sed could be done one day.

Ref: commit bf7fbeeae6db ("module: Cure the MODULE_LICENSE "GPL" vs. "GPL v2" bogosity")

Link: https://lkml.kernel.org/r/20220128185924.80137-1-joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-prefer-module_licensegpl-over-module_licensegpl-v2
+++ a/scripts/checkpatch.pl
@@ -7418,6 +7418,13 @@ sub process {
 				WARN("MODULE_LICENSE",
 				     "unknown module license " . $extracted_string . "\n" . $herecurr);
 			}
+			if (!$file && $extracted_string eq '"GPL v2"') {
+				if (WARN("MODULE_LICENSE",
+				     "Prefer \"GPL\" over \"GPL v2\" - see commit bf7fbeeae6db (\"module: Cure the MODULE_LICENSE \"GPL\" vs. \"GPL v2\" bogosity\")\n" . $herecurr) &&
+				    $fix) {
+					$fixed[$fixlinenr] =~ s/\bMODULE_LICENSE\s*\(\s*"GPL v2"\s*\)/MODULE_LICENSE("GPL")/;
+				}
+			}
 		}
 
 # check for sysctl duplicate constants
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-prefer-module_licensegpl-over-module_licensegpl-v2.patch
checkpatch-add-fix-option-for-some-trailing_statements.patch

