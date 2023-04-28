Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AC4C77B60
	for <mm-commits@archiver.kernel.org>; Fri, 28 Apr 2023 17:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbjD1Riz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Apr 2023 13:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbjD1Riy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Apr 2023 13:38:54 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355831BFD
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 10:38:54 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-b9a7c1b86e8so3430728276.2
        for <mm-commits@vger.kernel.org>; Fri, 28 Apr 2023 10:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682703533; x=1685295533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JEUjkbJ9fm2PEZ0Extrs/fz2ygbuTmXTyZY3mX3KEeA=;
        b=Ejv3a7PTN3IXJZlUkERwq3qQqtM27hv3V/XVRK+q4CMH1ibISS1AUFOYPzIsgGNwwk
         N6yvZ25VItjCEm5GC+6CpTcsEm04Ctrp+zBiffAoyWnadzym984vwc9eU5FyFOvKJfDV
         jlzqw6dw2tFpOEPvWMP5tD/DyR75jfwaRmskAyVJxujy3goFuHJMfR7EoLYJ44DaijeX
         5iCJ5mASHCmQtoNWBeC4E3MizVlKVFlLU8h5MEd4DSC+69Ra8V72SYEen6He4EyD8zhN
         Dzdt7A0PIM0wqhf7HG6Qp54oT08+WXKmFGwdV9W+z6FEuRSIhsB79ObhJx3TnoaRxlWL
         /cqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682703533; x=1685295533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JEUjkbJ9fm2PEZ0Extrs/fz2ygbuTmXTyZY3mX3KEeA=;
        b=B7Z+aTNk+YfwF8mil761q7LphuYpi0fzTEStPp1QY9MlzcWqVulWy2Qh8JL5ASNTQD
         +j1+Jtb1lIIgMupjzyUfUNOPNCeTsD5vEJuLHrkGYTC1CZl2x8j7vGBtn4twyu5u+ER6
         C3N30duHCijFTJ9xJXsIEFmI56V+Ki5WyKL1y8fnOLgdUhDs+0WAN+pIHgMub3gwLfjY
         HmK4h3HHmsChOYRTTGfhp0W1JUAjkxQyou9gHBscbDtinNvV/p+qkpDdCCjVGVYsZh/p
         QFuvzpxOm9KYGG0DF3t5sw6zvxLwuAEDAD/EjKZJCmgrX1wYzWRVlK5D+yI4RVEqjkVt
         VVBg==
X-Gm-Message-State: AC+VfDy26tTmPWlh2nm5A5Nc88ET3x+eDvtDRf40wzP7Ea8XvbqIXjSB
        JaCz61tyPaq1TCUAfcn5CDghwHpH9QgMx9DpjrBOeA==
X-Google-Smtp-Source: ACHHUZ6dLw6HJKkdLP6bWUPEO+9DUnDl5TOE1khXQwqotKvbKlIA03lwf1QpEuW1QgEj7BGdNI+Cuqs60JkcFYGYE50=
X-Received: by 2002:a25:3606:0:b0:b99:3d0c:f6e1 with SMTP id
 d6-20020a253606000000b00b993d0cf6e1mr4264643yba.23.1682703533178; Fri, 28 Apr
 2023 10:38:53 -0700 (PDT)
MIME-Version: 1.0
References: <20230427153345.451d86681f9c6775ea579e5a@linux-foundation.org>
 <CAHk-=wi5=LfeCMv5ZPAtzWhJyW=y1rVJFTRBfgcqzoUNk5NRDA@mail.gmail.com>
 <CAJuCfpHZSEjG2nti5iWbPQjWgXcHZ95hFS2FKwaPC-sZPdSznw@mail.gmail.com>
 <CAHk-=wg0SyFDp_sdcEH-D+LNxuzL_dWA1vZEowUN16n_+yRHPQ@mail.gmail.com>
 <CAJuCfpHouhrEtomhPe2sf+p0oG4pGFKb3xidhOXP6BN-PydY-Q@mail.gmail.com>
 <CAJuCfpGcnJiJyU78v1r548W3bZ2LyfaYpr5huKKG8-WaiRHFHA@mail.gmail.com> <CAHk-=wjj7tM9ER57Ed3LAOaxMLM3t5nkA=dYSyN-nKPFbOmAZw@mail.gmail.com>
In-Reply-To: <CAHk-=wjj7tM9ER57Ed3LAOaxMLM3t5nkA=dYSyN-nKPFbOmAZw@mail.gmail.com>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Fri, 28 Apr 2023 10:38:41 -0700
Message-ID: <CAJuCfpHyY+06MX4QuTnObz2DtA_2J151e_1CBM5J69mDtGfKWg@mail.gmail.com>
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

On Fri, Apr 28, 2023 at 9:20=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Apr 28, 2023 at 9:17=E2=80=AFAM Suren Baghdasaryan <surenb@google=
.com> wrote:
> >
> > Should I send a replacement patch for "mm: introduce per-VMA lock
> > statistics" or a followup patch fixing it?
>
> I've merged the MM pull request, so it's all in the kernel now, but
> I'd like to see a follow-up patch with more of a help text and that
> 'default n'.

Posted https://lore.kernel.org/all/20230428173533.18158-1-surenb@google.com=
/
to address this.

>
>                   Linus
