Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A64C38A2D
	for <mm-commits@archiver.kernel.org>; Tue, 25 Oct 2022 07:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiJYH61 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Oct 2022 03:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbiJYH6Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Oct 2022 03:58:25 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47623168E78
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 00:58:25 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id m6so11162485pfb.0
        for <mm-commits@vger.kernel.org>; Tue, 25 Oct 2022 00:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=18OjFPJqdKA3mkKe4s0tgRWLoiVeiEVmvtXfL4NGWPk=;
        b=BXtTrzXm79bDl+jiwC2lenGAHqYY6WeMJv8icZFlm3D7e6KaWPt8hqt2uR5eh5CY9V
         BHds6F0hYiH9Qe72ss/WxrkuRJexqrXwJNBS5076fsQ/lMlA09kON0veERZ8E0zy0zts
         vRciapFtjU4SqDnZXABbARFVvNkwvCHXPSB3M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=18OjFPJqdKA3mkKe4s0tgRWLoiVeiEVmvtXfL4NGWPk=;
        b=3/nNByHcxCl+BHURKOse4O+tKxuj+rxHn2h3Ea5ZCEppLOX/E9C8I2USemgfhQ3e2H
         ++c9bEh5+AcenrXBnpdQ9WN0HbDlycCfsXMWmGlubM28jK45j/l7vTQRXbjhnfYEx5Uj
         eGpuuwd6EcfOg1aBxcyt5NJiWqJIKgQHwUJLZA1BbLDob50H2M8rWsGz+tygOxtS3yFY
         mMcaWfGpCLfMu0Det/pa11Ux+8CVL6yh5ZYZWMn1rIq0TNw+NeFNRepymGvFLfzCHkFM
         pl70vxgDDuF6CwpFj2+yjSosH0UR4xelWfZJD9gp1bqptwh72YYYdDiTWGVb0E0jFgwr
         WBVA==
X-Gm-Message-State: ACrzQf0ViMBh9QnYinFxHm9wKLhfEwLxplaJYnHZfrsmz3Fjin1l+wFU
        UTioBZLPN7kfQBw8UFHDKFzEwQ==
X-Google-Smtp-Source: AMsMyM7h4ywnc4Oyc/4VaA3NZT3i7jkbG1FQDDm9Eer8q/zYy4UGvCHRR8pM5gQWiFzmby2c3KG+kw==
X-Received: by 2002:a63:145d:0:b0:44b:f115:f90f with SMTP id 29-20020a63145d000000b0044bf115f90fmr32037638pgu.157.1666684704825;
        Tue, 25 Oct 2022 00:58:24 -0700 (PDT)
Received: from google.com ([240f:75:7537:3187:c493:65a6:2d64:1325])
        by smtp.gmail.com with ESMTPSA id r13-20020aa7988d000000b0052d4b0d0c74sm904133pfl.70.2022.10.25.00.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 00:58:24 -0700 (PDT)
Date:   Tue, 25 Oct 2022 16:58:20 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, ngupta@vflare.org, minchan@kernel.org,
        senozhatsky@chromium.org
Subject: Re: + zsmalloc-make-sure-we-select-best-zspage-size.patch added to
 mm-unstable branch
Message-ID: <Y1eXHN9aDwKKuuQK@google.com>
References: <20221024203545.3BBBCC433C1@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024203545.3BBBCC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (22/10/24 13:35), Andrew Morton wrote:
> The patch titled
>      Subject: zsmalloc: make sure we select best zspage size
> has been added to the -mm mm-unstable branch.  Its filename is
>      zsmalloc-make-sure-we-select-best-zspage-size.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-make-sure-we-select-best-zspage-size.patch
> 
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Andrew, as was discussed in another thread, please drop this one.
(but only this one)
