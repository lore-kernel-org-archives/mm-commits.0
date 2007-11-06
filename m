From: akpm@linux-foundation.org
Subject: + powerpc-fix-memset-size-error.patch added to -mm tree
Date: Mon, 05 Nov 2007 17:12:02 -0800
Message-ID: <200711060112.lA61C2Yp029300@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54397 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756084AbXKFBMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 20:12:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lizf@cn.fujitsu.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     POWERPC: fix memset size error
has been added to the -mm tree.  Its filename is
     powerpc-fix-memset-size-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: POWERPC: fix memset size error
From: Li Zefan <lizf@cn.fujitsu.com>

The size passing to memset is wrong.

Signed-off-by Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Mackerras <paulus@samba.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/prom_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/kernel/prom_init.c~powerpc-fix-memset-size-error arch/powerpc/kernel/prom_init.c
--- a/arch/powerpc/kernel/prom_init.c~powerpc-fix-memset-size-error
+++ a/arch/powerpc/kernel/prom_init.c
@@ -1244,7 +1244,7 @@ static void __init prom_initialize_tce_t
 			local_alloc_bottom = base;
 
 		/* It seems OF doesn't null-terminate the path :-( */
-		memset(path, 0, sizeof(path));
+		memset(path, 0, PROM_SCRATCH_SIZE);
 		/* Call OF to setup the TCE hardware */
 		if (call_prom("package-to-path", 3, 1, node,
 			      path, PROM_SCRATCH_SIZE-1) == PROM_ERROR) {
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

time-fix-inconsistent-function-names-in-comments.patch
git-drm.patch
arm-fix-memset-size-error.patch
ia64-fix-memset-size-error.patch
powerpc-fix-memset-size-error.patch
drivers-video-ps3fb-fix-memset-size-error.patch
w1-fix-memset-size-error.patch
