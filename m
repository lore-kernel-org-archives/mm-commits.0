Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A82C77B72
	for <mm-commits@archiver.kernel.org>; Fri, 14 Apr 2023 18:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjDNS6j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Apr 2023 14:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDNS6i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Apr 2023 14:58:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF736900B
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 11:58:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A550649FE
        for <mm-commits@vger.kernel.org>; Fri, 14 Apr 2023 18:58:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D1EC433A1;
        Fri, 14 Apr 2023 18:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681498715;
        bh=tICBEsGl+C4Vj9nfpBx+2ZkPzH3181zSSCHx7Pyx3q0=;
        h=Date:To:From:Subject:From;
        b=uC31NIayslSMKhq39iolyiolMOUzwvXElNGlsyYOIN4tTgXcq0KeIOF2UujeMI+Dp
         KndKM4DM6k9NQv3bUvvS1FbdOTNZKFiA62Tv40bVtSqESyA+l+4t9zPYTHH4rSA1aK
         6MJtQ41SQ+daFEIIZJtxlQWUE763W45HUVRgpD/Q=
Date:   Fri, 14 Apr 2023 11:58:35 -0700
To:     mm-commits@vger.kernel.org, robh@kernel.org,
        lukas.bulwahn@gmail.com, krzysztof.kozlowski@linaro.org,
        joe@perches.com, dwaipayanray1@gmail.com, apw@canonical.com,
        ddrokosov@sberdevices.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-introduce-proper-bindings-license-check.patch added to mm-nonmm-unstable branch
Message-Id: <20230414185835.C1D1EC433A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: introduce proper bindings license check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-introduce-proper-bindings-license-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-introduce-proper-bindings-license-check.patch

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
Subject: checkpatch: introduce proper bindings license check
Date: Tue, 4 Apr 2023 22:17:15 +0300

All headers from 'include/dt-bindings/' must be verified by checkpatch
together with Documentation bindings, because all of them are part of the
whole DT bindings system.

The requirement is dual licensed and matching patterns:
* Schemas:
    /GPL-2\.0(?:-only)? OR BSD-2-Clause/
* Headers:
    /GPL-2\.0(?:-only)? OR \S+/

Above patterns suggested by Rob at:
https://lore.kernel.org/all/CAL_Jsq+-YJsBO+LuPJ=ZQ=eb-monrwzuCppvReH+af7hYZzNaQ@mail.gmail.com

The issue was found during patch review:
https://lore.kernel.org/all/20230313201259.19998-4-ddrokosov@sberdevices.ru/

Link: https://lkml.kernel.org/r/20230404191715.7319-1-ddrokosov@sberdevices.ru
Signed-off-by: Dmitry Rokosov <ddrokosov@sberdevices.ru>
Reviewed-by: Rob Herring <robh@kernel.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-introduce-proper-bindings-license-check
+++ a/scripts/checkpatch.pl
@@ -3763,7 +3763,7 @@ sub process {
 						     "'$spdx_license' is not supported in LICENSES/...\n" . $herecurr);
 					}
 					if ($realfile =~ m@^Documentation/devicetree/bindings/@ &&
-					    not $spdx_license =~ /GPL-2\.0.*BSD-2-Clause/) {
+					    $spdx_license !~ /GPL-2\.0(?:-only)? OR BSD-2-Clause/) {
 						my $msg_level = \&WARN;
 						$msg_level = \&CHK if ($file);
 						if (&{$msg_level}("SPDX_LICENSE_TAG",
@@ -3773,6 +3773,11 @@ sub process {
 							$fixed[$fixlinenr] =~ s/SPDX-License-Identifier: .*/SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)/;
 						}
 					}
+					if ($realfile =~ m@^include/dt-bindings/@ &&
+					    $spdx_license !~ /GPL-2\.0(?:-only)? OR \S+/) {
+						WARN("SPDX_LICENSE_TAG",
+						     "DT binding headers should be licensed (GPL-2.0-only OR .*)\n" . $herecurr);
+					}
 				}
 			}
 		}
_

Patches currently in -mm which might be from ddrokosov@sberdevices.ru are

checkpatch-introduce-proper-bindings-license-check.patch

