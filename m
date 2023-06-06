Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57262C7EE43
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jun 2023 22:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240111AbjFFW4o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:56:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234315AbjFFW4k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jun 2023 18:56:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 942F3125
        for <mm-commits@vger.kernel.org>; Tue,  6 Jun 2023 15:56:39 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1686092197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CSv0livednfIunLdwTXyS8e2D91/acgYsCLHi50SZno=;
        b=LH7B7yReeu7xBbwuBFpogashoqmPvObs34Pk71lZDZ96XJdOpOVHLUV9eByTQMU544QH+6
        BQ9Lr7DJf60MNf/C0K6mZbuAJQYJcqavNhMVVOaZpASNH2WrIboDIRqlN1t8L7TIOg0NT2
        /boLYJqoAvAJQkyWkrTOJ9XDGUlKMfwSSL08QTDUy+z59AXScsSuH5l0SiGGI0M8kV9YEe
        2SWO4EvMjKq36kLO32litca16NfQKNkZMrotSPYtSgf+gV+uQr+XlLSfa24hMVtQFLfdLG
        GKQ4Fy/ZNGFEXX4Vw718SsG7c1mAvY4sRMNKQB3ODlS8dxKKMEWQ48Qcr2VYUQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1686092197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CSv0livednfIunLdwTXyS8e2D91/acgYsCLHi50SZno=;
        b=08HAGCpgGMLWYwZ/xKCI8tFviWqeHGUPpsTtqjBI2XWomA3h/gNsBWBzDT7ZTWsiIbOrhU
        UO8xYl/hSXGwm0BA==
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, wuchi.zero@gmail.com,
        syzbot+7937ba6a50bdd00fffdf@syzkaller.appspotmail.com,
        swboyd@chromium.org, peterz@infradead.org,
        penguin-kernel@I-love.SAKURA.ne.jp, akpm@linux-foundation.org
Subject: Re: +
 debugobjects-turn-off-debug_objects_enabled-from-debug_objects_oom.patch
 added to mm-nonmm-unstable branch
In-Reply-To: <20230530203045.91EAAC433D2@smtp.kernel.org>
References: <20230530203045.91EAAC433D2@smtp.kernel.org>
Date:   Wed, 07 Jun 2023 00:56:36 +0200
Message-ID: <87y1kwjj2z.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Andrew!

On Tue, May 30 2023 at 13:30, Andrew Morton wrote:
> The patch titled
>      Subject: debugobjects: turn off debug_objects_enabled from debug_objects_oom()
> has been added to the -mm mm-nonmm-unstable branch.  Its filename is
>      debugobjects-turn-off-debug_objects_enabled-from-debug_objects_oom.patch

Why the heck are you applying random patches within a day without giving
the people who care and understand this code the chance to actually
review it?

You are well aware that I'm taking care of this since day one despite
that I'm not explicitely mentioned in the MAINTAINERS file. I'm going to
fix that now despite the fact that I want to reduced the number of
entries instead of increasing them...

Aside of that can you please fix your notification mechanism so that the
"I picked that up/dropped it/or whatever" mail shows up in the actual
submission mail thread?

Connecting these '+/- $subject' mails to the actual submission thread is
a pain. It's not rocket science to fix that. patchwork, tip-bot and
others do that for years.

Thanks,

        tglx




