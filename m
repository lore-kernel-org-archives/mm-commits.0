Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E60D1448E0
	for <mm-commits@vger.kernel.org>; Mon, 14 Apr 2025 22:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744668145; cv=none; b=bbdveHq2894KUxKbIa3oY5RHpSoARuVGPA8XE+r64gSCYSSull5ckkkbQmw/Dv2ypKRep7ye/dmzbuAT+8b2w07ONNbApkCDBp53chEdUl5prhnflU2VKS6CJPBi4CiOeYvdDyAVSHnRqDSkyJA1w6vVEvjugWV2LUIDjhz4QM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744668145; c=relaxed/simple;
	bh=s92rsj/HGI8BU+L6H0qQCpWiA8ITn3T/UHkcVRR2DwU=;
	h=Date:To:From:Subject:Message-Id; b=thx7kJ95fmLARKp3o8fmhDn/JbIb/iisH7AwriiwMNqjH5s62LDolZflmrqrIOiVRJcDH1UnN6Lf8+5gUx5BUKMBafAYNcJn/1J9+Q2gGl4XvqwgEsYrtwm7IoemUm/2Z9ELd4ovKSNwWccNtOvKdWL3IURcBa8Qm4avNBGUKHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X4qswwBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X4qswwBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5805C4CEE2;
	Mon, 14 Apr 2025 22:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744668144;
	bh=s92rsj/HGI8BU+L6H0qQCpWiA8ITn3T/UHkcVRR2DwU=;
	h=Date:To:From:Subject:From;
	b=X4qswwBFuL02W8ZeWV0qLRShYpW+kJKo5GPufr457eBPRaKzjoTBxBtOW6F/ld5cs
	 SJHPGEMkKYfoGpE2RBRS5tYYwYfCivErN/7N3P2U7PMpAhsNBLUoc/z+w3RZtl2LmO
	 Ray0h5Vym0WWMuISltZXzXXegwVbIjAcwXax822o=
Date: Mon, 14 Apr 2025 15:02:24 -0700
To: mm-commits@vger.kernel.org,teknoraver@meta.com,kernel@pengutronix.de,daniel.lezcano@linaro.org,axboe@kernel.dk,a.fatoum@pengutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-abi-replace-mcroce-microsoftcom-with-new-meta-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20250414220224.D5805C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs: ABI: replace mcroce@microsoft.com with new Meta address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     docs-abi-replace-mcroce-microsoftcom-with-new-meta-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-abi-replace-mcroce-microsoftcom-with-new-meta-address.patch

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

docs-abi-replace-mcroce-microsoftcom-with-new-meta-address.patch

