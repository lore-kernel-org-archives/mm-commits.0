Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC2FC433B4
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 10:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 816BE610A0
	for <mm-commits@archiver.kernel.org>; Thu, 13 May 2021 10:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbhEMKdK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 May 2021 06:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhEMKdK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 May 2021 06:33:10 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CD9C061574
        for <mm-commits@vger.kernel.org>; Thu, 13 May 2021 03:32:00 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id x19so37892405lfa.2
        for <mm-commits@vger.kernel.org>; Thu, 13 May 2021 03:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iXPfQNhEYBMN4E4yvqjZVMifmf38lIyyCaeoeAJs/jc=;
        b=NT7//NAk4h1DYrDZajgg7M6Q8gqo6nVt6tE2cyP+8Y7OHMU+d+we2G8YmMh4PbNalt
         0eCuOKlk061I9YUP1SBE82Obc29Yt7Io1pDdn+Y+UiBpH4bADKf4Er2bdDNF0021Ok0A
         tKAhzIgGNViBOW7M5GDBkYo9dx5QN+TrE6PpYBydnXV/cASOEaJ+Pvvq4qZuUCqFyby2
         mQv8IwgVFMde5eyNIMRcQ5BwF+uomHHHd/UTGgvAaVwon9SnY5GsOC2kYZpjhl8ns8jJ
         x8ONNOibcsGVOmr51uWnFIVywD7QMdmuV7VzAoLKMbmeKLbn8CVO7v0+FEpzVl/Gp1ak
         2OwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iXPfQNhEYBMN4E4yvqjZVMifmf38lIyyCaeoeAJs/jc=;
        b=EnIhJbyu09v59yq3sotS2zzQWy05f6C5hrC621kveyKAVAWAJ+7+7JmLypPnXFsFyk
         3rjBjR6S7vC4Hy6c2z+gvX1l110/OioIv869007BCc29A2uwBjsOgivLSRFWuYTnqFKM
         jPtsVj4x8cP1ByIhT4kS/1WNhfWujGfYysLsTQ2OdUHhpksjBO1qugRg7j3V00YIpmWf
         p+4J0yvq5kHyTF6j9DqV3V8DXtc6O4MQUjrEbRinST7wiiZXTayYogQRc8cKM9HpqKIb
         KMfp8HtZWtYrtJHsFG0dZnHQOm5GCqdtq7hURMvD7oNeHbpF5oCGAVPULgvuWGcsaOK7
         vJ7w==
X-Gm-Message-State: AOAM533o2o/8zqcPYYd520DqN94Oc+LnFQCeArjIDBfv2q9wijwBwiXP
        Vjnu/y40xP9X7Zf+kIvqYY4=
X-Google-Smtp-Source: ABdhPJxyVXFEhXGewO1U3zPiTk0Z9as2mVJCYryu70imAuBKYv7flGPVj/j0IM0c0w0wJb+D2MQh0g==
X-Received: by 2002:a19:6446:: with SMTP id b6mr29009778lfj.98.1620901919016;
        Thu, 13 May 2021 03:31:59 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id p2sm250930lfc.115.2021.05.13.03.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 03:31:58 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Thu, 13 May 2021 12:31:56 +0200
To:     Stephen Rothwell <sfr@canb.auug.org.au>, akpm@linux-foundation.org
Cc:     akpm@linux-foundation.org, hdanton@sina.com, mgorman@suse.de,
        mhocko@suse.com, mm-commits@vger.kernel.org, npiggin@gmail.com,
        oleksiy.avramchenko@sonymobile.com, rostedt@goodmis.org,
        urezki@gmail.com, willy@infradead.org
Subject: Re: [failures]
 mm-vmalloc-print-a-warning-message-first-on-failure.patch removed from -mm
 tree
Message-ID: <20210513103156.GA1856@pc638.lan>
References: <20210512202952.PRR7JClh8%akpm@linux-foundation.org>
 <20210513085602.6d3f9d63@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513085602.6d3f9d63@canb.auug.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, May 13, 2021 at 08:56:02AM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> On Wed, 12 May 2021 13:29:52 -0700 akpm@linux-foundation.org wrote:
> >
> > The patch titled
> >      Subject: mm/vmalloc: print a warning message first on failure
> > has been removed from the -mm tree.  Its filename was
> >      mm-vmalloc-print-a-warning-message-first-on-failure.patch
> > 
> > This patch was dropped because it had testing failures
> 
> Removed from linux-next.
> 
What can of testing failures does it trigger? Where can i find the
details, logs or tracers of it?

--
Vlad Rezki
