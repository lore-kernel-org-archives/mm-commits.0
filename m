Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8E4C77B61
	for <mm-commits@archiver.kernel.org>; Fri, 28 Apr 2023 03:03:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjD1DDm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Apr 2023 23:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbjD1DDl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Apr 2023 23:03:41 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD18F2709
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:03:39 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-956ff2399b1so1686804366b.3
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1682651018; x=1685243018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cSYUAhHGsv4p/YHSuQ4XkvXSQPBakl8RRPKNeekkNlA=;
        b=AvfuI8lNhw9F16NA3wNBqkfuac9y7byg8mQPlI7SFv3u8PcH3WlgBIbpTxTpgKEdN4
         8kv1NGZ4k7h/wv/NOF2wxgaNEiCBaSvogt6b/7bFEdb2M9J9nNbMoHNxTNPXZ/F5FXLH
         XGBp2ShaalNUaGvVdHXA27gAX1AbWo1fWNjPk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682651018; x=1685243018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cSYUAhHGsv4p/YHSuQ4XkvXSQPBakl8RRPKNeekkNlA=;
        b=eIcEHP6kkIzVFadqUUhSdMbTPoiWyWEXA9R5z/aWQixDdweRh+7bcDxoF7tOGPgXXC
         7oFn8oCvrYkIa/nh59n5e/D0/DBk9jfq4fOH2PlEsAEW/abih3xfNsM88c9fOWwxsebq
         SyRIMSlb6VP2eQ6gZkiXVUIO4h18EEhO4MADVUUvONSLeV8ueGOdpEHSt3E0wDnFaMCd
         OfT4sJdS4aQeL/bSWcK+3kB1vVOXk9Pe2jabAfHrP/3nveTviJglZkJpCd9FXOybVR5i
         F0DpdFf2DsPp8POBQCo1XP3UkUN2IOX94oo4okaxDdwW9L56cgMOzhCxB2Vt1OKhDUQp
         +0gA==
X-Gm-Message-State: AC+VfDzzfQn9Se5u7GbnM4LYGJKZe1EI5ThritRnX5DrYBQ9WdCKwj1w
        i6KRqT6vuM4nZFt2S0+Yljgd5GIImNdzTVmkhjAvcA==
X-Google-Smtp-Source: ACHHUZ5uSFYOWigBuVrmHRvfIkL3M494rV4e7JO7R47N4sbXeEJOfyq+r05yL9rTjUx50abWcrc/eQ==
X-Received: by 2002:a17:907:742:b0:94f:4801:6d08 with SMTP id xc2-20020a170907074200b0094f48016d08mr3609322ejb.71.1682651018197;
        Thu, 27 Apr 2023 20:03:38 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id ch21-20020a170906c2d500b0094e6a138170sm10554379ejb.72.2023.04.27.20.03.36
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 20:03:36 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5068e99960fso16144194a12.1
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:03:36 -0700 (PDT)
X-Received: by 2002:aa7:ca51:0:b0:509:f221:cedc with SMTP id
 j17-20020aa7ca51000000b00509f221cedcmr3189721edt.35.1682651016171; Thu, 27
 Apr 2023 20:03:36 -0700 (PDT)
MIME-Version: 1.0
References: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org>
In-Reply-To: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 27 Apr 2023 20:03:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi5=LfeCMv5ZPAtzWhJyW=y1rVJFTRBfgcqzoUNk5NRDA@mail.gmail.com>
Message-ID: <CAHk-=wi5=LfeCMv5ZPAtzWhJyW=y1rVJFTRBfgcqzoUNk5NRDA@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.4-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Apr 27, 2023 at 3:33=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> - Suren Baghdasaryan has improved mmap_lock scalability by switching to
>   per-VMA locking.

.. related to this, we have that new PER_VMA_LOCK_STATS config entry,
which is 'default y' and has basically no help test.

Please don't do that.

I don't think any of the VM debugging stuff should likely be 'default
y' in the first place, but if they are, they should most definitely
have a good *explanation* for why they should be on for a normal user.

                      Linus
