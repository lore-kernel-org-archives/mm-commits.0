From: akpm@linux-foundation.org
Subject: [folded] cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch removed from -mm tree
Date: Mon, 26 Mar 2012 13:16:54 -0700
Message-ID: <20120326201655.50DCAA0270@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:59736 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab2CZUQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 16:16:56 -0400
Received: by yenq2 with SMTP id q2so839573yen.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 13:16:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, broonie@opensource.wolfsonmicro.com, gregkh@linuxfoundation.org, hmh@hmh.eng.br, hpa@zytor.com, len.brown@intel.com, lenb@kernel.org, mingo@elte.hu, shuox.liu@intel.com, tglx@linutronix.de, yanmin_zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix
has been removed from the -mm tree.  Its filename was
     cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix.patch

This patch was dropped because it was folded into cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix

check kstrtol return value

drivers/cpuidle/sysfs.c: In function 'store_state_disable':
drivers/cpuidle/sysfs.c:274: warning: ignoring return value of 'kstrtol', declared with attribute warn_unused_result

Cc: "Brown, Len" <len.brown@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: ShuoX Liu <shuox.liu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yanmin Zhang <yanmin_zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cpuidle/sysfs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/cpuidle/sysfs.c~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix drivers/cpuidle/sysfs.c
--- a/drivers/cpuidle/sysfs.c~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix
+++ a/drivers/cpuidle/sysfs.c
@@ -238,9 +238,12 @@ static ssize_t store_state_##_name(struc
 		const char *buf, size_t size) \
 { \
 	long value; \
+	int err; \
 	if (!capable(CAP_SYS_ADMIN)) \
 		return -EPERM; \
-	kstrtol(buf, 0, &value); \
+	err = kstrtol(buf, 0, &value); \
+	if (err) \
+		return err; \
 	if (value) \
 		state->disable = 1; \
 	else \
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose.patch

