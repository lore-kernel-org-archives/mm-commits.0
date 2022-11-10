Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B32C5C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 01:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiKJBPD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 20:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiKJBPC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 20:15:02 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9414120BFC
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 17:15:00 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id mi9so465301qvb.8
        for <mm-commits@vger.kernel.org>; Wed, 09 Nov 2022 17:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y2z0l+w9AK1kH9+svuB1gzyJ5DuJ2g9p8N/jR5DOv8w=;
        b=PBFHPsEyjsTs5q3p7gReHOLPiGsPRWMbtTmiSCn4DxBz1FBKfPf+9+owURr8XyEqk4
         Bh6OBJ7gShauuKaK4HlJHr2e3wW5KMPkfje8GTcAACpkrZ6uIw0qQaPAHJmBh8BzKVhS
         70fnUwF/QMoScZsmsLmZsrMymEYv/d8CRCZrQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y2z0l+w9AK1kH9+svuB1gzyJ5DuJ2g9p8N/jR5DOv8w=;
        b=bD+X7MGvh0EoIoKwqSU+W/CBoIZozhOJiovO6mC9g7kPcerstJHajR730rpwg8fAb7
         j/SLYpTmcWy64K3WexH9uPBSna14Vzpyr87R+zcXXOg4BoJe8aLuY8C5cpHCVRBmNS56
         WFOEaFxnQAf4qD4pj5xNKukxwJ9c+Y4iybcgu0jAiQA1UNl25uJB+yjPvA0FiZcdGDMI
         wvfHyUKtQD474vWkj7SbCTN2NKQwEn1q+N8eFnwuY7m+zcWlb7rIhj3jydeeiGOXrvYC
         jQhNhAyna6nX5rdjoExa23D446k4g47EMhc6YFE9JyTSFqfD5MtXtiUUlasiWKzxBRJO
         M4vA==
X-Gm-Message-State: ACrzQf2bZf0ZdK8BNoa+339JwE3JV5MRR+R9oVEp6cCV756s7E3MDjWn
        TQfGFfRdR2s5HWMoYdyfMjENrzN24X+Zeg==
X-Google-Smtp-Source: AMsMyM68nPuCSmr19xf2Lwz3aUyj76/ZKDYi+PbEt5Nww+Lb0hQOTyrWdOBBwQbjdMutcYeRxb02fw==
X-Received: by 2002:a05:6214:f21:b0:4bb:b1f7:4cb7 with SMTP id iw1-20020a0562140f2100b004bbb1f74cb7mr57249910qvb.107.1668042899500;
        Wed, 09 Nov 2022 17:14:59 -0800 (PST)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id j3-20020a05620a288300b006faac3c33b8sm11755461qkp.27.2022.11.09.17.14.57
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:14:57 -0800 (PST)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-3775545dc24so2625867b3.7
        for <mm-commits@vger.kernel.org>; Wed, 09 Nov 2022 17:14:57 -0800 (PST)
X-Received: by 2002:a81:114e:0:b0:36a:fc80:fa62 with SMTP id
 75-20020a81114e000000b0036afc80fa62mr61406319ywr.58.1668042897203; Wed, 09
 Nov 2022 17:14:57 -0800 (PST)
MIME-Version: 1.0
References: <20221110000915.57C6CC433C1@smtp.kernel.org>
In-Reply-To: <20221110000915.57C6CC433C1@smtp.kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 9 Nov 2022 17:14:41 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg4s99W+A7A7DLpOY_10JW+eoWCK=4FM7usPJUMGKtrJQ@mail.gmail.com>
Message-ID: <CAHk-=wg4s99W+A7A7DLpOY_10JW+eoWCK=4FM7usPJUMGKtrJQ@mail.gmail.com>
Subject: Re: + mm-introduce-encoded-page-pointers-with-embedded-extra-bits.patch
 added to mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, will@kernel.org, svens@linux.ibm.com,
        peterz@infradead.org, npiggin@gmail.com, nadav.amit@gmail.com,
        hughd@google.com, hca@linux.ibm.com, hannes@cmpxchg.org,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        borntraeger@linux.ibm.com, aneesh.kumar@linux.ibm.com,
        agordeev@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Nov 9, 2022 at 4:09 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> +       BUILD_BUG_ON(flags > ENCODE_PAGE_BITS);

Note that if this causes any problems with some compiler version in
linux-next, just remove that line. It definitely is just a "nice to
have, let's try it" kind of thing.

If that happens, I'd be interested to know which compiler and config
causes it to blow up, though. Just out of morbid curiosity.

                 Linus
