Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB530C77B61
	for <mm-commits@archiver.kernel.org>; Sat,  8 Apr 2023 08:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjDHIQ2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 Apr 2023 04:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjDHIQ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 8 Apr 2023 04:16:27 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19CB2E1A9
        for <mm-commits@vger.kernel.org>; Sat,  8 Apr 2023 01:16:02 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id r21-20020a17090aa09500b0024663a79050so2115715pjp.4
        for <mm-commits@vger.kernel.org>; Sat, 08 Apr 2023 01:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680941761; x=1683533761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vWQxjNJV/jpYyrZR4qZIL2bmISPOxqy6jIxUfPeJkWw=;
        b=g59pmwtaWAFKOl2nAqdbe5fWsKcntGO6jlmxCKbyFLsZv5yrHGmtpMX5Q75QpyGuuO
         JpF/UkWntohNk9NGO1aXU4oGFvSxa4CM3fWSQprNu87RFvyzrtsyWo3zl9I+vcK0jRjY
         k4nXiy1X17F5BiRaOXqae/IAIkGtEHLLVq+I0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680941761; x=1683533761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWQxjNJV/jpYyrZR4qZIL2bmISPOxqy6jIxUfPeJkWw=;
        b=wnOKKlSmwACyvNdCvV45Wtua28sIILcjUEbQYyKfcnaN30QaImUntG5wmKMwHtgIN/
         ZKYbvMVpscghUyIRwZCUiQbyeZYQZbDWXFPkhd+5ObkmWQuxTAkNafIvVNk3UY1e2DFB
         4aWH+7qF718suc7b9pkQxsLbQyZ6+YDQPAtVwtO8fkeF2Q8e2U3Dft8M+lmnb/VTAJOR
         UT0ZewYeo+NnmoCzOreYjGmJ7SPL5wD5CY8BGM6wntFpZbSV/+UK0+Qh41yj5YsmQar+
         8Mm3F1SVmx0prGEs0TxkO7JwK60cNub6+Qq7/b7eoaUnQR/s0rky1Eim2C+wbTVdgAUx
         12pg==
X-Gm-Message-State: AAQBX9dL2eG2yVouQ6nIJNOLkmLMrz4kfbP3yOVrugggLnzvuReIOBDZ
        O3wj4FvG3jVa7Ul/qqcbC+nuKA==
X-Google-Smtp-Source: AKy350bytcmLP14CG/XBO3Oq+TyXDmd9GdgLgLONigMuoMhumoUVc2bej1Bh3nIjEkTi0SnWUzS9Ww==
X-Received: by 2002:a17:90b:3507:b0:244:ae1e:1998 with SMTP id ls7-20020a17090b350700b00244ae1e1998mr5119618pjb.40.1680941761550;
        Sat, 08 Apr 2023 01:16:01 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id u1-20020a17090add4100b00230ffcb2e24sm2820308pjv.13.2023.04.08.01.15.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 01:16:00 -0700 (PDT)
Date:   Sat, 8 Apr 2023 17:15:56 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de
Subject: Re: + zram-fix-synchronous-reads-fix.patch added to mm-unstable
 branch
Message-ID: <20230408081556.GB12892@google.com>
References: <20230407221754.E8045C433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407221754.E8045C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/04/07 15:17), Andrew Morton wrote:
> 
> turns out this doesn't even compile for PAGE_SIZE > 4096.
> 
> Below is the fix, which also removes the #if and instead relies
> on compiler dead code elimination.  I wonder if zram should (maybe
> optionally) also offer a 512 byte block size, so that we could
> also test the smaller than page size I/O path even on x86.
> 
> Link: https://lkml.kernel.org/r/20230407072224.GA8982@lst.de
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
