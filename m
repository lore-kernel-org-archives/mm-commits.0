Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33034EB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 26 Jun 2023 06:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjFZGOh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Jun 2023 02:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjFZGOg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Jun 2023 02:14:36 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965A4FE
        for <mm-commits@vger.kernel.org>; Sun, 25 Jun 2023 23:14:35 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-666e5f0d60bso1183637b3a.3
        for <mm-commits@vger.kernel.org>; Sun, 25 Jun 2023 23:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687760075; x=1690352075;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zSRFXahJfLVRfHzOeRCwRiq/E/w0B8owux+VH84uz1Y=;
        b=bW1JwphCaIeQuDuAMaiaZ79EXMhelEieM2bP3wq/jMXLm3/dlNhrJZ5sea1lElKgBG
         whHRZ3KXT0d03xi9yu9NHtyoWYZ/rVeJ9M5GQaWK+BAbh3zRbXajzSEJuzjVMS+PILKu
         LUfiKrM361ySXCmE4FaI2qRxck+LfWsggqBuQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687760075; x=1690352075;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zSRFXahJfLVRfHzOeRCwRiq/E/w0B8owux+VH84uz1Y=;
        b=ctEEfqg14Ow+D7SoivfsM/yqNWYK6c6Xc3maOlC1ROUX6zf9zPWqOtd7ATrxj9Xozf
         xjnDEz2tleuVizT+l6CiCj29j1tAvHrioOXpwj6xio4u6UoNI9vBEoyBU3bhEK8WMafQ
         STRX/XNPluWDM4rk4Wkk7CKTHf1LcbozUVEMDFRJIR2T61ZJXQ/pEQ1Zdu7T7ae3auiK
         XVE2EgYTVFhu7igc8S16e08lvWir8XULRSqVdP4P0ic/AGPWUa/f6jyG5v9LSsQmIyJS
         dt6q+tw0xlqpsl/xjLGlPfArZWvR6DeJYKGbpvqg+8mhfjbGt7tyIEhsM7qm0Vw98qaK
         qJTg==
X-Gm-Message-State: AC+VfDxhk4lAfwRC4OBuPXWiLhF84Vh8obkB6p610amsRyUGNy+lBfcp
        QQCm7u0Fgcgc7Xaz8BmVmUrjmL6/Ahc1PoM3n38=
X-Google-Smtp-Source: ACHHUZ64EYhXY2T5Qn9rXiU+Ne1I03dXnU5xlgPRi5S4nyAlSQASatodCneCY2osuL5Bh7Y6ea1szQ==
X-Received: by 2002:a05:6a00:14c4:b0:668:7090:bf18 with SMTP id w4-20020a056a0014c400b006687090bf18mr19278724pfu.34.1687760075036;
        Sun, 25 Jun 2023 23:14:35 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id c4-20020aa781c4000000b00653fe2d527esm3064155pfn.32.2023.06.25.23.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 23:14:34 -0700 (PDT)
Date:   Mon, 26 Jun 2023 15:14:29 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, zwp10758@gmail.com,
        senozhatsky@chromium.org, pc@cjr.nz, mcgrof@kernel.org,
        keescook@chromium.org, joe@perches.com, gregkh@linuxfoundation.org,
        tiozhang@didiglobal.com
Subject: Re: + cred-convert-printks-to-pr_level.patch added to
 mm-nonmm-unstable branch
Message-ID: <20230626061429.GI2934656@google.com>
References: <20230625035813.A23CAC433C8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230625035813.A23CAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On (23/06/24 20:58), Andrew Morton wrote:
> 
> Use current logging style.
> 
> Link: https://lkml.kernel.org/r/20230625033452.GA22858@didi-ThinkCentre-M930t-N000
> Signed-off-by: tiozhang <tiozhang@didiglobal.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Joe Perches <joe@perches.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Paulo Alcantara <pc@cjr.nz>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Weiping Zhang <zwp10758@gmail.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
