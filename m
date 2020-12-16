Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C120DC0018C
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92DB723133
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 04:45:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgLPEpD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 23:45:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgLPEpD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 23:45:03 -0500
Date:   Tue, 15 Dec 2020 20:44:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608093887;
        bh=JAnv2w2/QqWSqzDf2E8raK46pGFW+SE2MyJBRVuKHiA=;
        h=From:To:Subject:In-Reply-To:From;
        b=zdOCMAEUeyAyjH5MTqzb3B65060CriuPLMI7H7oMymZVxnCGb6O+nrEYJbSvPyZXO
         V/c6TadGulYhPrmH1cHpnqlpSog8xMjC7oDke3vIWb13CTw+0GDrtTK7agXSSVTbxR
         SWwn3krexMId+8LJfgo440MN60Gvffy0d9ZloiyY=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, joe@perches.com, linux-mm@kvack.org,
        lukas.bulwahn@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, yashsri421@gmail.com
Subject:  [patch 45/95] checkpatch: add fix option for
 GERRIT_CHANGE_ID
Message-ID: <20201216044447.EcKBEYEV3%akpm@linux-foundation.org>
In-Reply-To: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
