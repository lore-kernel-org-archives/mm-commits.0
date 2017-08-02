From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 08/16] fortify: use WARN instead of BUG for now
Date: Wed, 2 Aug 2017 16:48:12 -0700
Message-ID: <20170802164812.a22168351f0e7b556ba5b013@linux-foundation.org>
References: <598236c6.5zsRNFUQTD9/7toc%akpm@linux-foundation.org>
        <CA+55aFxnjNNYHG6HVUoL9WQ5wKcqnXxdC=Z_TkcfaCaHJSMtnw@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbdHBXsN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Aug 2017 19:48:13 -0400
In-Reply-To: <CA+55aFxnjNNYHG6HVUoL9WQ5wKcqnXxdC=Z_TkcfaCaHJSMtnw@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mm-commits@vger.kernel.org, Kees Cook <keescook@chromium.org>, Daniel Micay <danielmicay@gmail.com>, Josh Poimboeuf <jpoimboe@redhat.com>

On Wed, 2 Aug 2017 16:40:44 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, Aug 2, 2017 at 1:32 PM,  <akpm@linux-foundation.org> wrote:
> > From: Kees Cook <keescook@chromium.org>
> > Subject: fortify: use WARN instead of BUG for now
> >
> > While CONFIG_FORTIFY_SOURCE continues to shake out, don't unconditionally
> > use BUG(), opting instead for WARN().  This also renames fortify_panic()
> > to fortify_overflow() which better matches what it is being called for.
> 
> This does not build for me. I get:
> 
>    In file included from ./include/linux/bitmap.h:8:0,
>                  from ./include/linux/cpumask.h:11,
>                  from ./arch/x86/include/asm/cpumask.h:4,
>                  from ./arch/x86/include/asm/msr.h:10,
>                  from ./arch/x86/include/asm/processor.h:20,
>                  from ./arch/x86/include/asm/cpufeature.h:4,
>                  from ./arch/x86/include/asm/thread_info.h:52,
>                  from ./include/linux/thread_info.h:37,
>                  from ./arch/x86/include/asm/preempt.h:6,
>                  from ./include/linux/preempt.h:80,
>                  from ./include/linux/spinlock.h:50,
>                  from ./include/linux/wait.h:8,
>                  from ./include/linux/wait_bit.h:7,
>                  from ./include/linux/fs.h:5,
>                  from ./include/linux/buffer_head.h:11,
>                  from fs/adfs/dir_f.c:12:
>    In function ___memcpy___,
>        inlined from _____adfs_dir_put___ at fs/adfs/dir_f.c:318:2,
>        inlined from ___adfs_f_update___ at fs/adfs/dir_f.c:403:2:
>    ./include/linux/string.h:305:4: error: call to _____read_overflow2___
> declared with attribute error: detected read beyond size of object
> passed as 2nd parameter
>        __read_overflow2();

oops.  I have an adfs fix.  Let me send...
