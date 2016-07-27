From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kexec: add restriction on kexec_load() segment sizes
Date: Wed, 27 Jul 2016 13:03:13 -0700
Message-ID: <20160727130313.c9afc876d405cc2e10da976c@linux-foundation.org>
References: <1469502219-24140-1-git-send-email-zhongjiang@huawei.com>
	<20160726125501.69c8186ab9c3b1cef89899d4@linux-foundation.org>
	<57983425.4090901@huawei.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365AbcG0UDP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 16:03:15 -0400
In-Reply-To: <57983425.4090901@huawei.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhong jiang <zhongjiang@huawei.com>
Cc: ebiederm@xmission.com, linux-mm@kvack.org, mm-commits@vger.kernel.org

On Wed, 27 Jul 2016 12:10:13 +0800 zhong jiang <zhongjiang@huawei.com> wrote:

> >> +	for (i = 0; i < nr_segments; i++) {
> >> +		if (PAGE_COUNT(image->segment[i].memsz) > totalram_pages / 2
> >> +				|| PAGE_COUNT(total_segments) > totalram_pages / 2)
> >> +			return result;
> > And I don't think we need this?  Unless we're worried about the sum of
> > all segments overflowing an unsigned long, which I guess is possible. 
> > But if we care about that we should handle it in the next statement:
> >
> >> +		total_segments += image->segment[i].memsz;
> > Should this be 
> >
> > 		total_pages += PAGE_COUNT(image->segment[i].memsz);
>   ok
> > ?  I think "yes", if the segments are allocated separately and "no" if
> > they are all allocated in a big blob.
>    There is a possible that  most of segments size will exceed half of  the real memory.
> 
>   if (PAGE_COUNT(image->segment[i].memsz) > totalram_pages / 2
> 	|| total_pages > totalram_pages / 2)
>   I guess that it is ok , we should bail out timely when it happens to the condition.
>   
>   is right ?
> 
>  your mean that above condition is no need. In the end, we check the overflow just one time.
>   or I misunderstand.

It doesn't matter much.  Actually I misread the code a bit.  How about

	for (i = 0; i < nr_segments; i++) {
		unsigned long seg_pages = PAGE_COUNT(image->segment[i].memsz);

		if (seg_pages > totalram_pages / 2))
			return -EINVAL;

		total_pages += seg_pages;

		if (total_pages > totalram_pages / 2)
			return -EINVAL;
	}

