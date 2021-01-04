Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D055C433DB
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 21:13:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0556C20776
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 21:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbhADVNO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 16:13:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbhADVNO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 16:13:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE92E20776;
        Mon,  4 Jan 2021 21:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609794754;
        bh=XZ/VpRYOkT8PXfWQggPB1ewxix8fyWuO9GXQSjXIbmE=;
        h=Date:From:To:Subject:From;
        b=egRbKDtUunNlKobXy3k2MJkjVQCNLgxShnOXwh8M/RnDyhgjsGLMTz3cid/nADeqm
         sTWrUPrJrMvxkEukL1QcA2Dtupf4C3OCiO6s/mWwc7NXIL+/eNj3qPXaFdrot6vDp+
         pT31WGf5CiSp4BYJwHiGLVXQl8mxgPkIxdAl2+zE=
Date:   Mon, 04 Jan 2021 13:12:33 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, johannes.czekay@fau.de,
        mm-commits@vger.kernel.org, nicolai.fischer@fau.de
Subject:  + checkpatch-kconfig-replace-help-with-help.patch added
 to -mm tree
Message-ID: <20210104211233.yVKaikUOL%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: kconfig: replace '---help---' with 'help'
has been added to the -mm tree.  Its filename is
     checkpatch-kconfig-replace-help-with-help.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-kconfig-replace-help-with-help.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-kconfig-replace-help-with-help.patch

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
Subject: checkpatch: kconfig: replace '---help---' with 'help'

Patch series "update kconfig parsing", v3.

This series updates the parsing of Kconfig files within checkpatch.pl to
the current state.


This patch (of 5):

All '---help---' lines have been replaced by just 'help'.  Therefore it is
no longer necessary to include '---' in the regex.

Link: https://lkml.kernel.org/r/20210103075015.23946-1-nicolai.fischer@fau.de
Link: https://lkml.kernel.org/r/20210103075015.23946-2-nicolai.fischer@fau.de
Co-developed-by: Johannes Czekay <johannes.czekay@fau.de>
Signed-off-by: Johannes Czekay <johannes.czekay@fau.de>
Signed-off-by: Nicolai Fischer <nicolai.fischer@fau.de>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-kconfig-replace-help-with-help
+++ a/scripts/checkpatch.pl
@@ -3323,7 +3323,7 @@ sub process {
 
 				if ($lines[$ln - 1] =~ /^\+\s*(?:bool|tristate|prompt)\s*["']/) {
 					$is_start = 1;
-				} elsif ($lines[$ln - 1] =~ /^\+\s*(?:---)?help(?:---)?$/) {
+				} elsif ($lines[$ln - 1] =~ /^\+\s*help$/) {
 					$length = -1;
 				}
 
_

Patches currently in -mm which might be from nicolai.fischer@fau.de are

checkpatch-kconfig-replace-help-with-help.patch
checkpatch-kconfig-add-missing-types-to-regex.patch
checkpatch-kconfig-enforce-help-text-indentation.patch
checkpatch-kconfig-clarify-warning-for-paragraph-length.patch
checkpatch-kconfig-enforce-block-indentation.patch

