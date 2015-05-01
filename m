From: akpm@linux-foundation.org
Subject: + fix-a-misaligned-load-inside-ptrace_attach.patch added to -mm
 tree
Date: Fri, 01 May 2015 15:40:05 -0700
Message-ID: <554400c5.wq4NYgSDpeVt9Ehd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbbEAWkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2015 18:40:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: palmer@dabbelt.com, bobby.prani@gmail.com, cmetcalf@ezchip.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, richard@nod.at, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/sched.h: fix a misaligned load inside ptrace_attach()
has been added to the -mm tree.  Its filename is
     fix-a-misaligned-load-inside-ptrace_attach.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fix-a-misaligned-load-inside-ptrace_attach.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fix-a-misaligned-load-inside-ptrace_attach.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Palmer Dabbelt <palmer@dabbelt.com>
Subject: include/linux/sched.h: fix a misaligned load inside ptrace_attach()

I ran across what I believe is a bug in some asm-generic code while
working on the RISC-V Linux port.  Essentially the problem is that
wait_on_bit() takes a void *, but then perfroms long-aligned operation. 
As far as I can tell, this bug could manifest on any other architecture
that doesn't support misaligned operations and uses this particular
asm-generic implementation.

The patch set is split into three parts:

* #1 fixes the bug by making task_struct.jobctl an unsigned long,
   which ensures wait_on_bit() always ends up with a long-aligned
   argument.

* #2 changes the prototype of wait_on_bit() and friends to take a
   "unsigned long *" instead of a "void *", with the intent of
   ensuring these problems don't happen again.

* #3 is a bit more intrusive: it goes and changes all uses of
   task_struct.jobctl from int to long.

I'm not sure if #3 has gone too far, but I think #1 and #2 are sane.  The
cost is making task_struct larger on machines where
sizeof(long)>sizeof(int), but since it's so big already this isn't too
much cost.  I thought about making test_bit() perform byte-aligned
accesses to avoid this cost, but since there are very similar looking
atomic functions I thought that would be too odd.


This patch (of 3):

The misaligned load exception arises when running ptrace_attach() on the
RISC-V (which hasn't been upstreamed yet).  The problem is that
wait_on_bit() takes a void* but then proceeds to call test_bit(), which
takes a long*.  This allows an int-aligned pointer to be passed to
test_bit(), which promptly fails.  This will manifest on any other
asm-generic port where unaligned loads trap, where sizeof(long) >
sizeof(int), and where task_struct.jobctl ends up not being long-aligned.

This patch changes task_struct.jobctl to be a long, which ensures it
has the correct alignment.

Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Reviewed-by: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Pranith Kumar <bobby.prani@gmail.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/sched.h~fix-a-misaligned-load-inside-ptrace_attach include/linux/sched.h
--- a/include/linux/sched.h~fix-a-misaligned-load-inside-ptrace_attach
+++ a/include/linux/sched.h
@@ -1369,7 +1369,7 @@ struct task_struct {
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
-	unsigned int jobctl;	/* JOBCTL_*, siglock protected */
+	unsigned long jobctl;	/* JOBCTL_*, siglock protected */
 
 	/* Used for emulating ABI behavior of previous Linux versions */
 	unsigned int personality;
_

Patches currently in -mm which might be from palmer@dabbelt.com are

fix-a-misaligned-load-inside-ptrace_attach.patch
change-wait_on_bit-to-take-an-unsigned-long-not-a-void.patch
change-all-uses-of-jobctl_-from-int-to-long.patch

