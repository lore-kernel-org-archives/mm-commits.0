From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 nommu-get_user_pages-pin-last-page-on-non-page-aligned-start.patch added to
 -mm tree
Date: Thu, 18 Mar 2010 12:26:20 -0700
Message-ID: <20100318122620.908363f3.akpm@linux-foundation.org>
References: <1268076881.3077.90.camel@iscandar.digidescorp.com>
	<1268064566.3077.64.camel@iscandar.digidescorp.com>
	<201003032254.o23MsMMj003607@imap1.linux-foundation.org>
	<31004.1268057251@redhat.com>
	<1366.1268068048@redhat.com>
	<19133.1268144943@redhat.com>
	<1268147254.2985.4.camel@iscandar.digidescorp.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317Ab0CRT1W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Mar 2010 15:27:22 -0400
In-Reply-To: <1268147254.2985.4.camel@iscandar.digidescorp.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steve@digidescorp.com
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org, mm-commits@vger.kernel.org, lethal@linux-sh.org

On Tue, 09 Mar 2010 09:07:34 -0600
"Steven J. Magnani" <steve@digidescorp.com> wrote:

> On Tue, 2010-03-09 at 14:29 +0000, David Howells wrote:
> 
> > However, it does occur to me that if it's not pinning the last page correctly,
> > shouldn't that cause a usage counter underflow error on that page eventually
> > when it's returned to the system allocator?
> 
> Not in my scenario. All pages but the last get pinned;
> drivers/dma/iovlock.c::dma_pin_iovec_pages() detects the mismatch
> between what was requested and what was pinned, and unpins everything in
> the pinned list. So AFAICT the net effect is that the network stack
> falls back to plain old memcpy.
> 

Guys, what do we need to do to get this issue wrapped up?

Thanks.
