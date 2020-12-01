Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FFDC64E90
	for <mm-commits@archiver.kernel.org>; Tue,  1 Dec 2020 03:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC9E020725
	for <mm-commits@archiver.kernel.org>; Tue,  1 Dec 2020 03:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V2FQNyRn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbgLADNj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Nov 2020 22:13:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727368AbgLADNj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 30 Nov 2020 22:13:39 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E47C0613CF
        for <mm-commits@vger.kernel.org>; Mon, 30 Nov 2020 19:12:59 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id w187so177732pfd.5
        for <mm-commits@vger.kernel.org>; Mon, 30 Nov 2020 19:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/FFtbtzP3kTJAWGQByPQ8U+/ZFp1Aap8O/73nyaHCY4=;
        b=V2FQNyRnat/pHQF4c6zLaW9BYOkFGGNqO9gaAVT2/QEf6+OO9+mtZqgWM9PNpbOtNW
         HB0iedoZLaTL6nAxlCA6yk0O8jtG2jQZ7u05XvpMW3h1FpLKeQorthg15tfv2fEkDurJ
         dSA+GDsGq+TxcRdPkqac/rhObuMarGJfy+WqNydLOd7SIPimXlw88/I3dFbf4NgfQ64Z
         6P9MQy3fUMZvBPljWZihwY5IToQQRiqoY5HikxW3EPdX8BeJ5QhVJt5WKg82yQm+PGGT
         trdUj8zW9rgODiMNf1nOL0H1hzLWpJU92u8of3f4bVU5U43IbgQy2JOzNHH0HPfgRq1G
         Ve6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/FFtbtzP3kTJAWGQByPQ8U+/ZFp1Aap8O/73nyaHCY4=;
        b=owD9SZU5QWE3z77r92NfYIwE4HlfB53xszVjgPoJnBPj2R4K2gJ9izoCRuLc7e1Nwx
         cxAISRyJ/4EYH/SnhsCWmeFNRBqW/M8EDm5CZ2ZBcfTZ0qaNCA6OH1AL5Ay1dB+WUEzS
         nq+M1SlDuEiz5ComJQM7Rgsdyoau32/EFcNmSezjS7Xe7M7z+eUq7GJ27YaUSZEbzQYh
         RFg81LQRrlUuPQ9Um6Lo95i1wP5TqOaIBjUVtjQWjD1ZF+oQDxcrVZ+V76Q3eQSVatNF
         0B874/i4K0gS4Gqo7WS4ERVseIfis7iIuucULjIKJg80EebwXRqipBwh7Vu9KJOO5nfi
         KrGw==
X-Gm-Message-State: AOAM532uvIiCLLvgzJ2Hxc2ZAdOuB9jF0XRcn1XXOTDH4PdL0+qgDkzH
        ENX2VpW09LMaG1z1IKE/tiM=
X-Google-Smtp-Source: ABdhPJzoM4gPmQq7kR3afI/1pa2FvvGAI2/n2zv07izWxI+7iUFaA1svIXf1tV3wwjM/cbfMZJ4FCA==
X-Received: by 2002:a63:1c25:: with SMTP id c37mr507072pgc.164.1606792378580;
        Mon, 30 Nov 2020 19:12:58 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:a6ae:11ff:fe11:4b46])
        by smtp.gmail.com with ESMTPSA id r7sm334215pjd.8.2020.11.30.19.12.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 19:12:57 -0800 (PST)
Date:   Tue, 1 Dec 2020 12:12:55 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     akpm@linux-foundation.org
Cc:     minchan@kernel.org, mm-commits@vger.kernel.org,
        sergey.senozhatsky.work@gmail.com
Subject: Re: +
 zram-add-stat-to-gather-incompressible-pages-since-zram-set-up.patch added
 to -mm tree
Message-ID: <20201201031255.GD3723071@google.com>
References: <20201130204126.vQeku2E_m%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130204126.vQeku2E_m%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (20/11/30 12:41), akpm@linux-foundation.org wrote:
> 
> Currently, zram supports the stat via /sys/block/zram/mm_stat to represent
> how many of incompressible pages are stored at the moment but it couldn't
> show how many times incompressible pages were wrote down since zram set
> up.  It's also good indication to see how zram is effective in the system.
> 
> Link: https://lkml.kernel.org/r/20201130201907.1284910-1-minchan@kernel.org
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Looks good to me

Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss
