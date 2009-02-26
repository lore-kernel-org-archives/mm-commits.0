From: akpm@linux-foundation.org
Subject: + x86-conform-l3-cache-index-disable-to-linux-standards-build-fix.patch added to -mm tree
Date: Thu, 26 Feb 2009 14:51:11 -0800
Message-ID: <200902262251.n1QMpCW4030968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752944AbZBZWwH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 17:52:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: wli@movementarian.org, eric@lammerts.org, hpa@zytor.com, mingo@elte.hu, randy.dunlap@oracle.com, rusty@rustcorp.com.au, tglx@linutronix.de


The patch titled
     mm: k8_northbridges[] build fix
has been added to the -mm tree.  Its filename is
     x86-conform-l3-cache-index-disable-to-linux-standards-build-fix.patch

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
Subject: mm: k8_northbridges[] build fix
From: William Irwin <wli@movementarian.org>

k8_northbridges[] isn't a defined symbol unless arch/x86/kernel/k8.c is
compiled, which is conditional on CONFIG_K8_NB.  This patch resolves
the link error by making the sysfs access to the k8 northbridge
conditional on CONFIG_K8_NB in like fashion to the k8_northbridges[]
array itself.  The issue was encountered on a 32-bit build with the
processor family specified as CONFIG_MCORE2=y.

The link error was introduced in
	x86-conform-l3-cache-index-disable-to-linux-standards.patch

Signed-off-by: William Irwin <wli@movementarian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Eric Lammerts <eric@lammerts.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/cpu/intel_cacheinfo.c~x86-conform-l3-cache-index-disable-to-linux-standards-build-fix arch/x86/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c~x86-conform-l3-cache-index-disable-to-linux-standards-build-fix
+++ a/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -613,7 +613,7 @@ static int __cpuinit detect_cache_attrib
 	return retval;
 }
 
-#ifdef CONFIG_SYSFS
+#if defined(CONFIG_SYSFS) && defined(CONFIG_K8_NB)
 
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
@@ -986,4 +986,4 @@ static int __cpuinit cache_sysfs_init(vo
 
 device_initcall(cache_sysfs_init);
 
-#endif
+#endif /* defined(CONFIG_SYSFS) && defined(CONFIG_K8_NB) */
_

Patches currently in -mm which might be from wli@movementarian.org are

x86-conform-l3-cache-index-disable-to-linux-standards-build-fix.patch
epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-update.patch
epoll-keyed-wakeups-v2-make-eventfd-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-make-tty-use-keyed-wakeups.patch

