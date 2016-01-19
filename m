From: akpm@linux-foundation.org
Subject: [merged] uselib-default-depending-if-libc5-was-used.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:44 -0800
Message-ID: <569e9934.Ys2eGAa+kniGEZzm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riku.voipio@linaro.org, geert@linux-m68k.org, josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: uselib: default depending if libc5 was used
has been removed from the -mm tree.  Its filename was
     uselib-default-depending-if-libc5-was-used.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Riku Voipio <riku.voipio@linaro.org>
Subject: uselib: default depending if libc5 was used

uselib hasn't been used since libc5; glibc does not use it.
Deprecate uselib a bit more, by making the default y only
if libc5 was widely used on the plaform.

This makes arm64 kernel built with defconfig slightly smaller

bloat-o-meter:
add/remove: 0/3 grow/shrink: 0/2 up/down: 0/-1390 (-1390)
function                                     old     new   delta
kernel_config_data                         18164   18162      -2
uselib_flags                                  20       -     -20
padzero                                      216     192     -24
sys_uselib                                   380       -    -380
load_elf_library                             964       -    -964

Signed-off-by: Riku Voipio <riku.voipio@linaro.org>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~uselib-default-depending-if-libc5-was-used init/Kconfig
--- a/init/Kconfig~uselib-default-depending-if-libc5-was-used
+++ a/init/Kconfig
@@ -285,7 +285,7 @@ config FHANDLE
 
 config USELIB
 	bool "uselib syscall"
-	default y
+	def_bool ALPHA || M68K || SPARC || X86_32 || IA32_EMULATION
 	help
 	  This option enables the uselib syscall, a system call used in the
 	  dynamic linker from libc5 and earlier.  glibc does not use this
_

Patches currently in -mm which might be from riku.voipio@linaro.org are


