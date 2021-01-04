Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1233CC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 22:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0B1D22512
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 22:17:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbhADWRj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 17:17:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726026AbhADWRj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 17:17:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 982F122517;
        Mon,  4 Jan 2021 22:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609798618;
        bh=z6p1vt10/zCbtztbxKOp5vaosS3RrWgLJrcCbxj/pLk=;
        h=Date:From:To:Subject:From;
        b=CX8aCPhm0uyCyFTPSsz9Yc9RrrgZ+W/+lc+E98qWA5ay0aAiXXIHhvoaePhDztuLn
         B0jHol9vd1HhtjYC1EDz9drm9fP5HUbSF3pp2recnw+AXh+wuwjAP/WR+HfLvzkr/6
         fYTq516FlaQ91Tm2BPNyVvwVsokGLM3ALYikyyvU=
Date:   Mon, 04 Jan 2021 14:16:58 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, johannes.czekay@fau.de,
        mm-commits@vger.kernel.org, nicolai.fischer@fau.de
Subject:  [to-be-updated]
 checkpatch-kconfig-clarify-warning-for-paragraph-length.patch removed from
 -mm tree
Message-ID: <20210104221658.gOvcfbrDH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: kconfig: clarify warning for paragraph length
has been removed from the -mm tree.  Its filename was
     checkpatch-kconfig-clarify-warning-for-paragraph-length.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Nicolai Fischer <nicolai.fischer@fau.de>
Subject: checkpatch: kconfig: clarify warning for paragraph length

Currently checkpatch displays a warning if it detects a help text of a
Kconfig option which is too short.  However the warning does not contain
any further information.

This adds the expected and currently detected number of lines to the
warning, which makes it more obvious why checkpatch is warning.

Furthermore this makes it easier to quickly identify false positives, e.g.
when a help message contains a Kconfig keyword and falsely triggers
checkpatch to stop counting lines, it will be more apparent, because the
user can see how many lines they wrote and how many of those were counted
correctly.

Link: https://lkml.kernel.org/r/20210103075015.23946-5-nicolai.fischer@fau.de
Co-developed-by: Johannes Czekay <johannes.czekay@fau.de>
Signed-off-by: Johannes Czekay <johannes.czekay@fau.de>
Signed-off-by: Nicolai Fischer <nicolai.fischer@fau.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-kconfig-clarify-warning-for-paragraph-length
+++ a/scripts/checkpatch.pl
@@ -3356,7 +3356,7 @@ sub process {
 			}
 			if ($is_start && $is_end && $length < $min_conf_desc_length) {
 				WARN("CONFIG_DESCRIPTION",
-				     "please write a paragraph that describes the config symbol fully\n" . $herecurr);
+				     "please write a paragraph ($length/$min_conf_desc_length lines) that describes the config symbol fully\n" . $herecurr);
 			}
 			if ($is_start && $is_end && defined $help_stat_real) {
 				WARN("CONFIG_DESCRIPTION",
_

Patches currently in -mm which might be from nicolai.fischer@fau.de are

checkpatch-kconfig-enforce-block-indentation.patch

