Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C569C761A6
	for <mm-commits@archiver.kernel.org>; Fri,  7 Apr 2023 01:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236739AbjDGBHn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 21:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjDGBHm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 21:07:42 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDB383F2
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 18:07:42 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id o2so38942120plg.4
        for <mm-commits@vger.kernel.org>; Thu, 06 Apr 2023 18:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680829661; x=1683421661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zu81gGfx+P32zq+10v36MBcO+P+PAeny7Az8JxnW1jY=;
        b=YDPuS9MTPkSSroWMGLm1rfI6BJhCyhCJQ1wePo3GvGxRDm6D1ofPZbI1X+PUR3vebX
         //MXoHi1Iy45Op6ciX/E5o3Ey8ZXxXFUDVZMd64E9tGwpDhHSbyCs6806hlO0YN+vIWx
         nhO/Jg3Gjei772MVi2FVxsyU7wkzO6eAl2rNg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680829661; x=1683421661;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zu81gGfx+P32zq+10v36MBcO+P+PAeny7Az8JxnW1jY=;
        b=kDsnr+nxVcDcfZonxE+X2gwz7V4x6BVuRTftqEF/NH39Iotc10p0XiMzK4BC6pseVs
         s48ZsgQpwzqwXitM/55Yvqve0wj2MivIzyMgyRAREp2/NJn/laKHrhnae7a1acqvgPQV
         3b9KlUBfwe+ACbdO9S/ZVO0ybLFt3Uf4GKl+auGoepVy5ZGpK2DCA687SJ0hb/HqvDhK
         vLu5vc14bfo0WlirTKFv5JfQ6+jkNuJcILjgKGypI02heh0UKsZ/OOB8oI3dimIVzaag
         fscC/smZspYNpbUVs33vbmZ5dIAvsGSzAMKshthaoDzmMoYNaQEYqNKMBUyZGY16jYXB
         zDgA==
X-Gm-Message-State: AAQBX9exImRjlinmv/G1kdq9mbJpM3TCZe9Pc15PH31vgI3pJSAX0NHS
        4maEOAcbCFSFJWxvIZ8Gk7mJpw==
X-Google-Smtp-Source: AKy350aOUry02YWc8idLTDNYTdhIUdyEzMz2WXu0+NXEbyQdxPfNKUtFq2lhBur33m27MpjggZflPw==
X-Received: by 2002:a17:90b:3e83:b0:233:fb7d:845a with SMTP id rj3-20020a17090b3e8300b00233fb7d845amr623336pjb.4.1680829661540;
        Thu, 06 Apr 2023 18:07:41 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id w7-20020a170902904700b0019fcece6847sm1905408plz.227.2023.04.06.18.07.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 18:07:41 -0700 (PDT)
Date:   Fri, 7 Apr 2023 10:07:36 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de
Subject: Re: + zram-refactor-zram_bdev_write.patch added to mm-unstable branch
Message-ID: <20230407010736.GA12892@google.com>
References: <20230406221848.5B0DFC433EF@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406221848.5B0DFC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/04/06 15:18), Andrew Morton wrote:
> 
> Split the read/modify/write case into a separate helper.
> 
> Link: https://lkml.kernel.org/r/20230406144102.149231-13-hch@lst.de
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
