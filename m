Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500AAC64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 19:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjBZTlQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Feb 2023 14:41:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjBZTlQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Feb 2023 14:41:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399371285F
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 11:41:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8DC9B80955
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 19:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074C2C433EF;
        Sun, 26 Feb 2023 19:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677440472;
        bh=GlNsIL8B/vY1+Ir4GLmDSruUxDZwr0LO6B26CbOy0HE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lnbdxe2pyp71+CIMjAVJlwz4gm1WsR4YjS9MGPEPziSsIouyR6aszTtjA+fbnJzVi
         hdribPZrkfhe6API/2I7kTjaremFqTJSHyPaD3z8/MRHpGeqrJF1TbYuXGkUVteg1Q
         7DRPAF5kxAQFytlPbKCQvUPz4+aNYB+K8xqj5Wmk=
Date:   Sun, 26 Feb 2023 11:41:11 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        tglx@linutronix.de, ryabinin.a.a@gmail.com, peterz@infradead.org,
        nicolas@fjasle.eu, ndesaulniers@google.com, nathan@kernel.org,
        naresh.kamboju@linaro.org, mingo@redhat.com, lkft@linaro.org,
        keescook@chromium.org, jakub@redhat.com, glider@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com,
        andreyknvl@gmail.com, elver@google.com
Subject: Re: +
 kasan-emit-different-calls-for-instrumentable-memintrinsics.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20230226114111.405aa7d661076a45feb70a96@linux-foundation.org>
In-Reply-To: <Y/s7q4EAXRticRvR@zn.tnic>
References: <20230226050340.CFC98C433D2@smtp.kernel.org>
        <Y/s7q4EAXRticRvR@zn.tnic>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, 26 Feb 2023 11:59:55 +0100 Borislav Petkov <bp@alien8.de> wrote:

> On Sat, Feb 25, 2023 at 09:03:40PM -0800, Andrew Morton wrote:
> > --- a/mm/kasan/shadow.c~kasan-emit-different-calls-for-instrumentable-memintrinsics
> > +++ b/mm/kasan/shadow.c
> > @@ -107,6 +107,17 @@ void *__asan_memcpy(void *dest, const void *src, size_t len)
> >  }
> >  EXPORT_SYMBOL(__asan_memcpy);
> >  
> > +#ifdef CONFIG_KASAN_SW_TAGS
> > +void *__hwasan_memset(void *addr, int c, size_t len) __alias(__asan_memset);
> > +EXPORT_SYMBOL(__hwasan_memset);
> > +#ifdef __HAVE_ARCH_MEMMOVE
> > +void *__hwasan_memmove(void *dest, const void *src, size_t len) __alias(__asan_memmove);
> > +EXPORT_SYMBOL(__hwasan_memmove);
> > +#endif
> > +void *__hwasan_memcpy(void *dest, const void *src, size_t len) __alias(__asan_memcpy);
> > +EXPORT_SYMBOL(__hwasan_memcpy);
> 
> Any particular reason those exports are not _GPL?

mm/kasan/ is an exotic blend of both.  Perhaps the maintainers will
take a look at this sometime?
