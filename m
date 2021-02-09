Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D85AC433DB
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 22:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59A7164EB8
	for <mm-commits@archiver.kernel.org>; Tue,  9 Feb 2021 22:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbhBIWHU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 9 Feb 2021 17:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbhBIWFP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Feb 2021 17:05:15 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54E3C08EC31
        for <mm-commits@vger.kernel.org>; Tue,  9 Feb 2021 14:03:39 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id f8so206577ljk.3
        for <mm-commits@vger.kernel.org>; Tue, 09 Feb 2021 14:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tx92KR5yoK7Kj/E1nLE3ghpQl5QQOqByWmJjzpCqtGY=;
        b=V9UwqGgzVSybr9MIk7X99nXuilfse+Mk3lydDn9RKCzCDYoRB0jaRN+0j9MgwzacFu
         gRu43Pm1ruDkaldhqSI5PoDCwr8oM5gMRZ1n8jG6KKWHOx0mKaox9/lF3u76ljge1VQS
         yj32Jj3AKfWfodOLM8Zk0KFcJSORZEpSei+Io=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tx92KR5yoK7Kj/E1nLE3ghpQl5QQOqByWmJjzpCqtGY=;
        b=ZQzZs7u1Yeg71Ttlp/M7Are++wOSH7dTfUtlztJzFsPb1dmLcXlLfBUC6mbnhtVQMU
         WUvfrKA4ScrXXpttDTuRSoGScz+dMUXtVC+hYWCrOjp6wYQ+NqyJKTbgn/m8827/jCrE
         XS7ZCTGPiXSdF9CQXAYCMh2H4/vAuyaNQ9UoAP7KNY7WG3gDiAMixRXjEg/sVUzjIwyp
         /sEt5mLM7Vx2WoE5rJZzF7SBNNFTJLX3APHn+hdoUgDGug0wqNhmuO0JrXZ8wehERE2S
         F2296uhwYxFhUwpyNL5tkqRWC71dXSoY9GUw9mOXTTLCdu38p/jLx9KGC4iivJIdgsHp
         f3aw==
X-Gm-Message-State: AOAM5330SfDstrLRjw5RfiHkIhmWsHaNvhhbQ3wZIpfuDcxkdd5X8/Xx
        SdcwDhvd33kADO+ehf4Maru85ccfLEW0yA==
X-Google-Smtp-Source: ABdhPJzmRzrFHs0yXJjagSBXQTA/P68tZf/TRFEt63C01jm+dNvlDw+l4Ma/cvwJyYYM2/B1pTtzzg==
X-Received: by 2002:a05:651c:236:: with SMTP id z22mr14945553ljn.404.1612908217610;
        Tue, 09 Feb 2021 14:03:37 -0800 (PST)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id b31sm2786849ljf.38.2021.02.09.14.03.36
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 14:03:36 -0800 (PST)
Received: by mail-lj1-f174.google.com with SMTP id c18so165501ljd.9
        for <mm-commits@vger.kernel.org>; Tue, 09 Feb 2021 14:03:36 -0800 (PST)
X-Received: by 2002:a2e:8116:: with SMTP id d22mr15212997ljg.48.1612908215823;
 Tue, 09 Feb 2021 14:03:35 -0800 (PST)
MIME-Version: 1.0
References: <20210209134115.4d933d446165cd0ed8977b03@linux-foundation.org> <20210209214217.gRa4Jmu1g%akpm@linux-foundation.org>
In-Reply-To: <20210209214217.gRa4Jmu1g%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 9 Feb 2021 14:03:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiDt_eJvfrr-dCXq3eZ+ZmVTD2-rM2pcxBk4d-FM3h-bw@mail.gmail.com>
Message-ID: <CAHk-=wiDt_eJvfrr-dCXq3eZ+ZmVTD2-rM2pcxBk4d-FM3h-bw@mail.gmail.com>
Subject: Re: [patch 09/14] tmpfs: disallow CONFIG_TMPFS_INODE64 on alpha
To:     Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Chris Down <chris@chrisdown.name>,
        Hugh Dickins <hughd@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Linux-MM <linux-mm@kvack.org>, Matt Turner <mattst88@gmail.com>,
        mm-commits@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Seth Forshee <seth.forshee@canonical.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Feb 9, 2021 at 1:42 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> As with s390, alpha is a 64-bit architecture with a 32-bit ino_t.  With
> CONFIG_TMPFS_INODE64=y tmpfs mounts will get 64-bit inode numbers and
> display "inode64" in the mount options, whereas passing "inode64" in the
> mount options will fail.

Ugh.

The two patches for s390 and alpha are obviously the right thing to
do, but I do wonder if we could strive to make __kernel_ino_t go away
entirely.

It's actually not used very much, because it's such a nasty type, and
s390 and alpha are the only ones that override it from the default
"word length" version (and honestly, even that default is not a great
type).

The main use of it is for "ino_t" and for "struct ustat".

And yes, "ino_t" is widely used, but I think pretty much all uses of
it are entirely internal to the kernel, and we could just make it be
"unsigned long".

Does anybody see any actual user interfaces that depend on
"__kernel_ino_t", aka "ino_t" (apart from that "struct ustat")?

I guess this is mostly a question for s390, which is actively maintained?

           Linus
