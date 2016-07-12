From: akpm@linux-foundation.org
Subject: + module-do-a-warn_on_once-for-assert-module-mutex-not-held.patch added to -mm tree
Date: Tue, 12 Jul 2016 13:31:37 -0700
Message-ID: <578553a9.rxKOudOBOCzwD71B%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784AbcGLUbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Jul 2016 16:31:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/module.c: do a WARN_ON_ONCE() for assert module mutex not held
has been added to the -mm tree.  Its filename is
     module-do-a-warn_on_once-for-assert-module-mutex-not-held.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/module-do-a-warn_on_once-for-assert-module-mutex-not-held.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/module-do-a-warn_on_once-for-assert-module-mutex-not-held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Steven Rostedt <rostedt@goodmis.org>
Subject: kernel/module.c: do a WARN_ON_ONCE() for assert module mutex not held

When running with lockdep enabled, I triggered the WARN_ON() in the module
code that asserts when module_mutex or rcu_read_lock_sched are not held. 
The issue I have is that this can also be called from the dump_stack()
code, causing us to enter an infinite loop...

 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 0 at kernel/module.c:268 module_assert_mutex_or_preempt+0x3c/0x3e
 Modules linked in: ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.7.0-rc3-test-00013-g501c2375253c #14
 Hardware name: MSI MS-7823/CSM-H87M-G43 (MS-7823), BIOS V1.6 02/22/2014
  ffff880215e8fa70 ffff880215e8fa70 ffffffff812fc8e3 0000000000000000
  ffffffff81d3e55b ffff880215e8fac0 ffffffff8104fc88 ffffffff8104fcab
  0000000915e88300 0000000000000046 ffffffffa019b29a 0000000000000001
 Call Trace:
  [<ffffffff812fc8e3>] dump_stack+0x67/0x90
  [<ffffffff8104fc88>] __warn+0xcb/0xe9
  [<ffffffff8104fcab>] ? warn_slowpath_null+0x5/0x1f
 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 0 at kernel/module.c:268 module_assert_mutex_or_preempt+0x3c/0x3e
 Modules linked in: ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.7.0-rc3-test-00013-g501c2375253c #14
 Hardware name: MSI MS-7823/CSM-H87M-G43 (MS-7823), BIOS V1.6 02/22/2014
  ffff880215e8f7a0 ffff880215e8f7a0 ffffffff812fc8e3 0000000000000000
  ffffffff81d3e55b ffff880215e8f7f0 ffffffff8104fc88 ffffffff8104fcab
  0000000915e88300 0000000000000046 ffffffffa019b29a 0000000000000001
 Call Trace:
  [<ffffffff812fc8e3>] dump_stack+0x67/0x90
  [<ffffffff8104fc88>] __warn+0xcb/0xe9
  [<ffffffff8104fcab>] ? warn_slowpath_null+0x5/0x1f
 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 0 at kernel/module.c:268 module_assert_mutex_or_preempt+0x3c/0x3e
 Modules linked in: ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6
 CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.7.0-rc3-test-00013-g501c2375253c #14
 Hardware name: MSI MS-7823/CSM-H87M-G43 (MS-7823), BIOS V1.6 02/22/2014
  ffff880215e8f4d0 ffff880215e8f4d0 ffffffff812fc8e3 0000000000000000
  ffffffff81d3e55b ffff880215e8f520 ffffffff8104fc88 ffffffff8104fcab
  0000000915e88300 0000000000000046 ffffffffa019b29a 0000000000000001
 Call Trace:
  [<ffffffff812fc8e3>] dump_stack+0x67/0x90
  [<ffffffff8104fc88>] __warn+0xcb/0xe9
  [<ffffffff8104fcab>] ? warn_slowpath_null+0x5/0x1f
 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 0 at kernel/module.c:268 module_assert_mutex_or_preempt+0x3c/0x3e
[...]

Which gives us rather useless information.  Worse yet, there's some race
that causes this, and I seldom trigger it, so I have no idea what
happened.

This would not be an issue if that warning was a WARN_ON_ONCE().

Link: http://lkml.kernel.org/r/20160712091550.30ddfff7@gandalf.local.home
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/module.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/module.c~module-do-a-warn_on_once-for-assert-module-mutex-not-held kernel/module.c
--- a/kernel/module.c~module-do-a-warn_on_once-for-assert-module-mutex-not-held
+++ a/kernel/module.c
@@ -264,7 +264,7 @@ static void module_assert_mutex_or_preem
 	if (unlikely(!debug_locks))
 		return;
 
-	WARN_ON(!rcu_read_lock_sched_held() &&
+	WARN_ON_ONCE(!rcu_read_lock_sched_held() &&
 		!lockdep_is_held(&module_mutex));
 #endif
 }
_

Patches currently in -mm which might be from rostedt@goodmis.org are

module-do-a-warn_on_once-for-assert-module-mutex-not-held.patch

