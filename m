From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + ignore-stolen-time-in-the-softlockup-watchdog-fix.patch added
 to -mm tree
Date: Tue, 24 Apr 2007 19:14:25 -0700
Message-ID: <20070424191425.28a55eb6.akpm@linux-foundation.org>
References: <200704242045.l3OKjD9N018856@shell0.pdx.osdl.net>
	<17966.45949.796715.978244@cargo.ozlabs.ibm.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161823AbXDYCPZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Apr 2007 22:15:25 -0400
In-Reply-To: <17966.45949.796715.978244@cargo.ozlabs.ibm.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>
Cc: mm-commits@vger.kernel.org, clalance@redhat.com, dada1@cosmosbay.com, dhecht@vmware.com, jeremy@goop.org, jmorris@namei.org, johnstul@us.ibm.com, mingo@elte.hu, prarit@redhat.com, ricklind@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de, zach@vmware.com

On Wed, 25 Apr 2007 11:48:45 +1000 Paul Mackerras <paulus@samba.org> wrote:

> akpm@linux-foundation.org writes:
> 
> > Avoid reevaluating smp_processor_id()
> 
> >  	int this_cpu = smp_processor_id();
> > -	unsigned long touch_timestamp = __get_cpu_var(touch_timestamp);
> > +	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
> 
> This is actually worse on those cpus that have a fast way to get to
> the current cpu's per-cpu data.
> 

The patch adds 4 bytes (strange number) to powerpc text and removes 32 from
i386's.  A net win, I guess.

i386 now has a considerably better smp_processor_id(), but no special-case
handling of per-cpu data.  Maybe Jeremy has plans to move i386's per-cpu
data into the pda also?
