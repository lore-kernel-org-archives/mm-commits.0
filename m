Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7172AC433E0
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 21:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 498E320679
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 21:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbhADVNV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 16:13:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbhADVNU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 16:13:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E01C921D93;
        Mon,  4 Jan 2021 21:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609794760;
        bh=rS9SeKN9Wos7WPSkm9WYYZU6vYxuIZA6Eewvk+y3rsA=;
        h=Date:From:To:Subject:From;
        b=rIbLFntnV0ev9Tkbz6I6/YcwX0nGgUNzwGBnc4p8Pmuh4+mwDzl/JRFY+fgcBdPJI
         yVExf1bsg+6OAIwnXkcy/C+wBQ+YEQisBfCWWawKjjbUe0GESZKdhwAsck5Js7f9VQ
         1OEMHPTA9siH0Cl2iPfcwCsn/ugeIPOJYvqt3Ly4=
Date:   Mon, 04 Jan 2021 13:12:39 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, johannes.czekay@fau.de,
        mm-commits@vger.kernel.org, nicolai.fischer@fau.de
Subject:  +
 checkpatch-kconfig-clarify-warning-for-paragraph-length.patch added to -mm
 tree
Message-ID: <20210104211239.xw1yjOuwx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: kconfig: clarify warning for paragraph length
has been added to the -mm tree.  Its filename is
     checkpatch-kconfig-clarify-warning-for-paragraph-length.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-kconfig-clarify-warning-for-paragraph-length.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-kconfig-clarify-warning-for-paragraph-length.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

checkpatch-kconfig-replace-help-with-help.patch
checkpatch-kconfig-add-missing-types-to-regex.patch
checkpatch-kconfig-enforce-help-text-indentation.patch
checkpatch-kconfig-clarify-warning-for-paragraph-length.patch
checkpatch-kconfig-enforce-block-indentation.patch

