From: akpm@linux-foundation.org
Subject: +
 coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch added to
 -mm tree
Date: Tue, 19 Nov 2013 14:22:12 -0800
Message-ID: <528be494.ZwQgWnB/WhoLVzkE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab3KSWWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 17:22:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, segoon@openwall.com, pmatouse@redhat.com, keescook@chromium.org, josh@joshtriplett.org, ebiederm@xmission.com, alex.page.kelly@gmail.com, oleg@redhat.com

Subject: + coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch added to -mm tree
To: oleg@redhat.com,alex.page.kelly@gmail.com,ebiederm@xmission.com,josh@joshtriplett.org,keescook@chromium.org,pmatouse@redhat.com,segoon@openwall.com
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 14:22:12 -0800


The patch titled
     Subject: coredump: set_dumpable: fix the theoretical race with itself
has been added to the -mm tree.  Its filename is
     coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: coredump: set_dumpable: fix the theoretical race with itself

set_dumpable() updates MMF_DUMPABLE_MASK in a non-trivial way to ensure
that get_dumpable() can't observe the intermediate state, but this all
can't help if multiple threads call set_dumpable() at the same time.

And in theory commit_creds()->set_dumpable(SUID_DUMP_ROOT) racing with
sys_prctl()->set_dumpable(SUID_DUMP_DISABLE) can result in SUID_DUMP_USER.

Change this code to update both bits atomically via cmpxchg().

Note: this assumes that it is safe to mix bitops and cmpxchg.  IOW, if,
say, an architecture implements cmpxchg() using the locking (like
arch/parisc/lib/bitops.c does), then it should use the same locks for
set_bit/etc.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Alex Kelly <alex.page.kelly@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Petr Matousek <pmatouse@redhat.com>
Cc: Vasily Kulikov <segoon@openwall.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   49 +++++++++++++++----------------------------------
 1 file changed, 15 insertions(+), 34 deletions(-)

diff -puN fs/exec.c~coredump-set_dumpable-fix-the-theoretical-race-with-itself fs/exec.c
--- a/fs/exec.c~coredump-set_dumpable-fix-the-theoretical-race-with-itself
+++ a/fs/exec.c
@@ -1617,43 +1617,24 @@ EXPORT_SYMBOL(set_binfmt);
 
 /*
  * set_dumpable converts traditional three-value dumpable to two flags and
- * stores them into mm->flags.  It modifies lower two bits of mm->flags, but
- * these bits are not changed atomically.  So get_dumpable can observe the
- * intermediate state.  To avoid doing unexpected behavior, get get_dumpable
- * return either old dumpable or new one by paying attention to the order of
- * modifying the bits.
- *
- * dumpable |   mm->flags (binary)
- * old  new | initial interim  final
- * ---------+-----------------------
- *  0    1  |   00      01      01
- *  0    2  |   00      10(*)   11
- *  1    0  |   01      00      00
- *  1    2  |   01      11      11
- *  2    0  |   11      10(*)   00
- *  2    1  |   11      11      01
- *
- * (*) get_dumpable regards interim value of 10 as 11.
+ * stores them into mm->flags.
  */
 void set_dumpable(struct mm_struct *mm, int value)
 {
-	switch (value) {
-	case SUID_DUMP_DISABLE:
-		clear_bit(MMF_DUMPABLE, &mm->flags);
-		smp_wmb();
-		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
-		break;
-	case SUID_DUMP_USER:
-		set_bit(MMF_DUMPABLE, &mm->flags);
-		smp_wmb();
-		clear_bit(MMF_DUMP_SECURELY, &mm->flags);
-		break;
-	case SUID_DUMP_ROOT:
-		set_bit(MMF_DUMP_SECURELY, &mm->flags);
-		smp_wmb();
-		set_bit(MMF_DUMPABLE, &mm->flags);
-		break;
-	}
+	unsigned long old, new;
+
+	do {
+		old = ACCESS_ONCE(mm->flags);
+		new = old & ~MMF_DUMPABLE_MASK;
+
+		switch (value) {
+		case SUID_DUMP_ROOT:
+			new |= (1 << MMF_DUMP_SECURELY);
+		case SUID_DUMP_USER:
+			new |= (1<< MMF_DUMPABLE);
+		}
+
+	} while (cmpxchg(&mm->flags, old, new) != old);
 }
 
 int __get_dumpable(unsigned long mm_flags)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
coredump-set_dumpable-fix-the-theoretical-race-with-itself.patch
coredump-kill-mmf_dumpable-and-mmf_dump_securely.patch
coredump-make-__get_dumpable-get_dumpable-inline-kill-fs-coredumph.patch
linux-next.patch

