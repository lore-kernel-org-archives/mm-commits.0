Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90DD8C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 00:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E22761A4F
	for <mm-commits@archiver.kernel.org>; Fri,  1 Oct 2021 00:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350830AbhJAAtx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 30 Sep 2021 20:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349760AbhJAAtw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Sep 2021 20:49:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D31BC06176A
        for <mm-commits@vger.kernel.org>; Thu, 30 Sep 2021 17:48:09 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id bb10so5227079plb.2
        for <mm-commits@vger.kernel.org>; Thu, 30 Sep 2021 17:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4VFDlYLCDJyTdCozdBjGZHP23jhQYYCHK/pXcPk42S0=;
        b=gYFLz3LdgLYwFnwXA1Eedz+KfOBoOx99Oh+oQknZE6PQsZSDxBJaNwh5FsEXDEDXsT
         j/PglNgseNhuwOLnAsJuRodyx0yjrplOktcZZxb8dXG+w77lvmJnI6oF3vTyi66lER/6
         RvcFhWRBskx6vZqLULnRZHdktA0AR9dD5dcPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4VFDlYLCDJyTdCozdBjGZHP23jhQYYCHK/pXcPk42S0=;
        b=qvYMp7AetHM4iRFcOpOv7ZXcN1Vvz6ygorDxSdMs2Y/Q+JpYX9VI3imid5JmmgXM6y
         C96RJIo3CNTdGEmGcvLCGj0ki8Qv/bFwJG6NaCL1/rzBf1k2IS+IWddHcbZ0vl6uE7tz
         pWfzGXk5f8PiI7EksjqNuzASG/M4GBCwr3kR2qIvpb4L/UZs0bxs1rN3PIgSWIy7rG+r
         IbAPBFaxn16uJUEPUpkdgKCx/2jVtHY6vWyqqRpOx5vZBBYbQ8u7nZhKtRLEbd0gA2N/
         H8vie4DRiny25gwN3YiHY2sNsaJq/XCI9c3E9pZlO95BUi4JWOvMtg82x+HB0pvvLhJ+
         FSbQ==
X-Gm-Message-State: AOAM533lop+B0VmKn/ZDTbe2YuYG8LR9e2NqSThcRT3JF5i4KfhsUm/L
        pLF7BuM0ry75W69JMd7XD2/o8Q==
X-Google-Smtp-Source: ABdhPJxE1DlPGDTRxe6wL6rnFcH0YtVkmNvPTNX/VMYKVLXHUvgJ1DvUmwTYM47KUX1og/S6U0LoFQ==
X-Received: by 2002:a17:90a:10:: with SMTP id 16mr9849106pja.50.1633049288896;
        Thu, 30 Sep 2021 17:48:08 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:159f:3ab6:88f:1129])
        by smtp.gmail.com with ESMTPSA id l14sm6307358pjq.13.2021.09.30.17.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 17:48:08 -0700 (PDT)
Date:   Fri, 1 Oct 2021 09:47:59 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     akpm@linux-foundation.org
Cc:     andreyknvl@gmail.com, arnd@arndb.de, ast@kernel.org,
        benh@kernel.crashing.org, bp@alien8.de,
        christophe.leroy@csgroup.eu, davem@davemloft.net,
        dvyukov@google.com, glider@google.com, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        monstr@monstr.eu, mpe@ellerman.id.au, paulus@samba.org,
        pmladek@suse.com, rostedt@goodmis.org, rth@twiddle.net,
        ryabinin.a.a@gmail.com, senozhatsky@chromium.org,
        tglx@linutronix.de, wangkefeng.wang@huawei.com
Subject: Re: + kallsyms-remove-arch-specific-text-and-data-check.patch added
 to -mm tree
Message-ID: <YVZav3rnb3+A9bHz@google.com>
References: <20210930212149.TDvMQI9fl%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930212149.TDvMQI9fl%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (21/09/30 14:21), akpm@linux-foundation.org wrote:
> +++ a/include/linux/kallsyms.h
> @@ -34,8 +34,7 @@ static inline int is_kernel_inittext(uns
>  
>  static inline int is_kernel_text(unsigned long addr)
>  {
> -	if ((addr >= (unsigned long)_stext && addr <= (unsigned long)_etext) ||
> -	    arch_is_kernel_text(addr))
> +	if ((addr >= (unsigned long)_stext && addr <= (unsigned long)_etext))
>  		return 1;

Does this need to include _etext or should it be '< _etext'?
