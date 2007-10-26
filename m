From: akpm@linux-foundation.org
Subject: + powerpc-move-_rtc_time-routines-under-config_adb_cuda.patch added to -mm tree
Date: Thu, 25 Oct 2007 20:49:30 -0700
Message-ID: <200710260349.l9Q3nU1P006155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57753 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbXJZDuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 25 Oct 2007 23:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pbadari@us.ibm.com


The patch titled
     powerpc: move _rtc_time() routines under CONFIG_ADB_CUDA
has been added to the -mm tree.  Its filename is
     powerpc-move-_rtc_time-routines-under-config_adb_cuda.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

powerpc-move-_rtc_time-routines-under-config_adb_cuda.patch
hugetlb-allow-sticky-directory-mount-option.patch
mem-controller-gfp-mask-fix.patch
