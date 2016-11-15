From: akpm@linux-foundation.org
Subject: +
 mm-pkeys-generate-pkey-system-call-code-only-if-arch_has_pkeys-is-selected.patch added to -mm tree
Date: Mon, 14 Nov 2016 16:21:36 -0800
Message-ID: <582a5510.Ii9Rcr/HMVx0c2sM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755153AbcKOAVh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Nov 2016 19:21:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, dave.hansen@linux.intel.com, mark.rutland@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/pkeys: generate pkey system call code only if ARCH_HAS_PKEYS is selected
has been added to the -mm tree.  Its filename is
     mm-pkeys-generate-pkey-system-call-code-only-if-arch_has_pkeys-is-selected.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-pkeys-generate-pkey-system-call-code-only-if-arch_has_pkeys-is-selected.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-pkeys-generate-pkey-system-call-code-only-if-arch_has_pkeys-is-selected.patch

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
Subject: mm/pkeys: generate pkey system call code only if ARCH_HAS_PKEYS is selected

Having code for the pkey_mprotect, pkey_alloc and pkey_free system calls
makes only sense if ARCH_HAS_PKEYS is selected.  If not selected these
system calls will always return -ENOSPC or -EINVAL.

To simplify things and have less code generate the pkey system call code
only if ARCH_HAS_PKEYS is selected.

For architectures which have already wired up the system calls, but do not
select ARCH_HAS_PKEYS this will result in less generated code and a
different return code: the three system calls will now always return
-ENOSYS, using the cond_syscall mechanism.

For architectures which have not wired up the system calls less
unreachable code will be generated.

Link: http://lkml.kernel.org/r/20161114111251.70084-1-heiko.carstens@de.ibm.com
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/mprotect.c~mm-pkeys-generate-pkey-system-call-code-only-if-arch_has_pkeys-is-selected mm/mprotect.c
--- a/mm/mprotect.c~mm-pkeys-generate-pkey-system-call-code-only-if-arch_has_pkeys-is-selected
+++ a/mm/mprotect.c
@@ -497,6 +497,8 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 	return do_mprotect_pkey(start, len, prot, -1);
 }
 
+#ifdef CONFIG_ARCH_HAS_PKEYS
+
 SYSCALL_DEFINE4(pkey_mprotect, unsigned long, start, size_t, len,
 		unsigned long, prot, int, pkey)
 {
@@ -547,3 +549,5 @@ SYSCALL_DEFINE1(pkey_free, int, pkey)
 	 */
 	return ret;
 }
+
+#endif /* CONFIG_ARCH_HAS_PKEYS */
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

mm-pkeys-generate-pkey-system-call-code-only-if-arch_has_pkeys-is-selected.patch

