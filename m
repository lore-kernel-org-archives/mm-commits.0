Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D04FC7EE2E
	for <mm-commits@archiver.kernel.org>; Fri, 24 Feb 2023 16:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjBXQW1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Feb 2023 11:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjBXQW0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2023 11:22:26 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17E764E2B
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 08:22:23 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id i34so31535054eda.7
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 08:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s1ddkJIM272NGkB+LdN/hOmq0DPwywAhS02NibdV81Y=;
        b=bstXxSL+BDGWYBS5i0BfvHRTN5xNltCllunCBSGHMIovfA2Zl4RfJXVwEWe8wBnMcA
         j/8MypiD9cD6M+qyHUfL5CDqO9YEdIBWUdDzQBViMk5d2c96bWbBg7i6UXH/WXncbAj6
         aRxK/kG0bgqQB9xcxRQZsAkPeR0Ta+jmZuR/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s1ddkJIM272NGkB+LdN/hOmq0DPwywAhS02NibdV81Y=;
        b=OTosPtPUdewOu/MYfszhAzSQVjQSqJtDygQ50f25+B4OgNxRLhRFZ5wTIrBfB9Oss3
         Zfhbyyw2q1ngc1BdThGNJkTJoTKudwODl66frTVmpq6FMM4rg+4yloxdP6vU26RVWkjW
         x9W/NrVpOtoChCY43/WlvQOFod/NKpf81lFDvpy5Di6yBMHq9vckmIaMG6Vx/cOXk5Tk
         0gtc9DJdjXT5DvtJLgjeFcrtziO4O6QxUEnYr2jR2g3gt0hNnIdwvpDY1dnR0fXa3Not
         yVbt02lP3sW5XrQgBbi4NOePOri9J/IDH0KgQGGGpD3cxyBpor0T/SUiDS9ae+D1R/h0
         4BJQ==
X-Gm-Message-State: AO0yUKV+R9L9YREuuTxWPXhptJWHdR+7DbkJJ2Ls0hTF+Nz2uqdaZkA1
        uw8bXMA93ABzrGx49LpyFZEFp10szLpTQf7NAgxlJA==
X-Google-Smtp-Source: AK7set//CaiCar5kHyWorfK2/3awQVqrnwiKhNBZNNyVg9/BR4v6PAXpyQFCAOTBqqSz9TtgmbLLvA==
X-Received: by 2002:a17:906:1014:b0:8b1:756c:1a30 with SMTP id 20-20020a170906101400b008b1756c1a30mr31858911ejm.59.1677255742032;
        Fri, 24 Feb 2023 08:22:22 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id n14-20020a170906840e00b008eaf99be56esm2692116ejx.170.2023.02.24.08.22.20
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 08:22:21 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id h16so57010041edz.10
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 08:22:20 -0800 (PST)
X-Received: by 2002:a50:d619:0:b0:4ab:3a49:68b9 with SMTP id
 x25-20020a50d619000000b004ab3a4968b9mr7634213edi.5.1677255740399; Fri, 24 Feb
 2023 08:22:20 -0800 (PST)
MIME-Version: 1.0
References: <2134430.1677240738@warthog.procyon.org.uk> <2009825.1677229488@warthog.procyon.org.uk>
 <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com>
 <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
 <2213409.1677249075@warthog.procyon.org.uk> <2244151.1677251586@warthog.procyon.org.uk>
In-Reply-To: <2244151.1677251586@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 08:22:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgPPFN0MvHYwtaPAtQkDFHwZrDXxZ+bOWk-qSyGMiLV6g@mail.gmail.com>
Message-ID: <CAHk-=wgPPFN0MvHYwtaPAtQkDFHwZrDXxZ+bOWk-qSyGMiLV6g@mail.gmail.com>
Subject: Re: [RFC][PATCH] cifs: Improve use of filemap_get_folios_tag()
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <stfrench@microsoft.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Paulo Alcantara <pc@cjr.nz>,
        Matthew Wilcox <willy@infradead.org>,
        Huang Ying <ying.huang@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Xin Hao <xhao@linux.alibaba.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Feb 24, 2023 at 7:13 AM David Howells <dhowells@redhat.com> wrote:
>
> The inefficiency derived from filemap_get_folios_tag() get a batch of
> contiguous folios in Vishal's change to afs that got copied into cifs can
> be reduced by skipping over those folios that have been passed by the start
> position rather than going through the process of locking, checking and
> trying to write them.

This patch just makes me go "Ugh".

There's something wrong with this code for it to need these games.

That  just makes me convinced that your other patch that just gets rid
of the batching entirely is the right one.

Of course, I'd be even happier if Willy is right and the code could
use the generic write_cache_pages() and avoid all of these things
entirely. I'm not clear on why cifs and afs are being so different in
the first place, and some of the differences are just odd (like that
skip count).

               Linus
