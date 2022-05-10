Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00FAC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 17:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348130AbiEJRcr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 13:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348151AbiEJRcq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 13:32:46 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB3C3EAB8
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 10:28:48 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id m20so34339238ejj.10
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 10:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Mz7I1jn3xzDkkA1HCpKDXJNUAzdpv6ms7CIns60Dn4=;
        b=eft9x/Ewsct7cNwgh2+u9zvmAjY3Zq8s0S57BEeDFmQ3qM9TFDSLDaWMiAAbZsfrN6
         A+d1RrqdMKi9XMx1X4XPXtNoqp0dyVM5DUddPJY1pGuYaAzngJ3errQ4MUWrUCIh1Mag
         JVL6Xu16IeB/5p4peIuf19bhoX74Qqqre51Ak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Mz7I1jn3xzDkkA1HCpKDXJNUAzdpv6ms7CIns60Dn4=;
        b=tJQZtoM3U1N9E0CXonwhpiMDHftmQXFmPAcJRhFDEK9k1Sx5sTTXRnzJoO4s9IDGNu
         gFKAN6wHsWh9rQ0e6KtFDV/Nl2mZHLE7TD2Yc9fFpPnp0olfL/tSGJuD8DmeICIX/yFN
         49yqufjVp5SzSTjB6iltBSVsYyCn1SuvchBbjf9r668v7GhyYMeu3BlpYIY2RLJoF9or
         HY3IR/vilTgfMwWOeXfCM+iZWu7LDszqOqjaTvlYlRvLE+A9JiH9dPchyvGrui99bdEl
         NdeJMd51ttHE/CQPG4Fm3aWY7Deyoa88ZO6kUwjFvAnMeFXFXLlWDlPFRIHy3w1nBVQx
         jmWw==
X-Gm-Message-State: AOAM532B8y7YSBfTW9E0/K8rPrH/1xlRTQt7Lgy2n6VyVGmF2TZqcSnT
        JNRSdAIMBjCuWLCWt69HCs+kQ7mgveIBm3HRCrs=
X-Google-Smtp-Source: ABdhPJzViXoAsm+cYXidsN8uKimKYzKveBh/8x4XWGHpmMJA0mTcfCRJH31Op/AtBggFyuuGH3EE5w==
X-Received: by 2002:a17:906:6bd7:b0:6f4:e6e4:1d41 with SMTP id t23-20020a1709066bd700b006f4e6e41d41mr21123177ejs.770.1652203726902;
        Tue, 10 May 2022 10:28:46 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id ec40-20020a0564020d6800b0042617ba63c2sm7942316edb.76.2022.05.10.10.28.44
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 10:28:45 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id bg25so10608273wmb.4
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 10:28:44 -0700 (PDT)
X-Received: by 2002:a05:600c:4f06:b0:394:836b:1552 with SMTP id
 l6-20020a05600c4f0600b00394836b1552mr998628wmq.145.1652203724417; Tue, 10 May
 2022 10:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <YmiK7Bos+zLAvL0t@zn.tnic> <CAHk-=winO-QozwEEKeZJsT9Cux+JbihocPWhjm3m1RGTQwViDg@mail.gmail.com>
 <YmkdxaKdc2w/3I7o@zn.tnic> <CAHk-=wg=D9eaDHU5yHpqf_G7zTBcv6yU1kkNzV6KKb5jttNxvA@mail.gmail.com>
 <YnLMSWbz6BNfsBME@zn.tnic> <CAHk-=wh_62HBCz1g_6mKP71XOvJAs3JwBz0=jve2mg1DGWPq5g@mail.gmail.com>
 <YnLfl6lupN2nq7+t@zn.tnic> <CAHk-=wiGbrJMim6EWncZUQBzguqy-vtNd+grfNizm5L8Vcmu+w@mail.gmail.com>
 <YnLplKy0Y66SsvQw@zn.tnic> <CAHk-=wjUX5DGNSiBYvPC8fQJGRe5_RWR8NW=gYF4=UpPiwCE8A@mail.gmail.com>
 <Ynow8F3G8Kl6V3gu@zn.tnic>
In-Reply-To: <Ynow8F3G8Kl6V3gu@zn.tnic>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 10 May 2022 10:28:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
Message-ID: <CAHk-=whCmmipbBDips0OJ=UiBUjZfgBGYruoOsqcq2TVd5kBSA@mail.gmail.com>
Subject: Re: clear_user (was: [patch 02/14] tmpfs: fix regressions from wider
 use of ZERO_PAGE)
To:     Borislav Petkov <bp@alien8.de>
Cc:     Mark Hemment <markhemm@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        patrice.chotard@foss.st.com, Mikulas Patocka <mpatocka@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Hugh Dickins <hughd@google.com>, patches@lists.linux.dev,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, May 10, 2022 at 2:31 AM Borislav Petkov <bp@alien8.de> wrote:
>
> clear_user_original:
> Amean: 9219.71 (Sum: 6340154910, samples: 687674)
>
> fsrm:
> Amean: 8030.63 (Sum: 5522277720, samples: 687652)

Well, that's pretty conclusive.

I'm obviously very happy with fsrm. I've been pushing for that thing
for probably over two decades by now, because I absolutely detest
uarch optimizations for memset/memcpy that can never be done well in
software anyway (because it depends not just on cache organization,
but on cache sizes and dynamic cache hit/miss behavior of the load).

And one of the things I always wanted to do was to just have
memcpy/memset entirely inlined.

In fact, if you go back to the 0.01 linux kernel sources, you'll see
that they only compile with my bastardized version of gcc-1.40,
because I made the compiler inline those things with 'rep movs/stos',
and there was no other implementation of memcpy/memset at all.

That was a bit optimistic at the time, but here we are, 30+ years
later and it is finally looking possible, at least on some uarchs.

               Linus
