Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D180FC6FA99
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 21:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjCGVMZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 16:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbjCGVMY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 16:12:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD122A6490
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 13:12:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C7A5B81A13
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 21:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA7AC433EF;
        Tue,  7 Mar 2023 21:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678223540;
        bh=ee+H97EDR3I0H7i8ruVOv/oMnuJd61idi3K2S9Sv5pg=;
        h=Date:To:From:Subject:From;
        b=1VF0qR6PKsubtOb1EzahF3ILOL6175QWj8EDXBOMHBl6dVeDiSeb2JMbKakrPfjyU
         eRlmFYY3gb4S5DCsv4ptmH5ybHJ6DlI82llBj7O0msokWwnpkP8TIk8nkqXhqGjfLs
         4hqjYwaPeqDDuosOeT3Dbi0ftvJyoanyq/Bm6g7E=
Date:   Tue, 07 Mar 2023 13:12:19 -0800
To:     mm-commits@vger.kernel.org, lukas.bulwahn@gmail.com,
        joe@perches.com, dwaipayanray1@gmail.com, apw@canonical.com,
        gerhard@engleder-embedded.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-ignore-ethtool_link_mode_-enum-values.patch added to mm-nonmm-unstable branch
Message-Id: <20230307211220.4DA7AC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: ignore ETHTOOL_LINK_MODE_ enum values
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-ignore-ethtool_link_mode_-enum-values.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-ignore-ethtool_link_mode_-enum-values.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: checkpatch: ignore ETHTOOL_LINK_MODE_ enum values
Date: Wed, 4 Jan 2023 21:15:24 +0100

Since commit 4104a20646 ("checkpatch: ignore generated CamelCase defines
and enum values") enum values like ETHTOOL_LINK_MODE_Asym_Pause_BIT are
ignored.  But there are other enums like
ETHTOOL_LINK_MODE_1000baseT_Full_BIT, which are not ignored because of the
not matching '1000baseT' substring.

Add regex to match all ETHTOOL_LINK_MODE enums.

Link: https://lkml.kernel.org/r/20230104201524.28078-1-gerhard@engleder-embedded.com
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Gerhard Engleder <gerhard@engleder-embedded.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 ++
 1 file changed, 2 insertions(+)

--- a/scripts/checkpatch.pl~checkpatch-ignore-ethtool_link_mode_-enum-values
+++ a/scripts/checkpatch.pl
@@ -5809,6 +5809,8 @@ sub process {
 			    $var !~ /^(?:[A-Z]+_){1,5}[A-Z]{1,3}[a-z]/ &&
 #Ignore Page<foo> variants
 			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
+#Ignore ETHTOOL_LINK_MODE_<foo> variants
+			    $var !~ /^ETHTOOL_LINK_MODE_/ &&
 #Ignore SI style variants like nS, mV and dB
 #(ie: max_uV, regulator_min_uA_show, RANGE_mA_VALUE)
 			    $var !~ /^(?:[a-z0-9_]*|[A-Z0-9_]*)?_?[a-z][A-Z](?:_[a-z0-9_]+|_[A-Z0-9_]+)?$/ &&
_

Patches currently in -mm which might be from gerhard@engleder-embedded.com are

checkpatch-ignore-ethtool_link_mode_-enum-values.patch

