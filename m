Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90876C678DB
	for <mm-commits@archiver.kernel.org>; Sat,  4 Mar 2023 23:37:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCDXhd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 4 Mar 2023 18:37:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbjCDXhc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 4 Mar 2023 18:37:32 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C715E12079
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 15:37:31 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id i34so24388991eda.7
        for <mm-commits@vger.kernel.org>; Sat, 04 Mar 2023 15:37:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1677973049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8+/lbf3pRH4GEnXXO6XgzXlucudkUa6edzWyNE+Dnks=;
        b=XZhnPUxDdrVyuhYQGEvuqFyLspoLTzdRrYf9kmy9BUAB1BSurTrpDbdw+/DcTzlHx4
         GLva4noO4jKZUtwiHdx0f6D+q0CXBPZymx7+AnMhZEcvVsXoUirURjHz9N6mssGungAD
         Pks23WRVCYI7d3e9+a5FePAut1FivnfaQU030=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677973049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8+/lbf3pRH4GEnXXO6XgzXlucudkUa6edzWyNE+Dnks=;
        b=zhT87yksl94DDIaFIQzoccrGjObONxAyjIUtHpYv/xgrlHNRzhgXrIZnokHJN31O3/
         JYv4plXV0fHTrmSyaGwxEJ2iirhb9KaNxiUNyARObQ2FS+lgpiV9IuQL48zoDjc6cZ0l
         CgI4mfTOapLaVuh3N3NIrm4JAFGrdtaXOHaJqHd0PwQzSi2skGrOmTLHYKeQ2AMXvboT
         V7pVHDNJRa/3JlP5oMzc7bU5xd8Vl7WieusdzcqUFI1U0YyfeborgKgpqHEcBtfAehjz
         Rj0HAXV65R921SWf7asGKrMq0O9um74LcZJYMFOXYE6DIm19UTkJB1abeVmDtFd/vPBh
         46Wg==
X-Gm-Message-State: AO0yUKVcB1aDovBo6MaCLzDJ86SPm4+VZhpGcrPKXLhlgo51Anjs5c0i
        rrHlNqVpGq2VfBWZKBIoiK8KLRAicQgQ5XYrDtSi5w==
X-Google-Smtp-Source: AK7set8FsXYlAd3pVf9TPE+bKqSGwsg8o9BLrzejTcRLIxM3tje0MNfUR1mTtj79/Vd6mEfK932lRw==
X-Received: by 2002:a17:906:f8c8:b0:8b1:16b3:303e with SMTP id lh8-20020a170906f8c800b008b116b3303emr6677421ejb.65.1677973049593;
        Sat, 04 Mar 2023 15:37:29 -0800 (PST)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id my22-20020a1709065a5600b008eabe71429bsm2547221ejc.63.2023.03.04.15.37.28
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Mar 2023 15:37:28 -0800 (PST)
Received: by mail-ed1-f49.google.com with SMTP id k10so518559edk.13
        for <mm-commits@vger.kernel.org>; Sat, 04 Mar 2023 15:37:28 -0800 (PST)
X-Received: by 2002:a17:906:2bc2:b0:8f1:4cc5:f14c with SMTP id
 n2-20020a1709062bc200b008f14cc5f14cmr2954554ejg.0.1677973048247; Sat, 04 Mar
 2023 15:37:28 -0800 (PST)
MIME-Version: 1.0
References: <20230304131528.4645d19a2ab897fb7518159e@linux-foundation.org>
 <CAHk-=wj9guryjifHyr26w73ta+kNeoHtGde682Z5N6OSjKu4UQ@mail.gmail.com> <20230304152058.de91bf7abf424383ce31d500@linux-foundation.org>
In-Reply-To: <20230304152058.de91bf7abf424383ce31d500@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 4 Mar 2023 15:37:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiHX2NQiVH8uQZ_U8vB=qnzmQHauGAqAkC=4ZWp95ya8w@mail.gmail.com>
Message-ID: <CAHk-=wiHX2NQiVH8uQZ_U8vB=qnzmQHauGAqAkC=4ZWp95ya8w@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.3-rc1
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Huang, Ying" <ying.huang@intel.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Mar 4, 2023 at 3:21=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> Ah. Ying did it this way:

Yeah, I saw that patch flying past, but I actually think that it only
silences the warning almost by mistake. There's nothing fundamental in
there that a compiler wouldn't just follow across two assignments, and
it just happens to now not trigger any more.

Assigning to a union entry is a more fundamental operation in that
respect. Not that the compiler still doesn't see that it's assigning a
value that in the end is not really type compatible, so a different
version of gcc could still warn, but at that point I feel like it's
more of an actual compiler bug than just "oh, the compiler didn't
happen to follow the cast through a temporary".

            Linus
