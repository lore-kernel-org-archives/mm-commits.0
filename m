Return-Path: <SRS0=UFsa=EG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B2FC388F9
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 20:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92A89206F9
	for <mm-commits@archiver.kernel.org>; Sat, 31 Oct 2020 20:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604174591;
	bh=F1T38qbvtBltOUv2ZaPphzDc0pcCO7Lc8K2jGIsK1UY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Ux0551BBvtw9hO6Yu8IrxtILbYVHvnT3zedxjeeqeSlwi78jbLRVXtTAy4Wj39gF2
	 cNEGU9ob/atg3AsP2/NijYQigKwXFgAeFQsVCkcQ8duPPmIL16cQp1WRhF3jkOaxJ2
	 OHAbFYZeiV3D6ep6aXtsQFV060BK/1cuShmxmhyA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbgJaUDK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 31 Oct 2020 16:03:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728457AbgJaUDK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 31 Oct 2020 16:03:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B42D5206F9;
        Sat, 31 Oct 2020 20:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604174588;
        bh=F1T38qbvtBltOUv2ZaPphzDc0pcCO7Lc8K2jGIsK1UY=;
        h=Date:From:To:Subject:From;
        b=UcZmAxJcxlHkUDWFaNtL23RBSjAJaqkkdSA7fPGYpjBiHvnoeu5wucxddTwjLA101
         S78pzzXSK0C67+u5QKtg1MJrHdPm3WjKn6kbce0+82wZjE1eGaOVMAPN5VubV5cw5p
         dMH0fCBm2ttBrKFgOEPJx19NcACU1nh1iZe4XxQA=
Date:   Sat, 31 Oct 2020 13:03:08 -0700
From:   akpm@linux-foundation.org
To:     joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, yashsri421@gmail.com
Subject:  + checkpatch-add-fix-option-for-gerrit_change_id.patch
 added to -mm tree
Message-ID: <20201031200308.CD0akeND8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add fix option for GERRIT_CHANGE_ID
has been added to the -mm tree.  Its filename is
     checkpatch-add-fix-option-for-gerrit_change_id.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-add-fix-option-for-gerrit_change_id.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-add-fix-option-for-gerrit_change_id.patch

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
Subject: checkpatch: add fix option for GERRIT_CHANGE_ID

Currently, whenever a Gerrit Change-Id is present in a commit,
checkpatch.pl warns to remove the Change-Id before submitting the patch.

E.g., running checkpatch on commit adc311a5bbf6 ("iwlwifi: bump FW
API to 53 for 22000 series") reports this error:

ERROR: Remove Gerrit Change-Id's before submitting upstream
Change-Id: I5725e46394f3f53c3069723fd513cc53c7df383d

Provide a simple fix option by simply deleting the indicated line.

Link: https://lkml.kernel.org/r/20201030114447.24199-1-yashsri421@gmail.com
Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-fix-option-for-gerrit_change_id
+++ a/scripts/checkpatch.pl
@@ -2852,8 +2852,11 @@ sub process {
 
 # Check for Gerrit Change-Ids not in any patch context
 		if ($realfile eq '' && !$has_patch_separator && $line =~ /^\s*change-id:/i) {
-			ERROR("GERRIT_CHANGE_ID",
-			      "Remove Gerrit Change-Id's before submitting upstream\n" . $herecurr);
+			if (ERROR("GERRIT_CHANGE_ID",
+			          "Remove Gerrit Change-Id's before submitting upstream\n" . $herecurr) &&
+			    $fix) {
+                                fix_delete_line($fixlinenr, $rawline);
+                        }
 		}
 
 # Check if the commit log is in a possible stack dump
_

Patches currently in -mm which might be from yashsri421@gmail.com are

checkpatch-fix-false-positives-in-repeated_word-warning.patch
checkpatch-add-fix-option-for-gerrit_change_id.patch

