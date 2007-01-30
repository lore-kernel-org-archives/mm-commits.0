From: akpm@osdl.org
Subject: + sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch added to -mm tree
Date: Tue, 30 Jan 2007 11:39:31 -0800
Message-ID: <200701301939.l0UJdVNa026830@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44673 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbXA3Tje (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 14:39:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laurent.riffard@free.fr


The patch titled
     sysctl-move-utsname-sysctls-to-their-own-file-fix 2
has been added to the -mm tree.  Its filename is
     sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/Makefile |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/Makefile~sysctl-move-utsname-sysctls-to-their-own-file-fix-2 kernel/Makefile
--- a/kernel/Makefile~sysctl-move-utsname-sysctls-to-their-own-file-fix-2
+++ a/kernel/Makefile
@@ -52,6 +52,7 @@ ifeq ($(CONFIG_PREEMPT_RCU),y)
 obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
 endif
 obj-$(CONFIG_RELAY) += relay.o
+obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 
_

Patches currently in -mm which might be from laurent.riffard@free.fr are

reiser4-vs-streamline-generic_file_-interfaces-and-filemap.patch
sysctl-move-utsname-sysctls-to-their-own-file-fix-2.patch
