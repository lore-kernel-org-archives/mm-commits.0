Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59723C77B7F
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 23:57:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240666AbjELX5p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 19:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240007AbjELX5o (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 19:57:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BCF7A83
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 16:57:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2A6865985
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 23:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A05C433D2;
        Fri, 12 May 2023 23:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683935822;
        bh=o43r/F2+8v6bsawbcx4CYt/at0tpKGg93VB/Ioix/98=;
        h=Date:To:From:Subject:From;
        b=L9cSuJNCYvtrsqWuAS08WD8TBWAwVXv2Ko975vTBdoAj524yacZKymABqHCDuQMT7
         hEzixV92pZP/xKjHCZzrrhSYIpVXJZvOF7xFt/JP2RKLAFt4AKUsxc6s0D6Zf2fYW6
         zgHbPJh8b/oIPBu6M2qB6xCnGnKRVhNDbQsDu++4=
Date:   Fri, 12 May 2023 16:57:01 -0700
To:     mm-commits@vger.kernel.org, lee@kernel.org,
        conor.dooley@microchip.com, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-repair-pattern-in-dialog-semiconductor-drivers.patch added to mm-hotfixes-unstable branch
Message-Id: <20230512235702.13A05C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: MAINTAINERS: repair pattern in DIALOG SEMICONDUCTOR DRIVERS
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-repair-pattern-in-dialog-semiconductor-drivers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-repair-pattern-in-dialog-semiconductor-drivers.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: MAINTAINERS: repair pattern in DIALOG SEMICONDUCTOR DRIVERS
Date: Tue, 9 May 2023 09:48:34 +0200

Commit 361104b05684c ("dt-bindings: mfd: Convert da9063 to yaml") converts
da9063.txt to dlg,da9063.yaml and adds a new file pattern in MAINTAINERS. 
Unfortunately, the file pattern matches da90*.yaml, but the yaml file is
prefixed with dlg,da90.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken file pattern.

Repair this file pattern in DIALOG SEMICONDUCTOR DRIVERS.

Link: https://lkml.kernel.org/r/20230509074834.21521-1-lukas.bulwahn@gmail.com
Fixes: 361104b05684c ("dt-bindings: mfd: Convert da9063 to yaml")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Cc: Lee Jones <lee@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-repair-pattern-in-dialog-semiconductor-drivers
+++ a/MAINTAINERS
@@ -6019,7 +6019,7 @@ W:	http://www.dialog-semiconductor.com/p
 F:	Documentation/devicetree/bindings/input/da90??-onkey.txt
 F:	Documentation/devicetree/bindings/input/dlg,da72??.txt
 F:	Documentation/devicetree/bindings/mfd/da90*.txt
-F:	Documentation/devicetree/bindings/mfd/da90*.yaml
+F:	Documentation/devicetree/bindings/mfd/dlg,da90*.yaml
 F:	Documentation/devicetree/bindings/regulator/dlg,da9*.yaml
 F:	Documentation/devicetree/bindings/regulator/da92*.txt
 F:	Documentation/devicetree/bindings/regulator/slg51000.txt
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

maintainers-repair-pattern-in-dialog-semiconductor-drivers.patch

