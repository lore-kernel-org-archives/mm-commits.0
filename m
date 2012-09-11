From: akpm@linux-foundation.org
Subject: [nacked] checksyscalls-ignore-kcmp-system-call.patch removed from -mm tree
Date: Tue, 11 Sep 2012 16:16:36 -0700
Message-ID: <20120911231636.F1E671E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:51392 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab2IKXQi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Sep 2012 19:16:38 -0400
Received: by vbis24 with SMTP id s24so123727vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 11 Sep 2012 16:16:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, gorcunov@openvz.org, hpa@linux.intel.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: checksyscalls: ignore kcmp system call
has been removed from the -mm tree.  Its filename was
     checksyscalls-ignore-kcmp-system-call.patch

This patch was dropped because it was nacked

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
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

