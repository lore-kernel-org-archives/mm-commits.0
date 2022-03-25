Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763F9C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357510AbiCYBhb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357406AbiCYBf6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABB1338AD
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D017E60B42
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F51C340F1;
        Fri, 25 Mar 2022 01:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172032;
        bh=/r+C+/BugXykieJRIc8bOFa559kISGxiwICDiD0YEqc=;
        h=Date:To:From:Subject:From;
        b=rTqSyWgUU3n3B5dWx2u559P1DRtyQguWSYNZOjPgAOsCw1WlQ+biGH+GsUJxX+3JI
         Mc2NhtFpN3vj39qZT0XtWuIjtwNcI/TjC9Xr2LPYXcXGHieQu8t+7iurDDB1vWPhNE
         eDcMUMn574O5gBfDDX1wwibCn75gnojGfoHM2VNI=
Date:   Thu, 24 Mar 2022 18:33:51 -0700
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        dwaipayanray1@gmail.com, joe@perches.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] checkpatch-prefer-module_licensegpl-over-module_licensegpl-v2.patch removed from -mm tree
Message-Id: <20220325013352.33F51C340F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: prefer MODULE_LICENSE("GPL") over MODULE_LICENSE("GPL v2")
has been removed from the -mm tree.  Its filename was
     checkpatch-prefer-module_licensegpl-over-module_licensegpl-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


