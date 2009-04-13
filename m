From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
Date: Mon, 13 Apr 2009 11:49:32 -0700
Message-ID: <20090413114932.44b47910.akpm@linux-foundation.org>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org>
	<4609.1239456126@turing-police.cc.vt.edu>
	<alpine.LFD.2.00.0904130847500.4583@localhost.localdomain>
	<20090413171853.GA4601@elte.hu>
	<20090413102749.4ca3a217.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0904131040350.4583@localhost.localdomain>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbZDMSzb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Apr 2009 14:55:31 -0400
In-Reply-To: <alpine.LFD.2.00.0904131040350.4583@localhost.localdomain>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mingo@elte.hu, Valdis.Kletnieks@vt.edu, travis@sgi.com, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, rusty@rustcorp.com.au, davej@redhat.com, lenb@kernel.org

On Mon, 13 Apr 2009 10:45:45 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 13 Apr 2009, Andrew Morton wrote:
> >
> >  static void drv_write(struct drv_cmd *cmd)
> >  {
> > -	unsigned int i;
> > +	unsigned int cpu;
> >  
> > -	for_each_cpu(i, cmd->mask) {
> > -		work_on_cpu(i, do_drv_write, cmd);
> > -	}
> > +	for_each_cpu(cpu, cmd->mask)
> > +		smp_call_function_single(cpu, do_drv_write, cmd, 1);
> 
> Ok, that's just -wrong-.
> 
> Doesn't anybody else see anything odd in doing
> 
> 	for_each_cpu(cpu, cmd->mask)
> 		smp_call_function_single(cpu, ..);
> 
> and react to it?
> 
> IOW, why not just do
> 
> 	smp_call_function_many(cmd->mask, do_drv_write, cmd, 1);
> 
> here?
> 

Didn't know it existed :(
