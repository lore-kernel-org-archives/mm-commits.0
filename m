Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C35FC7EE23
	for <mm-commits@archiver.kernel.org>; Fri, 24 Feb 2023 19:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjBXTGD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Feb 2023 14:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjBXTGD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2023 14:06:03 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E84D1B2FF
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 11:06:02 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id ck15so1454983edb.0
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 11:06:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gOnW98lyJGpYbD3eJjqqzz7gc3Ub1QIGFkaXHUv4Ygw=;
        b=QgJzE1UXmKimaRQyvLPX5eOzT51cg/7f32m8GMjg3xQqoxdyxololhdOn94vv4mfJZ
         mNXn+/IMq2NgXpZq0dV9JUbm82Tv+OpUNyfJDu6dpCaBqQQlbZTu21GCYsC9+zVH0n42
         DBThtYurcSf7Bo98gVQ42RJLZrWoPKpK6t+u4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gOnW98lyJGpYbD3eJjqqzz7gc3Ub1QIGFkaXHUv4Ygw=;
        b=YkvXqmN25Bt9b/a02w6EgxB/qWiVkb86zwZf/EltKYPRT4hLAzyq/hqs5mROHUAI0E
         5nxDA+YHxA6UZcn2TmsGvwnL+HYwUF/+h0I9xzsQwDKuIHuCwB98vDI3XXBBv5vHfowm
         OCTyLwHpqLN2jDt7t1fqw3iUFXu4S9kFN6FP7cpfcPvRgt3X2hqrMlm51T3SwLoq10kJ
         fB09hZTDeZRosfI/AvBm8HwEJxu3BC+uj49rtFT1suvr7WjSXWe3pLP6YrR1pS8jIj9f
         Nc/CrpZpPHYeE6wzY1nIU7St6YWuVa1OibUXz77DqbIk+xgBOUJM1tvX6iq6TYmg8Rg/
         8pLQ==
X-Gm-Message-State: AO0yUKVJutcGl88XiR3IEMz98C1kMTrgWbXM/rVYWtFtJ20k+ffuL5xL
        lXfGZH6FrObBDZMTPyspgJXVV6jCUj94hrUxeaqp5Q==
X-Google-Smtp-Source: AK7set93VyzenNTGHbO21EeXidXy/AYKTKGfj1xi2rARQYiH7NWXnNIpNUb+Vt8tDnC+weQWy792DA==
X-Received: by 2002:a17:906:e285:b0:8b1:15ab:f4cd with SMTP id gg5-20020a170906e28500b008b115abf4cdmr26029153ejb.53.1677265560180;
        Fri, 24 Feb 2023 11:06:00 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id j24-20020a508a98000000b004acde0a1ae5sm23254edj.89.2023.02.24.11.05.59
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 11:05:59 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id cy6so1223372edb.5
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 11:05:59 -0800 (PST)
X-Received: by 2002:a50:baa7:0:b0:4ae:e5f1:7c50 with SMTP id
 x36-20020a50baa7000000b004aee5f17c50mr7747187ede.5.1677265559017; Fri, 24 Feb
 2023 11:05:59 -0800 (PST)
MIME-Version: 1.0
References: <2009825.1677229488@warthog.procyon.org.uk> <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com>
 <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
 <2134430.1677240738@warthog.procyon.org.uk> <2213409.1677249075@warthog.procyon.org.uk>
 <CAHk-=whFKL4VuFBWvenG8fAgfvbf36PDgouUSx47rZDWr9BkJw@mail.gmail.com>
 <2385284.1677259167@warthog.procyon.org.uk> <CAHk-=wiAQZUZCEH1OxFb3Oa_mqz69tagdXHnKuYd_rwRHba5Cw@mail.gmail.com>
In-Reply-To: <CAHk-=wiAQZUZCEH1OxFb3Oa_mqz69tagdXHnKuYd_rwRHba5Cw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 11:05:42 -0800
X-Gmail-Original-Message-ID: <CAHk-=wizKeB-EAsFgvUUfL2OaO3+W2OHr2L8Y4cGBBheYeJdtw@mail.gmail.com>
Message-ID: <CAHk-=wizKeB-EAsFgvUUfL2OaO3+W2OHr2L8Y4cGBBheYeJdtw@mail.gmail.com>
Subject: Re: [RFC][PATCH] cifs: Fix cifs_writepages_region()
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <stfrench@microsoft.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Paulo Alcantara <pc@cjr.nz>,
        Matthew Wilcox <willy@infradead.org>,
        Huang Ying <ying.huang@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Xin Hao <xhao@linux.alibaba.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Feb 24, 2023 at 10:58 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll apply that minimal fix for now - I think the right thing to do is
> your bigger patch, but that needs more thinking (or at least splitting
> up).

Minimal fix applied - that way I can drop this for now, and we can
discuss the whole "maybe we can just use write_cache_pages()" instead.

Because that _would_ be lovely, even if it's possible that the generic
helper might need some extra love to work better for cifs/afs.

             Linus
