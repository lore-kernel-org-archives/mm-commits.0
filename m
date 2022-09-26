Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4049C07E9D
	for <mm-commits@archiver.kernel.org>; Mon, 26 Sep 2022 20:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiIZU1Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 16:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiIZU1Q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 16:27:16 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4A09D50F
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:27:14 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id j8so5006301qvt.13
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Pv5o0TZDNeMSmawH17qKug3meL3WXlOBL4IBJGeG49U=;
        b=UQlvvWuczzs8yMB6KJ+ZljBN9ggCx4G2t3ZTV/A4bUN9+n48zAXu+mOVF15HggPjnl
         XGDMDrigHgz1teUmP0SgEtVbkqSvHMqzsfMib3MIt2CGPsqFyk7je5c3SrB5bF68x3c9
         hOLme/WPVtibnauDZDMSIKwT+9Ao29kjUEm2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Pv5o0TZDNeMSmawH17qKug3meL3WXlOBL4IBJGeG49U=;
        b=IisLVuYDF4r9AEKrKz7l0zImtZYS3VFLWqM/aNngo9IohhpoXRyw0hhZwY2gZ5EZhX
         RKNlhOjgvF4LzA+yJuNSs51oxGQPc36AcPGGvY1Mr8RD5vyb8AyVrJQJTOlKTCh6Yy+w
         /HPzsCSqWMZj+s06vGBIYzgISRATFc6kLC8UbNUErpskQAYi7P256niWxyu/hi9rrnUG
         8aEa88vCr7KeMk4Mi8ZKo9ssvFs38n51RGpWfou5YeoIWkqVyZQgqFfc9iVUHOWpXtOL
         gyFTDqBC1o+0kk5YZTjSceV55WUH1W7QorexyfVGM7CQ2GwjGdXOnuF8Tf36msAwgZ99
         s4SQ==
X-Gm-Message-State: ACrzQf2tmOzgyLwsj+nPotW0EZxFrwKTgOlc8mgvtvPMz7jkMNIc7gf7
        9Y/M3IkFpq9+pkJDrcFf+ylj6+DLIR7Q+A==
X-Google-Smtp-Source: AMsMyM6Q2SVYePJXMB26oOeMGpkonWjqAVDhfsSQVT1tse+3J510drKSGLXPtiohAsbExUloJOqgNg==
X-Received: by 2002:ad4:596f:0:b0:4ad:79fc:9ae0 with SMTP id eq15-20020ad4596f000000b004ad79fc9ae0mr18807131qvb.53.1664224032947;
        Mon, 26 Sep 2022 13:27:12 -0700 (PDT)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id t15-20020a37aa0f000000b006cbc6e1478csm11754467qke.57.2022.09.26.13.27.11
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 13:27:12 -0700 (PDT)
Received: by mail-yb1-f171.google.com with SMTP id f189so9818477yba.12
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 13:27:11 -0700 (PDT)
X-Received: by 2002:a05:6902:1352:b0:6bb:3f4b:9666 with SMTP id
 g18-20020a056902135200b006bb3f4b9666mr6940475ybu.101.1664224031612; Mon, 26
 Sep 2022 13:27:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220926123721.2a1edc734b4fc516a9a350b8@linux-foundation.org>
In-Reply-To: <20220926123721.2a1edc734b4fc516a9a350b8@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 26 Sep 2022 13:26:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=wihk0cRP_ZPFPsewJQ2KOM05i87jYUxcdMpok8a+fduKw@mail.gmail.com>
Message-ID: <CAHk-=wihk0cRP_ZPFPsewJQ2KOM05i87jYUxcdMpok8a+fduKw@mail.gmail.com>
Subject: Re: [GIT PULL] hotfixes for 6.0[-rc8]
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Sep 26, 2022 at 12:37 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> 26 hotfixes.

Ugh. It would have been very good to have gotten these (or at least
the bulk of them) a day or two ago, so that they would have made it
into -rc7.

Oh well. Pulled.

               Linus
