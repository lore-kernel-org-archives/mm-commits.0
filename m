From: akpm@linux-foundation.org
Subject: + x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:21:54 -0800
Message-ID: <200702251221.l1PCLuRL029195@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34383 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964842AbXBYMXW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:23:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: blaisorblade@yahoo.it, ak@suse.de, stable@kernel.org


The patch titled
     x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted
has been added to the -mm tree.  Its filename is
     x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>

Also PTRACE_OLDSETOPTIONS should be accepted, as done by kernel/ptrace.c
and forced by binary compatibility.  UML/32bit breaks because of this -
since it is wise enough to use PTRACE_OLDSETOPTIONS to be binary compatible
with 2.4 host kernels.

Until 2.6.17 (commit f0f2d6536e3515b5b1b7ae97dc8f176860c8c2ce) we had:

       default:
                return sys_ptrace(request, pid, addr, data);

Instead here we have:
        case PTRACE_GET_THREAD_AREA:
	case ...:
                return sys_ptrace(request, pid, addr, data);

        default:
                return -EINVAL;

This change was a style change - when a case is added, it must be
explicitly tested this way.  In this case, not enough testing was done.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ptrace32.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86_64/ia32/ptrace32.c~x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted arch/x86_64/ia32/ptrace32.c
--- a/arch/x86_64/ia32/ptrace32.c~x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted
+++ a/arch/x86_64/ia32/ptrace32.c
@@ -243,6 +243,7 @@ asmlinkage long sys32_ptrace(long reques
 	case PTRACE_SINGLESTEP:
 	case PTRACE_DETACH:
 	case PTRACE_SYSCALL:
+	case PTRACE_OLDSETOPTIONS:
 	case PTRACE_SETOPTIONS:
 	case PTRACE_SET_THREAD_AREA:
 	case PTRACE_GET_THREAD_AREA:
_

Patches currently in -mm which might be from blaisorblade@yahoo.it are

x86_64-fix-2618-regression-ptrace_oldsetoptions-should-be-accepted.patch
uml-enable-raw.patch
uml-host-vdso-fix.patch
uml-pte_mkread-fix.patch
uml-delete-unused-code.patch
uml-formatting-fixes.patch
uml-host_info-tidying.patch
uml-fix-prototypes.patch
git-gccbug.patch
