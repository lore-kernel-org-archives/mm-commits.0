Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BACC6FD1D
	for <mm-commits@archiver.kernel.org>; Tue, 21 Mar 2023 21:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjCUV3y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 21 Mar 2023 17:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCUV3u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Mar 2023 17:29:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3C158B7B
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 14:29:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28B3961D79
        for <mm-commits@vger.kernel.org>; Tue, 21 Mar 2023 21:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79232C4339B;
        Tue, 21 Mar 2023 21:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679434153;
        bh=h6fxdMA4YXiLNiwq9EaVWWfu4kd/WzSa41N1rcXxZRA=;
        h=Date:To:From:Subject:From;
        b=EjGRg0boDDTTeg71E0o4CLo3SWEKwtDlv5YtFjFbfmwGh/Xmco3P60T0qwjYJMGTF
         YuOUqAZJk+D+ACbUakH8Y2WI5hWOIBK4lh50uDA0xNuVyK3+vKwD/Oq9qS7pH7KNKz
         YDaYSFWjR+aMb2+SEso37E6i1RKVJ/UMVc4VEyUU=
Date:   Tue, 21 Mar 2023 14:29:12 -0700
To:     mm-commits@vger.kernel.org, robh@kernel.org,
        lukas.bulwahn@gmail.com, krzysztof.kozlowski@linaro.org,
        joe@perches.com, dwaipayanray1@gmail.com, apw@canonical.com,
        ddrokosov@sberdevices.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-add-missing-bindings-license-check.patch added to mm-nonmm-unstable branch
Message-Id: <20230321212913.79232C4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add missing bindings license check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-add-missing-bindings-license-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-add-missing-bindings-license-check.patch

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
From: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Subject: checkpatch: add missing bindings license check
Date: Mon, 20 Mar 2023 23:33:50 +0300

All headers from 'include/dt-bindings/' must be verified by checkpatch
together with Documentation bindings, because all of them are part of the
whole DT bindings system.

The requirement is dual licensed and matching pattern:
    /GPL-2\.0(?:-only|-or-later|\+)? (?:OR|or) BSD-2-Clause/

The issue was found during patch review:
https://lore.kernel.org/all/20230313201259.19998-4-ddrokosov@sberdevices.ru/

Link: https://lkml.kernel.org/r/20230320203350.13696-1-ddrokosov@sberdevices.ru
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-add-missing-bindings-license-check
+++ a/scripts/checkpatch.pl
@@ -3735,8 +3735,9 @@ sub process {
 						WARN("SPDX_LICENSE_TAG",
 						     "'$spdx_license' is not supported in LICENSES/...\n" . $herecurr);
 					}
-					if ($realfile =~ m@^Documentation/devicetree/bindings/@ &&
-					    not $spdx_license =~ /GPL-2\.0.*BSD-2-Clause/) {
+					if (($realfile =~ m@^Documentation/devicetree/bindings/@ ||
+					     $realfile =~ m@^include/dt-bindings/@) &&
+					    $spdx_license !~ /GPL-2\.0(?:-only|-or-later|\+)? (?:OR|or) BSD-2-Clause/) {
 						my $msg_level = \&WARN;
 						$msg_level = \&CHK if ($file);
 						if (&{$msg_level}("SPDX_LICENSE_TAG",
_

Patches currently in -mm which might be from ddrokosov@sberdevices.ru are

checkpatch-add-missing-bindings-license-check.patch

