Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DCD7C64ED8
	for <mm-commits@archiver.kernel.org>; Mon, 27 Feb 2023 07:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjB0HB0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Feb 2023 02:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjB0HBZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2023 02:01:25 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BD41A495
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 23:01:24 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id o32so9355906vsv.12
        for <mm-commits@vger.kernel.org>; Sun, 26 Feb 2023 23:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DFcLWtcp5YW/YjOPvb2/JyI7y/EuQSQ7y3W8POdgUzw=;
        b=UublM3ZLujTA6bPaf4B4/uNbQQjv9JgTs8euWQ+L7gTFN/aNhjTj4+cTb/slv/znRd
         WKd/zAWxX9DOPut7wFe09zBRkpk2uf5HzyZu4GxuIHw+Vpeh40ZSYX05bAZe2ePvzLw9
         jQ/EBeCqMfNLPaoHW5XZFdfKELnVf6sDxa5+dfYd96zxXPGu95tlu2Xl1F1J8hYVW6+h
         mlrjlkJ76SqhIEncf+iLgNhzsM2N6ojONPP9DeK/EOUheI6DaKlV3npF68kSfhzpyBX3
         YDFVjAPn+byuk+RI4HyRXFLWv9nqTSpwNMFUq2j8xeBKd81T4R5IHTQFjAox5cYMYhES
         buQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DFcLWtcp5YW/YjOPvb2/JyI7y/EuQSQ7y3W8POdgUzw=;
        b=7Bv5Qiywycd9Sc3+/5beXbBYL0X5ltOkweLRbIMvk2j6qu//L6uaz77IzBmQCJp+us
         wEmyqa996SMBd8OHTjndSHeaB9hlywob6C09glluaUsKOYMltqXg2gNM6D++F4CXPoOW
         JpueV4N3RyFA7drir3iYIBGHf2Y1iD4BOF2cmd7qICBTvd1lTilwzGlZTidKYKEmKDJU
         yj7G5g+vqkJSR3xRQhy/JM7W8C8TbrrlUQNgN58DyQ5rgtyhEQv7AOVdxskUIMiVvE+e
         2uOq8PPgqA33jE2s04CMZrglY8li58vuq2qq1On2mZ4u8b6j+E/N2rD+/GE0Gn4jtHdC
         xWqw==
X-Gm-Message-State: AO0yUKXvjKjWTk6NfBy0emZ671Q6DP1ON4QNw80uY6TWWeulRsWfK21r
        se1Z347gXI1G3eeF6MO/rD9+vVuCD2QxQE2S0/R/3rC4t7Yfc3GF
X-Google-Smtp-Source: AK7set9m6a20HGZMwiCe+OEgycMuFdC5svGB6xVmCZ5tJdRSrWgRRzT87uZB+Ai0A6Rh8ZeeqZmEgMbNNuchzHUxIlU=
X-Received: by 2002:ac5:c975:0:b0:401:73f4:dfe with SMTP id
 t21-20020ac5c975000000b0040173f40dfemr7142364vkm.3.1677481283322; Sun, 26 Feb
 2023 23:01:23 -0800 (PST)
MIME-Version: 1.0
References: <20230226050340.CFC98C433D2@smtp.kernel.org> <Y/s7q4EAXRticRvR@zn.tnic>
In-Reply-To: <Y/s7q4EAXRticRvR@zn.tnic>
From:   Marco Elver <elver@google.com>
Date:   Mon, 27 Feb 2023 08:00:00 +0100
Message-ID: <CANpmjNNgcBJxsabt7SZ8eMxMrJSZ_qhRY1NOjnHCmhNQT=Xiig@mail.gmail.com>
Subject: Re: + kasan-emit-different-calls-for-instrumentable-memintrinsics.patch
 added to mm-hotfixes-unstable branch
To:     Borislav Petkov <bp@alien8.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, vincenzo.frascino@arm.com,
        tglx@linutronix.de, ryabinin.a.a@gmail.com, peterz@infradead.org,
        nicolas@fjasle.eu, ndesaulniers@google.com, nathan@kernel.org,
        naresh.kamboju@linaro.org, mingo@redhat.com, lkft@linaro.org,
        keescook@chromium.org, jakub@redhat.com, glider@google.com,
        dvyukov@google.com, dave.hansen@linux.intel.com,
        andreyknvl@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sun, 26 Feb 2023 at 12:00, Borislav Petkov <bp@alien8.de> wrote:
>
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

To match lib/string.c:

$> grep EXPORT_SYMBOL lib/string.c
...
EXPORT_SYMBOL(memset);
...
EXPORT_SYMBOL(memcpy);
EXPORT_SYMBOL(memmove);
...

Note that these __asan/__hwasan calls are generated by the compiler,
in place of the above.

On a more fundamental level, KASAN is low level enough that being
_GPL would probably cause headaches for valid use cases. For example,
so that vendors can use KASAN on their however licensed modules -
wherever those non-GPL modules may be used, precluding use of KASAN
there would make the quality of these things even worse.

Thanks,
-- Marco
