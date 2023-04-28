Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8941C77B7E
	for <mm-commits@archiver.kernel.org>; Fri, 28 Apr 2023 16:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345429AbjD1QIo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Apr 2023 12:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjD1QIn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Apr 2023 12:08:43 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6D2E4E
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 09:08:42 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9505214c47fso1899245766b.1
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 09:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1682698120; x=1685290120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bfSng8MyOFNSU5Ks9K4WLSf/Qc3whKmNVFv1pCFwpjk=;
        b=O8g848DJeseueizHHVIzA0f3tTIGKKEXoHTt7sXb5VF4P7/ebVhCkTmVhe6AQFmNM6
         ayBFXHO4liBzfmy/oKEXALOZCjlZHRxEktwMTGTCSPN4aq21rdu2KniJvFdG3p3rcXNU
         ypjsr0Q3d05EluCdndJa4WBETM/PmkS3RrQjw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682698120; x=1685290120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bfSng8MyOFNSU5Ks9K4WLSf/Qc3whKmNVFv1pCFwpjk=;
        b=BPOzNIJTv9swivKkC9jRUqzD6Yg8hl4rj3qSjCy2xtEW+3p1S2lRFfm/tuLJ1NWylQ
         ywBbjLbmON7MzJ0PQCXrSPfz03nTzRt56tuuG+agPC2UwmIXq+3h6waz7vX/61nmtYir
         jDBx8MK8XVJO09pJwxy4wVr8F/MR/P1jrQWwpdzK1pTTRp+OlORGWlDu0CwWPMPoo703
         PVXjontRlrBsxa0Z/HY0HDCS5hwih2yj158AEDGLfZanxnT4HCLMtpKvO/56MLQeoW9H
         7/Gv4a7EMpYQum10amBs2zq91vfX/eiPUJYWuIIlTGPkqMiR7lqnKnPRIu/hvNLR33e+
         S4hw==
X-Gm-Message-State: AC+VfDzbmoMncz8ZBOMAJii2Cz6l0rFfnh6bzQDM2ewMU1s3MiVKRAw9
        Cb5XtBYpcqRDT2NH3+xYw9KTPI88QZpun70q8tzKdg==
X-Google-Smtp-Source: ACHHUZ4Rea2oHq2kAZv9Mjj2ufagay+BuxuCXER/WVyLE8b0caMvp+BDX8zkbSp9HEUM4Zpdw7NxSg==
X-Received: by 2002:a17:906:7950:b0:958:47b5:ec30 with SMTP id l16-20020a170906795000b0095847b5ec30mr6857447ejo.26.1682698120233;
        Fri, 28 Apr 2023 09:08:40 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id qn7-20020a170907210700b0094e44899367sm11277723ejb.101.2023.04.28.09.08.38
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 09:08:39 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-956ff2399c9so1819671166b.3
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 09:08:38 -0700 (PDT)
X-Received: by 2002:a17:907:988:b0:959:bbda:fa51 with SMTP id
 bf8-20020a170907098800b00959bbdafa51mr5254889ejc.41.1682698118661; Fri, 28
 Apr 2023 09:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org>
 <CAHk-=wi5=LfeCMv5ZPAtzWhJyW=y1rVJFTRBfgcqzoUNk5NRDA@mail.gmail.com> <CAJuCfpHZSEjG2nti5iWbPQjWgXcHZ95hFS2FKwaPC-sZPdSznw@mail.gmail.com>
In-Reply-To: <CAJuCfpHZSEjG2nti5iWbPQjWgXcHZ95hFS2FKwaPC-sZPdSznw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 28 Apr 2023 09:08:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg0SyFDp_sdcEH-D+LNxuzL_dWA1vZEowUN16n_+yRHPQ@mail.gmail.com>
Message-ID: <CAHk-=wg0SyFDp_sdcEH-D+LNxuzL_dWA1vZEowUN16n_+yRHPQ@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.4-rc1
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Apr 28, 2023 at 9:03=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> I wanted these stats enabled by default to be able to identify
> possible pathological cases and to also let users disable them if they
> can't tolerate even a small overhead in the pagefault path. Should I
> document this reasoning for the config option?

You should document what the stats actually count (at a high enough
level for a user to understand), and why anybody would want to keep
them on.

Honestly, 99% of the time, these are things that *developers* think
they might want, but that nobody else will ever ever use.

Really, ask yourself if a normal user would ever look at them?

Now, ask yourself whether this might be something that a cloud
provider would want to look at to gather statistics.

And if it's the latter case, then it should be "default n", because
the default should be for the people who DO NOT KNOW, AND DO NOT CARE.

The cloud provider will be using a custom config anyway. The default
is irrelevant for that use. The use that *matters* is literally the
clueless end user who I bet will never look at these numbers, and will
never be asked for them.

               Linus
