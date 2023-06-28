Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367F6EB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jun 2023 19:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjF1TUF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Jun 2023 15:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbjF1TUD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Jun 2023 15:20:03 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6701BD4
        for <mm-commits@vger.kernel.org>; Wed, 28 Jun 2023 12:20:02 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f76a0a19d4so8901638e87.2
        for <mm-commits@vger.kernel.org>; Wed, 28 Jun 2023 12:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1687980000; x=1690572000;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JyArVu4aB7TFdxCwRbf3XY40ntQA2MhFquVGiFkdvFo=;
        b=a/W8iJjlmmvCPEWuMe4BXKXFW/WMIAL9YlxN1j6FV80yakPKRKd4ztPijjeZesNjLb
         4SvO6nKPpHgHfx3087+APgp4brmIDPfDzlsx8HoWvaQOdFieUMRLxmKRKN2diFS2qvhU
         TI+48hX6WvnnwSpaHcAte1l6bqnvJYF1HXl6M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687980000; x=1690572000;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JyArVu4aB7TFdxCwRbf3XY40ntQA2MhFquVGiFkdvFo=;
        b=Q9P9DtfRkDzzu9waaHQS5UuisIZeumYTlnGY+31vrCLfZZEbPx/g5ybxQiyRwC6z44
         qraNksMeTBcdUPA+XqRe5Fq7v3nM+WCi0NMH7fd8rJBihyBoAMD9cOMtwjiU4PDMzc8N
         ZllKoiH628PWhFv3nWiE6kjnexK9Ph2GHAw8lslnwj2s4oYJCSVyLTEZ/zR8l92adBlO
         F8ItUZy/eNooTtmjhh32PhhGJVBWWlAtAx3K6Nmi48y/aWJc9gNeNQV4Lm4OnlovPrRb
         n1+eQTwn9KViorNSbRWORQr3al3S6y67ThxCvrHbqUy3fIPwZU+Y/McEO+4imLdOcGAW
         RbCw==
X-Gm-Message-State: AC+VfDzIK9D1Of8A0YRYFFp3Qvvg/nc38q12Trz2D/eNwuavA8xx9gF0
        bSXEsAjlwHfTP8WgM19J1yfMVjISs8GNiYIsKAofHXgr
X-Google-Smtp-Source: ACHHUZ7IKXgtyLrn7Fjfq0r5ChxESfOmgMzZCAoHsu8URwk782oFZuiu0SiLb09GejkfMcGZ3eJ4QQ==
X-Received: by 2002:a05:6512:3d90:b0:4f8:5600:9e5e with SMTP id k16-20020a0565123d9000b004f856009e5emr15203083lfv.47.1687980000546;
        Wed, 28 Jun 2023 12:20:00 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id v11-20020a056512096b00b004f76658694csm2030716lft.238.2023.06.28.12.19.59
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 12:19:59 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-4fb7acaa7a5so5288507e87.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Jun 2023 12:19:59 -0700 (PDT)
X-Received: by 2002:a19:7b02:0:b0:4f8:83f:babe with SMTP id
 w2-20020a197b02000000b004f8083fbabemr20751801lfc.62.1687979999337; Wed, 28
 Jun 2023 12:19:59 -0700 (PDT)
MIME-Version: 1.0
References: <20230626085035.e66992e96b4c6d37dad54bd9@linux-foundation.org>
In-Reply-To: <20230626085035.e66992e96b4c6d37dad54bd9@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 28 Jun 2023 12:19:42 -0700
X-Gmail-Original-Message-ID: <CAHk-=whppqqPdjVOx0mONDFx+JjewZPacionbWCUUFdrfOon-g@mail.gmail.com>
Message-ID: <CAHk-=whppqqPdjVOx0mONDFx+JjewZPacionbWCUUFdrfOon-g@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.5-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, 26 Jun 2023 at 08:50, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> Linus, please merge the MM updates for the 6.5-rc cycle.

Hmm. I have merged this, as pr-tracker-bot already noticed, but I
found a bug after merging it.

mm/memory.c: __access_remote_vm() is entirely broken for the
HAVE_IOREMAP_PROT case (ie all normal architectures), because it does
(skipping the non-HAVE_IOREMAP_PROT case):

        struct vm_area_struct *vma = NULL;
        struct page *page = get_user_page_vma_remote(mm, addr,
                                                     gup_flags, &vma);

        if (IS_ERR_OR_NULL(page)) {
                [ ... ]
                if (!vma)
                        break;
                if (vma->vm_ops && vma->vm_ops->access)
                        res = vma->vm_ops->access(vma, addr, buf, ...

but get_user_page_vma_remote() doesn't even set vma if it fails!

So that "if (!vma)" case will always trigger, and the whole ->access()
thing is never done.

So that __access_remote_vm() conversion in commit ca5e863233e8
("mm/gup: remove vmas parameter from get_user_pages_remote()") is
entirely broken.

Now, I don't disagree with removing the vmas parameter. I just
disagree with the get_user_page_vma_remote() helper use here.

I think the minimal fix is to just put the vma_lookup() back in the error case:

    --- a/mm/memory.c
    +++ b/mm/memory.c
    @@ -5592,6 +5592,7 @@ int __access_remote_vm(struct mm_struct *mm,
                 * Check if this is a VM_IO | VM_PFNMAP VMA, which
                 * we can access using slightly different code.
                 */
    +           vma = vma_lookup(mm, addr);
                if (!vma)
                        break;
                if (vma->vm_ops && vma->vm_ops->access)

and I'll commit that fix for now. Anybody who disagrees, please holler.

                 Linus
