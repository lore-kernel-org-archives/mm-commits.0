From: akpm@linux-foundation.org
Subject: - powerpc-fix-memset-size-error.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:07:12 -0800
Message-ID: <200711130407.lAD47BYx025216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39481 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756291AbXKMEH0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:07:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, benh@kernel.crashing.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     POWERPC: fix memset size error
has been removed from the -mm tree.  Its filename was
     powerpc-fix-memset-size-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
drivers-video-ps3fb-fix-memset-size-error.patch
w1-fix-memset-size-error.patch
arm-fix-memset-size-error.patch
ia64-efi-make-full-use-of-macro-efi_md_size.patch
