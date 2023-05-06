Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E29EC77B7F
	for <mm-commits@archiver.kernel.org>; Sat,  6 May 2023 18:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjEFSxi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 6 May 2023 14:53:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjEFSxh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 6 May 2023 14:53:37 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E6B160B4
        for <mm-commits@vger.kernel.org>; Sat,  6 May 2023 11:53:36 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9661047f8b8so141715166b.0
        for <mm-commits@vger.kernel.org>; Sat, 06 May 2023 11:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1683399214; x=1685991214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEGG4ECcZAyCqo1XIgGFB1QnJid3wS71S4I77W9mGF8=;
        b=cocDxGs6XB/b6nzG0IMXjMDF+UbL4smAz+yZrfei93lzQCkURr2D+nlzkSqVTvyv/0
         c+vx8jIgdVJ1p+EagHaE2Eybeu133yWHRvhqNfnkXlSFlZ+EomI6553XsHyYaF4EXP43
         2JgdggDt9FtI3JKFogbBT4ANHA/Bir0Qh92qU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683399214; x=1685991214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yEGG4ECcZAyCqo1XIgGFB1QnJid3wS71S4I77W9mGF8=;
        b=cKm0ss4Y3YXxPUKbasoBMdlIipYfYyIXIB0UDtnES7xbtyYPAVLdNxjtmyaims16HE
         rg53gZHJLtUriiVoBTThc4P1Sa658+3Sr8qs+QX1qBQBn73KnAtE9Qh7a2YgGmt2MLkG
         WbI7u0ZKWd78jBttyNgl/DvoRSg3Rp5BqrwfcuPllc52WH0oTZy3GYx6f//7d/3MyWFP
         ozjwo4IlAlkFrWNWzTVKGw93QgmDXNB/CWjiq3dhq+n6x7rZ7FtOBp37+rhJszjHYX9u
         hB/SKdfwFtMJrS2S/ZYopGu1B09NiEa/TwEDsyG3X2NcMOBSByQtmMUpQvwqs+HmmtAu
         DUmQ==
X-Gm-Message-State: AC+VfDxJOtGlTo1GcHujgICUG1BTAaBVW4UmbGrZIHnEa0CUYDryk6zq
        jcS5V+/rSvRpCJLLNQHg8kaKXJ17oOJCrxXKhMPkbQ==
X-Google-Smtp-Source: ACHHUZ5iBdERQBCrUOFvaq6GzfocKgsc2cPr8i3r1Vabi2icnjJE0nI/Dd0/N1LkJg9TWE3TtIPGtw==
X-Received: by 2002:a17:907:1614:b0:8a5:8620:575 with SMTP id hb20-20020a170907161400b008a586200575mr4579606ejc.3.1683399214378;
        Sat, 06 May 2023 11:53:34 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id p24-20020a1709065dd800b0094f44bdf7acsm2647207ejv.57.2023.05.06.11.53.33
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 May 2023 11:53:33 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-9659e9bbff5so540967166b.1
        for <mm-commits@vger.kernel.org>; Sat, 06 May 2023 11:53:33 -0700 (PDT)
X-Received: by 2002:a17:907:60d2:b0:966:1284:e3e with SMTP id
 hv18-20020a17090760d200b0096612840e3emr2378640ejc.9.1683399213047; Sat, 06
 May 2023 11:53:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230506105054.0155139b3d3a7f249ead37be@linux-foundation.org>
In-Reply-To: <20230506105054.0155139b3d3a7f249ead37be@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 6 May 2023 11:53:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wheZHs+15jtg68=Fjf0==xvfZ5rvTE00ii+MDUhWzxfgw@mail.gmail.com>
Message-ID: <CAHk-=wheZHs+15jtg68=Fjf0==xvfZ5rvTE00ii+MDUhWzxfgw@mail.gmail.com>
Subject: Re: [GIT PULL] dmapool updates for 6.4-rc1
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, May 6, 2023 at 10:50=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> Reinstate the dmapool changes which were accidentally removed by
> 2d55c16c0c54 ("dmapool: create/destroy cleanup").

Hmm. So this series is exactly the same as def8574308ed..2d55c16c0c54,
except for not having that last broken one.

Which is fine, but I'm a bit surprised. Why?

Because it's also missing the _real_ "dmapool: create/destroy cleanup"
patch, ie this one:

   https://lore.kernel.org/linux-mm/20230126215125.4069751-13-kbusch@meta.c=
om/

and I realize you somehow corrupted it last time, but I did expect it
to show up (perhaps folded into another patch, but in _some_ form).

Anyway, I've pulled this, but I think the end result of all this
confusion was still a tad broken.

                   Linus
