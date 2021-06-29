Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E205C11F69
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 17:50:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 548B161DD1
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 17:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbhF2RxA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Jun 2021 13:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbhF2Rw7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Jun 2021 13:52:59 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A5EC061760
        for <mm-commits@vger.kernel.org>; Tue, 29 Jun 2021 10:50:31 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id k8so32136259lja.4
        for <mm-commits@vger.kernel.org>; Tue, 29 Jun 2021 10:50:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nD2K9Pxsj0l0b+r7ypwFgEO7F+ajCZLB9GSClDHGIeM=;
        b=Uyx5+j8RItEl6KLB44CZsNqYyz2PhNSsPvCfMzZvprRy/E5nYisXzXC5dvyWNgVW9S
         ZZQSymVq/fe7l1ouggcOO4WkfRm5fYqi+1doWRfBPEMg8qVg0eBxTJiF67QYJ8F0I2Cp
         b8H0HqcANjqJrBdKKJ2joAHMLIUnJcu4/rZSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nD2K9Pxsj0l0b+r7ypwFgEO7F+ajCZLB9GSClDHGIeM=;
        b=ZLQEabfUsYZDb58lgC8ESgCPQ+o9j4qoLXWY6TpsZMvyccKG4BRhAao0DDaZ8Mmt4w
         kcHLZ/3ZHcwTnTWj0rqaq686cUXkd5IZ/yNyC7xwm3VmeP/GH2UCRkg9rCvsWpc8O0ki
         zHqiPtatOwB/ou1FNLa0h8YIIvG32jVgd8DYY7nRBJZ66a0TNNplE+b1DI+8c1IrLq6g
         QRjdbWOcv47npaxsoPij55j59TTt/TFzCWWVqBPewgFCQghwaUWq3Amdt0bVYzAmKcx1
         l9jQB4ygSnuWO7J5HCKlIASZOGO96oewl+Jotb7KkQvGbP4djffsh7uHXFhdF7d4w7LU
         j8qQ==
X-Gm-Message-State: AOAM533F7Dz7y9wFtib+AJrDgDMB6W64aExvCCdnEadtnGhEez+jIoD9
        OZ4awn/qFqvZRi5ysNZDPKz/fWJV5kIGJ7/WIHQ=
X-Google-Smtp-Source: ABdhPJzCc0h3QjSRMQ7iPOui4BzSGg+WIxAdxU5sS9tJF6XpeVr4id3WZnXduuex/qgDgzmoyuoudQ==
X-Received: by 2002:a2e:a54d:: with SMTP id e13mr4897693ljn.272.1624989029449;
        Tue, 29 Jun 2021 10:50:29 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id c7sm1840786lfm.50.2021.06.29.10.50.28
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Jun 2021 10:50:28 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id u25so16543726ljj.11
        for <mm-commits@vger.kernel.org>; Tue, 29 Jun 2021 10:50:28 -0700 (PDT)
X-Received: by 2002:a2e:a276:: with SMTP id k22mr4682986ljm.465.1624989028284;
 Tue, 29 Jun 2021 10:50:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210628193256.008961950a714730751c1423@linux-foundation.org> <20210629023959.4ZAFiI8oZ%akpm@linux-foundation.org>
In-Reply-To: <20210629023959.4ZAFiI8oZ%akpm@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 29 Jun 2021 10:50:12 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj4KCujAH_oPh40Bkp48amM4MXr+8AcbZ=qd5LF4Q+TDg@mail.gmail.com>
Message-ID: <CAHk-=wj4KCujAH_oPh40Bkp48amM4MXr+8AcbZ=qd5LF4Q+TDg@mail.gmail.com>
Subject: Re: [patch 128/192] mm: improve mprotect(R|W) efficiency on pages
 referenced once
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Andrea Arcangeli <aarcange@redhat.com>,
        Evgeniy Stepanov <eugenis@google.com>, kostyak@google.com,
        Linux-MM <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
        Peter Collingbourne <pcc@google.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Jun 28, 2021 at 7:40 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
>
> -                       /* Avoid taking write faults for known dirty pages */
> -                       if (dirty_accountable && pte_dirty(ptent) &&
> -                                       (pte_soft_dirty(ptent) ||
> -                                        !(vma->vm_flags & VM_SOFTDIRTY))) {
> +                       if (may_avoid_write_fault(ptent, vma, cp_flags))
>                                 ptent = pte_mkwrite(ptent);
> -                       }

Hmm. I don't think this is correct.

As fat as I can tell, may_avoid_write_fault() doesn't even check if
the vma is writable!

Am I misreading it? Because I think you just made even a shared mmap
with "mprotect(PROT_READ)" turn the pte's writable.

Which is a "slight" security issue.

Maybe the new code is fine, and I'm missing something. The old code
looks strange too, which makes me think that the MM_CP_DIRTY_ACCT test
ends up saving us and depend on VM_WRITE. But it's very much not
obvious.

And even if I _am_ missing something, I really would like a very
obvious and direct test for "this vma is writable", ie maybe a

        if (!(vma->vm_flags & VM_WRITE))
                return false;

at the very top of the function.

And no, "pte_dirty()" is not a reason to make something writable, it
might have started out as a writable mapping, and we dirtied the page,
and we made it read-only. The page stays dirty, but it shouldn't
become writable just because of that.

So please make me get the warm and fuzzies about this code. Because
as-is, it just looks scary.

              Linus
