From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 work_on_cpu-rewrite-it-to-create-a-kernel-thread-on-demand.patch  added to
 -mm tree
Date: Tue, 3 Feb 2009 20:16:42 -0800
Message-ID: <20090203201642.057a07b9.akpm@linux-foundation.org>
References: <200902031058.n13AwOoK016719@imap1.linux-foundation.org>
	<c62985530902030858y28906b2dh511c5868afabfd17@mail.gmail.com>
	<20090203112529.26e6bf76.akpm@linux-foundation.org>
	<200902041428.12059.rusty@rustcorp.com.au>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33934 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751358AbZBDERV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Feb 2009 23:17:21 -0500
In-Reply-To: <200902041428.12059.rusty@rustcorp.com.au>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, mingo@elte.hu, linux-kernel@vger.kernel.org, oleg@redhat.com, travis@sgi.com, a.p.zijlstra@chello.nl, mm-commits@vger.kernel.org

On Wed, 4 Feb 2009 14:28:11 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wednesday 04 February 2009 05:55:29 Andrew Morton wrote:
> > On Tue, 3 Feb 2009 17:58:13 +0100
> > Fr__d__ric Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > 2009/2/3 Ingo Molnar <mingo@elte.hu>:
> > > >
> > > > * akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> > > >
> > > >> ------------------------------------------------------
> > > >> Subject: work_on_cpu(): rewrite it to create a kernel thread on demand
> > > >> From: Andrew Morton <akpm@linux-foundation.org>
> > > >>
> > > >> The various implemetnations and proposed implemetnations of work_on_cpu()
> > > >> are vulnerable to various deadlocks because they all used queues of some
> > > >> form.
> > > >>
> > > >> Unrelated pieces of kernel code thus gained dependencies wherein if one
> > > >> work_on_cpu() caller holds a lock which some other work_on_cpu() callback
> > > >> also takes, the kernel could rarely deadlock.
> > > >>
> > > >> Fix this by creating a short-lived kernel thread for each work_on_cpu()
> > > >> invokation.
> > > >>
> > > >> This is not terribly fast, but the only current caller of work_on_cpu() is
> > > >> pci_call_probe().
> > > >
> > > > hm, it's quite ugly as well
> > 
> > No it isn't.
> > 
> > It's no less ugly than the current code.
> > 
> > It's less buggy than the current code.
> 
> Whatever, I like your version.

Careful, or you'll own it ;)

> Tho making it a series of 5 and exposing rdmsr_on_cpu/wrmsr_on_cpu for other
> uses would be even better.

These:

int rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
int wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);
int rdmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h);
int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h);

already exist.  I don't think anything else needs to be done here?
