Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A998CC77B75
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 23:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjDRXmm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 19:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjDRXmC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 19:42:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34AC7C177
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 16:40:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7A6D633C0
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 23:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078DBC433EF;
        Tue, 18 Apr 2023 23:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681861231;
        bh=soLKu0tb2dDyYdOk7V15Ofsrzs2WQ01LL4G9FS3x23Y=;
        h=Date:To:From:Subject:From;
        b=cxUzdUDYH/eSAeU7AnPxPBaWL4q2AiRtWDHNNeRy4AMki+iZl3jiJjHE/+Qn8Gapm
         sbirHNMmGfz7vjNymtNDIvF9wLYNh+B6iiq1RCyeI0lqDip+xjEoLuB0TZzIPtsYLP
         imtmeEpZ69VzUMrdZ+g1uFrLzXJTAew/5xIFLwhs=
Date:   Tue, 18 Apr 2023 16:40:30 -0700
To:     mm-commits@vger.kernel.org, robh@kernel.org,
        lukas.bulwahn@gmail.com, krzysztof.kozlowski@linaro.org,
        joe@perches.com, dwaipayanray1@gmail.com, apw@canonical.com,
        ddrokosov@sberdevices.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-introduce-proper-bindings-license-check.patch removed from -mm tree
Message-Id: <20230418234031.078DBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: checkpatch: introduce proper bindings license check
has been removed from the -mm tree.  Its filename was
     checkpatch-introduce-proper-bindings-license-check.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


