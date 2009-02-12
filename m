From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch  added to
 -mm tree
Date: Thu, 12 Feb 2009 12:48:35 -0800
Message-ID: <20090212124835.2fc41620.akpm@linux-foundation.org>
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org>
	<20090203121147.GB19979@elte.hu>
	<c62985530902030858y28906b2dh511c5868afabfd17@mail.gmail.com>
	<20090203112529.26e6bf76.akpm@linux-foundation.org>
	<m18wobcrw3.fsf@fess.ebiederm.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758620AbZBLUtf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:49:35 -0500
In-Reply-To: <m18wobcrw3.fsf@fess.ebiederm.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: fweisbec@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org, oleg@redhat.com, travis@sgi.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org, rusty@rustcorp.com.au

On Thu, 12 Feb 2009 12:38:36 -0800
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> >
> > Series of four patches:
> >
> > - switch cstate.c frmo work_on_cpu to smp_call_function_single()
> >
> > - ditto acpi-cpufreq.c
> >
> > - ditto mce_amd_64.c
> >
> > The final work_on_cpu() caller is pci_call_probe().  I'd like to find a
> > way of removing that callsite as well, so we can finally remove this
> > turkey but for now, just fix the bugs in it:
> 
> As far as I can tell when we are doing the probes we are in a function
> that can sleep, so we should be able to just call set_cpus_allowed to
> remove the need for work_on_cpu in pci_call_probe.  Possibly with a
> save/restore of the allowed cpus.
> 
> Am I missing something?
> 

The problem with set_cpus_allowed() is that some other
suitably-privileged userspace process can come in from the side and
modify your cpus_allowed at any time.

