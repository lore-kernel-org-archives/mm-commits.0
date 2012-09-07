From: akpm@linux-foundation.org
Subject: + checksyscalls-ignore-kcmp-system-call.patch added to -mm tree
Date: Fri, 07 Sep 2012 14:46:31 -0700
Message-ID: <20120907214632.7D43B2000BE@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:43123 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab2IGVqe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Sep 2012 17:46:34 -0400
Received: by fass10 with SMTP id s10so2059fas.1
        for <mm-commits@vger.kernel.org>; Fri, 07 Sep 2012 14:46:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heiko.carstens@de.ibm.com, gorcunov@openvz.org, hpa@linux.intel.com, mmarek@suse.cz


The patch titled
     Subject: checksyscalls: ignore kcmp system call
has been added to the -mm tree.  Its filename is
     checksyscalls-ignore-kcmp-system-call.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: checksyscalls: ignore kcmp system call

Now that the checksyscalls script works again it will warn about the
missing "kcmp" system call on all architectures but x86.

Since according to d97b46a6 ("syscalls, x86: add __NR_kcmp syscall") only
x86 is currently supported don't emit any warning for this system call.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checksyscalls.sh |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/checksyscalls.sh~checksyscalls-ignore-kcmp-system-call scripts/checksyscalls.sh
--- a/scripts/checksyscalls.sh~checksyscalls-ignore-kcmp-system-call
+++ a/scripts/checksyscalls.sh
@@ -194,6 +194,9 @@ cat << EOF
 #define __IGNORE_getpmsg
 #define __IGNORE_putpmsg
 #define __IGNORE_vserver
+
+/* kcmp is currently x86 only */
+#define __IGNORE_kcmp
 EOF
 }
 
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

linux-next.patch
checksyscalls-fix-here-document-handling.patch
checksyscalls-ignore-kcmp-system-call.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

