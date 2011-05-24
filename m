From: akpm@linux-foundation.org
Subject: + asm-generic-cacheflushh-flush-icache-when-copying-to-user-pages.patch added to -mm tree
Date: Mon, 23 May 2011 19:09:01 -0700
Message-ID: <201105240207.p4O27evR025786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758094Ab1EXCHr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 May 2011 22:07:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, arnd@arndb.de


The patch titled
     asm-generic/cacheflush.h: flush icache when copying to user pages
has been added to the -mm tree.  Its filename is
     asm-generic-cacheflushh-flush-icache-when-copying-to-user-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
net-irda-convert-bfin_sir-to-common-blackfin-uart-header.patch
asm-generic-cacheflushh-flush-icache-when-copying-to-user-pages.patch
lib-consolidate-debug_stack_usage-option.patch
asm-generic-ptraceh-start-a-common-low-level-ptrace-helper.patch
blackfin-convert-to-asm-generic-ptraceh.patch
x86-convert-to-asm-generic-ptraceh.patch
sh-convert-to-asm-generic-ptraceh.patch
kgdbts-unify-generalize-gdb-breakpoint-adjustment.patch
proc-constify-status-array.patch

