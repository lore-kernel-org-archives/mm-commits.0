From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
Date: Mon, 13 Apr 2009 10:27:49 -0700
Message-ID: <20090413102749.4ca3a217.akpm@linux-foundation.org>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org>
	<4609.1239456126@turing-police.cc.vt.edu>
	<alpine.LFD.2.00.0904130847500.4583@localhost.localdomain>
	<20090413171853.GA4601@elte.hu>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750713AbZDMReS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Apr 2009 13:34:18 -0400
In-Reply-To: <20090413171853.GA4601@elte.hu>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Valdis.Kletnieks@vt.edu, Mike Travis <travis@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mm-commits@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>, Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>

On Mon, 13 Apr 2009 19:18:53 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > So I do think Andrew's commit is broken and we should think about 
> > it a bit more, but I also think that Valdis' problem comes from 
> > acpi-cpufreq just being damn stupid. Doing a 
> > smp_call_function_single() to read two MSR's is going to be a 
> > _lot_ more efficient than doing that crazy work_on_cpu() for that.
> > 
> > So the _real_ problem came through the commits like
> > 
> >     cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
> >     cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs
> > 
> > that were meant to reduce stack usage with big cpu masks. And 
> > sure, the _old_ way of doing it was also stupid (it rescheduled 
> > the process to the other CPU by using cpus_allowed()).
> > 
> > Mike, Ingo?
> 
> I think Andrew has a stack of fixes queued up, one of which should 
> solve this problem too - which Mike tested - as the commit from 
> Andrew has caused another regression as well.
> 
> There's no sha1 - the patch is in this thread on lkml:
> 
>   sysbench(oltp)+mysql 10% regression with 2.6.30-rc1
> 
> | From: Andrew Morton <akpm@linux-foundation.org>
> |
> | Atttempting to rid us of the problematic work_on_cpu().  Just use
> | smp_call_fuction_single() here.
> |
> | This repairs a 10% sysbench(oltp)+mysql regression which Mike 
> | reported,
> 

Yup.  It's presently in Len's hands.  And Rusty's.

Vladis, perhaps you can verify?


From: Andrew Morton <akpm@linux-foundation.org>

Atttempting to rid us of the problematic work_on_cpu().  Just use
smp_call_fuction_single() here.

This repairs a 10% sysbench(oltp)+mysql regression which Mike reported,
due to 

commit 6b44003e5ca66a3fffeb5bc90f40ada2c4340896
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Thu Apr 9 09:50:37 2009 -0600

    work_on_cpu(): rewrite it to create a kernel thread on demand

It seems that the kernel calls these acpi-cpufreq functions at a quite
high frequency.

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Mike Galbraith <efault@gmx.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   25 ++++++++-----------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-using-work_on_cpu
+++ a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -153,7 +153,8 @@ struct drv_cmd {
 	u32 val;
 };
 
-static long do_drv_read(void *_cmd)
+/* Called via smp_call_function_single(), on the target CPU */
+static void do_drv_read(void *_cmd)
 {
 	struct drv_cmd *cmd = _cmd;
 	u32 h;
@@ -170,10 +171,10 @@ static long do_drv_read(void *_cmd)
 	default:
 		break;
 	}
-	return 0;
 }
 
-static long do_drv_write(void *_cmd)
+/* Called via smp_call_function_single(), on the target CPU */
+static void do_drv_write(void *_cmd)
 {
 	struct drv_cmd *cmd = _cmd;
 	u32 lo, hi;
@@ -192,23 +193,21 @@ static long do_drv_write(void *_cmd)
 	default:
 		break;
 	}
-	return 0;
 }
 
 static void drv_read(struct drv_cmd *cmd)
 {
 	cmd->val = 0;
 
-	work_on_cpu(cpumask_any(cmd->mask), do_drv_read, cmd);
+	smp_call_function_single(cpumask_any(cmd->mask), do_drv_read, cmd, 1);
 }
 
 static void drv_write(struct drv_cmd *cmd)
 {
-	unsigned int i;
+	unsigned int cpu;
 
-	for_each_cpu(i, cmd->mask) {
-		work_on_cpu(i, do_drv_write, cmd);
-	}
+	for_each_cpu(cpu, cmd->mask)
+		smp_call_function_single(cpu, do_drv_write, cmd, 1);
 }
 
 static u32 get_cur_val(const struct cpumask *mask)
@@ -252,15 +251,13 @@ struct perf_pair {
 	} aperf, mperf;
 };
 
-
-static long read_measured_perf_ctrs(void *_cur)
+/* Called via smp_call_function_single(), on the target CPU */
+static void read_measured_perf_ctrs(void *_cur)
 {
 	struct perf_pair *cur = _cur;
 
 	rdmsr(MSR_IA32_APERF, cur->aperf.split.lo, cur->aperf.split.hi);
 	rdmsr(MSR_IA32_MPERF, cur->mperf.split.lo, cur->mperf.split.hi);
