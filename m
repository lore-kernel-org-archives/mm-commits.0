From: akpm@linux-foundation.org
Subject: [merged] asm-generic-cacheflushh-flush-icache-when-copying-to-user-pages.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:34 -0700
Message-ID: <201105252028.p4PKSwok014796@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932802Ab1EYUs4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:48:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     asm-generic/cacheflush.h: flush icache when copying to user pages
has been removed from the -mm tree.  Its filename was
     asm-generic-cacheflushh-flush-icache-when-copying-to-user-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic/cacheflush.h: flush icache when copying to user pages
From: Mike Frysinger <vapier@gentoo.org>

The copy_to_user_page() function is supposed to flush the icache on the
memory that was written, but the current asm-generic version lacks that
logic.  While normally it isn't a big deal as the asm-generic version of
icache flushing is a stub, it is a deal for ports that want to use the
asm-generic version as a baseline and then overlay its own specific parts
(like icache flushing).

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/cacheflush.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/cacheflush.h~asm-generic-cacheflushh-flush-icache-when-copying-to-user-pages include/asm-generic/cacheflush.h
--- a/include/asm-generic/cacheflush.h~asm-generic-cacheflushh-flush-icache-when-copying-to-user-pages
+++ a/include/asm-generic/cacheflush.h
@@ -24,7 +24,10 @@
 #define flush_cache_vunmap(start, end)		do { } while (0)
 
 #define copy_to_user_page(vma, page, vaddr, dst, src, len) \
-	memcpy(dst, src, len)
+	do { \
+		memcpy(dst, src, len); \
+		flush_icache_user_range(vma, page, vaddr, len); \
+	} while (0)
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
backlight-new-driver-for-the-adp8870-backlight-devices.patch
backlight-add-backlight-type-fix.patch
linux-next.patch
mtd-convert-to-seq_file-interface.patch
asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch
blackfin-convert-to-asm-generic-ptraceh.patch
x86-convert-to-asm-generic-ptraceh.patch
sh-convert-to-asm-generic-ptraceh.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
proc-constify-status-array.patch

