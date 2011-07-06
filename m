From: akpm@linux-foundation.org
Subject: + notifiers-sys-move-reboot-notifiers-into-rebooth-fix.patch added to -mm tree
Date: Wed, 06 Jul 2011 15:20:16 -0700
Message-ID: <201107062220.p66MKGt5003256@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752967Ab1GFWUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 18:20:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, sfr@canb.auug.org.au


The patch titled
     notifiers-sys-move-reboot-notifiers-into-rebooth-fix
has been added to the -mm tree.  Its filename is
     notifiers-sys-move-reboot-notifiers-into-rebooth-fix.patch

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
Subject: notifiers-sys-move-reboot-notifiers-into-rebooth-fix
From: Cong Wang <amwang@redhat.com>

With this patch applied, make allyesconfig succeeds on ppc64.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/rtas.c       |    1 +
 arch/powerpc/kernel/rtas_flash.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/powerpc/kernel/rtas.c~notifiers-sys-move-reboot-notifiers-into-rebooth-fix arch/powerpc/kernel/rtas.c
--- a/arch/powerpc/kernel/rtas.c~notifiers-sys-move-reboot-notifiers-into-rebooth-fix
+++ a/arch/powerpc/kernel/rtas.c
@@ -24,6 +24,7 @@
 #include <linux/cpumask.h>
 #include <linux/memblock.h>
 #include <linux/slab.h>
+#include <linux/reboot.h>
 
 #include <asm/prom.h>
 #include <asm/rtas.h>
diff -puN arch/powerpc/kernel/rtas_flash.c~notifiers-sys-move-reboot-notifiers-into-rebooth-fix arch/powerpc/kernel/rtas_flash.c
--- a/arch/powerpc/kernel/rtas_flash.c~notifiers-sys-move-reboot-notifiers-into-rebooth-fix
+++ a/arch/powerpc/kernel/rtas_flash.c
@@ -17,6 +17,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
+#include <linux/reboot.h>
 #include <asm/delay.h>
 #include <asm/uaccess.h>
 #include <asm/rtas.h>
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
notifiers-cpu-move-cpu-notifiers-into-cpuh.patch
notifiers-net-move-netdevice-notifiers-into-netdeviceh.patch
notifiers-sys-move-reboot-notifiers-into-rebooth.patch
notifiers-sys-move-reboot-notifiers-into-rebooth-fix.patch
notifiers-pm-move-pm-notifiers-into-suspendh.patch
notifiers-pm-move-pm-notifiers-into-suspendh-update.patch
notifiers-vt-move-vt-notifiers-into-vth.patch

