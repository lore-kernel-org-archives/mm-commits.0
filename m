Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F011AC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 16 Apr 2022 17:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiDPRpS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 16 Apr 2022 13:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiDPRpR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2022 13:45:17 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2103968B
        for <mm-commits@vger.kernel.org>; Sat, 16 Apr 2022 10:42:45 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x33so18516977lfu.1
        for <mm-commits@vger.kernel.org>; Sat, 16 Apr 2022 10:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/jIUvFDPrhPXkkJF0Dp/55PJ5S0x4qstps2XI7eQ/M0=;
        b=YYzhPBou87optH724QK2IXpfqNyBE5k1bdRrq/6iVqz4j33fCs6gu77SZiD7uZ+/+y
         AyATSsUlQqmOxbDT/VFiodyniyPPS5dBwPFqxHjJltJ+4vFWCe6ZmMLgBqAp59zNbOWl
         mVLQQZ6sTlPDIsn1CrMHr8Rynu32DMPkzsZDw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/jIUvFDPrhPXkkJF0Dp/55PJ5S0x4qstps2XI7eQ/M0=;
        b=kSXiMU2qP6lrn7kHZUE8hsHNTYN3MpQt+ncY8v7bBRuxAdwQqdoG6D+rPV5dMG2Qlg
         IfJn4vlYm6dHMXvgmFgFfYngurba+kJgUY/RHvCuLXAkUfuUTUV7noi1UrtWBIYFRMBt
         ryp6rVQA941idSKaQjWl8ovtuOLcD/Q7yJTyLOVP+XmdCMMCEzb0/VvqMJPX5Rf5AM/b
         mTqWUvoZkGIInE4gP4YmkqhREnzovNT33g+97cjQhGjSO1LGptxXIUKHzXC4g+2GuHaF
         R0icDuKIIz/WmXcI/ZWShSuz90RuVv1KarLfe5hBRL9GpbqF99fUnJ8vszWuubvY/3SU
         jRVQ==
X-Gm-Message-State: AOAM5314d1xsULG9qnvQckHOgEz5hdGKTIgzxGvFowVKhMym2IOOX/Ca
        LRY2cWeOVHz3oIVzuxa2urJdFpL2/+24yqHRC5Y=
X-Google-Smtp-Source: ABdhPJz6Ww7PdNMdzibydhDP+YtzWHEjD9RauE40Y+CoRu399x7KHJFpQBvpbmNePwjis3QbG7fcxA==
X-Received: by 2002:a05:6512:15a5:b0:470:a63c:e602 with SMTP id bp37-20020a05651215a500b00470a63ce602mr1784913lfb.185.1650130963403;
        Sat, 16 Apr 2022 10:42:43 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id u18-20020a199212000000b0046ba06a6a19sm721236lfd.143.2022.04.16.10.42.39
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 10:42:40 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id u19so18493000lff.4
        for <mm-commits@vger.kernel.org>; Sat, 16 Apr 2022 10:42:39 -0700 (PDT)
X-Received: by 2002:a05:6512:2291:b0:46b:b72b:c947 with SMTP id
 f17-20020a056512229100b0046bb72bc947mr2938719lfu.531.1650130959084; Sat, 16
 Apr 2022 10:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220414191240.9f86d15a3e3afd848a9839a6@linux-foundation.org>
 <20220415021328.7D31EC385A1@smtp.kernel.org> <CAHk-=wh=Mu_EYhtOmPn6AxoQZyEh-4fo2Zx3G7rBv1g7vwoKiw@mail.gmail.com>
 <Ylpj9of+CP4ipDtm@zn.tnic> <29b9ef95-1226-73b4-b4d1-6e8d164fb17d@gmail.com> <Ylr8rR+LHQ1uGL47@zn.tnic>
In-Reply-To: <Ylr8rR+LHQ1uGL47@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 16 Apr 2022 10:42:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
Message-ID: <CAHk-=wgt=H-LXpXpsqS+nYQU4p+jW4izGs5RVS6k9uj0g_J2VQ@mail.gmail.com>
Subject: Re: [patch 02/14] tmpfs: fix regressions from wider use of ZERO_PAGE
To:     Borislav Petkov <bp@alien8.de>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Apr 16, 2022 at 10:28 AM Borislav Petkov <bp@alien8.de> wrote:
>
> you also need a _fsrm() one which checks X86_FEATURE_FSRM. That one
> should simply do rep; stosb regardless of the size. For that you can
> define an alternative_call_3 similar to how the _2 variant is defined.

Honestly, my personal preference would be that with FSRM, we'd have an
alternative that looks something like

    asm volatile(
        "1:"
        ALTERNATIVE("call __stosb_user", "rep movsb", X86_FEATURE_FSRM)
        "2:"
       _ASM_EXTABLE_UA(1b, 2b)
        :"=c" (count), "=D" (dest),ASM_CALL_CONSTRAINT
        :"0" (count), "1" (dest), "a" (0)
        :"memory");

iow, the 'rep stosb' case would be inline.

Note that the above would have a few things to look out for:

 - special 'stosb' calling convention:

     %rax/%rcx/%rdx as inputs
     %rcx as "bytes not copied" return value
     %rdi can be clobbered

   so the actual functions would look a bit odd and would need to
save/restore some registers, but they'd basically just emulate "rep
stosb".

 - since the whole point is that the "rep movsb" is inlined, it also
means that the "call __stosb_user" is done within the STAC/CLAC
region, so objdump would have to be taught that's ok

but wouldn't it be lovely if we could start moving towards a model
where we can just inline 'memset' and 'memcpy' like this?

NOTE! The above asm has not been tested. I wrote it in this email. I'm
sure I messed something up.

               Linus
