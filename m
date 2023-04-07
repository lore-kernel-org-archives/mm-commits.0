Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 963EEC761A6
	for <mm-commits@archiver.kernel.org>; Fri,  7 Apr 2023 01:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237197AbjDGBGq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Apr 2023 21:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjDGBGp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2023 21:06:45 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D9283FA
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 18:06:44 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id z19so38943654plo.2
        for <mm-commits@vger.kernel.org>; Thu, 06 Apr 2023 18:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680829604; x=1683421604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dlgcd23x81UX1SF70BqoK7xt4GBfnlpGHVijK3aQ5Oc=;
        b=YqikPvdMMIPcPDz0O8Vul9/uJfBvorHNsUaW6XyuokfjLmT03ZiEKO5DKBLMLo+ZZ1
         8i7TE6VGzzYvZU7AQ4YQPjNfszKJDaD9Jd4vNqA7uPHwXD+5RE96eq4OczZA9WFCwk3J
         Bj1FjDTvToNx8NC8YjmDSO1ISMisz/2BSffW4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680829604; x=1683421604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dlgcd23x81UX1SF70BqoK7xt4GBfnlpGHVijK3aQ5Oc=;
        b=YIaed1foY0P6mC2+siMpVbV7JyqPwomerw7A2zMbetDp4FVbtYlW4X0CWSAZfHOztg
         nf7vOcMIwNnGLkepvwZjT6UC2QrlW3beeeMY+BfW92H2lU1GsGycq8EdvHrU9fiY1G19
         lXk3cyOaiugc0ImyBAvhb2iVw7CVknGubl/8AnJQmHpYAITUaRdsY0J4XoAxnetC76BU
         NT3zBM6VC4suN4qqwMRKGOIB0uK6uX0dm48PYfnh599utGchKteaICHNi74vGl5Rq60F
         /aEyAjQg57hQcCQQN9eihM2Y+YuoInCpprbhuSTWIEmHiTtHA390LUN9p5OD3d84tkCn
         XUOA==
X-Gm-Message-State: AAQBX9dK09U20Rcb2ZvO2iOwX2g0ot4vwmx9PJaZhsAdVjDSjXLYkuIS
        on6ZHbhMLOtTIElj3qTMzy3wWA==
X-Google-Smtp-Source: AKy350ZOp01WxwOWhoVVJQrtLBF9/+CzIQT4moc/gBB9yE7DtNI8LzgTFp83lioGuAplPvLTmZGscg==
X-Received: by 2002:a17:90b:1e51:b0:23b:2963:ec94 with SMTP id pi17-20020a17090b1e5100b0023b2963ec94mr525366pjb.29.1680829603879;
        Thu, 06 Apr 2023 18:06:43 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id k17-20020a17090a911100b002448c1bb00csm1740570pjo.20.2023.04.06.18.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 18:06:43 -0700 (PDT)
Date:   Fri, 7 Apr 2023 10:06:34 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, senozhatsky@chromium.org,
        minchan@kernel.org, axboe@kernel.dk, hch@lst.de
Subject: Re: + zram-return-early-on-error-in-zram_bvec_rw.patch added to
 mm-unstable branch
Message-ID: <20230407010634.GZ12892@google.com>
References: <20230406221835.90C4BC433D2@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406221835.90C4BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/04/06 15:18), Andrew Morton wrote:
> 
> When the low-level access fails, don't clear the idle flag or clear the
> caches, and just return.
> 
> Link: https://lkml.kernel.org/r/20230406144102.149231-6-hch@lst.de
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Minchan Kim <minchan@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
