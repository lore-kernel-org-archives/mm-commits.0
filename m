Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86620C43334
	for <mm-commits@archiver.kernel.org>; Thu,  9 Jun 2022 17:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiFIRDO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Jun 2022 13:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237847AbiFIRDN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2022 13:03:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B793EEE1C
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 10:03:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56BB061976
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 17:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6898EC3411B
        for <mm-commits@vger.kernel.org>; Thu,  9 Jun 2022 17:03:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="ma2PIqGh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654794188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b+3hceIvLw4btixLxKr7UfUeGuJ2c7KfkhxtxDnIjwk=;
        b=ma2PIqGh34cPPmXQo64Vve+zbL9a96J/mwe/so9yuLJeYw4O6rJw5PfJKonned6jTAajoC
        UbJ+PUjtIWV8MrE5dkzoF+6IYAwXQZ9PUl6PwdmLgQYGdqDQ89u6wHgsrmyC+qxp7OYOLO
        RklXJofkc2YFb5kwcB7b1hVmqYbZaQs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 3cf912f4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <mm-commits@vger.kernel.org>;
        Thu, 9 Jun 2022 17:03:07 +0000 (UTC)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-3137c877092so47762207b3.13
        for <mm-commits@vger.kernel.org>; Thu, 09 Jun 2022 10:03:07 -0700 (PDT)
X-Gm-Message-State: AOAM532+Hi7L2WHoIDbRi6DoIcFEUFOjdqD108h8U6KMjPYQ/PcSFJre
        vb3G3khtBZLgADc2OkQX+LNN2Fbk3L2sgHFpQJ0=
X-Google-Smtp-Source: ABdhPJwhJCorA0G8EsH+UUYhI/bCHDL7/xgy9CYyH8883+8DAg2PZwYmmXT7oVX7hWiLyiAAyvvO6rZID4BZIBZ3Ggo=
X-Received: by 2002:a81:5305:0:b0:304:a8cb:9589 with SMTP id
 h5-20020a815305000000b00304a8cb9589mr41863556ywb.2.1654794186774; Thu, 09 Jun
 2022 10:03:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220609165640.E538EC34114@smtp.kernel.org>
In-Reply-To: <20220609165640.E538EC34114@smtp.kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 9 Jun 2022 19:02:55 +0200
X-Gmail-Original-Message-ID: <CAHmME9pgWOU1wg2s5r99DowFgKYHYn=uYPjOLzHf6HEWOcsqgw@mail.gmail.com>
Message-ID: <CAHmME9pgWOU1wg2s5r99DowFgKYHYn=uYPjOLzHf6HEWOcsqgw@mail.gmail.com>
Subject: Re: + mm-kfence-select-random-number-before-taking-raw-lock.patch
 added to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        John Ogness <john.ogness@linutronix.de>,
        Alexander Potapenko <glider@google.com>,
        geert+renesas@glider.be, Geert Uytterhoeven <geert@linux-m68k.org>,
        Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

On Thu, Jun 9, 2022 at 6:56 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>      Subject: mm/kfence: select random number before taking raw lock
> has been added to the -mm mm-unstable branch.

I believe this belongs in the hotfixes branch, actually. It's a
regression in 5.19.

Jason
