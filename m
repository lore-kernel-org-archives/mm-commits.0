From: akpm@linux-foundation.org
Subject: + ptrace-remove-pt_dtrace-from-arch-h8300.patch added to -mm tree
Date: Thu, 23 Apr 2009 17:01:45 -0700
Message-ID: <200904240001.n3O01jdD004618@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbZDXAFO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 20:05:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com, ysato@users.sourceforge.jp


The patch titled
     ptrace: remove PT_DTRACE from arch/h8300
has been added to the -mm tree.  Its filename is
     ptrace-remove-pt_dtrace-from-arch-h8300.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: remove PT_DTRACE from arch/h8300
From: Oleg Nesterov <oleg@redhat.com>

h8300 defines PT_DTRACE for asm but never uses it.

DEFINE(PT_PTRACED, PT_PTRACED) seems to be unused too.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/kernel/asm-offsets.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/h8300/kernel/asm-offsets.c~ptrace-remove-pt_dtrace-from-arch-h8300 arch/h8300/kernel/asm-offsets.c
--- a/arch/h8300/kernel/asm-offsets.c~ptrace-remove-pt_dtrace-from-arch-h8300
+++ a/arch/h8300/kernel/asm-offsets.c
@@ -55,7 +55,6 @@ int main(void)
 	DEFINE(LRET,  offsetof(struct pt_regs, pc)       - sizeof(long));
 
 	DEFINE(PT_PTRACED, PT_PTRACED);
-	DEFINE(PT_DTRACE, PT_DTRACE);
 
 	return 0;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

