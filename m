From: akpm@linux-foundation.org
Subject: - register_cpu-__devinit-or-__cpuinit.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:15 -0800
Message-ID: <200802070020.m170KufS006205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56542 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763283AbYBGAoQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:44:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     register_cpu __devinit or __cpuinit
has been removed from the -mm tree.  Its filename was
     register_cpu-__devinit-or-__cpuinit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
documentation-move-dnotifytxt-to-filesystems.patch
documentation-move-sharedsubtreestxt-to-filesystems.patch
documentation-create-new-scheduler-subdirectory.patch
reporting-bugs-cc-the-mailing-list-too.patch
kernel-doc-prevent-duplicate-description-output.patch
kernel-doc-warn-on-badly-formatted-short-description.patch
email-clientstxt-sylpheed-is-ok-at-imap.patch
fs-menu-small-reorg.patch
the-scheduled-time-option-removal.patch
getdelays-fix-gcc-warnings.patch
profile-likely-unlikely-macros.patch
