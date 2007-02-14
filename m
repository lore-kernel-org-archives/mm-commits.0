From: akpm@linux-foundation.org
Subject: - sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch removed from -mm tree
Date: Tue, 13 Feb 2007 23:41:23 -0800
Message-ID: <200702140741.l1E7fNBP024626@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45172 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166AbXBNHl1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 02:41:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laurent.riffard@free.fr, mm-commits@vger.kernel.org


The patch titled
     sysctl-move-utsname-sysctls-to-their-own-file-fix 2
has been removed from the -mm tree.  Its filename was
     sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch

This patch was dropped because it was folded into sysctl-move-utsname-sysctls-to-their-own-file.patch

------------------------------------------------------
Subject: sysctl-move-utsname-sysctls-to-their-own-file-fix 2
From: ebiederm@xmission.com (Eric W. Biederman)

akpm@osdl.org writes:

> The patch titled
>      compile and link utsname_sysctl.o
> has been added to the -mm tree.  Its filename is
>      sysctl-move-utsname-sysctls-to-their-own-file-fix.patch
>
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
>
> ------------------------------------------------------
> Subject: compile and link utsname_sysctl.o
> From: Laurent Riffard <laurent.riffard@free.fr>
>
> The utsname stuff has been moved from kernel/sysctl.c to the new file
> utsname_sysctl.c. Let's use it...

Andrew I just looked at the original version of this patch that
went out from mm-commits and the appropriate makefile change was in
it.  It looks like somewhere in the chaos the makefile change got
lost.  Resolving conflicting patches perhaps?

Anyway here is just the original makefile change hunk taken
from the original patch.  I prefer it this way primarily
because it doesn't make sense to compile this file if we are
not compiling sysctl support into the kernel.

kernel/Makefile

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/Makefile~sysctl-move-utsname-sysctls-to-their-own-file-fix-2 kernel/Makefile
--- a/kernel/Makefile~sysctl-move-utsname-sysctls-to-their-own-file-fix-2
+++ a/kernel/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_RELAY) += relay.o
+obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
_

Patches currently in -mm which might be from laurent.riffard@free.fr are

sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
