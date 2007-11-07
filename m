From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32 make header check fails
Date: Wed, 7 Nov 2007 13:55:37 -0800
Message-ID: <20071107135537.08ece5bb.akpm@linux-foundation.org>
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
	<47322340.702@linux.vnet.ibm.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41911 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754253AbXKGV4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2007 16:56:49 -0500
In-Reply-To: <47322340.702@linux.vnet.ibm.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, k.shutemov@gmail.com, apw@shadowen.org

> On Thu, 08 Nov 2007 02:12:40 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> Hi Andrew,
> 
> The build fails with error
> 
>   CHECK   include/asm-generic/siginfo.h
>   CHECK   include/asm-generic/resource.h
>   CHECK   include/asm-generic/statfs.h
>   CHECK   include/asm-generic/signal.h
>   CHECK   include/asm-generic/poll.h
>   CHECK   include/asm-generic/mman.h
>   CHECK   include/asm-generic/ioctl.h
>   CHECK   include/asm-generic/fcntl.h
>   CHECK   include/asm-generic/errno.h
>   CHECK   include/asm-generic/errno-base.h
>   CHECK   include/asm/cputable.h
>   CHECK   include/asm/byteorder.h
>   CHECK   include/asm/bootx.h
>   CHECK   include/asm/auxvec.h
>   CHECK   include/asm/asm-compat.h
>   CHECK   include/asm/a.out.h
>   CHECK   include/asm/ucontext.h
>   CHECK   include/asm/ps3fb.h
>   CHECK   include/asm/linkage.h
>   CHECK   include/asm/elf.h
> /home/test/kernels/linux-2.6.24-rc1/patches/linux-2.6.24-rc1/usr/include/asm/elf.h requires asm/page.h, which does not exist in exported headers
> make[3]: *** [/home/test/kernels/linux-2.6.24-rc1/patches/linux-2.6.24-rc1/usr/include/asm/.check.elf.h] Error 1
> make[2]: *** [asm-powerpc] Error 2
> make[1]: *** [headers_check] Error 2
> make: *** [vmlinux] Error 2
> 

I am going to guess that you're building for powerpc here.

It looks like ia64 broke too.  I'll drop the patch, thanks.
