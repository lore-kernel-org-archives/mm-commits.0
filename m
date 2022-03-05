Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05203C433EF
	for <mm-commits@archiver.kernel.org>; Sat,  5 Mar 2022 19:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbiCETE6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 5 Mar 2022 14:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiCETE4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 5 Mar 2022 14:04:56 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803C47A98D
        for <mm-commits@vger.kernel.org>; Sat,  5 Mar 2022 11:04:05 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id bg10so23981336ejb.4
        for <mm-commits@vger.kernel.org>; Sat, 05 Mar 2022 11:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yDPu/xaKJbdDPmhQDpmRjEgFy5bmctUIRCD39EGUvLg=;
        b=eBnI1VXfagds1G8DpzAeYzz4CY4BK/8v2hq67nTYqGT9gPw7UZ0YhXCKsxxFFmiCnJ
         HuiUq3PyNtTeGgJNiQKW98ebwpbEBHjtfP1gPB8u20pb/9TJF3wyNv5210M+3JWigKxf
         tOo2KOEdtXC6DrYqfWWcdFb/dYiIDFG+Npb9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yDPu/xaKJbdDPmhQDpmRjEgFy5bmctUIRCD39EGUvLg=;
        b=du/1vgrCZjvCeqcSY6eTAc7HBGZgKXzTuI4/Ism31scJjHT66yBsSPaFHlBh0v/L63
         c9e9GAlrm73WmCGx/wElTxDp/gh9UWiSTBsi5GMc26sbbSoeNE7Xuy3nqIbLq5AWOHPp
         LBpvA3/kIlxJduJ0jQCKl2fPBS3vN7jMUZJhKFjqj+7dL/gkWZVBf2bE4HuHihFyImFN
         GkGcwD2KMz2MZ01qVz9B+tcPdMChyoUUVaAwFfu0SjzbxvRKL/eDcwcFz8GkY5ouHOE4
         sOausfOGdxey/kNazEeTj0nNvgJGvKPyV23usXoZc4aGHDa84vz14ZGaJH/qXox8Ucak
         zrYg==
X-Gm-Message-State: AOAM531Bt+kigNyLSFH3/vItK45NzEcygiHldQwhAVE0a+nXvJoeagCr
        /UFy3C2qrreJXKAoV4kFS63cao+zSlRd1Y2KgNU=
X-Google-Smtp-Source: ABdhPJyeZqnGyE0TWYYaFgLxXEhMEKF5Y37BTGtb0HucmLa8SWEY5EAlfp48qgHUCauhAKHSAhwRkg==
X-Received: by 2002:a17:906:974e:b0:6bb:4f90:a6ae with SMTP id o14-20020a170906974e00b006bb4f90a6aemr3715836ejy.452.1646507043737;
        Sat, 05 Mar 2022 11:04:03 -0800 (PST)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id n6-20020a170906724600b006d4e2f6857dsm3107520ejk.139.2022.03.05.11.04.03
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Mar 2022 11:04:03 -0800 (PST)
Received: by mail-ed1-f45.google.com with SMTP id g20so14738392edw.6
        for <mm-commits@vger.kernel.org>; Sat, 05 Mar 2022 11:04:03 -0800 (PST)
X-Received: by 2002:a05:6512:3042:b0:437:96f5:e68a with SMTP id
 b2-20020a056512304200b0043796f5e68amr3018649lfb.449.1646507032344; Sat, 05
 Mar 2022 11:03:52 -0800 (PST)
MIME-Version: 1.0
References: <20220304202822.d47f8084928321c83070d7d7@linux-foundation.org> <20220305042855.BFBB9C004E1@smtp.kernel.org>
In-Reply-To: <20220305042855.BFBB9C004E1@smtp.kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 5 Mar 2022 11:03:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjA82m5VxsjXLN7giO--0rqXq7-WXxy+O2UTjtdYdYZ3g@mail.gmail.com>
Message-ID: <CAHk-=wjA82m5VxsjXLN7giO--0rqXq7-WXxy+O2UTjtdYdYZ3g@mail.gmail.com>
Subject: Re: [patch 3/8] mm: prevent vm_area_struct::anon_name refcount saturation
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, sumit.semwal@linaro.org,
        Sasha Levin <sashal@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Alexey Gladkov <legion@kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Hildenbrand <david@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Dave Hansen <dave.hansen@intel.com>, chris.hyser@oracle.com,
        Colin Cross <ccross@google.com>, caoxiaofeng@yulong.com,
        Christian Brauner <brauner@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        patches@lists.linux.dev, Linux-MM <linux-mm@kvack.org>,
        mm-commits@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Mar 4, 2022 at 8:28 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> To ensure anon_vma_name refcount does not overflow, stop anon_vma_name
> sharing when the refcount reaches REFCOUNT_MAX (2147483647), which still
> leaves INT_MAX/2 (1073741823) values before the counter reaches
> REFCOUNT_SATURATED.  This should provide enough headroom for raising the
> refcounts temporarily.

This is a classic case of kref simply being the wrong type for this.

We sh ould move away from that idiotic "saturate with a warning" type,
and just codify that what the page refs do is the RightThing(tm) to
do.

I've ranted against kref for years, I hate that damn thing. It's
literally broken by design with the known leaking behavior.

Oh well. I'm taking this patch as a "fix up refcount problems", and I
guess I need to some day just extract the page_ref code into a nice
type of its own so that it's usable outside of pages.

(Others have copied the page_ref code manually, but there's no "helper
type with functions to use it", which is why people then use that
mis-designed refcount stuff).

              Linus
