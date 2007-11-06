From: akpm@linux-foundation.org
Subject: - powerpc-move-_rtc_time-routines-under-config_adb_cuda.patch removed from -mm tree
Date: Tue, 06 Nov 2007 12:24:53 -0800
Message-ID: <200711061924.lA6JOmv1005394@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43010 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbXKFTZa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Nov 2007 14:25:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: move _rtc_time() routines under CONFIG_ADB_CUDA
has been removed from the -mm tree.  Its filename was
     powerpc-move-_rtc_time-routines-under-config_adb_cuda.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: powerpc: move _rtc_time() routines under CONFIG_ADB_CUDA
From: Badari Pulavarty <pbadari@us.ibm.com>

to_rtc_time() and from_rtc_time() seems to be used only if CONFIG_ADB_CUDA
defined. Moving them under that ifdef.

arch/powerpc/platforms/powermac/time.c:88: warning: `to_rtc_time' defined but not used
arch/powerpc/platforms/powermac/time.c:95: warning: `from_rtc_time' defined but not used

Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/powermac/time.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/platforms/powermac/time.c~powerpc-move-_rtc_time-routines-under-config_adb_cuda arch/powerpc/platforms/powermac/time.c
--- a/arch/powerpc/platforms/powermac/time.c~powerpc-move-_rtc_time-routines-under-config_adb_cuda
+++ a/arch/powerpc/platforms/powermac/time.c
@@ -84,6 +84,7 @@ long __init pmac_time_init(void)
 	return delta;
 }
 
+#ifdef CONFIG_ADB_CUDA
 static void to_rtc_time(unsigned long now, struct rtc_time *tm)
 {
 	to_tm(now, tm);
@@ -97,7 +98,6 @@ static unsigned long from_rtc_time(struc
 		      tm->tm_hour, tm->tm_min, tm->tm_sec);
 }
 
-#ifdef CONFIG_ADB_CUDA
 static unsigned long cuda_get_time(void)
 {
 	struct adb_request req;
_

Patches currently in -mm which might be from pbadari@us.ibm.com are

memory-hotremove-unset-migrate-type-isolate-after-removal.patch
add-ioresouce_busy-flag-for-system-ram.patch
powerpc-move-_rtc_time-routines-under-config_adb_cuda.patch
hugetlb-allow-sticky-directory-mount-option.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
add-remove_memory-for-ppc64-2.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
mem-controller-gfp-mask-fix.patch
