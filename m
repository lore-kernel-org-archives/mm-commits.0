Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB66C77B60
	for <mm-commits@archiver.kernel.org>; Fri, 28 Apr 2023 16:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbjD1QDm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Apr 2023 12:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjD1QDl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Apr 2023 12:03:41 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0652709
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 09:03:40 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-54f9d6eccf3so371187b3.2
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 09:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682697819; x=1685289819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8QgP7oOPrCOMv4LzWX+EiazStwQFUH2wo4nGqGDOHAQ=;
        b=nvfKOytggc0TV2KC1oVi0eO9jK45GWpComHTEdKXS38DLXUAecZItgJp+zOL9O7ixs
         KRj5Ar99YcAM3NoA9WfWL63497jD7/7bITxxlATu2hbqRcj0JLhiIICwEqXHI9FdaL2I
         lqP/EXLTekjFh/xxnxZxYmQXbrVl7xQxOAYWqd7eDG6ntWNahsHR18+td5mj1D2fgUfy
         /jXGx1oPlomoWllZH4MNfPjphGCRMcOupm3Y5Vx1HkOVnOfDi96Q6zYOqkq0aUIhXwPc
         Ky0BAvwBDzrztRJ1E/wFcPq/b8C8sK9ibvtRYh138C4vdgydQ5E/HdfEsHec5NyAGESN
         IX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682697819; x=1685289819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8QgP7oOPrCOMv4LzWX+EiazStwQFUH2wo4nGqGDOHAQ=;
        b=lKUbrAfTrccjMndT5wUi1AJLfe4pyLHXO6W7G0nONnqwt5QZrdpPIUc60k7Wso0Vav
         7CG0f33ZX++c18bcsMwNV9zOgWh1kEGmeK9SgW+iS6htpIBFoDk947OmxQ4/g+53sJVE
         MondSln4qjYBMSnVaHdWli3KB2klXAuqERSEj12rjLozak5L3nm3NIDj2neVOEd163A/
         0PdYNG3SRwr9sSzaMnUYqAqdqzUhRE7oyfddkIJFuPB4UiVknk5fMsGexbknGGryONaL
         Wna8L9h5trhNp3jgfDsACP3sfWlNXuHSMM8c6u4bDchCddTeiG7+BdSfQaXsQkLv1z+7
         ctyQ==
X-Gm-Message-State: AC+VfDzh0/ibUKHgClofIU5QLhj1gxAfNWWLViL/Z2MRGf3UFZtxeWCs
        Y6g+13uTmYPQRxVhLeK/pub2kZz7+XBZId+oRQEuKA==
X-Google-Smtp-Source: ACHHUZ64tMS0gUi6CNL1GsL8dHEGzJsUS2Ahoys8Q+1dLz3B4rmbWKE4ji0jyrWetULT4u121cXCnOjs+4mItf3RNCA=
X-Received: by 2002:a81:6087:0:b0:54f:bb49:c3a2 with SMTP id
 u129-20020a816087000000b0054fbb49c3a2mr3750188ywb.28.1682697819401; Fri, 28
 Apr 2023 09:03:39 -0700 (PDT)
MIME-Version: 1.0
References: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org> <CAHk-=wi5=LfeCMv5ZPAtzWhJyW=y1rVJFTRBfgcqzoUNk5NRDA@mail.gmail.com>
In-Reply-To: <CAHk-=wi5=LfeCMv5ZPAtzWhJyW=y1rVJFTRBfgcqzoUNk5NRDA@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Fri, 28 Apr 2023 09:03:27 -0700
Message-ID: <CAJuCfpHZSEjG2nti5iWbPQjWgXcHZ95hFS2FKwaPC-sZPdSznw@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.4-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Lorenzo Stoakes <lstoakes@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Apr 27, 2023 at 8:03=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Apr 27, 2023 at 3:33=E2=80=AFPM Andrew Morton <akpm@linux-foundat=
ion.org> wrote:
> >
> > - Suren Baghdasaryan has improved mmap_lock scalability by switching to
> >   per-VMA locking.
>
> .. related to this, we have that new PER_VMA_LOCK_STATS config entry,
> which is 'default y' and has basically no help test.
>
> Please don't do that.
>
> I don't think any of the VM debugging stuff should likely be 'default
> y' in the first place, but if they are, they should most definitely
> have a good *explanation* for why they should be on for a normal user.

Understood.
I wanted these stats enabled by default to be able to identify
possible pathological cases and to also let users disable them if they
can't tolerate even a small overhead in the pagefault path. Should I
document this reasoning for the config option?

>
>                       Linus
