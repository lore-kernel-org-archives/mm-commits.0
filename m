Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B280E149E00
	for <mm-commits@vger.kernel.org>; Thu,  2 Jan 2025 23:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735861695; cv=none; b=R9Hz0/gKMS87HtbjdTvaS7GwxqKpNwlBXM4aExp00fhSfDT3OzeHHLYSKypZVE92DxNYPqgbWO7cdauzLxhivqsWYC21pnlmQkFJcn8HwDEzdcVX7gA0v9l/t4vgrB9j/ogGpCTpK6wCdW3rAvPLXmxjKI9yxTWZnCR3E5AnWP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735861695; c=relaxed/simple;
	bh=NbiOdwuTuJJJnESmwy/W02xcJXnAqBx/bGJHYCs7CEA=;
	h=Date:To:From:Subject:Message-Id; b=QUAPGI202JBrMaO7BveucsgOonWbwaYBIFC1s+tadPQvgZY6aiHfI9+jPDBIoG2dm/snyrQVP02uTfYAdqfI9BYotnKfGrozl8ENMZ6FYB3lsSBZ0FfulHbJiz026aOD4YRDcjiYG5xR5lbtPzBXPcOTHV1dCw93V2Pedfk2RGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ITNAOZUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ITNAOZUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2B4C4CED0;
	Thu,  2 Jan 2025 23:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735861695;
	bh=NbiOdwuTuJJJnESmwy/W02xcJXnAqBx/bGJHYCs7CEA=;
	h=Date:To:From:Subject:From;
	b=ITNAOZUHCn/npdN7bOSyOBUv+wfEqZf/YGA7Wv/7bvGotTaoEb/PScnRv9xW3efYE
	 iOTj3GPwoIsMvEVHgM/k/FtEUFE5T2mF8Oc09NTtHiDC8ttbvwSM8h1gwIfyraerAP
	 UqdhoQ0o9tP9T6V8TKkHLprAwBrEipuCcGTOd2CQ=
Date: Thu, 02 Jan 2025 15:48:14 -0800
To: mm-commits@vger.kernel.org,joe@perches.com,arnd@arndb.de,robh@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-fix-list-entries-with-display-names.patch added to mm-nonmm-unstable branch
Message-Id: <20250102234815.2B2B4C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: fix list entries with display names
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-fix-list-entries-with-display-names.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-fix-list-entries-with-display-names.patch

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
From: "Rob Herring (Arm)" <robh@kernel.org>
Subject: MAINTAINERS: fix list entries with display names
Date: Tue, 31 Dec 2024 09:54:14 -0600

get_maintainers.pl doesn't expect list entries to have a display name. 
Entries with a display name are omitted and print just the description:

 (open list:PIN CONTROLLER - FREESCALE)

These cases are pretty much aliases to a few people, not lists which are
archived and can be subscribed to.  Change these cases to be reviewers
instead.

Link: https://lkml.kernel.org/r/20241231155415.186244-1-robh@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/MAINTAINERS~maintainers-fix-list-entries-with-display-names
+++ a/MAINTAINERS
@@ -2830,7 +2830,7 @@ ARM/NXP S32G ARCHITECTURE
 R:	Chester Lin <chester62515@gmail.com>
 R:	Matthias Brugger <mbrugger@suse.com>
 R:	Ghennadi Procopciuc <ghennadi.procopciuc@oss.nxp.com>
-L:	NXP S32 Linux Team <s32@nxp.com>
+R:	NXP S32 Linux Team <s32@nxp.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm64/boot/dts/freescale/s32g*.dts*
@@ -16613,8 +16613,8 @@ F:	arch/nios2/
 
 NITRO ENCLAVES (NE)
 M:	Alexandru Ciobotaru <alcioa@amazon.com>
+R:	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>
 L:	linux-kernel@vger.kernel.org
-L:	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>
 S:	Supported
 W:	https://aws.amazon.com/ec2/nitro/nitro-enclaves/
 F:	Documentation/virt/ne_overview.rst
@@ -16625,8 +16625,8 @@ F:	samples/nitro_enclaves/
 
 NITRO SECURE MODULE (NSM)
 M:	Alexander Graf <graf@amazon.com>
+R:	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>
 L:	linux-kernel@vger.kernel.org
-L:	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>
 S:	Supported
 W:	https://aws.amazon.com/ec2/nitro/nitro-enclaves/
 F:	drivers/misc/nsm.c
@@ -18438,8 +18438,8 @@ M:	Fabio Estevam <festevam@gmail.com>
 M:	Shawn Guo <shawnguo@kernel.org>
 M:	Jacky Bai <ping.bai@nxp.com>
 R:	Pengutronix Kernel Team <kernel@pengutronix.de>
+R:	NXP S32 Linux Team <s32@nxp.com>
 L:	linux-gpio@vger.kernel.org
-L:	NXP S32 Linux Team <s32@nxp.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/pinctrl/fsl,*
 F:	Documentation/devicetree/bindings/pinctrl/nxp,s32*
@@ -19574,7 +19574,7 @@ F:	drivers/ras/amd/fmpm.c
 
 RASPBERRY PI PISP BACK END
 M:	Jacopo Mondi <jacopo.mondi@ideasonboard.com>
-L:	Raspberry Pi Kernel Maintenance <kernel-list@raspberrypi.com>
+R:	Raspberry Pi Kernel Maintenance <kernel-list@raspberrypi.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/media/raspberrypi,pispbe.yaml
_

Patches currently in -mm which might be from robh@kernel.org are

maintainers-fix-list-entries-with-display-names.patch

