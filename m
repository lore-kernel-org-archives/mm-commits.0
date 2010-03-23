From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: - fix-mtd-cfi-lpddr-flash-driver-huge-latency-bug.patch removed
 from -mm tree
Date: Tue, 23 Mar 2010 15:40:11 -0700
Message-ID: <20100323154011.7abb9f60.akpm@linux-foundation.org>
References: <201003232219.o2NMJVcm029198@imap1.linux-foundation.org>
	<20100323233326.73366j7ufi3kol9y@mail.your-server.de>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753349Ab0CWWkz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Mar 2010 18:40:55 -0400
In-Reply-To: <20100323233326.73366j7ufi3kol9y@mail.your-server.de>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stefani@seibold.net
Cc: dwmw2@infradead.org, michael.kreuzer@nsn.com, nico@fluxnic.net, mm-commits@vger.kernel.org

On Tue, 23 Mar 2010 23:33:26 +0100
stefani@seibold.net wrote:

> 
> Zitat von akpm@linux-foundation.org:
> 
> >
> > The patch titled
> >      mtd: CFI/LPDDR flash driver: fix huge latency bug
> > has been removed from the -mm tree.  Its filename was
> >      fix-mtd-cfi-lpddr-flash-driver-huge-latency-bug.patch
> >
> > This patch was dropped because of linux-next bitrot and struct mutex  
> > mutex[1] weirness
> >
> 
> Sorry but i did not understand. What does bitrot mean?

Other changes in linux-next caused it to break.

> And where was the problem with mutex[1]?

It caused warnings because your various calls to mutex_init() didn't handle
it correctly.

It's unconventional and odd - don't bother with it.


