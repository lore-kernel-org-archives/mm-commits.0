Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98202C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 26 Mar 2022 14:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbiCZOfP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 26 Mar 2022 10:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiCZOfO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2022 10:35:14 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D031F611
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 07:33:37 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id bg10so20459872ejb.4
        for <mm-commits@vger.kernel.org>; Sat, 26 Mar 2022 07:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r2Z5mXbF5V2c+QhdhI+R0ZWaNEeFhsKVzQxlNibPK8I=;
        b=bTdKu8t9rkx0PTwkrPqn14Gm8l+0DURIqULEqTfWOKfDun4z51QHaG9zltEg17Y7xR
         6zwyvYiaIrkKhgDT+dH/vXBc1vNeuoXyp8JTYXiScd0b9rWyr3sjsf8Y7X/nYYpw0rum
         c+JetDMs5ERnMH4IA7ikbx+pUb2Og65xKY4gzvH757Z5X7QCCEYzVaRlKUoiLccUp39E
         1iwGVRpJkZeYaOwJ+91hGT6htz8cLP9GhxnA0RLHLo8kO/RhneA6WlSl0ftMnNKbPHxZ
         z1Uvlz8LGv1g+O2tuGclGMVBlarapaWkuuM8Q/6ZfqaYkBErBhTrv3Pfo6Z2nBi4EuwE
         2VPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r2Z5mXbF5V2c+QhdhI+R0ZWaNEeFhsKVzQxlNibPK8I=;
        b=lb8/UJ0fPyit2F4NrZeeiD+m0ZLKXNM3YibETyMCyiO3rYy9rAtgevg1i6rDY/glrg
         JDvf3TMOIGnikRnxaeGj3icQIkoI3IziljqSBV2c8kZWzOtF1WW5iK/j1G9XS/OcDPDY
         FMgtyLU3X8paK9NqyXj7mOx4Fs9FSkKwfuzgo+JdO3FjW7WKQqKgZzISrGOz7xCXW1WD
         RjQQZDpI/VYxkVGPiaOBMLxBAsXpdEyYQFUvfQMFklXmh4R8fL2iPZTBaniAsOfCesZn
         qAbUGlJYQ59GVAKAeIiQwmMO0yTkbEcgcVSRcWqSydFaYWzN0Q+LqJWxj0sLhyEsUCAY
         0Nfg==
X-Gm-Message-State: AOAM5310+iM2gsznJ4lr8S58FexqDZZhNKgqx35jRk9pzkY13M+IGQuK
        AnaB+xpV7wGP6Mr8ts0VSDh7mE8ZLw==
X-Google-Smtp-Source: ABdhPJyY7KCIv+gLdkX36gijAhufYdCVwfkh04j18SBn45U+j/MyZWWdZJaUc8cchOJWNdaWaN4S/Q==
X-Received: by 2002:a17:906:58d6:b0:6da:bc08:af7 with SMTP id e22-20020a17090658d600b006dabc080af7mr17240273ejs.537.1648305215962;
        Sat, 26 Mar 2022 07:33:35 -0700 (PDT)
Received: from localhost.localdomain ([46.53.254.45])
        by smtp.gmail.com with ESMTPSA id r22-20020a17090638d600b006d584aaa9c9sm3559935ejd.133.2022.03.26.07.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 07:33:35 -0700 (PDT)
Date:   Sat, 26 Mar 2022 17:33:34 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org
Subject: Re: +
 proc-fix-dentry-inode-overinstantiating-under-proc-pid-net-checkpatch-fixes.patch
 added to -mm tree
Message-ID: <Yj8kPp6FctCnMu7a@localhost.localdomain>
References: <20220326032728.43D0EC004DD@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220326032728.43D0EC004DD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Mar 25, 2022 at 08:27:27PM -0700, Andrew Morton wrote:
 
> WARNING: braces {} are not necessary for single statement blocks

Who is inventing all these silly rules?

> #31: FILE: fs/proc/generic.c:452:
> +	if ((*parent)->proc_dops == &proc_net_dentry_ops) {
> +		pde_force_lookup(ent);
> +	}
