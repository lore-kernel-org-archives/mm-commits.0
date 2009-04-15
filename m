From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
Date: Wed, 15 Apr 2009 01:34:56 -0700
Message-ID: <20090415013456.cf5ce205.akpm__37517.1668282293$1239785056$gmane$org@linux-foundation.org>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org>
	<4609.1239456126@turing-police.cc.vt.edu>
	<alpine.LFD.2.00.0904130847500.4583@localhost.localdomain>
	<20090413171853.GA4601@elte.hu>
	<20090413102749.4ca3a217.akpm@linux-foundation.org>
	<20090415081534.GA2894@lilem.mirepesht>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752865AbZDOImF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Apr 2009 04:42:05 -0400
In-Reply-To: <20090415081534.GA2894@lilem.mirepesht>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Ali Gholami Rudi <ali@rudi.ir>
Cc: Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@linux-foundation.org>, Valdis.Kletnieks@vt.edu, Mike Travis <travis@sgi.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mm-commits@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>, Dave Jones <davej@redhat.com>, Len Brown <lenb@kernel.org>

On Wed, 15 Apr 2009 12:45:34 +0430 Ali Gholami Rudi <ali@rudi.ir> wrote:

> Hi,
> 
> In today's tip (v2.6.30-rc2), when my cpu is idle (and the ondemand
> governor correctly uses the lowest frequency) the temperature of my CPU
> rises to above 50^C till the fan turns on (it used to be about 40^C
> before).  Git bisect points to this patch:
> 
>   commit 01599fca6758d2cd133e78f87426fc851c9ea725
>   Author: Andrew Morton <akpm@linux-foundation.org>
>   Date:   Mon Apr 13 10:27:49 2009 -0700
>   
>       cpufreq: use smp_call_function_[single|many]() in acpi-cpufreq.c
>       
>       Atttempting to rid us of the problematic work_on_cpu().  Just use
>       smp_call_fuction_single() here.
>       
>       This repairs a 10% sysbench(oltp)+mysql regression which Mike reported,
>       due to
>       
>         commit 6b44003e5ca66a3fffeb5bc90f40ada2c4340896
>         Author: Andrew Morton <akpm@linux-foundation.org>
>         Date:   Thu Apr 9 09:50:37 2009 -0600
>       
>             work_on_cpu(): rewrite it to create a kernel thread on demand
>       
>       It seems that the kernel calls these acpi-cpufreq functions at a quite
>       high frequency.
>       
>       Valdis Kletnieks also reports that this causes 70-90 forks per second on
>       his hardware.
>       
>       Cc: Valdis.Kletnieks@vt.edu
>       Cc: Rusty Russell <rusty@rustcorp.com.au>
>       Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>       Cc: Len Brown <len.brown@intel.com>
>       Cc: Zhao Yakui <yakui.zhao@intel.com>
>       Acked-by: Dave Jones <davej@redhat.com>
>       Cc: Thomas Gleixner <tglx@linutronix.de>
>       Tested-by: Mike Galbraith <efault@gmx.de>
>       Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
>       Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>       Acked-by: Ingo Molnar <mingo@elte.hu>
>       [ Made it use smp_call_function_many() instead of looping over cpu's
>         with smp_call_function_single()    - Linus ]

<stares suspiciously at smp_call_function_many()>

 * smp_call_function_many(): Run a function on a set of other CPUs.

"other".  It refuses to call the function on *this* CPU.  Tricky.

Does this fix it up?

--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c~a
+++ a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -204,7 +204,10 @@ static void drv_read(struct drv_cmd *cmd
 
 static void drv_write(struct drv_cmd *cmd)
 {
-	smp_call_function_many(cmd->mask, do_drv_write, cmd, 1);
+	unsigned cpu;
+
+	for_each_cpu(cpu, cmd->mask)
+		smp_call_function_single(cpu, do_drv_write, cmd, 1);	
 }
 
 static u32 get_cur_val(const struct cpumask *mask)
_

