From: akpm@linux-foundation.org
Subject: [merged] fix-a-misaligned-load-inside-ptrace_attach.patch removed from -mm tree
Date: Mon, 11 May 2015 10:58:29 -0700
Message-ID: <5550edc5.eXvWP728TNV+HFH1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36720 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbbEKR6a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 May 2015 13:58:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: palmer@dabbelt.com, bobby.prani@gmail.com, cmetcalf@ezchip.com, oleg@redhat.com, paulmck@linux.vnet.ibm.com, peterz@infradead.org, richard@nod.at, vdavydov@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/sched.h: fix a misaligned load inside ptrace_attach()
has been removed from the -mm tree.  Its filename was
     fix-a-misaligned-load-inside-ptrace_attach.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch

