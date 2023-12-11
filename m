Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C57B321D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="td8LO76D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA559C433C8;
	Mon, 11 Dec 2023 01:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257427;
	bh=OZRaaNFL/C74ghKa/tYkk5oJioL8ZwQTOvCrLRiv810=;
	h=Date:To:From:Subject:From;
	b=td8LO76DoyVbDonXoRzyIapJiQwGIhdqMeL1P0CmkGTtSpolmLftz+DzSwci++Tr4
	 by2NW6WrDyuJ34PpT1eTERATSwhA/TH4eEr1onCL9dRERPMIQIgEnJEiqMVIEuMEGw
	 nLocbZj7rkULIp1AEg41NIpBx8qDfTF+Sv31/XfM=
Date: Sun, 10 Dec 2023 17:17:07 -0800
To: mm-commits@vger.kernel.org,ldmldm05@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch removed from -mm tree
Message-Id: <20231211011707.DA559C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix
has been removed from the -mm tree.  Its filename was
     kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix.patch

This patch was dropped because it was folded into kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix
Date: Mon Nov  6 08:22:24 AM PST 2023

tweak comment text

Cc: Dongmin Lee <ldmldm05@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/reboot.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/reboot.c~kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off-fix
+++ a/kernel/reboot.c
@@ -59,9 +59,10 @@ struct sys_off_handler {
 };
 
 /*
- * This variable is used to indicate if a halt initiated instead when
- * reboot call is invoked with LINUX_REBOOT_CMD_POWER_OFF, but system
- * cannot be powered off. This allowes kernel_halt() to notify that.
+ * This variable is used to indicate if a halt was initiated instead of a
+ * reboot when the reboot call was invoked with LINUX_REBOOT_CMD_POWER_OFF, but
+ * the system cannot be powered off. This allowes kernel_halt() to notify users
+ * of that.
  */
 static bool poweroff_fallback_to_halt;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-restore-subtree-stats-flushing-fix.patch
kernel-reboot-explicitly-notify-if-halt-occurred-instead-of-power-off.patch

