From: akpm@linux-foundation.org
Subject: - dmi-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch removed from -mm tree
Date: Mon, 27 Aug 2007 14:54:39 -0700
Message-ID: <200708272154.l7RLsex9030459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965239AbXH0Vyv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 17:54:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, greg@kroah.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     drivers/firmware/dmi-id.c: fix overflow
has been removed from the -mm tree.  Its filename was
     dmi-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: drivers/firmware/dmi-id.c: fix overflow
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dmi-id.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/firmware/dmi-id.c~dmi-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct drivers/firmware/dmi-id.c
--- a/drivers/firmware/dmi-id.c~dmi-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct
+++ a/drivers/firmware/dmi-id.c
@@ -152,9 +152,10 @@ static int dmi_dev_uevent(struct device 
 	if (add_uevent_var(env, "MODALIAS="))
 		return -ENOMEM;
 	len = get_modalias(&env->buf[env->buflen - 1],
-			   sizeof(env->buf) - env->buflen);
-	if (len >= (sizeof(env->buf) - env->buflen))
+			   sizeof(env->buf) - (env->buflen - 1));
+	if (len >= (sizeof(env->buf) - (env->buflen - 1)))
 		return -ENOMEM;
+	env->buflen += len + 1;
 	return 0;
 }
 
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
dmi-fix-gregkh-driver-driver-core-change-add_uevent_var-to-use-a-struct.patch
sysfs-crash-debugging.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
