Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3DF7C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Oct 2022 16:25:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiJTQZL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Oct 2022 12:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJTQZJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Oct 2022 12:25:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705036F54E
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 09:25:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B98461C14
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 16:25:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C0FC433D6
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 16:25:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Qib4WeiZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666283104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DI3n1WAW5K3UvSyzoBgbcqtov21bv8GQYVFSsvoS+X8=;
        b=Qib4WeiZxcqlpcaCDTp8ZA2Bv8R4X8T/+qcbiS9WRtjVIGV8ayiEA1M4tcddsqb4dXJxnI
        X4mQ+hS5UrNvrC/1PsWcvx6Qtml0g9rrGLH9UD6jUWzZMwidITY5gzVfONy7OA1hbfQGpU
        c/pKybWm7lBemeYekmifuafQt50DRu4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f0ef5f28 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <mm-commits@vger.kernel.org>;
        Thu, 20 Oct 2022 16:25:03 +0000 (UTC)
Received: by mail-ua1-f53.google.com with SMTP id n5so1507692uap.2
        for <mm-commits@vger.kernel.org>; Thu, 20 Oct 2022 09:25:03 -0700 (PDT)
X-Gm-Message-State: ACrzQf1f9iMQExE3TuwXA18CjsaQITPFB1q6iE1TJYSUi4U50T02IGkN
        wnQBYAH/TyXayhQDqDoksHbllYb8IWiLSx5DoW4=
X-Google-Smtp-Source: AMsMyM7sYn5bKpKuRvmzTjmOp9Vl6Fo3Bhq4zLx6pgAIMfBbQGLSaqx+9TX+hyZJ6MP9wEyFAyd7SrqImxrcjuOpTXY=
X-Received: by 2002:a05:6102:7c9:b0:3a7:6261:935 with SMTP id
 y9-20020a05610207c900b003a762610935mr7785939vsg.73.1666283102434; Thu, 20 Oct
 2022 09:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <20221020000356.177CDC433C1@smtp.kernel.org>
In-Reply-To: <20221020000356.177CDC433C1@smtp.kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 20 Oct 2022 10:24:51 -0600
X-Gmail-Original-Message-ID: <CAHmME9oGZMN14qnbyGBGDp2EQg7y1rR8yYVuAtAyn2cjFC6NwQ@mail.gmail.com>
Message-ID: <CAHmME9oGZMN14qnbyGBGDp2EQg7y1rR8yYVuAtAyn2cjFC6NwQ@mail.gmail.com>
Subject: Re: + kbuild-treat-char-as-always-unsigned.patch added to
 mm-nonmm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        masahiroy@kernel.org, keescook@chromium.org,
        gregkh@linuxfoundation.org, andriy.shevchenko@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi Andrew,

On Wed, Oct 19, 2022 at 6:03 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> The patch titled
>      Subject: kbuild: treat char as always unsigned
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      kbuild-treat-char-as-always-unsigned.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kbuild-treat-char-as-always-unsigned.patch
>
> This patch will later appear in the mm-nonmm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Looks like you missed this email -
https://lore.kernel.org/lkml/Y1CP%2FuJb1SQjyS0n@zx2c4.com/ - and
didn't communicate about your intention to take this. Kind of
annoying, but oh well. Either way, I'll drop it from my tree, so that
-next has a clear path with it. Just please don't drop it from your
tree without appropriate discussion first. As mentioned in the thread,
there inevitably will be a few dragons with this patch, and the whole
idea of putting this in -next a whopping 4.5 months before 6.2 is
released is so that we can actually have time to chip away at those
issues as they come up. So please don't drop this at the very first
sign of trouble; just plan for some trouble.

Jason
