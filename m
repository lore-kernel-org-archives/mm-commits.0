From: akpm@linux-foundation.org
Subject: +
 fs-proc-dont-expose-absolute-kernel-addresses-via-wchan-fix.patch added to
 -mm tree
Date: Wed, 30 Sep 2015 14:52:45 -0700
Message-ID: <560c59ad.+Yt2fOPn/IejJltT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51510 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879AbbI3Vwr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Sep 2015 17:52:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, a.p.zijlstra@chello.nl, andreyknvl@google.com, bp@alien8.de, dvlasenk@redhat.com, dvyukov@google.com, efault@gmx.de, glider@google.com, kcc@google.com, luto@kernel.org, mingo@kernel.org, ryabinin.a.a@gmail.com, sasha.levin@oracle.com, tglx@linutronix.de, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs-proc-dont-expose-absolute-kernel-addresses-via-wchan-fix
has been added to the -mm tree.  Its filename is
     fs-proc-dont-expose-absolute-kernel-addresses-via-wchan-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-proc-dont-expose-absolute-kernel-addresses-via-wchan-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-proc-dont-expose-absolute-kernel-addresses-via-wchan-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs-proc-dont-expose-absolute-kernel-addresses-via-wchan-fix

Probably should also update Documentation/filesystems/proc.txt with
something like:

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~fs-proc-dont-expose-absolute-kernel-addresses-via-wchan-fix Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~fs-proc-dont-expose-absolute-kernel-addresses-via-wchan-fix
+++ a/Documentation/filesystems/proc.txt
@@ -312,7 +312,7 @@ Table 1-4: Contents of the stat files (a
   blocked       bitmap of blocked signals
   sigign        bitmap of ignored signals
   sigcatch      bitmap of caught signals
-  wchan         address where process went to sleep
+  0             (place holder, was wchan, see /proc/PID/wchan instead)
   0             (place holder)
   0             (place holder)
   exit_signal   signal to send to parent thread on exit
_

Patches currently in -mm which might be from keescook@chromium.org are

fs-proc-dont-expose-absolute-kernel-addresses-via-wchan-fix.patch

