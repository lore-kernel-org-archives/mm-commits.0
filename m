From: akpm@linux-foundation.org
Subject: + proc-add-kpageidle-file-fix-99.patch added to -mm tree
Date: Wed, 09 Sep 2015 14:08:40 -0700
Message-ID: <55f09fd8.EWxNCr8JKql2lyma%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49986 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbbIIVIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 17:08:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hughd@google.com, kirill.shutemov@linux.intel.com, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kpageidle: decouple from page-flags rework
has been added to the -mm tree.  Its filename is
     proc-add-kpageidle-file-fix-99.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-add-kpageidle-file-fix-99.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-add-kpageidle-file-fix-99.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kpageidle: decouple from page-flags rework

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/page-flags.h~proc-add-kpageidle-file-fix-99 include/linux/page-flags.h
--- a/include/linux/page-flags.h~proc-add-kpageidle-file-fix-99
+++ a/include/linux/page-flags.h
@@ -294,10 +294,10 @@ PAGEFLAG_FALSE(HWPoison)
 #endif
 
 #if defined(CONFIG_IDLE_PAGE_TRACKING) && defined(CONFIG_64BIT)
-TESTPAGEFLAG(Young, young, PF_ANY)
-SETPAGEFLAG(Young, young, PF_ANY)
-TESTCLEARFLAG(Young, young, PF_ANY)
-PAGEFLAG(Idle, idle, PF_ANY)
+TESTPAGEFLAG(Young, young)
+SETPAGEFLAG(Young, young)
+TESTCLEARFLAG(Young, young)
+PAGEFLAG(Idle, idle)
 #endif
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

proc-add-kpageidle-file-fix-6-fix.patch
proc-add-kpageidle-file-fix-6-fix-2-fix.patch
proc-add-kpageidle-file-fix-99.patch
proc-export-idle-flag-via-kpageflags-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
fs-coda-fix-readlink-buffer-overflow-checkpatch-fixes.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix.patch
kexec-split-kexec_file-syscall-code-to-kexec_filec-fix-2-fix-fix.patch
kexec-split-kexec_load-syscall-from-kexec-core-code-checkpatch-fixes.patch
align-crash_notes-allocation-to-make-it-be-inside-one-physical-page-fix.patch
mm-mpx-add-vm_flags_t-vm_flags-arg-to-do_mmap_pgoff-fix-checkpatch-fixes.patch

