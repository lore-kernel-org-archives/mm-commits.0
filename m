From: akpm@osdl.org
Subject: + ext4-calls-journal_stop.patch added to -mm tree
Date: Fri, 08 Dec 2006 00:14:37 -0800
Message-ID: <200612080814.kB88EbnZ013099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34040 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425154AbWLHIOl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 03:14:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     ext4 calls journal_stop
has been added to the -mm tree.  Its filename is
     ext4-calls-journal_stop.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-acpi.patch
git-alsa.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

