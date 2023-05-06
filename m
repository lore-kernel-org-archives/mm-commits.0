Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0C2C77B75
	for <mm-commits@archiver.kernel.org>; Sat,  6 May 2023 00:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjEFABA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 20:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjEFABA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 20:01:00 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F67059F4
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 17:00:58 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-50bd87539c2so3795551a12.0
        for <mm-commits@vger.kernel.org>; Fri, 05 May 2023 17:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683331257; x=1685923257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xmoQ4JAeW1YkMZDeEEvmPdlawBAzHdE1sbOruHeBD2M=;
        b=TNvXUue7R72smLWlxdoQjZwlk2jNGDZyW2WC+HS3HzJv6eB8lktMmkJ+rRzY+TtHgD
         NOBU8XP8c+85Tiux7wQld54pgULXGRRtIUnipHASQaiFXhWArWInZTAAmmuX3qPnHT25
         0H5TDExk7Z8aQYDtuzhHph9A+wpaGCjXXlsaLMMtBHnCk0AOwNeZSATkeeha+PNaOCIM
         iAb+Rmkl7Dck4bo6HrIf2H6fmuuwaBsZPx74c+YZY1FAa+lgkH1dizgAXTFk9p4dgAZ+
         +2k6U84ih0PUlq6AlYaB4eWDWrwCfEjcXa8ZnIyChrhdUF+gjOEtwppcRXhrFgdnmdeR
         EVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683331257; x=1685923257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xmoQ4JAeW1YkMZDeEEvmPdlawBAzHdE1sbOruHeBD2M=;
        b=LyTZhm4iwIPw3dFVyPCXexdYKLPPIsVexZcA5C8f7pFosIp+HZnVBvFFk9uKPkCrzk
         zjIYru4OnCqphJOGiQysyX5tB6UDO1kDVZyucxAT3I9oBVmvDAis7Py5rNFS5XDqrNnw
         iooRu6c2BBGfJY6PKJdL+0qqlpTURTTyaRAelJc/WI4RTS9+A5KKd8q6JgdpZEKfKXy6
         wzPTcbLuvtUQmluRIXLHua5PCIeVxCYGW02jrx+Eyq2eaHffgEAm+wtQuDc6i9Bm9nDT
         lxW5I3cTK9kNjO3TK72DGxa1t+OLoOtCiE6wL+IHqWmSDOpgAlJpMYGWVFO9iBYA6OB5
         84LQ==
X-Gm-Message-State: AC+VfDx0w84tpu0VBnHIjmZEnV3JU+k74+Pz7UCZdwN31QQeHnD6BKsU
        3UGfKRWz89VPWgBH+pv/gju2onX89DMKHUMAZ1eA9u4J3XHvBmVkUL4=
X-Google-Smtp-Source: ACHHUZ75XsrD0XmchzXeqHp1GWGbf/cK9T0302J0RXEDvCvfUmkx5Dd2h1zfuNCPjPBfizbe32UtF/sq/DdGIAkO3eI=
X-Received: by 2002:a17:907:3e27:b0:965:b517:89a4 with SMTP id
 hp39-20020a1709073e2700b00965b51789a4mr2553795ejc.56.1683331256811; Fri, 05
 May 2023 17:00:56 -0700 (PDT)
MIME-Version: 1.0
References: <20230505224521.C3D6BC433EF@smtp.kernel.org> <20230505235754.121741-1-sj@kernel.org>
In-Reply-To: <20230505235754.121741-1-sj@kernel.org>
From:   Yosry Ahmed <yosryahmed@google.com>
Date:   Fri, 5 May 2023 17:00:20 -0700
Message-ID: <CAJD7tkY9wBYX6JNf7D6tHTHRyYac_U+JKzRab+RJUKHCAG4zgw@mail.gmail.com>
Subject: Re: [merged] seq_buf-add-seq_buf_do_printk-helper.patch removed from
 -mm tree
To:     SeongJae Park <sj@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, rostedt@goodmis.org, pmladek@suse.com,
        senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, May 5, 2023 at 4:57=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
> Hi Andrew,
>
> On Fri, 05 May 2023 15:45:21 -0700 Andrew Morton <akpm@linux-foundation.o=
rg> wrote:
>
> >
> > The quilt patch titled
> >      Subject: seq_buf: add seq_buf_do_printk() helper
> > has been removed from the -mm tree.  Its filename was
> >      seq_buf-add-seq_buf_do_printk-helper.patch
> >
> > This patch was dropped because it was merged into mainline or a subsyst=
em tree
>
> Just for headup.  I just found the latest mm-unstable indeed dropped the =
patch
> but a patch[1] depends on it.  As a result, build fails as below.

That patch was merged into Linus's tree, so I assumed that's why it
was dropped from mm-unstable. Perhaps I am wrong.

>
>       CC      mm/memcontrol.o
>     /mm/memcontrol.c: In function =E2=80=98mem_cgroup_print_oom_meminfo=
=E2=80=99:
>     /mm/memcontrol.c:1693:2: error: implicit declaration of function =E2=
=80=98seq_buf_do_printk=E2=80=99; did you mean =E2=80=98seq_buf_bprintf=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
>      1693 |  seq_buf_do_printk(&s, KERN_INFO);
>           |  ^~~~~~~~~~~~~~~~~
>           |  seq_buf_bprintf
>     cc1: some warnings being treated as errors
>
> [1] https://lore.kernel.org/mm-commits/20230502201509.B8711C433D2@smtp.ke=
rnel.org/
>
>
> Thanks,
> SJ
>
> >
> > ------------------------------------------------------
> > From: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Subject: seq_buf: add seq_buf_do_printk() helper
> > Date: Sat, 15 Apr 2023 19:01:10 +0900
> >
> > (akpm: temporary addition for
> > memcg-use-seq_buf_do_printk-with-mem_cgroup_print_oom_meminfo.patch)
> >
> > Sometimes we use seq_buf to format a string buffer, which we then pass =
to
> > printk().  However, in certain situations the seq_buf string buffer can
> > get too big, exceeding the PRINTKRB_RECORD_MAX bytes limit, and causing
> > printk() to truncate the string.
> >
> > Add a new seq_buf helper.  This helper prints the seq_buf string buffer
> > line by line, using as a delimiter, rather than passing the whole strin=
g
> > buffer to printk() at once.
> >
> > Link: https://lkml.kernel.org/r/20230415100110.1419872-1-senozhatsky@ch=
romium.org
> > Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> > Reviewed-by: Petr Mladek <pmladek@suse.com>
> > Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
> > Cc: Yosry Ahmed <yosryahmed@google.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
