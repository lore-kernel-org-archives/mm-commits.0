Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708D7C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 01:53:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B84A64EB1
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 01:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhBYBxm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 20:53:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235198AbhBYBxm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 Feb 2021 20:53:42 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDC8C061574
        for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2021 17:53:01 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id c8so4664946ljd.12
        for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2021 17:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mh7o610LxlV2/U6h/ZruDPO4/3tZZo0CK9z9YNL0Osc=;
        b=CaiAx2UvsURkIclBiKEd8v5fQdmINg0E+P031xrPnjuSfkRh01ODYwRKRyYQAB7Mfe
         RJZUqI5UvvWbnzraXAO97VdSYgH76v0afcOXb/SaN4Mda1V0lrS2lzWOC7ZJcspy49lt
         xjBQLsCfsSgQMOgXzxGE6NAzu45qTDpwvX1gY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mh7o610LxlV2/U6h/ZruDPO4/3tZZo0CK9z9YNL0Osc=;
        b=I9gBNJFTIFEX0hYIZSfibMqPQPLZSJOhTKcA9NggMl3jIZrmwChQRbZ5amDVGZOk8r
         eLD3ODq0jXfvFNFBuvdGeVfYXR+EGhx7QrDWFvtqJtP7al2BRc69gYKaHVECW2NAAz0t
         E3E1GoDnQ7pGHHAm22otIMyegsVn/270WdzsrrcMRii1Q0sZhFm526yMbipIGpHrYkd5
         qiJ04mT97StCJnkgkD2z9C+sDk20eNf1ORm8bMMTtePXnYCXP4ppyHv2bHQQ1s9aILAL
         hluDFWADn9XAklVOHUI3TPn+NDFpRvfyB/+HcZXpTmtS8UIw8CPx6t/G0JY+44DIhrvA
         22AQ==
X-Gm-Message-State: AOAM530PTigMwgGJQ1KnAmR/pKvmk8Pk+z+RJABLLZvz8icGLyBoQjZG
        tGYjUejF6DA7WtGrJzNRFsrNHSV633NNpA==
X-Google-Smtp-Source: ABdhPJyc6J4teRTtj/rZuLWpmyGStkBKUP3w17NAVz0iNCIaiEMTJC4jmzmEX3JRMy0umCK8yM3Hxw==
X-Received: by 2002:a2e:9c50:: with SMTP id t16mr337372ljj.102.1614217979817;
        Wed, 24 Feb 2021 17:52:59 -0800 (PST)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id w12sm837078ljo.20.2021.02.24.17.52.58
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 17:52:59 -0800 (PST)
Received: by mail-lf1-f52.google.com with SMTP id v5so6092937lft.13
        for <mm-commits@vger.kernel.org>; Wed, 24 Feb 2021 17:52:58 -0800 (PST)
X-Received: by 2002:ac2:4acd:: with SMTP id m13mr460260lfp.201.1614217978393;
 Wed, 24 Feb 2021 17:52:58 -0800 (PST)
MIME-Version: 1.0
References: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
 <20210224200055.U7Xz47kX5%akpm@linux-foundation.org> <20210224203708.4489755a@oasis.local.home>
 <CAHk-=whoqLWCcUXOBfWsEu49jLRJFkwnCRq6dyjg_M=dO1FhcQ@mail.gmail.com>
In-Reply-To: <CAHk-=whoqLWCcUXOBfWsEu49jLRJFkwnCRq6dyjg_M=dO1FhcQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 24 Feb 2021 17:52:42 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgyUz_NPbvK7TGrriOjXSiqvQm5pPN5xGpePRR16w+ZFw@mail.gmail.com>
Message-ID: <CAHk-=wgyUz_NPbvK7TGrriOjXSiqvQm5pPN5xGpePRR16w+ZFw@mail.gmail.com>
Subject: Re: [patch 014/173] mm, tracing: record slab name for kmem_cache_free()
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, jian.w.wen@oracle.com,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Feb 24, 2021 at 5:51 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I can obviously revert, but if the fix is the two-liner you outlined,

Duh. Three lines, not two...

          Linus
