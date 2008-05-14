From: akpm@linux-foundation.org
Subject: + x86-use-explicit-copy-in-vdso_gettimeofday.patch added to -mm tree
Date: Wed, 14 May 2008 10:19:30 -0700
Message-ID: <200805141719.m4EHJUGr011926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57202 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852AbYENRUX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 May 2008 13:20:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, jeremy@goop.org, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: use explicit copy in vdso_gettimeofday()
has been added to the -mm tree.  Its filename is
     x86-use-explicit-copy-in-vdso_gettimeofday.patch

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
Subject: x86: use explicit copy in vdso_gettimeofday()
From: Andi Kleen <andi@firstfloor.org>

Jeremy's gcc 3.4 seems to be unable to inline a 8 byte memcpy.  But the
vdso doesn't support external references.  Copy the structure members
of struct timezone explicitely instead.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/vdso/vclock_gettime.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/vdso/vclock_gettime.c~x86-use-explicit-copy-in-vdso_gettimeofday arch/x86/vdso/vclock_gettime.c
--- a/arch/x86/vdso/vclock_gettime.c~x86-use-explicit-copy-in-vdso_gettimeofday
+++ a/arch/x86/vdso/vclock_gettime.c
@@ -107,9 +107,9 @@ notrace int __vdso_gettimeofday(struct t
 		do_realtime((struct timespec *)tv);
 		tv->tv_usec /= 1000;
 		if (unlikely(tz != NULL)) {
-			/* This relies on gcc inlining the memcpy. We'll notice
-			   if it ever fails to do so. */
-			memcpy(tz, &gtod->sys_tz, sizeof(struct timezone));
+			/* Avoid memcpy. Some old compilers fail to inline it */
+			tz->tz_minuteswest = gtod->sys_tz.tz_minuteswest;
+			tz->tz_dsttime = gtod->sys_tz.tz_dsttime;
 		}
 		return 0;
 	}
_

Patches currently in -mm which might be from andi@firstfloor.org are

linux-next.patch
x86-use-explicit-copy-in-vdso_gettimeofday.patch
bkl-removal-convert-cifs-over-to-unlocked_ioctl.patch
git-kbuild-fixes.patch
profile-likely-unlikely-macros.patch

