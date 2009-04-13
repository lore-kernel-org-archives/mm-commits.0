From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
 added to -mm tree
Date: Sun, 12 Apr 2009 17:35:16 -0700
Message-ID: <20090412173516.6f8e315c.akpm@linux-foundation.org>
References: <200904101930.n3AJUNqD013281@imap1.linux-foundation.org>
	<200904130945.54932.rusty@rustcorp.com.au>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbZDMAl3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 12 Apr 2009 20:41:29 -0400
In-Reply-To: <200904130945.54932.rusty@rustcorp.com.au>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: mm-commits@vger.kernel.org, davej@redhat.com, efault@gmx.de, len.brown@intel.com, mingo@elte.hu, tglx@linutronix.de, venkatesh.pallipadi@intel.com, yakui.zhao@intel.com

On Mon, 13 Apr 2009 09:45:54 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Sat, 11 Apr 2009 05:00:23 am akpm@linux-foundation.org wrote:
> > In drv_read(), check to see whether we can run the rdmsr() on the current
> > CPU.  If so, do that.  So smp_call_function_single() can avoid the IPI.
> > 
> > Arguably, cpumask_any() should do this.
> 
> cpumask_any_close()?  It would try smp_processor_id, then node-local?

Yeah, good idea.  cpumask_closest, perhaps.

> I prefer not to mess with the fairly clear "I really don't care" semantic of
> cpumask_any().

