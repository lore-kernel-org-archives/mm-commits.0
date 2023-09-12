Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0881BCA0ED2
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 16:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237233AbjILQ4f (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 12:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237284AbjILQ4b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 12:56:31 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F0061720
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 09:56:27 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-64f457c97a3so37218216d6.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 09:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1694537786; x=1695142586; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OP6Q6o8FGbGvxndyeGmyIjIYrMnEOeORNz+Auf2DNjQ=;
        b=xMB72i0HPPa1AClqLdk1eJJK3Dox5eVZ648/239CPt7K0/bk+LvpQG2P2oTGp6PgNv
         p7Z0sgHn/GSCIsPSl150eTIPC/AhV6TVkAHnsbZSVETqD9kFJ7BhnWrm+VVNEtsGMeY8
         lA69QKTzWFhNKJHHxGUbxkY4ydXMBZz+tNDZiBOC2oRymEPQDrpHjHwXlQoItrFxei44
         j7Y+vX0ZlWOhFgrtYPkQuYztA8nFW7jdjNrUGQgPU7fWuk0hi+hhvlHieMu3J32TnOaa
         crRrH8uhmvU3TlsQpziBl5y/gTGRUhiy1dUlAaJjVT+dFKb+/Vd6V45o1ZO7m5pFB6Gy
         9L1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694537786; x=1695142586;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OP6Q6o8FGbGvxndyeGmyIjIYrMnEOeORNz+Auf2DNjQ=;
        b=Gy+Ei4YkAEywbN29sAFHIZUfiD9t14u8AIT3gO66QgOVvgoewDRFJqPoHGN61tknDR
         kD29ZO6cZ11UgEDve8y3XYTDUywAAPu1iI4J6ILC5MnU/sQWle+zEGnkUFjD5/KtLwCn
         aRv5go/APNbXK7hwx+pEPdVaew7IwzlNgh5NORJd6NueaQh8bnViNdlAwx7Z49IKU6K7
         7HvafGC8mh4MN91fayQRp4ZAYQfsRSSs6lPNMOD571FGb7rUZlD2G+9zOcIlCruG1hI6
         AxsGYpnuh8wDll8nqwX3ZPzKxC6f1BYprEGjdMiSxYBM4lNP6a6d1dV5w6EhyWzid4Xi
         AkbA==
X-Gm-Message-State: AOJu0Yypc43SDcek2iF+fqlIupOr/USp3WMDFjd3Eje2XgiebDORDjS8
        f/m+VPpBU8V3a//cYcNBtg80Jw/jf23H61GOtpk=
X-Google-Smtp-Source: AGHT+IFCTVb0dQm+Pn/TCEePMFW6SPUMKrQ8EOrnbaMDqjwB7NtyfGs6jUNyj7yY/RSCDFlOBBiYZQ==
X-Received: by 2002:a0c:e14b:0:b0:637:ad25:9070 with SMTP id c11-20020a0ce14b000000b00637ad259070mr4160221qvl.53.1694537786512;
        Tue, 12 Sep 2023 09:56:26 -0700 (PDT)
Received: from localhost (2603-7000-0c01-2716-3012-16a2-6bc2-2937.res6.spectrum.com. [2603:7000:c01:2716:3012:16a2:6bc2:2937])
        by smtp.gmail.com with ESMTPSA id r6-20020a0ce286000000b0064f732aa45csm3772064qvl.133.2023.09.12.09.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 09:56:26 -0700 (PDT)
Date:   Tue, 12 Sep 2023 12:56:25 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, vbabka@suse.cz, stable@vger.kernel.org,
        joe.liu@mediatek.com, mgorman@techsingularity.net
Subject: Re: +
 mm-page_alloc-free-pages-to-correct-buddy-list-after-pcp-lock-contention.patch
 added to mm-hotfixes-unstable branch
Message-ID: <20230912165625.GA34089@cmpxchg.org>
References: <20230911210053.8B7B0C433CD@smtp.kernel.org>
 <20230912135029.GA249952@cmpxchg.org>
 <20230912090938.c5314956fe385241bf567a9e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912090938.c5314956fe385241bf567a9e@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Sep 12, 2023 at 09:09:38AM -0700, Andrew Morton wrote:
> On Tue, 12 Sep 2023 09:50:29 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > 
> > This patch is superseded by the following patch you picked up:
> > mm-page_alloc-fix-cma-and-highatomic-landing-on-the-wrong-buddy-list.patch
> 
> OK.
> 
> > If you drop this patch here, you can also drop the fixlet to
> > free_unref_page(). The branch in there should look like this:
> > 
> > 	if (pcp)
> > 		free_unref_page_commit(..., pcpmigratetype, ...);
> > 	else
> > 		free_one_page(..., migratetype, ...);
> 
> Well kinda.  It's actually
> 
> 	if (pcp) {
> 		free_unref_page_commit(zone, pcp, page, migratetype, order);

							^^ pcpmigratetype

is what I was trying to highlight.

But yes, the pcp_spin_unlock() is needed too!

> 		pcp_spin_unlock(pcp);
> 	} else {
> 		free_one_page(zone, page, pfn, order, migratetype, FPI_NONE);
> 	}
> 
