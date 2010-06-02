From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 kfifo-replace-the-old-non-generic-api-kfifo-fix-scatterlist-usage.patch
 added to -mm tree
Date: Wed, 2 Jun 2010 13:34:13 -0700
Message-ID: <20100602133413.9acfa300.akpm@linux-foundation.org>
References: <201006022019.o52KJZQC014816@imap1.linux-foundation.org>
	<1275510551.1294.7.camel@wall-e.seibold.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166Ab0FBUe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 16:34:29 -0400
In-Reply-To: <1275510551.1294.7.camel@wall-e.seibold.net>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Stefani Seibold <stefani@seibold.net>
Cc: mm-commits@vger.kernel.org, kernel@irasnyder.com, greg@kroah.com

On Wed, 02 Jun 2010 22:29:11 +0200
Stefani Seibold <stefani@seibold.net> wrote:

> 
> Am Mittwoch, den 02.06.2010, 13:19 -0700 schrieb
> akpm@linux-foundation.org:
> > The patch titled
> >      kfifo: fix scatterlist usage
> > has been added to the -mm tree.  Its filename is
> >      kfifo-replace-the-old-non-generic-api-kfifo-fix-scatterlist-usage.patch
> > 
> > Before you just go and hit "reply", please:
> >    a) Consider who else should be cc'ed
> >    b) Prefer to cc a suitable mailing list as well
> >    c) Ideally: find the original patch on the mailing list and do a
> >       reply-to-all to that, adding suitable additional cc's
> > 
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
> > 
> > See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> > out what to do about this
> > 
> > The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> > 
> > ------------------------------------------------------
> > Subject: kfifo: fix scatterlist usage
> > From: Ira W. Snyder <kernel@irasnyder.com>
> > 
> > The current kfifo scatterlist implementation will not work with chained
> > scatterlists.  It assumes that struct scatterlist arrays are allocated
> > contiguously, which is not the case when chained scatterlists (struct
> > sg_table) are in use.
> > 
> 
> Why do you have added this?

Because nobody reviewed the code.

> No one had reviewed the code and no one gave
> an ack. I am currently to busy to check this.

And I don't have the bandwidth to track hundreds of maybe, maybe-not
emails stretching over months of time.  So generally I'll just apply
the thing if it looks good so that I can keep track of it and so that
it gets some testing.

