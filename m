Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2E6CC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 00:55:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7366261A63
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 00:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350383AbhJAA5I (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 20:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349760AbhJAA5I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Sep 2021 20:57:08 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A6BC06176A
        for <mm-commits@vger.kernel.org>; Thu, 30 Sep 2021 17:55:24 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id a73so4973858pge.0
        for <mm-commits@vger.kernel.org>; Thu, 30 Sep 2021 17:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VO1XkqcmGKuJq1ty4RT0GkBObOPRQCGheSFuUC1DlW0=;
        b=LhZcvz/b1+ACnsk/hnzfLc4Gv/9+2bkzmVq/EzDyIzLpVYkDqadmYmUyx0/ePiLsX6
         0OlSfFUSQRqoOrbzsKeUoXOqfVxCXDYir04Qo9f74++08speo2hYzKkCBMsu5dt9fGtN
         xM7lyouTmVpSdq57UKQUXgkEzy33yY+yaXVvI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VO1XkqcmGKuJq1ty4RT0GkBObOPRQCGheSFuUC1DlW0=;
        b=1kyPAfROuPB0abgByc9/K941lpYXqSvMuf3yAVuAl9IYFMD3NIbFvPQa9X7cWLbmm7
         ti0hGpbppR6fBAQXhA7ksDPThaZT0/cEHQW4crz18BSZ9S0NBbGpz25udGA63VN2pqzB
         IPfS3Zd+22VdKsRw9trCewMBDDZjdleCt/nklS5UUaiaMv7dC4VVaiQ/ZDlazepCgho+
         Sym45KRR0yY6lU5N5yhIY07JnIoXlxejkGaUDwDyl2igTbRKNS1gn8JMkSByizo/tDZL
         owGCNL8HgFZxM5iv2SUcZTchD7+CFY7orHmdzoNnMkyUsDtCVuzhF+QRuet6yz0g5yT/
         NAyQ==
X-Gm-Message-State: AOAM530ae1Bc9738beBR/k9/rXL9tJrt+bd3e9I+HCJaZsMu3Li0wO8a
        pthFfy6YsUD5eSgBFWmTrCuyHg==
X-Google-Smtp-Source: ABdhPJyi8xqW4gZxB0mY4ILkYkYQ/z2lObzKIYdi35R6qw/fpGr0HqnkHzjfuLeizukT7hDURckKTg==
X-Received: by 2002:a63:4506:: with SMTP id s6mr7560071pga.211.1633049724309;
        Thu, 30 Sep 2021 17:55:24 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:159f:3ab6:88f:1129])
        by smtp.gmail.com with ESMTPSA id az15sm5834892pjb.42.2021.09.30.17.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 17:55:23 -0700 (PDT)
Date:   Fri, 1 Oct 2021 09:55:16 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
        ast@kernel.org, benh@kernel.crashing.org, bp@alien8.de,
        christophe.leroy@csgroup.eu, davem@davemloft.net,
        dvyukov@google.com, glider@google.com, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        monstr@monstr.eu, mpe@ellerman.id.au, paulus@samba.org,
        pmladek@suse.com, rostedt@goodmis.org, rth@twiddle.net,
        ryabinin.a.a@gmail.com, tglx@linutronix.de,
        wangkefeng.wang@huawei.com
Subject: Re: + kallsyms-remove-arch-specific-text-and-data-check.patch added
 to -mm tree
Message-ID: <YVZcdIBbXM0mp4cS@google.com>
References: <20210930212149.TDvMQI9fl%akpm@linux-foundation.org>
 <YVZav3rnb3+A9bHz@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVZav3rnb3+A9bHz@google.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (21/10/01 09:47), Sergey Senozhatsky wrote:
> On (21/09/30 14:21), akpm@linux-foundation.org wrote:
> > +++ a/include/linux/kallsyms.h
> > @@ -34,8 +34,7 @@ static inline int is_kernel_inittext(uns
> >  
> >  static inline int is_kernel_text(unsigned long addr)
> >  {
> > -	if ((addr >= (unsigned long)_stext && addr <= (unsigned long)_etext) ||
> > -	    arch_is_kernel_text(addr))
> > +	if ((addr >= (unsigned long)_stext && addr <= (unsigned long)_etext))
> >  		return 1;
> 
> Does this need to include _etext or should it be '< _etext'?

Oh, this is fixed in the next patch.
