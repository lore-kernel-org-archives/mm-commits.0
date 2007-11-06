From: akpm@linux-foundation.org
Subject: + ia64-fix-memset-size-error.patch added to -mm tree
Date: Mon, 05 Nov 2007 17:12:00 -0800
Message-ID: <200711060112.lA61C0CH029291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756380AbXKFBMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 20:12:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, horms@verge.net.au, tony.luck@intel.com


The patch titled
     IA64: fix memset size error
has been added to the -mm tree.  Its filename is
     ia64-fix-memset-size-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IA64: fix memset size error
From: Li Zefan <lizf@cn.fujitsu.com>

The size arguments passing to memset is wrong.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/efi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/efi.c~ia64-fix-memset-size-error arch/ia64/kernel/efi.c
--- a/arch/ia64/kernel/efi.c~ia64-fix-memset-size-error
+++ a/arch/ia64/kernel/efi.c
@@ -218,7 +218,7 @@ efi_gettimeofday (struct timespec *ts)
 {
 	efi_time_t tm;
 
-	memset(ts, 0, sizeof(ts));
+	memset(ts, 0, sizeof(*ts));
 	if ((*efi.get_time)(&tm, NULL) != EFI_SUCCESS)
 		return;
 
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

time-fix-inconsistent-function-names-in-comments.patch
git-drm.patch
arm-fix-memset-size-error.patch
ia64-fix-memset-size-error.patch
powerpc-fix-memset-size-error.patch
drivers-video-ps3fb-fix-memset-size-error.patch
w1-fix-memset-size-error.patch
