From: akpm@linux-foundation.org
Subject: + fs-proc-task_mmuc-check-the-return-value-of-mpol_to_str.patch
 added to -mm tree
Date: Wed, 21 Aug 2013 15:01:59 -0700
Message-ID: <521538d7.h4nJvyhlXjlJcnP2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab3HUWCA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Aug 2013 18:02:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, gorcunov@gmail.com, andi@firstfloor.org, gang.chen@asianux.com

Subject: + fs-proc-task_mmuc-check-the-return-value-of-mpol_to_str.patch added to -mm tree
To: gang.chen@asianux.com,andi@firstfloor.org,gorcunov@gmail.com,mel@csn.ul.ie
From: akpm@linux-foundation.org
Date: Wed, 21 Aug 2013 15:01:59 -0700


The patch titled
     Subject: fs/proc/task_mmu.c: check the return value of mpol_to_str()
has been added to the -mm tree.  Its filename is
     fs-proc-task_mmuc-check-the-return-value-of-mpol_to_str.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-task_mmuc-check-the-return-value-of-mpol_to_str.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-task_mmuc-check-the-return-value-of-mpol_to_str.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: fs/proc/task_mmu.c: check the return value of mpol_to_str()

mpol_to_str() may fail, and not fill the buffer (e.g. -EINVAL), so need
check about it, or buffer may not be zero based, and next seq_printf()
will cause issue.

The failure return need after mpol_cond_put() to match get_vma_policy().

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/proc/task_mmu.c~fs-proc-task_mmuc-check-the-return-value-of-mpol_to_str fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-check-the-return-value-of-mpol_to_str
+++ a/fs/proc/task_mmu.c
@@ -1402,8 +1402,10 @@ static int show_numa_map(struct seq_file
 	walk.mm = mm;
 
 	pol = get_vma_policy(task, vma, vma->vm_start);
-	mpol_to_str(buffer, sizeof(buffer), pol);
+	n = mpol_to_str(buffer, sizeof(buffer), pol);
 	mpol_cond_put(pol);
+	if (n < 0)
+		return n;
 
 	seq_printf(m, "%08lx %s", vma->vm_start, buffer);
 
_

Patches currently in -mm which might be from gang.chen@asianux.com are

sh64-kernel-use-usp-instead-of-fn.patch
sh64-kernel-remove-useless-variable-regs.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch
mm-page_allocc-use-__paginginit-instead-of-__init.patch
mm-mremapc-call-pud_free-after-fail-calling-pmd_alloc.patch
mm-backing-devc-check-user-buffer-length-before-copying-data-to-the-related-user-buffer.patch
kernel-smpc-free-related-resources-when-failure-occurs-in-hotplug_cfd.patch
fs-proc-task_mmuc-check-the-return-value-of-mpol_to_str.patch
linux-next.patch
mm-kconfig-add-mmu-dependency-for-migration.patch

