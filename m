From: akpm@linux-foundation.org
Subject: + generic-syscalls-kill-cruft-from-removed-pkey-syscalls.patch
 added to -mm tree
Date: Mon, 17 Oct 2016 16:11:28 -0700
Message-ID: <58055aa0.ELUm0Sh45OqPJnfm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58326 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932614AbcJQXL3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Oct 2016 19:11:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@intel.com, dave.hansen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: generic syscalls: kill cruft from removed pkey syscalls
has been added to the -mm tree.  Its filename is
     generic-syscalls-kill-cruft-from-removed-pkey-syscalls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/generic-syscalls-kill-cruft-from-removed-pkey-syscalls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/generic-syscalls-kill-cruft-from-removed-pkey-syscalls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Hansen <dave.hansen@intel.com>
Subject: generic syscalls: kill cruft from removed pkey syscalls

pkey_set() and pkey_get() were syscalls present in older versions of the
protection keys patches.  They were fully excised from the x86 code, but
some cruft was left in the generic syscall code.  The C++ comments were
intended to help to make it more glaring to me to fix them before actually
submitting them.  That technique worked, but later than I would have
liked.

I test-compiled this for arm64.

Fixes: a60f7b69d92c0 ("generic syscalls: Wire up memory protection keys syscalls")
Link: http://lkml.kernel.org/r/20161017151814.1CE8B6C3@viggo.jf.intel.com
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/syscalls.h          |    3 ---
 include/uapi/asm-generic/unistd.h |    4 ----
 2 files changed, 7 deletions(-)

diff -puN include/linux/syscalls.h~generic-syscalls-kill-cruft-from-removed-pkey-syscalls include/linux/syscalls.h
--- a/include/linux/syscalls.h~generic-syscalls-kill-cruft-from-removed-pkey-syscalls
+++ a/include/linux/syscalls.h
@@ -902,8 +902,5 @@ asmlinkage long sys_pkey_mprotect(unsign
 				  unsigned long prot, int pkey);
 asmlinkage long sys_pkey_alloc(unsigned long flags, unsigned long init_val);
 asmlinkage long sys_pkey_free(int pkey);
-//asmlinkage long sys_pkey_get(int pkey, unsigned long flags);
-//asmlinkage long sys_pkey_set(int pkey, unsigned long access_rights,
-//			     unsigned long flags);
 
 #endif
diff -puN include/uapi/asm-generic/unistd.h~generic-syscalls-kill-cruft-from-removed-pkey-syscalls include/uapi/asm-generic/unistd.h
--- a/include/uapi/asm-generic/unistd.h~generic-syscalls-kill-cruft-from-removed-pkey-syscalls
+++ a/include/uapi/asm-generic/unistd.h
@@ -730,10 +730,6 @@ __SYSCALL(__NR_pkey_mprotect, sys_pkey_m
 __SYSCALL(__NR_pkey_alloc,    sys_pkey_alloc)
 #define __NR_pkey_free 290
 __SYSCALL(__NR_pkey_free,     sys_pkey_free)
-#define __NR_pkey_get 291
-//__SYSCALL(__NR_pkey_get,      sys_pkey_get)
-#define __NR_pkey_set 292
-//__SYSCALL(__NR_pkey_set,      sys_pkey_set)
 
 #undef __NR_syscalls
 #define __NR_syscalls 291
_

Patches currently in -mm which might be from dave.hansen@intel.com are

generic-syscalls-kill-cruft-from-removed-pkey-syscalls.patch

