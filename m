From: akpm@linux-foundation.org
Subject: + add-compile-time-check-for-__arch_si_preamble_size-fix.patch
 added to -mm tree
Date: Fri, 26 Feb 2016 13:33:57 -0800
Message-ID: <56d0c4c5.p2t7Y8uEJhaPZ9dv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbcBZVd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Feb 2016 16:33:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, dave.hansen@linux.intel.com, deller@gmx.de, hpa@zytor.com, mingo@elte.hu, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: signals, pkeys: make si_pkey 32 bits for now
has been added to the -mm tree.  Its filename is
     add-compile-time-check-for-__arch_si_preamble_size-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/add-compile-time-check-for-__arch_si_preamble_size-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/add-compile-time-check-for-__arch_si_preamble_size-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: signals, pkeys: make si_pkey 32 bits for now

to prevent a change of alignment in the siginfo structure

Fixes: cd0ea35ff551 ("signals, pkeys: Notify userspace about protection key faults")
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Helge Deller <deller@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/include/uapi/asm/siginfo.h |    2 +-
 arch/mips/include/uapi/asm/siginfo.h |    2 +-
 include/uapi/asm-generic/siginfo.h   |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/ia64/include/uapi/asm/siginfo.h~add-compile-time-check-for-__arch_si_preamble_size-fix arch/ia64/include/uapi/asm/siginfo.h
--- a/arch/ia64/include/uapi/asm/siginfo.h~add-compile-time-check-for-__arch_si_preamble_size-fix
+++ a/arch/ia64/include/uapi/asm/siginfo.h
@@ -70,7 +70,7 @@ typedef struct siginfo {
 					void __user *_upper;
 				} _addr_bnd;
 				/* used when si_code=SEGV_PKUERR */
-				u64 _pkey;
+				int _pkey;
 			};
 		} _sigfault;
 
diff -puN arch/mips/include/uapi/asm/siginfo.h~add-compile-time-check-for-__arch_si_preamble_size-fix arch/mips/include/uapi/asm/siginfo.h
--- a/arch/mips/include/uapi/asm/siginfo.h~add-compile-time-check-for-__arch_si_preamble_size-fix
+++ a/arch/mips/include/uapi/asm/siginfo.h
@@ -93,7 +93,7 @@ typedef struct siginfo {
 					void __user *_upper;
 				} _addr_bnd;
 				/* used when si_code=SEGV_PKUERR */
-				u64 _pkey;
+				int _pkey;
 			};
 		} _sigfault;
 
diff -puN include/uapi/asm-generic/siginfo.h~add-compile-time-check-for-__arch_si_preamble_size-fix include/uapi/asm-generic/siginfo.h
--- a/include/uapi/asm-generic/siginfo.h~add-compile-time-check-for-__arch_si_preamble_size-fix
+++ a/include/uapi/asm-generic/siginfo.h
@@ -98,7 +98,7 @@ typedef struct siginfo {
 					void __user *_upper;
 				} _addr_bnd;
 				/* used when si_code=SEGV_PKUERR */
-				u64 _pkey;
+				int _pkey;
 			};
 		} _sigfault;
 
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

add-compile-time-check-for-__arch_si_preamble_size-fix.patch

