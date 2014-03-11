From: akpm@linux-foundation.org
Subject: [merged] fs-proc-basec-fix-gpf-in-proc-pid-map_files.patch
 removed from -mm tree
Date: Tue, 11 Mar 2014 11:25:04 -0700
Message-ID: <531f5500.NrFu1rFN5Em2SxFb%akpm__29304.0302269675$1394562320$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214AbaCKSZF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Mar 2014 14:25:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, wiebittewas@gmail.com, stable@vger.kernel.org, gorcunov@openvz.org, ebiederm@xmission.com, aleksandr_terekhov@epam.com, artem_fetishev@epam.com

Subject: [merged] fs-proc-basec-fix-gpf-in-proc-pid-map_files.patch removed from -mm tree
To: artem_fetishev@epam.com,aleksandr_terekhov@epam.com,ebiederm@xmission.com,gorcunov@openvz.org,stable@vger.kernel.org,wiebittewas@gmail.com,xemul@parallels.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 11 Mar 2014 11:25:04 -0700


The patch titled
     Subject: fs/proc/base.c: fix GPF in /proc/$PID/map_files
has been removed from the -mm tree.  Its filename was
     fs-proc-basec-fix-gpf-in-proc-pid-map_files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Fetishev <artem_fetishev@epam.com>
Subject: fs/proc/base.c: fix GPF in /proc/$PID/map_files

The expected logic of proc_map_files_get_link() is either to return 0 and
initialize 'path' or return an error and leave 'path' uninitialized.  By
the time dname_to_vma_addr() returns 0 the corresponding vma may have
already be gone.  In this case the path is not initialized but the return
value is still 0.  This results in 'general protection fault' inside
d_path().

Steps to reproduce:
CONFIG_CHECKPOINT_RESTORE=y

fd = open(...);
while (1) {
	mmap(fd, ...);
	munmap(fd, ...);
}

ls -la /proc/$PID/map_files

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=68991

Signed-off-by: Artem Fetishev <artem_fetishev@epam.com>
Signed-off-by: Aleksandr Terekhov <aleksandr_terekhov@epam.com>
Reported-by: <wiebittewas@gmail.com>
Acked-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/base.c~fs-proc-basec-fix-gpf-in-proc-pid-map_files fs/proc/base.c
--- a/fs/proc/base.c~fs-proc-basec-fix-gpf-in-proc-pid-map_files
+++ a/fs/proc/base.c
@@ -1824,6 +1824,7 @@ static int proc_map_files_get_link(struc
 	if (rc)
 		goto out_mmput;
 
+	rc = -ENOENT;
 	down_read(&mm->mmap_sem);
 	vma = find_exact_vma(mm, vm_start, vm_end);
 	if (vma && vma->vm_file) {
_

Patches currently in -mm which might be from artem_fetishev@epam.com are

origin.patch

