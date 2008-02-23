From: akpm@linux-foundation.org
Subject: - ata-fix-sparse-warning-in-libatah.patch removed from -mm tree
Date: Sat, 23 Feb 2008 12:22:02 -0800
Message-ID: <200802232022.m1NKM23A013392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54648 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761447AbYBWU2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 15:28:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, htejun@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ata: fix sparse warning in libata.h
has been removed from the -mm tree.  Its filename was
     ata-fix-sparse-warning-in-libatah.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ata: fix sparse warning in libata.h
From: Harvey Harrison <harvey.harrison@gmail.com>

Avoids lots of these, also is more readable.
include/linux/libata.h:1210:13: warning: potentially expensive pointer subtraction

Change the subtraction to addition on the other side of the comparison.

Thanks to Christer Weinigel for the suggestion.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/libata.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/libata.h~ata-fix-sparse-warning-in-libatah include/linux/libata.h
--- a/include/linux/libata.h~ata-fix-sparse-warning-in-libatah
+++ a/include/linux/libata.h
@@ -1207,7 +1207,7 @@ static inline struct ata_link *ata_port_
 		return ap->pmp_link;
 	}
 
-	if (++link - ap->pmp_link < ap->nr_pmp_links)
+	if (++link < ap->nr_pmp_links + ap->pmp_link)
 		return link;
 	return NULL;
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
markers-fix-sparse-warnings-in-markersc.patch
bttv-struct-member-initialized-twice.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-nfsd.patch
git-sched.patch
git-scsi-rc-fixes.patch
git-x86.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
