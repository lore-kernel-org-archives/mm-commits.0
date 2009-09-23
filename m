From: akpm@linux-foundation.org
Subject: [merged] kbuild-fail-build-if-recordmcountpl-fails.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:04:47 -0700
Message-ID: <200909232004.n8NK4lF2022006@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33413 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753942AbZIWUF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:05:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andi@firstfloor.org, ak@linux.intel.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     kbuild: fail build if recordmcount.pl fails
has been removed from the -mm tree.  Its filename was
     kbuild-fail-build-if-recordmcountpl-fails.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kbuild: fail build if recordmcount.pl fails
From: Andi Kleen <andi@firstfloor.org>

When this script fails the build should fail too. Otherwise there
are mysterious build failures later.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.build |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/Makefile.build~kbuild-fail-build-if-recordmcountpl-fails scripts/Makefile.build
--- a/scripts/Makefile.build~kbuild-fail-build-if-recordmcountpl-fails
+++ a/scripts/Makefile.build
@@ -206,7 +206,7 @@ cmd_modversions =							\
 endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
-cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
+cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_64BIT),64,32)" \
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
linux-next.patch
vfs-optimization-for-touch_atime.patch
vfs-optimize-touch_time-too.patch
time-add-function-to-convert-between-calendar-time-and-broken-down-time-for-universal-use.patch
fatfs-use-common-time_to_tm-in-fat_time_unix2fat.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch
exec-allow-do_coredump-to-wait-for-user-space-pipe-readers-to-complete-v9.patch

