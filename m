From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 015/119] mm/slub.c: add a naive detection of double free
 or corruption
Date: Wed, 6 Sep 2017 17:44:29 -0700
Message-ID: <20170906174429.fd482253af327f7b06a684bf@linux-foundation.org>
References: <20170906231922.NPtw_S3Sv%akpm@linux-foundation.org>
        <CA+55aFzmpViw5CJdCXC7f0TdsFYQAdbJt77bfn4t6oXq_=W9xw@mail.gmail.com>
        <CAGXu5jLHyo3MZt2b7HSA-vpzn1qojUOU4AGo=eoBuyz6X9dzLw@mail.gmail.com>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58148 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752524AbdIGAob (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 6 Sep 2017 20:44:31 -0400
In-Reply-To: <CAGXu5jLHyo3MZt2b7HSA-vpzn1qojUOU4AGo=eoBuyz6X9dzLw@mail.gmail.com>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Popov <alex.popov@linux.com>, Christoph Lameter <cl@linux.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@kernel.org>, mm-commits@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>, Paul McKenney <paulmck@linux.vnet.ibm.com>, Pekka Enberg <penberg@kernel.org>, Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Tycho Andersen <tycho@docker.com>

On Wed, 6 Sep 2017 17:25:21 -0700 Kees Cook <keescook@chromium.org> wrote:

> On Wed, Sep 6, 2017 at 4:55 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > This _may_ be one of the few acceptable uses of BUG_ON(), but I still
> > question it.
> >
> > It's quite possibly going to bring the machine down, with no messages
> > going to the logs, and nothing to say what happened.
> >
> > That's not good for debugging, but it's not good for security either.
> >
> > Are you really sure you don't want to just replace it with a
> >
> >    if (WARN_ON_ONCE(..)) return;
> >
> > instead?
> >
> > Killing a machine really isn't a great thing to do.
> 
> I asked after this as well, but it didn't really get addressed:
> http://www.openwall.com/lists/kernel-hardening/2017/07/19/9
> 
> I'd be fine with this being WARN_ON_ONCE().

Well...  if the kernel warns then proceeds with known pointer crazies,
it isn't really "hardened".  It's just "kernel with extra debug
checks".  Yes the log splat is useful, but not very satisfying if
someone has already made off with all your customers' credit card
numbers?


