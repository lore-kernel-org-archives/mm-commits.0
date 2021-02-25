Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70554C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 17:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 348B064F4E
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 17:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhBYR6g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 12:58:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232491AbhBYR6Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 12:58:25 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35E5F64DE8;
        Thu, 25 Feb 2021 17:57:43 +0000 (UTC)
Date:   Thu, 25 Feb 2021 12:57:41 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jacob Wen <jian.w.wen@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [patch 014/173] mm, tracing: record slab name for
 kmem_cache_free()
Message-ID: <20210225125741.4fc7e43e@gandalf.local.home>
In-Reply-To: <CAHk-=witGXc2FsqkOUy+Fh1_Vdpg=G5-MnDnDHv5DR5d6bRztQ@mail.gmail.com>
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
        <20210224200055.U7Xz47kX5%akpm@linux-foundation.org>
        <20210224203708.4489755a@oasis.local.home>
        <20210224210740.73273c7a@oasis.local.home>
        <5a0b6fb4-6efd-e391-45fa-cd188f181d5d@oracle.com>
        <20210225093128.4cd86439@gandalf.local.home>
        <CAHk-=witGXc2FsqkOUy+Fh1_Vdpg=G5-MnDnDHv5DR5d6bRztQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 25 Feb 2021 09:49:15 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Feb 25, 2021 at 6:31 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Here's nothing special about %s in TP_printk. It uses the same code as
> > printk() and what other string formatters use.
> >
> > What is special is that the print is on data that is stored from a previous
> > time.  
> 
> Well, technically that's not actually limited to just %s, although
> that's the common case.
> 
> All our magic "%p*" formats do the same thing: they print out not the
> argument _value_, but something that the pointer value points to.
> 
> So "%pD" takes a "struct file *" pointer, and follows it to the
> dentry, and then from the dentry to the name. So it will in fact
> follow pointers even more than "%s" does.

Correct, as I've told people about that as well.

> 
> It might indeed be worth having a warning for TP_printk() about any of
> the formats that follow a pointer, exactly because of the whole "by
> the time it actually prints, the pointer may be long gone".
>

Just a comment? Or should we add some check that gives a warning for when
one of these are used? That can be done at boot up or module load. (note, %s
can be OK for some cases, as mentioned in a previous email).

-- Steve
