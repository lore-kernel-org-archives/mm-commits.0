Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56982C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:58:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F1C361108
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 20:58:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbhDIU7C (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Apr 2021 16:59:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234278AbhDIU7A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 9 Apr 2021 16:59:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F95460FEE;
        Fri,  9 Apr 2021 20:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618001917;
        bh=N/IaemW+E6ssFBY1MD5lp8pl6ZSRMEO7w+HboJ04ORw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d9ROmN0VVfkuZ6NWMF5hQMCXmwfEqGYnl0b1ThnSugVeFQJoy9wBZU3ZvSVP5szXS
         ZxZWlDAOeWCyyAMDFMrln5TBFujYjNFiFlUgxDkNRMPzyQpIcAsAtYrJZSZW8WcRsE
         jHvu/HYeZp2o7hHJjacLuT9cq1ApZ4R1dOd9CuE4=
Date:   Fri, 9 Apr 2021 13:58:36 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Andrey Konovalov <andreyknvl@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        mm-commits@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 05/16] kasan: fix hwasan build for gcc
Message-Id: <20210409135836.5fd622e4bec07650774f58c2@linux-foundation.org>
In-Reply-To: <CA+fCnZf1ABrQg0dsxtoZa9zM1BSbLYq_Xbu+xi9cv8WAZxdC2g@mail.gmail.com>
References: <20210409132633.6855fc8fea1b3905ea1bb4be@linux-foundation.org>
        <20210409202713.NIELx3Tx9%akpm@linux-foundation.org>
        <CA+fCnZf1ABrQg0dsxtoZa9zM1BSbLYq_Xbu+xi9cv8WAZxdC2g@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, 9 Apr 2021 22:39:46 +0200 Andrey Konovalov <andreyknvl@gmail.com> wrote:

> >
> >  endif # CONFIG_KASAN_SW_TAGS
> > _
> 
> Hi,
> 
> As I commented on the patch, this breaks SW_TAGS build with Clang for me with:
> 
> arch/arm64/include/asm/current.h:19: undefined reference to `__hwasan_tls'
> 
> The reason for this is that cc-param is only defined for
> KASAN_GENERIC, the definition needs to be moved.
> 

Oh.  I thought that had been fixed.

Please send a patch?
