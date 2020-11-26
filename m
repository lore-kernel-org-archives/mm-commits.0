Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC521C56202
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8639C20B1F
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 00:23:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aEWDnKOL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgKZAXS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Nov 2020 19:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728449AbgKZAXR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Nov 2020 19:23:17 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE85CC0613D4
        for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2020 16:23:17 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id t8so12793pfg.8
        for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2020 16:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xg/dLvx0N8Zb5TkW5t3vsakr3hJ0FQG6CMuU4xSFuIU=;
        b=aEWDnKOLth1/q1m9Nmz6gNd+pHeMg6K8hkg6Avp4mcK+Iudtu5h2gndpR0D3YaxwZX
         tJDXElgxLOsG5oPppbwuZE9Dqr3akMPa7GQVFfuLmP5/7p5LGDGG8wYNp+kIiuF4wWZH
         5YpbKEngkoRnHE61HWCw8Kt9AdWzweKShxVx3rK4O6/yWsxZE5M0LRkROSGpAbw5Ao8s
         501Djlv9vYAbT0TWdr3pTaeoOmlMwJ0te+Wc4kshFNDtxdnDqguiRrFX1nzlzdMYH7iL
         eALwpq/dnsSiMKFgK2aKuj301vum990RV0qvS2hWJZNSkma7IVEoq9RCw3Z8ErdvT6CH
         NDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xg/dLvx0N8Zb5TkW5t3vsakr3hJ0FQG6CMuU4xSFuIU=;
        b=Su06WVZFp/sKPy0q7SMJ6SgSNAIJMb8+aJkc0X7VojzWJZQ2+Oc9JV5G91bZjyp096
         0fHCtrW0wH1toabx35q6cg8HRfGMoPCzt4xsFDHgOpwfnGAd/1XYtMRFz/DUSMzOvu9a
         4OPBmdOxIRkhhrIgOsiPLDzbR0K5TNgKluBMhImqTFKrWv8C5ocvULKD4GbbSca9Ehq1
         P+7AUdxn4/sMoeqC2Eb7fp2YSW8A4CClop8ohCEfzwoVu1u2pkKmmwfxregBkQ7N5onB
         qP7s1VCDsSx7lNM896GfdN7jy4odq2e2iOD2U6O6MracgYnHizpaUtnDmpW+k8liCJrD
         yIOg==
X-Gm-Message-State: AOAM533Yv69+az4p2VZIQDFSDs3Dh2l2+xnZ2iceIZ2fzNhhKW6VCZZC
        V80JMiemMuy/anNTtEu0538=
X-Google-Smtp-Source: ABdhPJwbg6QkU4hea6u1XlN//SotyVf9xJRqWVjJvyDXKbt9ZESKQrKWaI/OOt+meqQfd6uumMOTyw==
X-Received: by 2002:a17:90a:788e:: with SMTP id x14mr393838pjk.139.1606350197226;
        Wed, 25 Nov 2020 16:23:17 -0800 (PST)
Received: from localhost ([2401:fa00:8f:203:a6ae:11ff:fe11:4b46])
        by smtp.gmail.com with ESMTPSA id r66sm2895331pfc.114.2020.11.25.16.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 16:23:16 -0800 (PST)
Date:   Thu, 26 Nov 2020 09:23:13 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     akpm@linux-foundation.org
Cc:     minchan@kernel.org, mm-commits@vger.kernel.org,
        rsalvaterra@gmail.com, sergey.senozhatsky.work@gmail.com
Subject: Re: + zram-break-the-strict-dependency-from-lzo.patch added to -mm
 tree
Message-ID: <20201126002313.GA3723071@google.com>
References: <20201125213102.EI9Vpki-V%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125213102.EI9Vpki-V%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (20/11/25 13:31), akpm@linux-foundation.org wrote:
> Since the beginning, the zram block device always enabled CRYPTO_LZO,
> since lzo-rle is hardcoded as the fallback compression algorithm.  As a
> consequence, on systems where another compression algorithm is chosen
> (e.g.  CRYPTO_ZSTD), the lzo kernel module becomes unused, while still
> having to be built/loaded.
> 
> This patch removes the hardcoded lzo-rle dependency and allows the user to
> select the default compression algorithm for zram at build time.  The
> previous behaviour is kept, as the default algorithm is still lzo-rle.
> 
> Link: https://lkml.kernel.org/r/20201122095051.4819-1-rsalvaterra@gmail.com

Reviewed-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

	-ss
