Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F0DC7EE2C
	for <mm-commits@archiver.kernel.org>; Wed, 17 May 2023 22:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjEQWZd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 May 2023 18:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjEQWZY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 May 2023 18:25:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B9749DC
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 15:25:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F618642FC
        for <mm-commits@vger.kernel.org>; Wed, 17 May 2023 22:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7487EC4339B;
        Wed, 17 May 2023 22:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1684362322;
        bh=AABvRMLE14fl2EEVyOC/vGlY00hFWqb1UzBpeBXBHzc=;
        h=Date:To:From:Subject:From;
        b=yKxVv1AGfN7b+cLPDUEN8QD9vl5sY5ZHiCEO1tP69/XGpMJuy+bbGK9Gguh6cPBYr
         YlwIRq7bY5AJgsXpYFxSECI3Nq03DuRfvsOjIVoBFNesfAMHJl+V7AEnKZwDS//jWM
         jJuXvKoCu/tMKj6DJGpNvGyw3CVxNGr5puBVmsJw=
Date:   Wed, 17 May 2023 15:25:21 -0700
To:     mm-commits@vger.kernel.org, lee@kernel.org,
        conor.dooley@microchip.com, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-repair-pattern-in-dialog-semiconductor-drivers.patch removed from -mm tree
Message-Id: <20230517222522.7487EC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MAINTAINERS: repair pattern in DIALOG SEMICONDUCTOR DRIVERS
has been removed from the -mm tree.  Its filename was
     maintainers-repair-pattern-in-dialog-semiconductor-drivers.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


