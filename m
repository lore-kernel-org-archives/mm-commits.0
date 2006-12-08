From: akpm@osdl.org
Subject: - ext4-calls-journal_stop.patch removed from -mm tree
Date: Fri, 08 Dec 2006 11:59:12 -0800
Message-ID: <200612081959.kB8JxCvB001606@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56434 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426182AbWLHT7z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 14:59:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ext4 calls journal_stop
has been removed from the -mm tree.  Its filename was
     ext4-calls-journal_stop.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ext4 calls journal_stop
From: Randy Dunlap <randy.dunlap@oracle.com>

journal_stop() is not defined for ext4; change to ext4_journal_stop().

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext4/inode.c~ext4-calls-journal_stop fs/ext4/inode.c
--- a/fs/ext4/inode.c~ext4-calls-journal_stop
+++ a/fs/ext4/inode.c
@@ -1232,7 +1232,7 @@ retry:
 				from, to, NULL, do_journal_get_write_access);
 		if (ret)
 			/* fatal error, just put the handle and return */
-			journal_stop(handle);
+			ext4_journal_stop(handle);
 	}
 	return ret;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
ext4-calls-journal_stop.patch
generic-bug-implementation.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
reiser4-use-null-for-pointers.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

