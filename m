Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AADC64ED6
	for <mm-commits@archiver.kernel.org>; Sun, 26 Feb 2023 03:55:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjBZDy4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 25 Feb 2023 22:54:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbjBZDyt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 25 Feb 2023 22:54:49 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAFF1717A
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 19:54:24 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id ck15so13026703edb.0
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 19:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B3jzL0y6Ler5qUbb1nqA59NxYv4O7GPc8dG7aoiVSCI=;
        b=QLHt3ynSiWLdbW+mwY8WM0pFw+QPheMzsqFmcvauKPsFIdlaYmeyyVLbA4lQawcg4d
         rsoeJffGH7ki5ChbK3/YyLOGD/nrs+Uww7HdhEyNe/2b5z2lJy4TJ8RoemtH7InNWeDZ
         TpAqTpWyI/4aS4+2CnNU1BZoUUG1asBgcSfAQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B3jzL0y6Ler5qUbb1nqA59NxYv4O7GPc8dG7aoiVSCI=;
        b=BRSjeRxIZlQvG4zelh97vWHQAvROu0O5j2dV6jHdSDuEOOL+qFVYEol3lR86FtWNDU
         SnI2Dd1hILxSoM16z1sHR+nC9B/xv5KZKPAvokYnaaT3+F9g9n/Fo27jzljYY7Oh8vlj
         8Df5e6lYH8BkfqUZr/Heb8yQf9hGERZl59PvFUH1yBsExpPn9sDU7AJzUwEEFDDwXPqP
         NFtWpMDzzzqbRTfv/SaqOhh1m1UF3PraF4tF6UEkvFNrhYegpL5l7b7LKUyjOteuiJiX
         j/29NCvwHTvv5KaZ2Fb3FValufZ/UOMCmWBfVfxHG32p0npyYfMlHQP3g5/MzWolBXiJ
         MjDw==
X-Gm-Message-State: AO0yUKXJwbkoSkgHKTq9uGVlg2skLhIyThc72b7lmivv/3V2L85yUkTb
        tS0R6oboMIDwvrHM2svAzjt3XzcJOSoGpndlJevIJQ==
X-Google-Smtp-Source: AK7set+2v3yQGnLNVLQ/Jtf3rDl3jOrXDzD5b9/M870fxUHOlbhpWI8g5ZiPTF4OUZgwecjg/xn5ww==
X-Received: by 2002:a17:907:7255:b0:880:3129:d84a with SMTP id ds21-20020a170907725500b008803129d84amr36404030ejc.60.1677383601734;
        Sat, 25 Feb 2023 19:53:21 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id z11-20020a170906074b00b008c6c47f59c1sm1511503ejb.48.2023.02.25.19.53.21
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 19:53:21 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id ck15so13026631edb.0
        for <mm-commits@vger.kernel.org>; Sat, 25 Feb 2023 19:53:21 -0800 (PST)
X-Received: by 2002:a17:906:9f25:b0:8f5:2e0e:6def with SMTP id
 fy37-20020a1709069f2500b008f52e0e6defmr3062810ejc.0.1677383601014; Sat, 25
 Feb 2023 19:53:21 -0800 (PST)
MIME-Version: 1.0
References: <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
 <CAHk-=whVN2gKO_7UvMqgG8cetrVs3BCTxQovJvhC5x7AcJDJgQ@mail.gmail.com> <CAHk-=wgxWDgLJ-e3uDiYQvmMEqTNYFvDxtHbu4inR=zgBEP11Q@mail.gmail.com>
In-Reply-To: <CAHk-=wgxWDgLJ-e3uDiYQvmMEqTNYFvDxtHbu4inR=zgBEP11Q@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 25 Feb 2023 19:53:04 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjFmVL7NiuxL54qLkoabni_yD-oF9=dpDgETtdsiCbhUg@mail.gmail.com>
Message-ID: <CAHk-=wjFmVL7NiuxL54qLkoabni_yD-oF9=dpDgETtdsiCbhUg@mail.gmail.com>
Subject: Re: [GIT PULL] MM updates for 6.3-rc1
To:     Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc:     linux-mm@kvack.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Sat, Feb 25, 2023 at 7:27=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Will bisect further, but adding Liam to the participants because it's
> now narrowed down to his changes.

Ok, it's commit 2286a6914c77 ("mm: change mprotect_fixup to vma iterator")

It was entirely consistent, and bisected right to that all the way
from my current git tip.

Without that commit, google-chrome works fine.

With that commit, I get "Aww snap" and a

  traps: ThreadPoolForeg[4337] trap invalid opcode ip:55d5542363ee
sp:7fa5e04f1f80 error:0 in chrome[55d5537d3000+a14c000]

message in the kernel dumps (and core dump noise in journalctl).

The commit before is fine.

Sadly, it doesn't revert cleanly on my current top-of-tree (or even
_remotely_ cleanly_ because of all the other vma changes), so I can't
test just reverting that on the current state.

Also, it's not like I can debug google-chrome very much. It presumably
does complex vma's and unusual mprotect() stuff to trigger this, when
nothing else seems to care.

Liam?

             Linus

---
2286a6914c776ec34cd97e4573b1466d055cb9de is the first bad commit
commit 2286a6914c776ec34cd97e4573b1466d055cb9de
Author: Liam R. Howlett <Liam.Howlett@Oracle.com>
Date:   Fri Jan 20 11:26:18 2023 -0500

    mm: change mprotect_fixup to vma iterator

    Use the vma iterator so that the iterator can be invalidated or updated=
 to
    avoid each caller doing so.

    Link: https://lkml.kernel.org/r/20230120162650.984577-18-Liam.Howlett@o=
racle.com
    Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 fs/exec.c          |  5 ++++-
 include/linux/mm.h |  6 +++---
 mm/mprotect.c      | 47 ++++++++++++++++++++++-------------------------
 3 files changed, 29 insertions(+), 29 deletions(-)
