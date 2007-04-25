From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + ignore-stolen-time-in-the-softlockup-watchdog-fix.patch added
 to -mm tree
Date: Tue, 24 Apr 2007 21:48:49 -0700
Message-ID: <20070424214849.37783c2d.akpm@linux-foundation.org>
References: <200704242045.l3OKjD9N018856@shell0.pdx.osdl.net>
	<462EB849.4080402@goop.org>
	<20070424191623.d98a0880.akpm@linux-foundation.org>
	<462EDB1B.5010909@goop.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161600AbXDYEtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 00:49:46 -0400
In-Reply-To: <462EDB1B.5010909@goop.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mm-commits@vger.kernel.org, clalance@redhat.com, dada1@cosmosbay.com, dhecht@vmware.com, jmorris@namei.org, johnstul@us.ibm.com, mingo@elte.hu, paulus@samba.org, prarit@redhat.com, ricklind@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de, zach@vmware.com

On Tue, 24 Apr 2007 21:37:47 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > Any which enable CONFIG_DEBUG_PREEMPT...
> >   
> 
> Hm.  Normally smp_processor_id() CSEs nicely, so it isn't generally
> necessary to do it manually.

For all architectures?

>  Not sure what CONFIG_DEBUG_PREEMPT will do
> to it.

#ifdef CONFIG_DEBUG_PREEMPT
  extern unsigned int debug_smp_processor_id(void);
# define smp_processor_id() debug_smp_processor_id()
#else
# define smp_processor_id() raw_smp_processor_id()
#endif

We could perhaps mark debug_smp_processor_id() as pure or const or whatever
the trick is to say it doesn't need to be reevaluated.  That would usually
be OK, because as long as preempt is disabled that _is_ how it works,
however code might do:

	preempt_disable();
	smp_processor_id();
	preempt_enable();

	<preempt or schedule()>

	preempt_disable();
	smp_processor_id();
	preempt_enable();

and caching the value would be wrong.

hm.  If "smp_processor_id() CSEs nicely", what prevents the compiler from
making the same mistake?  IOW, what are the barriers for CSE?  Function
calls?
