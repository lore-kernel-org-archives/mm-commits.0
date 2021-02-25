Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D700C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 17:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1ED264F3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 17:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhBYRuR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 12:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhBYRuQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Feb 2021 12:50:16 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E94FC061574
        for <mm-commits@vger.kernel.org>; Thu, 25 Feb 2021 09:49:36 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id 2so2928189ljr.5
        for <mm-commits@vger.kernel.org>; Thu, 25 Feb 2021 09:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zU4aOxtFZT7R1f+rrboFRm9WstvNO0s8X9Gu+u3DCBo=;
        b=hitC4olgG8YgCzw8OF2AEAmt/+xFesmkFz6U8u4GB5ybIn+omTo09J4atdnBjxkdNC
         a4QQlEziGYX6emaPTTwjQTqSonntQUXinRwKnFJcocPbqnuTMA29DZoRcjsGbuc7p/1B
         pgatQsKrL6jTkFG3O1AVPc8krWhNCuoZm91kA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zU4aOxtFZT7R1f+rrboFRm9WstvNO0s8X9Gu+u3DCBo=;
        b=n9z+P875965syt0LyIR6zJC7Yp3ClAwK2uBH107jTBFYWnrP3GedoB7+PX8wcwd7lB
         26IkU4dIqHw0R0isPdiLjHVmxmdtbR1IiOzvKYpPM76cpDh0ntfwNOgtlOwdOp34WjtD
         2RvULah1aLhDiUaFJso4I6yi7+iqxP/fnVww3cV7GsjoHUvsW58c1CfnmihgZav4NAJo
         VCTXsCjpIDxaslP33hIyEDBLZiynR4OBKAAGtdh+kIGNbOyWCqFfB+0aSvF0H2X6DXM7
         iOdg9JgdQb4sdwyjAnUx89HIqr113cYVvwuYWEKPiVwXcTmVJtAkKsxmbUCpP0JvhHRp
         XW3Q==
X-Gm-Message-State: AOAM532fR+C/jRcv2Mtl/Yve4Qrexsd/M+wpX5a4ihprSzycokZP7/yq
        MYz7ti/dTlMXYI3N7g76YMO7EqW/X2h+8w==
X-Google-Smtp-Source: ABdhPJzK0x2dvU447OaxRZrhCuiOrk32Yr9aoMiExKWw49PuDzaAZtBc5gBjbDmAlMNKKDZrlSmqTw==
X-Received: by 2002:a05:651c:485:: with SMTP id s5mr2286742ljc.276.1614275372882;
        Thu, 25 Feb 2021 09:49:32 -0800 (PST)
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com. [209.85.167.46])
        by smtp.gmail.com with ESMTPSA id 14sm1156599lfr.9.2021.02.25.09.49.31
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 09:49:32 -0800 (PST)
Received: by mail-lf1-f46.google.com with SMTP id d3so9812724lfg.10
        for <mm-commits@vger.kernel.org>; Thu, 25 Feb 2021 09:49:31 -0800 (PST)
X-Received: by 2002:a19:8186:: with SMTP id c128mr2405939lfd.377.1614275371361;
 Thu, 25 Feb 2021 09:49:31 -0800 (PST)
MIME-Version: 1.0
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
 <20210224200055.U7Xz47kX5%akpm@linux-foundation.org> <20210224203708.4489755a@oasis.local.home>
 <20210224210740.73273c7a@oasis.local.home> <5a0b6fb4-6efd-e391-45fa-cd188f181d5d@oracle.com>
 <20210225093128.4cd86439@gandalf.local.home>
In-Reply-To: <20210225093128.4cd86439@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 25 Feb 2021 09:49:15 -0800
X-Gmail-Original-Message-ID: <CAHk-=witGXc2FsqkOUy+Fh1_Vdpg=G5-MnDnDHv5DR5d6bRztQ@mail.gmail.com>
Message-ID: <CAHk-=witGXc2FsqkOUy+Fh1_Vdpg=G5-MnDnDHv5DR5d6bRztQ@mail.gmail.com>
Subject: Re: [patch 014/173] mm, tracing: record slab name for kmem_cache_free()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jacob Wen <jian.w.wen@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Feb 25, 2021 at 6:31 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Here's nothing special about %s in TP_printk. It uses the same code as
> printk() and what other string formatters use.
>
> What is special is that the print is on data that is stored from a previous
> time.

Well, technically that's not actually limited to just %s, although
that's the common case.

All our magic "%p*" formats do the same thing: they print out not the
argument _value_, but something that the pointer value points to.

So "%pD" takes a "struct file *" pointer, and follows it to the
dentry, and then from the dentry to the name. So it will in fact
follow pointers even more than "%s" does.

It might indeed be worth having a warning for TP_printk() about any of
the formats that follow a pointer, exactly because of the whole "by
the time it actually prints, the pointer may be long gone".

             Linus
