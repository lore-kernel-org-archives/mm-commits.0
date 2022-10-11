Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3AE6C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 11 Oct 2022 17:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJKRI6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Oct 2022 13:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiJKRI5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2022 13:08:57 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B481A98C9
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 10:08:56 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id k11-20020a4ab28b000000b0047659ccfc28so10477679ooo.8
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 10:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J3Fqg+9feMJbILjgk++Bkfbac3ec4L/8fKPKqGtQdGs=;
        b=GlTdZOuh8v9Ksjs86dNpq80JgWCOer6MArumLBeRkLd5PJv7vki/Vwx+VjAQsfVNu6
         h4GqegcDW9PFftM1lZ8QwxD2jF7EivdL5mI6xa+V5EK45papkiZokO1I0lq0Em9XF8zp
         zCjzqEDXLzDrBhiEidB8bVRiD3fZbYaujfhTg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J3Fqg+9feMJbILjgk++Bkfbac3ec4L/8fKPKqGtQdGs=;
        b=x/Fx6cPrWTqjNXzrzHn91aSJ5RmMw6gzu9Zsi5s5UPOUTh7uAiNvL4n301utz6HCK/
         bvTE6sjKmAPN60p0E0OVWs2CGJ3zKYHzzfN97aj2wFjrh/c7x7E1s3L6J5O4KAbsf7g1
         AeYThkcXUaS3q0KTRI9LZi7S+6uKNkCBUm23Rmd9LVeOspb7bE/7DFPh/DHLEecyXFwa
         ikF7m/xRajLVfnRJkmp0Bd69EsOeybyTzE/VJQyfeXQJfI2fTnfc0IZrdJj5zbu6/uHf
         YFdi4cyrzqpzdc+tmHz97cJK1Dez4zLnIcpKUUkJZcX+4aY6Ih5seh9nYRWI5GnilOlx
         g18A==
X-Gm-Message-State: ACrzQf11I0eX4v+Iu1XX2CVIqoDkPrMl2iT9O2gesbBA7wvzzjBfBe4m
        hChwhHWrF5lynkIF42unDt3tkxSM8EymXg==
X-Google-Smtp-Source: AMsMyM7Qy2W9zUCLR4QT3zz4ijb+ebtPp0goomt8uHHeLheuwR9kdSgEYdqGMe2NT9szIgf8mGCh7A==
X-Received: by 2002:a05:6830:6286:b0:661:955c:f44b with SMTP id ce6-20020a056830628600b00661955cf44bmr5921194otb.159.1665508134217;
        Tue, 11 Oct 2022 10:08:54 -0700 (PDT)
Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com. [209.85.160.50])
        by smtp.gmail.com with ESMTPSA id o185-20020acaf0c2000000b0035418324b78sm5709602oih.11.2022.10.11.10.08.51
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 10:08:51 -0700 (PDT)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-132af5e5543so16639476fac.8
        for <mm-commits@vger.kernel.org>; Tue, 11 Oct 2022 10:08:51 -0700 (PDT)
X-Received: by 2002:a05:6870:c0c9:b0:127:c4df:5b50 with SMTP id
 e9-20020a056870c0c900b00127c4df5b50mr87866oad.126.1665508131198; Tue, 11 Oct
 2022 10:08:51 -0700 (PDT)
MIME-Version: 1.0
References: <20221008132113.919b9b894426297de78ac00f@linux-foundation.org>
 <CAHk-=wigZoriP8ZB+V87Jf+EQV=ka6DQe_HCAQmh3Dmus2FFhw@mail.gmail.com> <Y0UoO2+NsJjbZtaf@hirez.programming.kicks-ass.net>
In-Reply-To: <Y0UoO2+NsJjbZtaf@hirez.programming.kicks-ass.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 11 Oct 2022 10:08:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgGAtKxPNBV+u7+bgNt3g47G+i4CV8dq-s-hExhU68gKQ@mail.gmail.com>
Message-ID: <CAHk-=wgGAtKxPNBV+u7+bgNt3g47G+i4CV8dq-s-hExhU68gKQ@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.1-rc1
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Potapenko <glider@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, Oct 11, 2022 at 1:24 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> I've not yet tried to reproduce, I'm taking this is allyesconfig or
> something glorious like that? LLVM-15 ?

Just a bog-standard allmodconfig build with gcc 12.2.1 as packaged by Fedora.

               Linus
