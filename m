From: akpm@linux-foundation.org
Subject: + kexec-jump-check-code-size-in-control-page-fix-2.patch added to -mm tree
Date: Tue, 12 Aug 2008 20:03:24 -0700
Message-ID: <200808130303.m7D33OgO027586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751928AbYHMDEF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 23:04:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, ebiederm@xmission.com, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, vgoyal@redhat.com


The patch titled
     kexec jump: fix code size checking
has been added to the -mm tree.  Its filename is
     kexec-jump-check-code-size-in-control-page-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec jump: fix code size checking
From: Huang Ying <ying.huang@intel.com>

Fix building issue when CONFIG_KEXEC=n.  Thanks to Vivek Goyal for his
reminding.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/kexec.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/asm-x86/kexec.h~kexec-jump-check-code-size-in-control-page-fix-2 include/asm-x86/kexec.h
--- a/include/asm-x86/kexec.h~kexec-jump-check-code-size-in-control-page-fix-2
+++ a/include/asm-x86/kexec.h
@@ -43,6 +43,9 @@
 
 #ifdef CONFIG_X86_32
 # define KEXEC_CONTROL_CODE_MAX_SIZE	2048
+# ifndef CONFIG_KEXEC
+#  define kexec_control_code_size	0
+# endif
 #endif
 
 #ifndef __ASSEMBLY__
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch
kexec-jump-clean-up-ifdef-and-comments.patch
kexec-jump-rename-kexec_control_code_size-to-kexec_control_page_size.patch
kexec-jump-check-code-size-in-control-page.patch
kexec-jump-check-code-size-in-control-page-fix-2.patch
kexec-jump-remove-duplication-of-kexec_restart_prepare.patch
kexec-jump-in-sync-with-hibernation-implementation.patch
kexec-jump-__ftrace_enabled_save-restore.patch
kexec-jump-fix-for-ftrace.patch

