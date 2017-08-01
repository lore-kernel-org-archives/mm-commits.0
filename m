From: akpm@linux-foundation.org
Subject: + fs-proc-remove-priv-argument-from-is_stack-fix.patch added to
 -mm tree
Date: Tue, 01 Aug 2017 15:36:02 -0700
Message-ID: <59810252.07PfJKeh3nRMvLWl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41408 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbdHAWgD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Aug 2017 18:36:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mhocko@kernel.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: fs, proc: remove unused variable
has been added to the -mm tree.  Its filename is
     fs-proc-remove-priv-argument-from-is_stack-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-remove-priv-argument-from-is_stack-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-remove-priv-argument-from-is_stack-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fs, proc: remove unused variable

The last cleanup can go a little further, as shown by this warning:

fs/proc/task_mmu.c: In function 'show_map_vma':
fs/proc/task_mmu.c:285:28: error: unused variable 'priv' [-Werror=unused-variable]

Link: http://lkml.kernel.org/r/20170801120150.1520051-1-arnd@arndb.de
Fixes: 14ccc3193225 ("fs, proc: remove priv argument from is_stack")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/proc/task_mmu.c~fs-proc-remove-priv-argument-from-is_stack-fix fs/proc/task_mmu.c
--- a/fs/proc/task_mmu.c~fs-proc-remove-priv-argument-from-is_stack-fix
+++ a/fs/proc/task_mmu.c
@@ -282,7 +282,6 @@ show_map_vma(struct seq_file *m, struct
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct file *file = vma->vm_file;
-	struct proc_maps_private *priv = m->private;
 	vm_flags_t flags = vma->vm_flags;
 	unsigned long ino = 0;
 	unsigned long long pgoff = 0;
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning-v3.patch
adfs-use-unsigned-types-for-memcpy-length.patch
nvdimm-avoid-bogus-wmaybe-uninitialized-warning.patch
fs-proc-remove-priv-argument-from-is_stack-fix.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch
iopoll-avoid-wint-in-bool-context-warning.patch
kbuild-use-fshort-wchar-globally.patch

