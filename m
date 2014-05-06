From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 printk-print-initial-logbuf-contents-before-re-enabling-interrupts.patch
 added to -mm tree
Date: Tue, 6 May 2014 15:05:53 -0700
Message-ID: <20140506150553.a12959fd71d83eddcb4b325d__37521.0288832479$1399414204$gmane$org@linux-foundation.org>
References: <53640c8c.5++0zeO0pmfqKMwm%akpm@linux-foundation.org>
	<20140502224651.GG23636@quack.suse.cz>
	<20140506120648.GA30234@arm.com>
	<20140506122958.GG9291@quack.suse.cz>
	<20140506131234.GD30234@arm.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbaEFWFz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 18:05:55 -0400
In-Reply-To: <20140506131234.GD30234@arm.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Jan Kara <jack@suse.cz>, "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "kay@vrfy.org" <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, 6 May 2014 14:12:34 +0100 Will Deacon <will.deacon@arm.com> wrote:

> > > > My opinion is that when you are printing from each and every interrupt
> > > > which happens so often, then you have a problem and disabling IRQs in
> > > > printk so that your interrupt doesn't happen that often seems like a poor
> > > > solution to me. You could as well just ratelimit your debug messages,
> > > > couldn't you?
> > > 
> > > My use-case was basically using printk as a debug trace during early boot
> > > when bringing up Linux on a new CPU core. I don't think ratelimiting would
> > > be the right thing there, since I really did want as many messages to
> > > reach the console as possible (which is also why I wrote this patch, not
> > > just the other one in the series).
> >   OK, I understand. It just seems wrong to me to throttle all interrupts on
> > the cpu while doing printing just because someone might be doing debug
> > printing from the interrupt. Sure it's fine as a debug hack but on a
> > production machine that seems rather counterproductive.
> 
> Perhaps, but the one time I *really* want printk to be reliable is when I'm
> using it to debug a problem.

If you're debugging a problem, you're able to alter printk!  So perhaps
one way out of this is some developer-only ifdef to robustify printk
for particular usage patterns.

