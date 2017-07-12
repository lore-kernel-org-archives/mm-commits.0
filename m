From: akpm@linux-foundation.org
Subject: [folded-merged]
 powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr-fix.patch
 removed from -mm tree
Date: Wed, 12 Jul 2017 14:15:54 -0700
Message-ID: <5966918a.4QTDnylrR9qRX00n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52116 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753282AbdGLVPz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:15:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: crash: Fix linux-next build warning
has been removed from the -mm tree.  Its filename was
     powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr-fix.patch

This patch was dropped because it was folded into powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr.patch

------------------------------------------------------
From: Xunlei Pang <xlpang@redhat.com>
Subject: crash: Fix linux-next build warning

linux-next build (arm multi_v7_defconfig) produced this warning:

In file included from include/asm-generic/bug.h:15:0,
                 from arch/arm/include/asm/bug.h:59,
                 from include/linux/bug.h:4,
                 from include/linux/elfcore.h:5,
                 from include/linux/crash_core.h:5,
                 from kernel/crash_core.c:9:
kernel/crash_core.c: In function 'vmcoreinfo_append_str':
include/linux/kernel.h:757:16: warning: comparison of distinct pointer
types lacks a cast
  (void) (&min1 == &min2);   \
                ^
include/linux/kernel.h:760:2: note: in expansion of macro '__min'
  __min(typeof(x), typeof(y),   \
  ^
kernel/crash_core.c:360:6: note: in expansion of macro 'min'
  r = min(r, VMCOREINFO_BYTES - vmcoreinfo_size);
      ^

This patch fixes it with an explicit "size_t" type-casting on
VMCOREINFO_BYTES.

Andrew will help merge it into commit fc7d2b44367f ("powerpc/fadump:
use the correct VMCOREINFO_NOTE_SIZE for phdr") before sending it to
stable.

Link: http://lkml.kernel.org/r/1494830606-27736-1-git-send-email-xlpang@redhat.com
Signed-off-by: Xunlei Pang <xlpang@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/crash_core.c~powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr-fix kernel/crash_core.c
--- a/kernel/crash_core.c~powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr-fix
+++ a/kernel/crash_core.c
@@ -342,7 +342,7 @@ void vmcoreinfo_append_str(const char *f
 	r = vscnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 
-	r = min(r, VMCOREINFO_BYTES - vmcoreinfo_size);
+	r = min(r, (size_t)VMCOREINFO_BYTES - vmcoreinfo_size);
 
 	memcpy(&vmcoreinfo_data[vmcoreinfo_size], buf, r);
 
_

Patches currently in -mm which might be from xlpang@redhat.com are

kexec-move-vmcoreinfo-out-of-the-kernels-bss-section.patch
powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr.patch
kdump-protect-vmcoreinfo-data-under-the-crash-memory.patch

