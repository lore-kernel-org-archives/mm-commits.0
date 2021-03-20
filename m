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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121DFC433DB
	for <mm-commits@archiver.kernel.org>; Sat, 20 Mar 2021 11:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D88286199C
	for <mm-commits@archiver.kernel.org>; Sat, 20 Mar 2021 11:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhCTL3s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 20 Mar 2021 07:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbhCTL3n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 20 Mar 2021 07:29:43 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D414BC0613A6
        for <mm-commits@vger.kernel.org>; Sat, 20 Mar 2021 03:40:02 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y6so13710568eds.1
        for <mm-commits@vger.kernel.org>; Sat, 20 Mar 2021 03:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pmKHmExTLQuY2TjAQk+J78li8R5i+nxLfT904tyPByA=;
        b=Z1vGX20sACmgw76vbcEmgNFihCVTiWYKT19vq45ZdRaIL/bbipURmrGeyKon/UTHQf
         MWvwh3vyOjl3QAp7FvE5L4D/GN1s+9UxvJWtrH8ZqdAXYsTLH8ZrXT8F1nKVmgskhrOS
         uKL2NsEUxEv1kLdeM1AxePmVITK6oxcQMbAGXywKbJ+dXhm3x68vDYqefCrmi3kcu8i4
         7wiHAmwdE7W+zfhplXFdT5Z2E603WVU1mLvLcuWD0W1EQYo3KuogjL4jO8GHQghoOBAk
         pV1sn6/0uon0nOhA66jFNFTMCK6VviIU1W0QMt74jZbv7ZSL0mZz1UnC3X08ZO2B8h5e
         nLtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pmKHmExTLQuY2TjAQk+J78li8R5i+nxLfT904tyPByA=;
        b=NrlgEjqd9xKLY+JfgK/pc984KIkHiyGsCBcpzrax/8/dXQspwx2610Kff9N4c2bMR/
         zIIo+lc4Qqpds/cW+Ej17Yab9ky6GSo5nPlxIXOs9GQq6jHPs7usgHnU4Kuy74mgjsqo
         ln9b+Lv9GUFsvlmxlLswT4TjDYLHNzhC0HbqCFTELv1YNUx2ivE1NyqjRbYyhM9MrHkc
         2WUdVzjg5JySxVdhCnpyQZc3DVhpmuu3IhIsG+os9eTREczlaMKURJFi9aaXDPALYsS/
         zpYHVuGl7K+plHrRdXlBEyN+D+xW+3Y1lMHKS3DwpPQ7gg6S71NMLUVs1dwcLUiIL0BQ
         hTAA==
X-Gm-Message-State: AOAM533/SZBvPag2hK5/o/+Rx7tMziYltKOqWVPRhEuf73HWlOg2XYYs
        inEyEQ8BtxC0SMAueQScpYp2D+YCaw==
X-Google-Smtp-Source: ABdhPJyioBwpCUfDPIf8LPHyIZG42QexGzHDvPi8OaxAT1oTBN5qUTi9wnsGXNROi8SePnq5nPQ+pQ==
X-Received: by 2002:a17:906:d157:: with SMTP id br23mr8972035ejb.192.1616229473232;
        Sat, 20 Mar 2021 01:37:53 -0700 (PDT)
Received: from localhost.localdomain ([46.53.248.213])
        by smtp.gmail.com with ESMTPSA id u16sm5883392edq.4.2021.03.20.01.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 01:37:52 -0700 (PDT)
Date:   Sat, 20 Mar 2021 11:37:51 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org
Subject: Re: + proc-fix-incorrect-pde_is_permanent-check.patch added to -mm
 tree
Message-ID: <YFW0XxH+wH/6Nr5K@localhost.localdomain>
References: <20210319231814.DJd9aSf0-%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210319231814.DJd9aSf0-%akpm@linux-foundation.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Mar 19, 2021 at 04:18:14PM -0700, akpm@linux-foundation.org wrote:
>      proc-fix-incorrect-pde_is_permanent-check.patch

> Currently the pde_is_permanent() check is being run on root multiple times
> rather than on the next proc directory entry.  This looks like a
> copy-paste error.  Fix this by replacing root with next.
> 
> Addresses-Coverity: ("Copy-paste error")
> Link: https://lkml.kernel.org/r/20210318122633.14222-1-colin.king@canonical.com
> Fixes: d919b33dafb3 ("proc: faster open/read/close with "permanent" files")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

Doesn't hurt to check more entries.

Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>

> -			if (unlikely(pde_is_permanent(root))) {
> +			if (unlikely(pde_is_permanent(next))) {
