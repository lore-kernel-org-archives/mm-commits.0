From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + lib-optimize-cpumask_next_and.patch added to -mm tree
Date: Fri, 3 Nov 2017 11:27:06 -0700
Message-ID: <20171103112706.24e34c02cfedabd4d6ee2b21@linux-foundation.org>
References: <59fb89ff.CtPKwRXZPiXavcjK%akpm@linux-foundation.org>
        <20171103011229.n2pjtpbhip7duabq@yury-thinkpad>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45024 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756147AbdKCS1I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Nov 2017 14:27:08 -0400
In-Reply-To: <20171103011229.n2pjtpbhip7duabq@yury-thinkpad>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Yury Norov <ynorov@caviumnetworks.com>
Cc: courbet@google.com, adobriyan@gmail.com, arnd@arndb.de, linux@rasmusvillemoes.dk, mawilcox@microsoft.com, mingo@kernel.org, mm-commits@vger.kernel.org

On Fri, 3 Nov 2017 04:12:29 +0300 Yury Norov <ynorov@caviumnetworks.com> wrote:

> >  #if !defined(find_next_bit_le) || !defined(find_next_zero_bit_le)
> > -static unsigned long _find_next_bit_le(const unsigned long *addr,
> > -		unsigned long nbits, unsigned long start, unsigned long invert)
> > +static unsigned long _find_next_bit_le(const unsigned long *addr1,
> > +		const unsigned long *addr2, unsigned long nbits,
> > +		unsigned long start, unsigned long invert)
> 
> This should also be inline I think.

gcc-4.4.4 (at least) does that automatically.

> The rest is looking OK.
> Andrew, did you see my patch with the test for _find_bit()?
> https://lkml.org/lkml/2017/10/28/70

It was unclear from Clement's testing that the change is worthwhile?
