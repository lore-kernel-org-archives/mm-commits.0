From: akpm@linux-foundation.org
Subject: - smaps-only-define-clear_refs-for-config_mmu.patch removed from -mm tree
Date: Wed, 09 May 2007 01:42:36 -0700
Message-ID: <200705090842.l498gaIW018217@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754289AbXEIImv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 04:42:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     smaps: only define clear_refs for CONFIG_MMU
has been removed from the -mm tree.  Its filename was
     smaps-only-define-clear_refs-for-config_mmu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: smaps: only define clear_refs for CONFIG_MMU
From: David Rientjes <rientjes@google.com>

/proc/pid/clear_refs is only defined in the CONFIG_MMU case, so make sure we
don't have any references to clear_refs_smap() in generic procfs code.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/proc/base.c~smaps-only-define-clear_refs-for-config_mmu fs/proc/base.c
--- a/fs/proc/base.c~smaps-only-define-clear_refs-for-config_mmu
+++ a/fs/proc/base.c
@@ -708,6 +708,7 @@ static const struct file_operations proc
 	.write		= oom_adjust_write,
 };
 
+#ifdef CONFIG_MMU
 static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -741,6 +742,7 @@ static ssize_t clear_refs_write(struct f
 static struct file_operations proc_clear_refs_operations = {
 	.write		= clear_refs_write,
 };
+#endif
 
 #ifdef CONFIG_AUDITSYSCALL
 #define TMPBUFLEN 21
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
git-alsa.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
compiler-introduce-__used-and-__maybe_unused.patch
i386-pci-type-may-be-unused.patch
sh-dma-use-__maybe_unused.patch
scsi-fix-ambiguous-gdthtable-definition.patch
frv-gdb-use-__maybe_unused.patch
i386-voyager-use-__maybe_unused.patch
mips-excite-use-__maybe_unused.patch
mips-tlbex-use-__maybe_unused.patch
powerpc-ps3-use-__maybe_unused.patch
i386-mmzone-use-__maybe_unused.patch
