From: akpm@linux-foundation.org
Subject: [merged] powerpc-use-generic-posix_typesh-fix.patch removed from -mm tree
Date: Mon, 27 Feb 2012 14:29:53 -0800
Message-ID: <20120227222953.7D711A02DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:46454 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab2B0W3y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2012 17:29:54 -0500
Received: by mail-ww0-f74.google.com with SMTP id dt11so67256wgb.1
        for <mm-commits@vger.kernel.org>; Mon, 27 Feb 2012 14:29:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, benh@kernel.crashing.org, hpa@zytor.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc-use-generic-posix_typesh-fix
has been removed from the -mm tree.  Its filename was
     powerpc-use-generic-posix_typesh-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: powerpc-use-generic-posix_typesh-fix

In file included from include/linux/posix_types.h:47:0,
                 from include/linux/types.h:17,
                 from include/linux/page-flags.h:8,
                 from kernel/bounds.c:9:
arch/powerpc/include/asm/posix_types.h:15:14: error: conflicting types for =
'__kernel_size_t'
arch/powerpc/include/asm/posix_types.h:14:22: note: previous declaration of=
 '__kernel_size_t' was here
In file included from include/linux/page-flags.h:8:0,
                 from kernel/bounds.c:9:
include/linux/types.h:68:1: error: unknown type name '__kernel_ssize_t'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/include/asm/posix_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/include/asm/posix_types.h~powerpc-use-generic-posix_typesh-fix arch/powerpc/include/asm/posix_types.h
--- a/arch/powerpc/include/asm/posix_types.h~powerpc-use-generic-posix_typesh-fix
+++ a/arch/powerpc/include/asm/posix_types.h
@@ -12,7 +12,7 @@ typedef unsigned long	__kernel_old_dev_t
 #define __kernel_old_dev_t __kernel_old_dev_t
 #else
 typedef unsigned int	__kernel_size_t;
-typedef int		__kernel_size_t;
+typedef int		__kernel_ssize_t;
 typedef long		__kernel_ptrdiff_t;
 #define __kernel_size_t __kernel_size_t
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

linux-next.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-fix-2.patch

