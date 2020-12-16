Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B75C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6870A23406
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 17:11:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgLPRKn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 12:10:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726918AbgLPRKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Dec 2020 12:10:43 -0500
Date:   Wed, 16 Dec 2020 09:10:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608138602;
        bh=dWAaIDUX4IxnKalsEe2oiuxyjHUXopaMdLXVBx/kaj0=;
        h=From:To:Subject:From;
        b=rHBZYedk3g8JkpNlQupG2X2HaIlghnqWzA52+IzmsvqrdzbmUCKR0oYHH0c2wyWj0
         H4ZefxJzOqfYRXK10D5yZiNH9c21vV5uE0Znk2d2ddhZuJfsHkpyfOf0e6vKc8Bssv
         7tuGR7DdaD64O3B1wiYXhR9K9LQ6x3rZrHxO1J0g=
From:   akpm@linux-foundation.org
To:     joe@perches.com, lukas.bulwahn@gmail.com,
        mm-commits@vger.kernel.org, yashsri421@gmail.com
Subject:  [merged]
 checkpatch-add-fix-option-for-gerrit_change_id.patch removed from -mm tree
Message-ID: <20201216171002.zzu2U8OTH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add fix option for GERRIT_CHANGE_ID
has been removed from the -mm tree.  Its filename was
     checkpatch-add-fix-option-for-gerrit_change_id.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


