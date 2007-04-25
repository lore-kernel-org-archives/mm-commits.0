From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + ignore-stolen-time-in-the-softlockup-watchdog-fix.patch added
 to -mm tree
Date: Tue, 24 Apr 2007 19:16:23 -0700
Message-ID: <20070424191623.d98a0880.akpm@linux-foundation.org>
References: <200704242045.l3OKjD9N018856@shell0.pdx.osdl.net>
	<462EB849.4080402@goop.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161828AbXDYCRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Apr 2007 22:17:15 -0400
In-Reply-To: <462EB849.4080402@goop.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: mm-commits@vger.kernel.org, clalance@redhat.com, dada1@cosmosbay.com, dhecht@vmware.com, jmorris@namei.org, johnstul@us.ibm.com, mingo@elte.hu, paulus@samba.org, prarit@redhat.com, ricklind@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de, zach@vmware.com

On Tue, 24 Apr 2007 19:09:13 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> akpm@linux-foundation.org wrote:
> > The patch titled
> >      ignore-stolen-time-in-the-softlockup-watchdog-fix
> > has been added to the -mm tree.  Its filename is
> >      ignore-stolen-time-in-the-softlockup-watchdog-fix.patch
> >
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> >
> > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> > out what to do about this
> >
> > ------------------------------------------------------
> > Subject: ignore-stolen-time-in-the-softlockup-watchdog-fix
> > From: Andrew Morton <akpm@linux-foundation.org>
> >
> > Avoid reevaluating smp_processor_id()
> >   
> 
> I don't think this is a useful patch.  Are there any architectures which
> have an expensive smp_processor_id() and use it in per_cpu?

Any which enable CONFIG_DEBUG_PREEMPT...

>  On x86
> smp_processor_id is cheap, and once the pda->percpu patches go in, won't
> be used for get_cpu_var anyway.
> 
>     J
