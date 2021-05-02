Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F4E4C433ED
	for <mm-commits@archiver.kernel.org>; Sun,  2 May 2021 18:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59C0F61352
	for <mm-commits@archiver.kernel.org>; Sun,  2 May 2021 18:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhEBSFu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 2 May 2021 14:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231788AbhEBSFu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 2 May 2021 14:05:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30177610FC;
        Sun,  2 May 2021 18:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619978697;
        bh=RMzxlhg5QnpgDwVktb697u84AkdnLgHnGdDSv9o3yBU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q6WEJIYBKovoNnHZxvObOu5DPzjnDlWTwOqTbRlXaCyteXYZD7PblL1yf4OIfJrxA
         zHpziI9+aEg+zFoRDoI4exyixvDaG99JN4g3oCgfcRIGXmf2rQf9sG6Uy6HuQnsSTA
         IhoBG15CM9za6cSNKMZPTK9p+IEhBEsjK2xan0js=
Date:   Sun, 2 May 2021 11:04:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Subject: Re: [patch 148/178] kasan: detect false-positives in tests
Message-Id: <20210502110456.238c3e175d35e4a6ce8a6088@linux-foundation.org>
In-Reply-To: <CAHk-=whhOEXyFGV7CfwB44etgYsb1vAkLhRrWb-mxjeUcqWu=g@mail.gmail.com>
References: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
        <20210430060049.FrKVS3ZER%akpm@linux-foundation.org>
        <CAHk-=whhOEXyFGV7CfwB44etgYsb1vAkLhRrWb-mxjeUcqWu=g@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 30 Apr 2021 11:32:43 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> This patch is untested garbage that doesn't even compile.

Sorry, I fat-fingered a thing and used gcc-9, which disables CONFIG_KASAN.

> Use the previous release as a base (ie in this case 5.12)

Not a problem for the first batch of patches, but what base do I use for
the second and succeeding batches?

> If you have patches in
> your patch-series that depend on stuff that comes in this merge
> window, just drop them - or at least don't send them to me.

Maybe 10% of the patches I carry are based on changes which are in
linux-next.  Things like

- tree-wide renames which need to catch other developers adding
  instances of the old name.  They'll pop up in third-party testing and
  I do a last-minute grep to find these.

- changes which I've worked with other developers to stage things in
  that order.

- removal of duplicated includes for which I need to do a last-minute
  check that nobody has gone and removed the other include.

- new syscalls which would generate a ton of conflicts with new
  syscalls in other trees.

- right now I'm carrying a pile of little spelling fixes.  I stage
  these after linux-next to find out whether other tree maintainers
  have independently merged the same patches, or partially similar ones
  from others.

- etc.

I send this sort of material to you very late in the merge window,
after the prerequisites have been merged up.

