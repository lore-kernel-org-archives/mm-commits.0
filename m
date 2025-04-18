Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C8F158545
	for <mm-commits@vger.kernel.org>; Fri, 18 Apr 2025 03:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744945877; cv=none; b=rlyccHLj5tnPxExw5t6ZR0vklwwRC42vw1FAKpvqvvQPtAhOMGjLQjPEElaVGJmPGHwMPvCAXuQ3onEW8QdVBM65QqbZPMctjNrVyw5IGYYhiqHra6CPGtXvezOifLYP5saWsvcTUqHJpihjMN/LLmxLorqUSjmZC+c6zzm9dLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744945877; c=relaxed/simple;
	bh=Npq1fi6Cxoa7E4sWDKlyo15YuCFw4J0I2XZ/na2YBdw=;
	h=Date:To:From:Subject:Message-Id; b=oWM3MSkcrAbPPx7nJ2Pf4qbEaztKgsg/jeKNf/k6fuTyLaEkhfy+2umRLSV7p8iqcvbhBJQdiwNPsH1iPiv1ib40QKJ2m/uHXhTcz1M71HXbpCs9ObqFxepTAShz0KB3PfclBFdoJi5kdNXoMpOS9BvtuW6XoMpTApWMk5V2GgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WQI9wIIl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WQI9wIIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5832BC4CEEA;
	Fri, 18 Apr 2025 03:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744945876;
	bh=Npq1fi6Cxoa7E4sWDKlyo15YuCFw4J0I2XZ/na2YBdw=;
	h=Date:To:From:Subject:From;
	b=WQI9wIIlDunoxb59UkQ28V3zHPI27i8XNzE+LCvQw2luSVb34u4Ydj7bv8q4fHfYh
	 CWFi904JiIJqdjeMaDJN2huF5AJaeHPF0qiTPsZxl4ixLEKfuaP79vO2zQ0hdwEaOI
	 BzOtJy3ocDf8OGnCs+HZX8moDdd6EBFiZZsIF/Xs=
Date: Thu, 17 Apr 2025 20:11:15 -0700
To: mm-commits@vger.kernel.org,teknoraver@meta.com,kernel@pengutronix.de,daniel.lezcano@linaro.org,axboe@kernel.dk,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] docs-abi-replace-mcroce-microsoftcom-with-new-meta-address.patch removed from -mm tree
Message-Id: <20250418031116.5832BC4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs: ABI: replace mcroce@microsoft.com with new Meta address
has been removed from the -mm tree.  Its filename was
     docs-abi-replace-mcroce-microsoftcom-with-new-meta-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: docs: ABI: replace mcroce@microsoft.com with new Meta address
Date: Mon, 14 Apr 2025 09:35:31 +0200

The Microsoft email address is bouncing:

    550 5.4.1 Recipient address rejected: Access denied.

So let's replace it with Matteo's current mail address.

Link: https://lkml.kernel.org/r/20250414-fix-mcroce-mail-bounce-v3-1-0aed2d71f3d7@pengutronix.de
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Acked-by: Matteo Croce <teknoraver@meta.com>
Link: https://lore.kernel.org/all/BYAPR15MB2504E4B02DFFB1E55871955DA1062@BYAPR15MB2504.namprd15.prod.outlook.com/
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matteo Croce <teknoraver@meta.com>
Cc: Sascha Hauer <kernel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/stable/sysfs-block          |    2 +-
 Documentation/ABI/testing/sysfs-kernel-reboot |   10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/ABI/stable/sysfs-block~docs-abi-replace-mcroce-microsoftcom-with-new-meta-address
+++ a/Documentation/ABI/stable/sysfs-block
@@ -77,7 +77,7 @@ Description:
 
 What:		/sys/block/<disk>/diskseq
 Date:		February 2021
-Contact:	Matteo Croce <mcroce@microsoft.com>
+Contact:	Matteo Croce <teknoraver@meta.com>
 Description:
 		The /sys/block/<disk>/diskseq files reports the disk
 		sequence number, which is a monotonically increasing
--- a/Documentation/ABI/testing/sysfs-kernel-reboot~docs-abi-replace-mcroce-microsoftcom-with-new-meta-address
+++ a/Documentation/ABI/testing/sysfs-kernel-reboot
@@ -1,7 +1,7 @@
 What:		/sys/kernel/reboot
 Date:		November 2020
 KernelVersion:	5.11
-Contact:	Matteo Croce <mcroce@microsoft.com>
+Contact:	Matteo Croce <teknoraver@meta.com>
 Description:	Interface to set the kernel reboot behavior, similarly to
 		what can be done via the reboot= cmdline option.
 		(see Documentation/admin-guide/kernel-parameters.txt)
@@ -9,25 +9,25 @@ Description:	Interface to set the kernel
 What:		/sys/kernel/reboot/mode
 Date:		November 2020
 KernelVersion:	5.11
-Contact:	Matteo Croce <mcroce@microsoft.com>
+Contact:	Matteo Croce <teknoraver@meta.com>
 Description:	Reboot mode. Valid values are: cold warm hard soft gpio
 
 What:		/sys/kernel/reboot/type
 Date:		November 2020
 KernelVersion:	5.11
-Contact:	Matteo Croce <mcroce@microsoft.com>
+Contact:	Matteo Croce <teknoraver@meta.com>
 Description:	Reboot type. Valid values are: bios acpi kbd triple efi pci
 
 What:		/sys/kernel/reboot/cpu
 Date:		November 2020
 KernelVersion:	5.11
-Contact:	Matteo Croce <mcroce@microsoft.com>
+Contact:	Matteo Croce <teknoraver@meta.com>
 Description:	CPU number to use to reboot.
 
 What:		/sys/kernel/reboot/force
 Date:		November 2020
 KernelVersion:	5.11
-Contact:	Matteo Croce <mcroce@microsoft.com>
+Contact:	Matteo Croce <teknoraver@meta.com>
 Description:	Don't wait for any other CPUs on reboot and
 		avoid anything that could hang.
 
_

Patches currently in -mm which might be from a.fatoum@pengutronix.de are


