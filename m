From: akpm@linux-foundation.org
Subject: [folded-merged]
 kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 15:09:47 -0700
Message-ID: <55f0ae2b.+X+X2SHTaeQ4S3WO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56168 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbbIIWJs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 18:09:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dyoung@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec-split-kexec_file-syscall-code-to-kexec_filec-fix
has been removed from the -mm tree.  Its filename was
     kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch

This patch was dropped because it was folded into kexec-split-kexec_file-syscall-code-to-kexec_filec.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-split-kexec_file-syscall-code-to-kexec_filec-fix

fix bisectability

kernel/kexec.c: In function 'crash_save_vmcoreinfo_init':
kernel/kexec.c:1593: error: 'vmap_area_list' undeclared (first use in this function)
kernel/kexec.c:1593: error: (Each undeclared identifier is reported only once
kernel/kexec.c:1593: error: for each function it appears in.)
kernel/kexec.c:1631: error: invalid use of undefined type 'struct vmap_area'
kernel/kexec.c:1632: error: invalid use of undefined type 'struct vmap_area'

Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/kexec.c~kexec-split-kexec_file-syscall-code-to-kexec_filec-fix kernel/kexec.c
--- a/kernel/kexec.c~kexec-split-kexec_file-syscall-code-to-kexec_filec-fix
+++ a/kernel/kexec.c
@@ -28,6 +28,7 @@
 #include <linux/suspend.h>
 #include <linux/device.h>
 #include <linux/freezer.h>
+#include <linux/vmalloc.h>
 #include <linux/pm.h>
 #include <linux/cpu.h>
 #include <linux/console.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch

