From: akpm@osdl.org
Subject: - compile-time-check-re-world-writeable-module-params.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:34 -0800
Message-ID: <200612072303.kB7N3YVO029970@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51917 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163727AbWLGXDh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Compile-time check re world-writeable module params
has been removed from the -mm tree.  Its filename was
     compile-time-check-re-world-writeable-module-params.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Compile-time check re world-writeable module params
From: Alexey Dobriyan <adobriyan@gmail.com>

One of the mistakes a module_param() user can make is to supply default
value of module parameter as the last argument.  module_param() accepts
permissions instead.  If default value is, say, 3 (-------wx), parameter
becomes world-writeable.

So far, the only remedy was to apply grep(1) and read drivers submitted
to -mm. BTDT.

With this patch applied, compiler will finally do some job.

*) bounds checking on permissions
*) world-writeable bit checking on permissions
*) compile breakage if checks trigger

First version of this check (only "& 2" part) directly caught 4 out of 7
places during my last grep.

    Subject: Neverending module_param() bugs
    [X] drivers/acpi/sbs.c:101:module_param(capacity_mode, int, CAPACITY_UNIT);
    [X] drivers/acpi/sbs.c:102:module_param(update_mode, int, UPDATE_MODE);
    [ ] drivers/acpi/sbs.c:103:module_param(update_info_mode, int, UPDATE_INFO_MODE);
    [ ] drivers/acpi/sbs.c:104:module_param(update_time, int, UPDATE_TIME);
    [ ] drivers/acpi/sbs.c:105:module_param(update_time2, int, UPDATE_TIME2);
    [X] drivers/char/watchdog/sbc8360.c:203:module_param(timeout, int, 27);
    [X] drivers/media/video/tuner-simple.c:13:module_param(offset, int, 0666);

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/moduleparam.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/moduleparam.h~compile-time-check-re-world-writeable-module-params include/linux/moduleparam.h
--- a/include/linux/moduleparam.h~compile-time-check-re-world-writeable-module-params
+++ a/include/linux/moduleparam.h
@@ -63,6 +63,9 @@ struct kparam_array
    not there, read bits mean it's readable, write bits mean it's
    writable. */
 #define __module_param_call(prefix, name, set, get, arg, perm)		\
+	/* Default value instead of permissions? */			\
+	static int __param_perm_check_##name __attribute__((unused)) =	\
+	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2));	\
 	static char __param_str_##name[] = prefix #name;		\
 	static struct kernel_param const __param_##name			\
 	__attribute_used__						\
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-cpufreq.patch
git-ieee1394.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-isdn-trivial-vsnprintf-conversion.patch
drivers-video-use-kmemdup.patch

