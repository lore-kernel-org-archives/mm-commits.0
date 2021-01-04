Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C714C433E6
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 21:13:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 158D220679
	for <mm-commits@archiver.kernel.org>; Mon,  4 Jan 2021 21:13:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbhADVNQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 4 Jan 2021 16:13:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbhADVNQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 4 Jan 2021 16:13:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6E06207B0;
        Mon,  4 Jan 2021 21:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609794756;
        bh=MBBn2AkZJuJQg5NR/b9Q+X1Lql8ofHWID8FR8+ZRaiM=;
        h=Date:From:To:Subject:From;
        b=lvNmTIXtZyNlccFhzzbUJZtcDScDusdKhH4YXEIMtv5bAxVgToEl3q8V3ZyGJnai9
         kfYvPo7ckkBrqsL31m4yiCoXxHosNYYfvIiWXTJh143hMGYblZg3IbnaC/Upv5srIZ
         S3Ov28sT52AODLkYhrvxoR+LJI5RPIb2yCrdr800=
Date:   Mon, 04 Jan 2021 13:12:35 -0800
From:   akpm@linux-foundation.org
To:     joe@perches.com, johannes.czekay@fau.de,
        mm-commits@vger.kernel.org, nicolai.fischer@fau.de
Subject:  + checkpatch-kconfig-add-missing-types-to-regex.patch
 added to -mm tree
Message-ID: <20210104211235.kLy4WwvsE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: kconfig: add missing types to regex
has been added to the -mm tree.  Its filename is
     checkpatch-kconfig-add-missing-types-to-regex.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/checkpatch-kconfig-add-missing-types-to-regex.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-kconfig-add-missing-types-to-regex.patch

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
Subject: checkpatch: kconfig: add missing types to regex

Kconfig parsing does not recognise all type attributes.
This adds the missing 'int', 'string' and 'hex' types.

Link: https://lkml.kernel.org/r/20210103075015.23946-3-nicolai.fischer@fau.de
Co-developed-by: Johannes Czekay <johannes.czekay@fau.de>
Signed-off-by: Johannes Czekay <johannes.czekay@fau.de>
Signed-off-by: Nicolai Fischer <nicolai.fischer@fau.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-kconfig-add-missing-types-to-regex
+++ a/scripts/checkpatch.pl
@@ -3321,7 +3321,7 @@ sub process {
 				next if ($f =~ /^-/);
 				last if (!$file && $f =~ /^\@\@/);
 
-				if ($lines[$ln - 1] =~ /^\+\s*(?:bool|tristate|prompt)\s*["']/) {
+				if ($lines[$ln - 1] =~ /^\+\s*(?:bool|tristate|int|hex|string|prompt)\s*(?:["'].*)?$/) {
 					$is_start = 1;
 				} elsif ($lines[$ln - 1] =~ /^\+\s*help$/) {
 					$length = -1;
_

Patches currently in -mm which might be from nicolai.fischer@fau.de are

checkpatch-kconfig-replace-help-with-help.patch
checkpatch-kconfig-add-missing-types-to-regex.patch
checkpatch-kconfig-enforce-help-text-indentation.patch
checkpatch-kconfig-clarify-warning-for-paragraph-length.patch
checkpatch-kconfig-enforce-block-indentation.patch

