Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CCCC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E247422D02
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 22:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgLOWua (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 17:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgLOWuX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2020 17:50:23 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9C5C0613D3
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 14:49:42 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id a9so43582036lfh.2
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 14:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F9WNvlkmYnm6g3UciMUVhYcGO9pevy8gpF5fgcObURM=;
        b=RbgticD/yZaDxkpplZkcklwne79VvymYyp+ddP3bxFPOAI8S4xX9aWlgHlpCUZTtEv
         43IFYaKJEEsIB/vwR/apM5EWf0DUKyj8KWqOyU1xmDEnI+H4CVhkSOe2XMfyG6HQ/rG+
         dk3yP24jv4TgQGV1EggrlZOktsIDQEgWu/p70=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F9WNvlkmYnm6g3UciMUVhYcGO9pevy8gpF5fgcObURM=;
        b=aLvsW3NVL4s9/K6ARhKjdlJ1tNlHWt0klGa3U8zo0sWAugqlovxmAe4R11Jem6MgrA
         vSIzpMa4oRydpql+Danx5K8DcaYnrDfklf+K49U5eDPTWpAEEl5dfBGwg00OFzxoTddO
         3kPCrJHGoPcRd3teVUeTpV2TqVH9aR7LviKaCAJaSyD4p7RHFGYqExJd+xoJfUyxZi2R
         F4T6KdGJENoBekyr0k3jXusz955oNoQZUINrsFbn5+9xMdRLcd0SY4c8vCUs/cEWoB9g
         m+VvLJOOsCC8lwT25mG23TBw6ikoQ9H4EqxCce2O5hxU6y54Q1QCtd7lQZC/vAigRPN+
         0ZLw==
X-Gm-Message-State: AOAM531+jnHNKQA6asPnDmx2QY7CjGh5j16NKGEg91ms+zvkGPCtyiTE
        guwM1A3lVpoBRSeQT/FZCqOAU09oZnmKNw==
X-Google-Smtp-Source: ABdhPJy9zI1SVOpvdJIGNRouBLGRCefsLOjos06VjRjM0BC9xbDafjY/dC9dVlSyurVegTDwh0KZhg==
X-Received: by 2002:a05:651c:546:: with SMTP id q6mr13253571ljp.235.1608072580910;
        Tue, 15 Dec 2020 14:49:40 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id t26sm24827ljo.16.2020.12.15.14.49.40
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 14:49:40 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id l11so43614860lfg.0
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 14:49:40 -0800 (PST)
X-Received: by 2002:a19:8557:: with SMTP id h84mr11270439lfd.201.1608072579836;
 Tue, 15 Dec 2020 14:49:39 -0800 (PST)
MIME-Version: 1.0
References: <20201215123253.954eca9a5ef4c0d52fd381fa@linux-foundation.org> <CAHk-=wi2-u8+m2k=dt-=L8sjHC=nR-Z7Db9igZDCjnkis1G9gA@mail.gmail.com>
In-Reply-To: <CAHk-=wi2-u8+m2k=dt-=L8sjHC=nR-Z7Db9igZDCjnkis1G9gA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Dec 2020 14:49:24 -0800
X-Gmail-Original-Message-ID: <CAHk-=whiXW8dDgsYzb=gPRE3x6BeET9rsPF_5+x6Lf4bRR90-w@mail.gmail.com>
Message-ID: <CAHk-=whiXW8dDgsYzb=gPRE3x6BeET9rsPF_5+x6Lf4bRR90-w@mail.gmail.com>
Subject: Re: incoming
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Dec 15, 2020 at 2:48 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I will try to apply it on top of my merge of your previous series instead.

Yes, then it applies cleanly. So apparently we just have different
concepts of what really constitutes a "base" for applying your series.

              Linus
