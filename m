Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754CBEB64D7
	for <mm-commits@archiver.kernel.org>; Wed, 28 Jun 2023 17:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjF1R3P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Jun 2023 13:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbjF1R2G (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Jun 2023 13:28:06 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FE91FF7
        for <mm-commits@vger.kernel.org>; Wed, 28 Jun 2023 10:28:04 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9741caaf9d4so7319066b.0
        for <mm-commits@vger.kernel.org>; Wed, 28 Jun 2023 10:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1687973282; x=1690565282;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=k+2E0Rt8HIW6qnRJgQGPRjPuN/s1eCRBBVkSd2Fo7f8=;
        b=ZnbhkWthy3eR2jV3Fa0jSGlCcQtNRPTMENE53fJR5/GZ1tUGT3arTsEAnmrZElUuTA
         hoZmGBf55Q87kt0l2iQkxedGCZL+IPIiuNhVN6vkO345Uht2IpNi+288R8gt+PC2/YZg
         sioXmIMls+2T/khoT/vOXP/w/19FzH2XWyIGQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687973282; x=1690565282;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k+2E0Rt8HIW6qnRJgQGPRjPuN/s1eCRBBVkSd2Fo7f8=;
        b=ZhKhrVCr6pu/Q/FXA7OMeAErcJW1qPL5sHFydEyKfZO4PjRa6CHtKR4b7WDTb73vBD
         CY0t5C7fU6qnpw/FhE/rF+ALcLFUOdJJewCSLWVFwOJL6M0/qitnTJYsgkCKJCNaBVAS
         stdrG1NIobAD1WSTVjm+cJGqAXusLbwPex2SZCGEbLUq1t42Yyo39+nGSc+faQ1SeFx1
         WWIFJx8kTKrkLlLYnfERfCrOBsd+s+eq/3lk2Vj/a74RWferJ3XhZ9Vn5vKCraOpf2/O
         7KYppf5W43s99/fwL0IAj4E2NJmQGn/KM0Q3z09rxS5zcPxxezA8/6hMn33LCNDU4RTo
         kiNg==
X-Gm-Message-State: AC+VfDye8HfJMQ6pd6X/zezqBwALu8obLTgtGhTfpqrMn2vTOKkDT14X
        hbeKUZQOLB+aIVMAbRFLqgem2xf4wICEG12COAKoJycl
X-Google-Smtp-Source: ACHHUZ4bxf0Zc1mfrqAPNkPdltDn92AqstbY1PYLS1cd4HTs0wdJJmRTeLOxHgbPEjpzkhSop8h63A==
X-Received: by 2002:a17:907:934e:b0:989:5d0:3189 with SMTP id bv14-20020a170907934e00b0098905d03189mr26168271ejc.33.1687973282381;
        Wed, 28 Jun 2023 10:28:02 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id bu2-20020a170906a14200b009829dc0f2a0sm5862465ejb.111.2023.06.28.10.28.01
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jun 2023 10:28:01 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-51d9128494cso4448819a12.0
        for <mm-commits@vger.kernel.org>; Wed, 28 Jun 2023 10:28:01 -0700 (PDT)
X-Received: by 2002:a05:6402:505:b0:51d:a24b:3d74 with SMTP id
 m5-20020a056402050500b0051da24b3d74mr6867136edv.20.1687973281251; Wed, 28 Jun
 2023 10:28:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230626085035.e66992e96b4c6d37dad54bd9@linux-foundation.org>
In-Reply-To: <20230626085035.e66992e96b4c6d37dad54bd9@linux-foundation.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 28 Jun 2023 10:27:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjyJyV=Kyb8XJcLjFEPP-RMF0J6CQfT2OXLmJdM2yEv8w@mail.gmail.com>
Message-ID: <CAHk-=wjyJyV=Kyb8XJcLjFEPP-RMF0J6CQfT2OXLmJdM2yEv8w@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.5-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
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
>  [...]
> merge conflict in mm/gup.c, vs block tree:
> https://lkml.kernel.org/r/20230616115856.3ce7682c@canb.auug.org.au

Hmm. I think this merge resolution in -next is wrong.

It now does a common

        folio = try_get_folio(page, refs);
        if (flags & FOLL_GET)
                return folio;

for both FOLL_GET and FOLL_PIN, and then *after* that for the FOLL_PIN
case it does that

        /*
         * Don't take a pin on the zero page - it's not going anywhere
         * and it is used in a *lot* of places.
         */
        if (is_zero_page(page))
                return page_folio(page);

but by then it has already done the try_get_folio().

End result: it has already updated refcounts, despite the comment
saying not to do that.

So I think it needs to match the comment (and the try_grab_page()
logic), and just basically

        if (flags & FOLL_GET)
                return try_get_folio(page, refs);

        if (is_zero_page(page))
                return page_folio(page);

        folio = try_get_folio(page, refs);
        if (!folio)
                return NULL;

instead.

That's what my resolution is going to do, but let's add others to the
participants list just in case somebody goes "No, Linus, the reason
-next does that is XYZ"...

               Linus
