From: akpm@linux-foundation.org
Subject: [to-be-updated] fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes-fix.patch removed from -mm tree
Date: Tue, 13 Jan 2009 10:46:18 -0800
Message-ID: <200901131846.n0DIkIfr002406@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43958 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753621AbZAMSqd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Jan 2009 13:46:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hugh@veritas.com, mikew@google.com, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes-fix
has been removed from the -mm tree.  Its filename was
     fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes-fix.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes-fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

pgoff is *not* vma->vm_start >> PAGE_SHIFT.
And no adjustment is necessary (when it maps the same start
before/after adjust vma.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/exec.c~fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes-fix fs/exec.c
--- a/fs/exec.c~fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes-fix
+++ a/fs/exec.c
@@ -509,7 +509,7 @@ static int shift_arg_pages(struct vm_are
 	unsigned long length = old_end - old_start;
 	unsigned long new_start = old_start - shift;
 	unsigned long new_end = old_end - shift;
-	unsigned long new_pgoff = new_start >> PAGE_SHIFT;
+	unsigned long new_pgoff = vma->vm_pgoff;
 	struct mmu_gather *tlb;
 
 	BUG_ON(new_start > new_end);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes-fix.patch
cgroups-consolidate-cgroup-documents.patch
rtc-cumulative-style-fixes-fix-fix.patch

