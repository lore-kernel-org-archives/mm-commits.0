From: akpm@linux-foundation.org
Subject: +
 powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr-fix.patch
 added to -mm tree
Date: Mon, 15 May 2017 13:00:36 -0700
Message-ID: <591a08e4.8Zi8CNcWqHGu5B6H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37772 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752109AbdEOUAj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 15 May 2017 16:00:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xlpang@redhat.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: crash: Fix linux-next build warning
has been added to the -mm tree.  Its filename is
     powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
powerpc-fadump-use-the-correct-vmcoreinfo_note_size-for-phdr-fix.patch
kdump-protect-vmcoreinfo-data-under-the-crash-memory.patch

