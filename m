From: akpm@linux-foundation.org
Subject: + register_cpu-__devinit-or-__cpuinit.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:31:41 -0700
Message-ID: <200710302031.l9UKVfbq026747@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50813 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbXJ3Ucc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:32:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     register_cpu __devinit or __cpuinit
has been added to the -mm tree.  Its filename is
     register_cpu-__devinit-or-__cpuinit.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: register_cpu __devinit or __cpuinit
From: Randy Dunlap <randy.dunlap@oracle.com>

Is there some reason why register_cpu() is __devinit instead of __cpuinit ?
Make it __cpuinit.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/cpu.c~register_cpu-__devinit-or-__cpuinit drivers/base/cpu.c
--- a/drivers/base/cpu.c~register_cpu-__devinit-or-__cpuinit
+++ a/drivers/base/cpu.c
@@ -110,7 +110,7 @@ static SYSDEV_ATTR(crash_notes, 0400, sh
  *
  * Initialize and register the CPU device.
  */
-int __devinit register_cpu(struct cpu *cpu, int num)
+int __cpuinit register_cpu(struct cpu *cpu, int num)
 {
 	int error;
 	cpu->node_id = cpu_to_node(num);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
sysctl-fix-token-ring-procname.patch
register_cpu-__devinit-or-__cpuinit.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
