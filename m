From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: +
 all-arches-signal-move-restart_block-to-struct-task_struct.patch added to
 -mm tree
Date: Wed, 3 Dec 2014 16:23:15 -0800
Message-ID: <20141203162315.99f318757fc085c3311c375f@linux-foundation.org>
References: <547fa457.hlgB/Ig+t6HXFsjh%akpm@linux-foundation.org>
	<20141204000848.GB22619@flint.arm.linux.org.uk>
	<CALCETrXXtcr4YwbqnD6sRDh1pfr1c6EYSbNrae+O3UTDs67jYA@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaLDAXT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2014 19:23:19 -0500
In-Reply-To: <CALCETrXXtcr4YwbqnD6sRDh1pfr1c6EYSbNrae+O3UTDs67jYA@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Russell King <rmk@arm.linux.org.uk>, a-jacquiot@ti.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Catalin Marinas <catalin.marinas@arm.com>, chris@zankel.net, cmetcalf@ezchip.com, "David S. Miller" <davem@davemloft.net>, deller@gmx.de, David Howells <dhowells@redhat.com>, egtvedt@samfundet.no, Geert Uytterhoeven <geert@linux-m68k.org>, gxt@mprc.pku.edu.cn, Heiko Carstens <heiko.carstens@de.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, hskinnemoen@gmail.com, ink@jurassic.park.msu.ru, James Hogan <james.hogan@imgtec.com>, jcmvbkbc@gmail.com, jejb@parisc-linux.org, jesper.nilsson@axis.com, jonas@southpole.se, Kees Cook <keescook@chromium.org>, lennox.wu@gmail.com, liqin.linux@gmail.com, mattst88@gmail.com, Ingo Molnar <mingo@kernel.org>, monstr@monstr.eu, mpe@ellerman.id.au, msalter@redhat.com, Oleg Nesterov <oleg@redhat.com>, Paul Mackerras <paulus@samba.org>, Ra

On Wed, 3 Dec 2014 16:12:30 -0800 Andy Lutomirski <luto@amacapital.net> wrote:

> On Wed, Dec 3, 2014 at 4:08 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> > On Wed, Dec 03, 2014 at 04:01:27PM -0800, akpm@linux-foundation.org wrote:
> >> @@ -221,7 +221,7 @@ asmlinkage int sys_rt_sigreturn(struct p
> >>       struct rt_sigframe __user *frame;
> >>
> >>       /* Always make any pending restarted system calls return -EINTR */
> >> -     current_thread_info()->restart_block.fn = do_no_restart_syscall;
> >> +     current->restart_block.fn = do_no_restart_syscall;
> >>
> >>       /*
> >>        * Since we stacked the signal on a 64-bit boundary,
> >> diff -puN arch/arm/kernel/traps.c~all-arches-signal-move-restart_block-to-struct-task_struct arch/arm/kernel/traps.c
> >> diff -puN arch/arm64/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct arch/arm64/include/asm/thread_info.h
> >> --- a/arch/arm64/include/asm/thread_info.h~all-arches-signal-move-restart_block-to-struct-task_struct
> >> +++ a/arch/arm64/include/asm/thread_info.h
> >
> > Andrew,
> >
> > Did a change to arch/arm/kernel/traps.c get lost here?
> >
> 
> I think this is correct, due to:
> 
> commit 3f4aa45ceea5789a4aade536acc27f2e0d3da5e1
> Author: Vladimir Murzin <vladimir.murzin@arm.com>
> Date:   Thu Nov 27 11:39:04 2014 +0100
> 
>     ARM: 8226/1: cacheflush: get rid of restarting block
> 

Yes.  And unfortunately I don't have an automated (ie: nice patch
rejects) way of knowing whether 3f4aa45ceea5789 is present when I merge
Andy's patch.  However the arm build will break so the fix will be
quick and trivial (I do arm allnoconfig and defconfig occasionally, but
not reliably).

But probably 3f4aa45ceea5789a4aa will be present in 3.19-final so no
probs.
