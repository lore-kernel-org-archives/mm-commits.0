From: akpm@linux-foundation.org
Subject: + kick-cpus-that-might-be-sleeping-in-cpus_idle_wait.patch added to -mm tree
Date: Wed, 09 Jan 2008 17:00:53 -0800
Message-ID: <200801100100.m0A10sAx030186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59071 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754266AbYAJBCo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Jan 2008 20:02:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, ak@suse.de, lenb@kernel.org, mingo@elte.hu, srostedt@redhat.com, tglx@linutronix.de, venkatesh.pallipadi@intel.com


The patch titled
     Kick CPUS that might be sleeping in cpus_idle_wait
has been added to the -mm tree.  Its filename is
     kick-cpus-that-might-be-sleeping-in-cpus_idle_wait.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Kick CPUS that might be sleeping in cpus_idle_wait
From: Steven Rostedt <rostedt@goodmis.org>

Sometimes cpu_idle_wait gets stuck because it might miss CPUS that are
already in idle, have no tasks waiting to run and have no interrupts going
to them.  This is common on bootup when switching cpu idle governors.

This patch gives those CPUS that don't check in an IPI kick.

Background:
-----------
I notice this while developing the mcount patches, that every once in a
while the system would hang. Looking deeper, the hang was always at boot
up when registering init_menu of the cpu_idle menu governor. Talking
with Thomas Gliexner, we discovered that one of the CPUS had no timer
events scheduled for it and it was in idle (running with NO_HZ). So the
CPU would not set the cpu_idle_state bit.

Hitting sysrq-t a few times would eventually route the interrupt to the
stuck CPU and the system would continue.

Note, I would have used the PDA isidle but that is set after the
cpu_idle_state bit is cleared, and would leave a window open where we
may miss being kicked.

hmm, looking closer at this, we still have a small race window between
clearing the cpu_idle_state and disabling interrupts (hence the RFC).

    CPU0:                          CPU 1:
  ---------                       ---------
 cpu_idle_wait():                 cpu_idle():
      |                           __cpu_cpu_var(is_idle) = 1;
      |                           if (__get_cpu_var(cpu_idle_state)) /* == 0 */
 per_cpu(cpu_idle_state, 1) = 1;         |
 if (per_cpu(is_idle, 1)) /* == 1 */     |
 smp_call_function(1)                    |
      |                             receives ipi and runs do_nothing.
 wait on map == empty               idle();
   /* waits forever */


So really we need interrupts off for most of this then. One might think
that we could simply clear the cpu_idle_state from do_nothing, but I'm
assuming that cpu_idle governors can be removed, and this might cause a
race that a governor might be used after the module was removed.


Venki said:

  I think your RFC patch is the right solution here.  As I see it, there is
  no race with your RFC patch.  As long as you call a dummy smp_call_function
  on all CPUs, we should be OK.  We can get rid of cpu_idle_state and the
  current wait forever logic altogether with dummy smp_call_function.  And so
  there wont be any wait forever scenario.

  The whole point of cpu_idle_wait() is to make all CPUs come out of idle
  loop atleast once.  The caller will use cpu_idle_wait something like this.

  // Want to change idle handler

  - Switch global idle handler to always present default_idle

  - call cpu_idle_wait so that all cpus come out of idle for an instant
    and stop using old idle pointer and start using default idle

  - Change the idle handler to a new handler

  - optional cpu_idle_wait if you want all cpus to start using the new
    handler immediately.

Maybe the below 1s patch is safe bet for .24.  But for .25, I would say we
just replace all complicated logic by simple dummy smp_call_function and
remove cpu_idle_state altogether.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/process_32.c |   11 +++++++++++
 arch/x86/kernel/process_64.c |   11 +++++++++++
 2 files changed, 22 insertions(+)

diff -puN arch/x86/kernel/process_32.c~kick-cpus-that-might-be-sleeping-in-cpus_idle_wait arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~kick-cpus-that-might-be-sleeping-in-cpus_idle_wait
+++ a/arch/x86/kernel/process_32.c
@@ -204,6 +204,10 @@ void cpu_idle(void)
 	}
 }
 
+static void do_nothing(void *unused)
+{
+}
+
 void cpu_idle_wait(void)
 {
 	unsigned int cpu, this_cpu = get_cpu();
@@ -228,6 +232,13 @@ void cpu_idle_wait(void)
 				cpu_clear(cpu, map);
 		}
 		cpus_and(map, map, cpu_online_map);
+		/*
+		 * We waited 1 sec, if a CPU still did not call idle
+		 * it may be because it is in idle and not waking up
+		 * because it has nothing to do.
+		 * Give all the remaining CPUS a kick.
+		 */
+		smp_call_function_mask(map, do_nothing, 0, 0);
 	} while (!cpus_empty(map));
 
 	set_cpus_allowed(current, tmp);
diff -puN arch/x86/kernel/process_64.c~kick-cpus-that-might-be-sleeping-in-cpus_idle_wait arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~kick-cpus-that-might-be-sleeping-in-cpus_idle_wait
+++ a/arch/x86/kernel/process_64.c
@@ -135,6 +135,10 @@ static void poll_idle (void)
 	cpu_relax();
 }
 
+static void do_nothing(void *unused)
+{
+}
+
 void cpu_idle_wait(void)
 {
 	unsigned int cpu, this_cpu = get_cpu();
@@ -160,6 +164,13 @@ void cpu_idle_wait(void)
 				cpu_clear(cpu, map);
 		}
 		cpus_and(map, map, cpu_online_map);
+		/*
+		 * We waited 1 sec, if a CPU still did not call idle
+		 * it may be because it is in idle and not waking up
+		 * because it has nothing to do.
+		 * Give all the remaining CPUS a kick.
+		 */
+		smp_call_function_mask(map, do_nothing, 0, 0);
 	} while (!cpus_empty(map));
 
 	set_cpus_allowed(current, tmp);
_

Patches currently in -mm which might be from rostedt@goodmis.org are

kick-cpus-that-might-be-sleeping-in-cpus_idle_wait.patch
git-sched.patch
git-x86.patch
