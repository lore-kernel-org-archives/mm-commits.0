Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B3C2C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 23:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiLLXdW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Dec 2022 18:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbiLLXdV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2022 18:33:21 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F27C15FF0
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 15:33:20 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id h16so10475064qtu.2
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 15:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fga4qUrgOLw2yQYkt0IWHNCALPR+bSFXVXGNvrtam+g=;
        b=T89ajwxpcbXcHjR4PtXDmD5i/UX6zN5Mci2FNmYP6Ijn1+KckGeEdjUWpRMxmZeOLI
         hD36lMGIXsQ3E93rqbcuvZYuI6IKua/cwG0SEix+oUGyQH7q+OzRmdqXKprP483jb0Na
         FTbS4RbkuQ/R9SYqhH2ac8MWZfGA8NiE5Lk0U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fga4qUrgOLw2yQYkt0IWHNCALPR+bSFXVXGNvrtam+g=;
        b=Vb2xicOLsQ5ihAeW85gTReISSxbbeDcEwKXDGXNRqlXwdh+3+JJhD21aQGrq+R8Gcu
         KztJJYyqVFDiEj2QbdURZV1PdnRj2tX4WDv7Lz6KuefsGAcVJfIS3HrqVfrYMJDalhOR
         VvreAelKor1PtGn+OW3LP5Ah60DCtMe5cL1IOFD2j0GJ70Am9AhrNoUjFJn07RVG65y6
         FJM8igZb05lWJUqr4crq90UFc0GW3g5GeVe/ZuIAzeQw7jypfAmwgWmM/M8setLS5CZ2
         jy7zFvW2oGK4zEuB7X+CFV+D4vm/siVdCHn7Va9FDBWtLIMIjnw2fQN2ITJSInfmd5mX
         Nd9Q==
X-Gm-Message-State: ANoB5pm2oN/2dbOK1hFuDxcTQc5Q+KnWDz+lMxyxN05D1CVk1FvFgAtx
        SI/+7YHtdYe7c7J9WliP9DEeBY2qf4nmQ3Na
X-Google-Smtp-Source: AA0mqf6YCbHjRIYFR1Qe31swq4yVIuTWjZafFxOU7o4A+xk2BI8HgGMDJjiy1nQSFZPZxXCgTg1aGQ==
X-Received: by 2002:ac8:647:0:b0:3a6:9069:ed37 with SMTP id e7-20020ac80647000000b003a69069ed37mr20383201qth.2.1670887998994;
        Mon, 12 Dec 2022 15:33:18 -0800 (PST)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com. [209.85.219.47])
        by smtp.gmail.com with ESMTPSA id x9-20020ac87ec9000000b003a57a317c17sm6548361qtj.74.2022.12.12.15.33.18
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 15:33:18 -0800 (PST)
Received: by mail-qv1-f47.google.com with SMTP id h10so9285606qvq.7
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 15:33:18 -0800 (PST)
X-Received: by 2002:a0c:c790:0:b0:4c6:608c:6b2c with SMTP id
 k16-20020a0cc790000000b004c6608c6b2cmr68762628qvj.130.1670887997972; Mon, 12
 Dec 2022 15:33:17 -0800 (PST)
MIME-Version: 1.0
References: <20221212134425.b20b80955e5e8a4a36ce1b9a@linux-foundation.org>
 <Y5eoS/UfBhovR70j@zx2c4.com> <20221212142754.5f699c4ff515fd9d42768fb2@linux-foundation.org>
In-Reply-To: <20221212142754.5f699c4ff515fd9d42768fb2@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 12 Dec 2022 15:33:02 -0800
X-Gmail-Original-Message-ID: <CAHk-=wisHBccs=VyL5DBUOmd2pge4OM6An9T600B4rmgnX5mNg@mail.gmail.com>
Message-ID: <CAHk-=wisHBccs=VyL5DBUOmd2pge4OM6An9T600B4rmgnX5mNg@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM commits for 6.2-rc1
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Dec 12, 2022 at 2:27 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Is there some way of telling git to complain about identical changes
> when doing a trial merge?

No, the merge functionality of git literally doesn't care about
individual commits.

(git does walk the commit chain as part of finding the common
ancestor, but apart from that, very fundamentally merging in git is
*not* about merging individual commits at any point. None of the darcs
"patch algebra" nonsense).

But as Vlastimil pointed out, git does have various log-based models
for finding identical patches based on the patch ID.

Those are intentionally not used for merging, but for the various
"move patches around" models (cherry-picking and rebasing).

           Linus
