Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA69EC77B61
	for <mm-commits@archiver.kernel.org>; Fri, 28 Apr 2023 03:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345043AbjD1DQV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 27 Apr 2023 23:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344993AbjD1DQU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Apr 2023 23:16:20 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2131F2736
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:16:18 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-508418b6d59so17045641a12.3
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1682651776; x=1685243776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W7sdITuIFnEQoKW0N5OSKzGyU3doRmglDS9WyyDhnvg=;
        b=HefGwn9o1DUg/IOho8RxRAPza+qGGSkjPvqHmFMpHxci5DjPatouumxm9s+SuUL2iR
         96k/NyZWmfymVpUENyJqUyvOnpdLZn9pXT9OXHqll3GTLRASplJjoW3qiM2genfTKRBM
         7vScpiwuW3cOd230PhuYEAct7hix4y35h5/2I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682651776; x=1685243776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W7sdITuIFnEQoKW0N5OSKzGyU3doRmglDS9WyyDhnvg=;
        b=JvlVPG3iyia9vSiD4Ku7+6zJ34YfYa4buhT3BfGasqlDneQiseUFSCYoRTCEyuoYs0
         +frVmheIRwkp8iMxKtagUElJ0Kgq8UGeEE7VCeyMxRoeF6tli9ZiZHi8bbRPOqKD66b4
         8dcwkWImT6Yo/xSqxr7uTcKy+azDzgVSIFu2zmXRoP5qPfRcc/gLLHBY0dFgYp9/F4AA
         tvpxqw3fj7wEEe6uEbVWTrtKC/UYeFZbMFwLB/7aHmK4AG2KOx9lVNv70qnEhj/vSXKh
         NabsbdIk1RTlfD4Z+1ViE05yMNhctQXfebQR9EdNwnO7V/6HeVFa2mUt6qhIIrvx7YJ2
         D5Lg==
X-Gm-Message-State: AC+VfDxbsj30D/Q70uWYsWDPdayP/Lm1rpreJCV4BTXzAzpdXd3pL1WO
        bp0e8cHBI6V73ZhLAhAycPBeyZl7Ic33B6t+u2R1dw==
X-Google-Smtp-Source: ACHHUZ5fObdA9LRmqL12eLRYsfdUI1yNl6q3t+287Fm2YMLKmRzrKaaDaX7BWURuMBrysnHNdq0R6g==
X-Received: by 2002:a17:906:9c83:b0:953:603e:e939 with SMTP id fj3-20020a1709069c8300b00953603ee939mr4883290ejc.69.1682651776527;
        Thu, 27 Apr 2023 20:16:16 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id d9-20020a17090694c900b0095354acf666sm10591072ejy.92.2023.04.27.20.16.14
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Apr 2023 20:16:15 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-959a3e2dc72so1152992966b.2
        for <mm-commits@vger.kernel.org>; Thu, 27 Apr 2023 20:16:14 -0700 (PDT)
X-Received: by 2002:a17:907:5c1:b0:94a:90e5:b2b6 with SMTP id
 wg1-20020a17090705c100b0094a90e5b2b6mr3512007ejb.58.1682651774330; Thu, 27
 Apr 2023 20:16:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org>
In-Reply-To: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 27 Apr 2023 20:15:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjaYXeWKsyifQCS=gJf4mxav-b6cdf5boKpMO6M1C-2LQ@mail.gmail.com>
Message-ID: <CAHk-=wjaYXeWKsyifQCS=gJf4mxav-b6cdf5boKpMO6M1C-2LQ@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.4-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Matthew Wilcox <willy@infradead.org>
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
>   git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-20=
23-04-27-15-30

Ok, so all the merge conflicts looked straightforward enough (except
the one I asked Vlastimil to look at - and that conflict was tiny and
straightforward too, it was just in a really grotty place).

However, let's not get cocky - so I'd ask people double-check my
conflict resolution, even if it looked fairly straightforward.
Mistakes happen.

Most of the bulk of the conflicts were around __filemap_get_folio()
now returning an ERR_PTR, particularly then with Willy doing the ext4
folio conversion.

So Christoph, Willy, mind just double-checking me?

                 Linus
