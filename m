Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABD2C6FA8E
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 04:04:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjBZEEE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Feb 2023 23:04:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjBZEED (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Feb 2023 23:04:03 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49F91165B
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 20:04:00 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id ec43so12785063edb.8
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 20:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ydNEG6i1njPpUhHYW477txuJZoyUfrSlN9+lyZsORZc=;
        b=hKCI8tDvdl2kgPalORYkss42z/GJoxbrfe3A/5gvmIAGDcVYq3bjAc3T1Cgk65q6Nl
         pzDK949pAA3tAIRY/870y/f7xX/8fWCeOQ7z/oRTYDDmjS8HoxYo6yX4bZicQr+H0j9r
         BEpdWOxbdwmjZJwQKBixM24rAYWHhc7+iW4gk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ydNEG6i1njPpUhHYW477txuJZoyUfrSlN9+lyZsORZc=;
        b=rCt/FXlvxE5NjW7NfqEbvNt37vrmU5K0YIGJZO+UnUyS1Y7P5YdYaPJl8HIn9+0h26
         9x/1CNsgbTLScDiSYsJjS0Wm0NgYs87rgDXlbuxPyCQAmxI4t/xFTi/UsRQufGds1dw3
         beDnFd/WpbQNp+h6VEWx71wvdTV6JKAqwAE0wQZJY2i84M6jgqtArpf4S3+xjeVtoPh8
         Qr+bHzZrGt7NuaciA1pE2FUycr67JFAmCXFLH7ieidPkEZcqlhZCmcPaPFyaf0Irogit
         KoFuvsppJSkHiqwI+eY5IlOx0VDoOnhO/ifH5f9Ce0vCVagt0IgFuoY8Mq7040aHgsQQ
         +Xew==
X-Gm-Message-State: AO0yUKXd0qoI8Jyzc8RNs5JYoqQvb0PkzCeFU32Z7ELllgi6AHVu6mA4
        0MoHYfHMi3rL9YsOVNl8lqbCZMrAK54zgPyMIymbkA==
X-Google-Smtp-Source: AK7set/8VIpugB+2TK+RcRSio+QMWDiVlnDGR247L4hkZL8dem/uNokY5OzTHFD3xqwGAVhFwTWg9g==
X-Received: by 2002:a17:907:3e22:b0:8e3:8543:8e71 with SMTP id hp34-20020a1709073e2200b008e385438e71mr22347973ejc.40.1677384238977;
        Sat, 25 Feb 2023 20:03:58 -0800 (PST)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id w2-20020a17090649c200b008c16025b318sm1521257ejv.155.2023.02.25.20.03.58
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 20:03:58 -0800 (PST)
Received: by mail-ed1-f47.google.com with SMTP id da10so12890533edb.3
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 20:03:58 -0800 (PST)
X-Received: by 2002:a17:907:73c6:b0:8f1:fd:50d0 with SMTP id
 es6-20020a17090773c600b008f100fd50d0mr4382163ejc.0.1677384237911; Sat, 25 Feb
 2023 20:03:57 -0800 (PST)
MIME-Version: 1.0
References: <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
 <CAHk-=whVN2gKO_7UvMqgG8cetrVs3BCTxQovJvhC5x7AcJDJgQ@mail.gmail.com>
 <CAHk-=wgxWDgLJ-e3uDiYQvmMEqTNYFvDxtHbu4inR=zgBEP11Q@mail.gmail.com>
 <CAHk-=wjFmVL7NiuxL54qLkoabni_yD-oF9=dpDgETtdsiCbhUg@mail.gmail.com> <20230225195727.1b73a356f4f1a79833a31885@linux-foundation.org>
In-Reply-To: <20230225195727.1b73a356f4f1a79833a31885@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 25 Feb 2023 20:03:41 -0800
X-Gmail-Original-Message-ID: <CAHk-=whpy3yHt0X5Vb97kdvtryj93KVTJs07zLZVJ8zEXH=Q-A@mail.gmail.com>
Message-ID: <CAHk-=whpy3yHt0X5Vb97kdvtryj93KVTJs07zLZVJ8zEXH=Q-A@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.3-rc1
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Feb 25, 2023 at 7:57=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> Liam sent us a fix yesterday, hopefully this?

Will test right away. It's certainly right in that suspicious area.

                Linus
