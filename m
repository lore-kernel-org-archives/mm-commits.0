Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEF125761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742256; cv=none; b=Utd8B4bdieRNe2Qb54p6ze/HuKwc2Wj+g7UMJlSOtwrenXNbXIBzPzWCLKOiXejbAEhMrW14v9V48ud/6OnhThjywwOhF/rO0vlAAcgGUrJYlv/apR7wDan0EdsnnIACnTw2Lb0xjF7GK6BpQ755VTQz9OkVS5i6rVWJIGaZqJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742256; c=relaxed/simple;
	bh=4PdkyldXm2lXRa3fotsoVasloSxBXgW9dPQp8wdyIII=;
	h=Date:To:From:Subject:Message-Id; b=adEzKH2MOTrv4fJhjwJXsavC+fVFgJmUp671M1dgqjSTEobh4gudR3dPBXXVBs6N9fVi82DK8O1C/xN6jccKJpRqExAsDlsvTFzjVfz7dCBWgbOXfr6YTFNiiUt1vS3Wmly7xk0xAKFoEX5Zfk8xQ0WBptWdYHVkbkAspk5R+z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A2gU0muB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A2gU0muB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263DFC4CED6;
	Mon, 13 Jan 2025 04:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742256;
	bh=4PdkyldXm2lXRa3fotsoVasloSxBXgW9dPQp8wdyIII=;
	h=Date:To:From:Subject:From;
	b=A2gU0muBWaTAlv1UoCVP1gm0GCUu+FgFdJdVSqp98xcbEr+yYx9hDrqKVPcR8ttI8
	 g1idwNYcWqXwnPmz4INg/JzvEKmd1tSkpeCg/bHACy3YTRVnuxRbg0raK9umE4JFyu
	 NNsuB3RkcqzXHxl/bTzuESHQh923v2OP68L0RdPg=
Date: Sun, 12 Jan 2025 20:24:15 -0800
To: mm-commits@vger.kernel.org,joe@perches.com,arnd@arndb.de,robh@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] maintainers-fix-list-entries-with-display-names.patch removed from -mm tree
Message-Id: <20250113042416.263DFC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: fix list entries with display names
has been removed from the -mm tree.  Its filename was
     maintainers-fix-list-entries-with-display-names.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -2829,7 +2829,7 @@ ARM/NXP S32G ARCHITECTURE
 R:	Chester Lin <chester62515@gmail.com>
 R:	Matthias Brugger <mbrugger@suse.com>
 R:	Ghennadi Procopciuc <ghennadi.procopciuc@oss.nxp.com>
-L:	NXP S32 Linux Team <s32@nxp.com>
+R:	NXP S32 Linux Team <s32@nxp.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	arch/arm64/boot/dts/freescale/s32g*.dts*
@@ -16604,8 +16604,8 @@ F:	arch/nios2/
 
 NITRO ENCLAVES (NE)
 M:	Alexandru Ciobotaru <alcioa@amazon.com>
+R:	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>
 L:	linux-kernel@vger.kernel.org
-L:	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>
 S:	Supported
 W:	https://aws.amazon.com/ec2/nitro/nitro-enclaves/
 F:	Documentation/virt/ne_overview.rst
@@ -16616,8 +16616,8 @@ F:	samples/nitro_enclaves/
 
 NITRO SECURE MODULE (NSM)
 M:	Alexander Graf <graf@amazon.com>
+R:	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>
 L:	linux-kernel@vger.kernel.org
-L:	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>
 S:	Supported
 W:	https://aws.amazon.com/ec2/nitro/nitro-enclaves/
 F:	drivers/misc/nsm.c
@@ -18429,8 +18429,8 @@ M:	Fabio Estevam <festevam@gmail.com>
 M:	Shawn Guo <shawnguo@kernel.org>
 M:	Jacky Bai <ping.bai@nxp.com>
 R:	Pengutronix Kernel Team <kernel@pengutronix.de>
+R:	NXP S32 Linux Team <s32@nxp.com>
 L:	linux-gpio@vger.kernel.org
-L:	NXP S32 Linux Team <s32@nxp.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/pinctrl/fsl,*
 F:	Documentation/devicetree/bindings/pinctrl/nxp,s32*
@@ -19565,7 +19565,7 @@ F:	drivers/ras/amd/fmpm.c
 
 RASPBERRY PI PISP BACK END
 M:	Jacopo Mondi <jacopo.mondi@ideasonboard.com>
-L:	Raspberry Pi Kernel Maintenance <kernel-list@raspberrypi.com>
+R:	Raspberry Pi Kernel Maintenance <kernel-list@raspberrypi.com>
 L:	linux-media@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/media/raspberrypi,pispbe.yaml
_

Patches currently in -mm which might be from robh@kernel.org are


