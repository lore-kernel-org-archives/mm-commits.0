From: akpm@linux-foundation.org
Subject: + kernel-sysc-sys_reboot-fix-malformed-panic-message.patch added
 to -mm tree
Date: Fri, 31 May 2013 16:04:18 -0700
Message-ID: <51a92c72.asoDCULKykeNKuF9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41137 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab3EaXES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 19:04:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lig.fnst@cn.fujitsu.com

Subject: + kernel-sysc-sys_reboot-fix-malformed-panic-message.patch added to -mm tree
To: lig.fnst@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 16:04:18 -0700


The patch titled
     Subject: kernel/sys.c: sys_reboot(): fix malformed panic message
has been added to the -mm tree.  Its filename is
     kernel-sysc-sys_reboot-fix-malformed-panic-message.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: liguang <lig.fnst@cn.fujitsu.com>
Subject: kernel/sys.c: sys_reboot(): fix malformed panic message

If LINUX_REBOOT_CMD_HALT for reboot failed, the message "cannot halt" will
stay on the same line with the next message, so append a '\n'.

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~kernel-sysc-sys_reboot-fix-malformed-panic-message kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-sys_reboot-fix-malformed-panic-message
+++ a/kernel/sys.c
@@ -509,7 +509,7 @@ SYSCALL_DEFINE4(reboot, int, magic1, int
 	case LINUX_REBOOT_CMD_HALT:
 		kernel_halt();
 		do_exit(0);
-		panic("cannot halt");
+		panic("cannot halt.\n");
 
 	case LINUX_REBOOT_CMD_POWER_OFF:
 		kernel_power_off();
_

Patches currently in -mm which might be from lig.fnst@cn.fujitsu.com are

kernel-sysc-remove-unnecessary-parameter-of-set_one_prio.patch
kernel-sysc-remove-unnecessary-parameter-of-set_one_prio-fix.patch
kernel-sysc-sys_reboot-fix-malformed-panic-message.patch

