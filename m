Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7E8DC00140
	for <mm-commits@archiver.kernel.org>; Fri,  5 Aug 2022 23:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241598AbiHEXVG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Aug 2022 19:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241596AbiHEXVG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 Aug 2022 19:21:06 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CF327FFC
        for <mm-commits@vger.kernel.org>; Fri,  5 Aug 2022 16:21:04 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k26so7434050ejx.5
        for <mm-commits@vger.kernel.org>; Fri, 05 Aug 2022 16:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=iJnXDkhY3WibcgHqNJ/apiNs6qhmQXpZMLsKos5BMCQ=;
        b=eFUwGAvhoJ8EEYaGa/arj7adR8QlkncfXKcdX7iXgroj9yZ+Gm7dJ7Ts8/p6/xX1J5
         x2r64ctbmyaFhx/lwup2rv3LDgDyHASHgKfhjxJiW6vrzdpSBUQpTRk11nT06VQg+LMi
         l9uKIxCdZxEdhmLdSRr30emGV+zBPUQDQ3YRY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=iJnXDkhY3WibcgHqNJ/apiNs6qhmQXpZMLsKos5BMCQ=;
        b=wxVXsxWr1dq9qJrvj/xUsAOAuMfT2cXRX3rkFLAY7eHQMYd9M1e0k1TzXrhoihFOQL
         AI0bVW9XCXOSvkALjOaLlUcAvHTX1FalBPsXc3ompDneGLGHyvfuFenZ8zk2a36FLvMf
         jNHKJCDpva9U/GMpbfyrkXV5B5TjS6ySuvmCYoo0tCM1XOvH8lceEOnMO0eVFbEpcmpx
         XZ73gCtQThbwHqjUCB3rFsCzk17z6wq50YsxSwydnNi25mMruyFDWYTj4eu/EUmH4F4T
         YGsdHYSWLdaqnnClumzHGImCrHq2aQyLb27ovx7YwWcJmqlhO4dHVEVCSbzKMfLJN2UN
         FePQ==
X-Gm-Message-State: ACgBeo0DOF117zjTtbrXBnU4uBF/rBAm8aHXVMXNxGambEuDJmxPVw6A
        vb59218f2IrasJtPhzSW1W+G+eTWezeaklCU
X-Google-Smtp-Source: AA6agR6QVBNv+odWPLkMxjJsN0ceeYb6yruhlxkgk5p+fh/04Qjn5uZ8o1PBPd2AREOc/z+lPJ0wcw==
X-Received: by 2002:a17:907:9707:b0:730:92f0:9c59 with SMTP id jg7-20020a170907970700b0073092f09c59mr6720165ejc.352.1659741662534;
        Fri, 05 Aug 2022 16:21:02 -0700 (PDT)
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com. [209.85.128.51])
        by smtp.gmail.com with ESMTPSA id u19-20020aa7db93000000b0043bbb3535d6sm575369edt.66.2022.08.05.16.21.01
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Aug 2022 16:21:01 -0700 (PDT)
Received: by mail-wm1-f51.google.com with SMTP id c22so2038657wmr.2
        for <mm-commits@vger.kernel.org>; Fri, 05 Aug 2022 16:21:01 -0700 (PDT)
X-Received: by 2002:a1c:f603:0:b0:3a5:23ca:3e7c with SMTP id
 w3-20020a1cf603000000b003a523ca3e7cmr1634050wmc.38.1659741660817; Fri, 05 Aug
 2022 16:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220803133541.18b82ec9344ed0e8b975fe5b@linux-foundation.org>
In-Reply-To: <20220803133541.18b82ec9344ed0e8b975fe5b@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 5 Aug 2022 16:20:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wheFdrnTLNhw6+2ekT_AuJHXHTWEKVQyJrA864mmjFKtQ@mail.gmail.com>
Message-ID: <CAHk-=wheFdrnTLNhw6+2ekT_AuJHXHTWEKVQyJrA864mmjFKtQ@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 5.20-rc1
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Aug 3, 2022 at 1:35 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> There are 6-7 conflicts with your tree here.  All very minor, mainly
> related to the rename of Documentation/vm to Documentation/mm.

What? No. Yeah, the doc conflicts were annoying enough, with the
Chinese translations having incorrect pointers to the original sources
both before and after the move in the MM tree.

But that xfs conflict was positively nasty and definitely not minor.
Had to look up Darrick Wong's "here's how to do it" message from the
linux-next days.

So I think I got it all right, but "very minor" it wasn't.

              Linus
