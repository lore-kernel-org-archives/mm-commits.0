Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C0BCC77B7E
	for <mm-commits@archiver.kernel.org>; Fri, 28 Apr 2023 16:20:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345910AbjD1QUc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Apr 2023 12:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346028AbjD1QUb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Apr 2023 12:20:31 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 829DD103
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 09:20:29 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-94f3cd32799so1931891966b.0
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 09:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1682698827; x=1685290827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0r3+Q951qW+5Zp+jfP21B0X2Vqy1oBdvEig1isGyoXM=;
        b=gZf2E4bxz19MpEiZOueSKszJapF8b+h5Ew4oS34roi3ER/TbnE+Yfdw9ixuDIEp5Nl
         hn2FrV0XD4VbjxAolxLpdXZD///mDyqYSbx+TOrr1YNPNggoGcv7kHE3euyJ5Ut8w877
         apfGNyWe1GtpfSh9hGGM1+X1mm7EKWH8RjppA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682698827; x=1685290827;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0r3+Q951qW+5Zp+jfP21B0X2Vqy1oBdvEig1isGyoXM=;
        b=eE/rohqnAFO66Scyta1oxC0OGgLlmOdYv/SWST5JC5ahfAPkAzDl3JixB6nR/N3w3w
         SdMHu+KMAA99+bKVyNsZfse0CbtNzpjDa+hOlY+ViMGwSQ0uFOkJz216MWYb4QuBICZ1
         ZJZvTPT+x9oV6s+ctjqqGeeIIW87kEldkiPhgas54oI1f+pVn3vtmulftI8CAQbtv4o3
         +5nvncOsf2qoriQgPH7oMMKi9eBbpHROCpC0r5UpXtnLbqUgWDP/lfT5+NvzzV6HeIxL
         dIHJ2Dl7nWlakb0iYNuyoLXR2QJWRFRolGL7SeomrKpjrjM2w2rlt2qTl7M1ydKtlNmq
         1WzQ==
X-Gm-Message-State: AC+VfDz2qjjc7417NOecLoA++YOx8CdP/AcZbwmKJZ6DwRvYIhO2eK9j
        Eqm1NHrq8AQq+VP3H4UUWGwod+Qn8pWgD314BzwemA==
X-Google-Smtp-Source: ACHHUZ7+iz1GlTL33P9M7q3ji6j7pmGORQVWxTwEn0SLeIWTJb0lpInNK8fQkmfH/+K327Qa+WkZYw==
X-Received: by 2002:a17:907:3183:b0:94e:c97b:e3ba with SMTP id xe3-20020a170907318300b0094ec97be3bamr5323859ejb.37.1682698827507;
        Fri, 28 Apr 2023 09:20:27 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id j15-20020aa7c40f000000b0050488d1d376sm9384947edq.0.2023.04.28.09.20.26
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 09:20:27 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5052caa1e32so17891079a12.2
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 09:20:26 -0700 (PDT)
X-Received: by 2002:aa7:d941:0:b0:504:8c15:a132 with SMTP id
 l1-20020aa7d941000000b005048c15a132mr4371919eds.7.1682698826625; Fri, 28 Apr
 2023 09:20:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org>
 <CAHk-=wi5=LfeCMv5ZPAtzWhJyW=y1rVJFTRBfgcqzoUNk5NRDA@mail.gmail.com>
 <CAJuCfpHZSEjG2nti5iWbPQjWgXcHZ95hFS2FKwaPC-sZPdSznw@mail.gmail.com>
 <CAHk-=wg0SyFDp_sdcEH-D+LNxuzL_dWA1vZEowUN16n_+yRHPQ@mail.gmail.com>
 <CAJuCfpHouhrEtomhPe2sf+p0oG4pGFKb3xidhOXP6BN-PydY-Q@mail.gmail.com> <CAJuCfpGcnJiJyU78v1r548W3bZ2LyfaYpr5huKKG8-WaiRHFHA@mail.gmail.com>
In-Reply-To: <CAJuCfpGcnJiJyU78v1r548W3bZ2LyfaYpr5huKKG8-WaiRHFHA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 28 Apr 2023 09:20:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjj7tM9ER57Ed3LAOaxMLM3t5nkA=dYSyN-nKPFbOmAZw@mail.gmail.com>
Message-ID: <CAHk-=wjj7tM9ER57Ed3LAOaxMLM3t5nkA=dYSyN-nKPFbOmAZw@mail.gmail.com>
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

On Fri, Apr 28, 2023 at 9:17=E2=80=AFAM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> Should I send a replacement patch for "mm: introduce per-VMA lock
> statistics" or a followup patch fixing it?

I've merged the MM pull request, so it's all in the kernel now, but
I'd like to see a follow-up patch with more of a help text and that
'default n'.

                  Linus
