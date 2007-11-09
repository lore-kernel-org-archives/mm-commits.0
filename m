From: akpm@linux-foundation.org
Subject: - ia64-fix-memset-size-error.patch removed from -mm tree
Date: Fri, 09 Nov 2007 11:13:06 -0800
Message-ID: <200711091913.lA9JD6fV027983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56422 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754742AbXKITNU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 14:13:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, horms@verge.net.au, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     IA64: fix memset size error
has been removed from the -mm tree.  Its filename was
     ia64-fix-memset-size-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

drivers-video-ps3fb-fix-memset-size-error.patch
w1-fix-memset-size-error.patch
arm-fix-memset-size-error.patch
powerpc-fix-memset-size-error.patch
git-ia64.patch
