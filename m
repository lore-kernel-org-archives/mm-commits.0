From: akpm@linux-foundation.org
Subject: [merged] proc-fix-missing-reference-of-mm.patch removed from -mm
 tree
Date: Wed, 03 Feb 2016 13:53:12 -0800
Message-ID: <56b276c8.RbwzEkdP7R0SCvZ9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933165AbcBCVxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2016 16:53:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sudipm.mukherjee@gmail.com, hannes@cmpxchg.org, sudip@vectorindia.org, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix missing reference of mm
has been removed from the -mm tree.  Its filename was
     proc-fix-missing-reference-of-mm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: proc: fix missing reference of mm

The defconfig build of blackfin was failing with the error:
fs/proc/task_nommu.c: In function 'is_stack':
fs/proc/task_nommu.c:132:28: error: 'mm' undeclared (first use in this function)

While reverting /proc/<pid>/maps [stack:TID] annotation a reference to
mm was missed.

Fixes: e87d4fd02f40 ("proc: revert /proc/<pid>/maps [stack:TID] annotation")
Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/proc/task_nommu.c~proc-fix-missing-reference-of-mm fs/proc/task_nommu.c
--- a/fs/proc/task_nommu.c~proc-fix-missing-reference-of-mm
+++ a/fs/proc/task_nommu.c
@@ -126,6 +126,7 @@ unsigned long task_statm(struct mm_struc
 static int is_stack(struct proc_maps_private *priv,
 		    struct vm_area_struct *vma, int is_pid)
 {
+	struct mm_struct *mm = vma->vm_mm;
 	int stack = 0;
 
 	if (is_pid) {
_

Patches currently in -mm which might be from sudipm.mukherjee@gmail.com are

m32r-fix-build-failure-due-to-smp-and-mmu.patch
m32r-mm-fix-build-warning.patch

