Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1F5C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 22 Sep 2021 10:45:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4219461357
	for <mm-commits@archiver.kernel.org>; Wed, 22 Sep 2021 10:45:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbhIVKqv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Sep 2021 06:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234871AbhIVKqu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Sep 2021 06:46:50 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8999BC061756;
        Wed, 22 Sep 2021 03:45:20 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id v24so8272996eda.3;
        Wed, 22 Sep 2021 03:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Iv+aqhr6TwoBfc/MRkxFU8sk3GDAunF1Y+pLFpHKuDc=;
        b=qjmt2THoagD6EXh+TaL3hH0ci9nb+1zCV6pAebFVqofsZqVeukArMheY6DMr5Phyx6
         kfQGGYRCMg1FWWpdz4mrH3ZF1bEdQgQ50HRGvdvEDuSi3UbKAI83H+qchCG5J5+qcDv9
         Sdfc21N6Xgcxm4VqoYejwga2DzQ7l+/Dm8wXhVFm5qBiG8Mto2aDH2sUT0QvBQ1xV8OO
         w8mVEAfmvXkOD70pn3CqbNrv7FhQkrF3hsY/6gY99pxdAOiKl26UHUcM4cZn2nRogaiO
         m43NTADA0Jst86ecEQeVPa9V8SziZCzXZb+QvKuDxmzeJh5G3+mSk4TlPV610nPCrYrd
         dGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Iv+aqhr6TwoBfc/MRkxFU8sk3GDAunF1Y+pLFpHKuDc=;
        b=u8+Zb7LtWX2zNAOMDp0Lvsq0ymclbzPVY7/LEoe4hspp97TTowlgzSOEoyfSuy7XBp
         dn88jVbXkGefrKRs/96WMfSxHwk6GUHOc+gquG8YtMkKyJM3RKtQYjaWObgXx58HjFa+
         /F3lH3UqJuEYBs1HoLjH0RvSXR0OnLXB2zZdichm8JFFtUwI0VsSeh2/Ekxt3Ck3dl4d
         vIRmcytJgRgiCXtwf18tdl/2cYwMrPdJJsB/YTlM5jU8DpMA1lD4h+5qSMd4SJAEOJ69
         5Vum79JNa1ZeLQQIXQylZXto8FOlQqsOitmifd5IUVxT+MuxLIrOqCHdvCyFuCINflUe
         U0hQ==
X-Gm-Message-State: AOAM530D0/sNVo2R5DCDmkPT6x3n+JL5sMHYECgBPxMY63dfrHazP6oB
        WOXshA1uuoAAaKfuEOrbkw==
X-Google-Smtp-Source: ABdhPJzj/AQfGN60lBCLn+qgySa/N4l+FMMQkwlUu1OhUnv2YzCSyAY89M7fuFzI5HdjB1wBVBRpyQ==
X-Received: by 2002:a17:907:2651:: with SMTP id ar17mr40811795ejc.15.1632307519076;
        Wed, 22 Sep 2021 03:45:19 -0700 (PDT)
Received: from localhost.localdomain ([46.53.254.56])
        by smtp.gmail.com with ESMTPSA id q9sm856559ejf.70.2021.09.22.03.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 03:45:18 -0700 (PDT)
Date:   Wed, 22 Sep 2021 13:45:16 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Joe Perches <joe@perches.com>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
        Christoph Lameter <cl@linux.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Dennis Zhou <dennis@kernel.org>, dwaipayanray1@gmail.com,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Linux-MM <linux-mm@kvack.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        mm-commits@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        linux-doc@vger.kernel.org
Subject: Re: function prototype element ordering
Message-ID: <YUsJPCHHc+T+Fqs2@localhost.localdomain>
References: <20210909200948.090d4e213ca34b5ad1325a7e@linux-foundation.org>
 <20210910031046.G76dQvPhV%akpm@linux-foundation.org>
 <CAHk-=wgfbSyW6QYd5rmhSHRoOQ=ZvV+jLn1U8U4nBDgBuaOAjQ@mail.gmail.com>
 <202109211630.2D00627@keescook>
 <af3c775a1515f97c8dbe6a6651bd6e4b6986e8cd.camel@perches.com>
 <202109211757.F38DF644@keescook>
 <YUraGKetS+Tgc7y9@localhost.localdomain>
 <e231bce4942848400f4286a2d4178eeab6555989.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e231bce4942848400f4286a2d4178eeab6555989.camel@perches.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Sep 22, 2021 at 01:51:34AM -0700, Joe Perches wrote:
> On Wed, 2021-09-22 at 10:24 +0300, Alexey Dobriyan wrote:
> 
> > Attributes should be on their own line, they can be quite lengthy.
> > 
> > 	__attribute__((...))
> > 	[static] [inline] T f(A1 arg1, ...)
> > 	{
> > 		...
> > 	}
> > 
> > There will be even more attributes in the future, both added by
> > compilers and developers (const, pure, WUR), so let's make "prototype lane"
> > for them.
> > 
> > Same for structures:
> > 
> > 	__attribute__((packed))
> > 	struct S {
> > 	};
> 
> Do you know if placing attributes like __packed/__aligned() before
> definitions would work for all cases for structs/substructs/unions?

Somehow, it doesn't.

But it works for members:

	struct S {
       		__attribute__((aligned(16)))
	        int a;
	};
