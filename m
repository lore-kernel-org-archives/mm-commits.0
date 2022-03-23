Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB0FC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:06:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345379AbiCWXHa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345392AbiCWXHa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:07:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0001890274
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:05:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4F95B8217F
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A3FC36AE2;
        Wed, 23 Mar 2022 23:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076757;
        bh=aY1Ac9gGgXQ3FLGmYYUJjxUBFVKOHqhRHPYN+mLNezQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=j2SDASQmwg5Y37VpWffij/flDLZkNUmfc92GYhs7Khpd5Xk8TPUwQvxMJWk2JEbhN
         frXvyUk06f86X+fF/CxCXH1mLsVmaRM8Wny2QbhSonmVdyFIzJQJcUK7SHubeqkwTR
         8oMjUU/Z+BFN74nmXtnvbf8XpZ/DvGLEFMTdcQP4=
Date:   Wed, 23 Mar 2022 16:05:56 -0700
To:     lukas.bulwahn@gmail.com, dwaipayanray1@gmail.com, joe@perches.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 13/41] checkpatch: prefer MODULE_LICENSE("GPL") over MODULE_LICENSE("GPL v2")
Message-Id: <20220323230557.46A3FC36AE2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
