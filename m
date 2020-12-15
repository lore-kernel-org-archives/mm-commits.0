Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2742FC4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 14:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDF36224D2
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 14:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgLOOEv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 09:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728359AbgLOOEv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Dec 2020 09:04:51 -0500
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28284C06179C
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 06:04:11 -0800 (PST)
Received: by mail-qv1-xf2f.google.com with SMTP id d11so9510540qvo.11
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 06:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rDxIefuvefH4uNE83uMVqRqkmgdvN/y5BqoY1rQ84mQ=;
        b=OclGybNFknCZNrHT7096u0tvXaQUGNIt7OARUj2YZ7nIblcN8VPbbyk0SV71a0JgrV
         8bS3iKemRb+WN7vJXZHMLvBx05ZROsjGO6wPNOh1B4qbCFgegK7kCL1e8qiwIwR6vLH4
         ePESSZ2Kqp5p2Hi+KpIkUg2dZiRNVP1GyQRoA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rDxIefuvefH4uNE83uMVqRqkmgdvN/y5BqoY1rQ84mQ=;
        b=GNV8ipheOyJmWvWrE/TMkmPXtadhGjcbf0lmeH+sGg5WmYc2jp/cOesMMvs8Mbs5NB
         KZoy3OkmPOxx7+HyioHkFGS1PbBjU3Mo7vXj9HeXj2Sj9eJy2IWrzN2Heym8q/hpz0IS
         6MwAW3lBH33ph5w4oi8gNkpujlszQ11HK1a1LFhUnPk8agAOu3esshRcaIcaSV+lxGBK
         7whkNfuDuurZCNEN9vJf2Mp+eLzbbbZhWV6tnrxlueibIDV1O01Vazl3BkiWVOIV0zXW
         7NnEkQ7FS10aIHREwSBblrY3pD7o94Coot5yCBpygi+eqSEB9TQ6vK8/zyejIYokikMk
         DXPg==
X-Gm-Message-State: AOAM530ZxLHUuuvGyqCv2t+7lhmmbHWU71KhTsOv6/RAY822nv4Gw4Dh
        SlTJ6cRRNNPGMAQTCJuwbz/20EDmEqb/WFlo
X-Google-Smtp-Source: ABdhPJyhNc365Ic7e4H1kP0ND+1sHL2YEvHyrZOwmWOem87oQMtnkW9cZdbHGtSYDnvesNgL7biVsQ==
X-Received: by 2002:a05:6214:7ac:: with SMTP id v12mr37573224qvz.13.1608041050005;
        Tue, 15 Dec 2020 06:04:10 -0800 (PST)
Received: from chatter.i7.local ([89.36.78.230])
        by smtp.gmail.com with ESMTPSA id n66sm17131159qkn.136.2020.12.15.06.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 06:04:09 -0800 (PST)
Date:   Tue, 15 Dec 2020 09:04:07 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, Linux-MM <linux-mm@kvack.org>
Subject: Re: incoming
Message-ID: <20201215140407.btfql3rupfl6uzdw@chatter.i7.local>
References: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
 <CAHk-=whRm2sKHeY-YQqxEJF=d9fGhnU2ajJs9i7CKC4feuPMTA@mail.gmail.com>
 <CAHk-=whV8E0d198RGn45ewBu_kGzhyYd3YXOQBg7nAHLYWvB9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=whV8E0d198RGn45ewBu_kGzhyYd3YXOQBg7nAHLYWvB9w@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Dec 14, 2020 at 07:30:54PM -0800, Linus Torvalds wrote:
> > All the patches except for _one_ get a nice little green check-mark
> > next to them when I use 'git am' on this series.
> >
> > The one that did not was [patch 192/200].
> >
> > I have no idea why
> 
> Hmm. It looks like that patch is the only one in the series with the
> ">From" marker in the commit message, from the silly "clarify that
> this isn't the first line in a new message in mbox format".
> 
> And "b4 am" has turned the single ">" into two, making the stupid
> marker worse, and actually corrupting the end result.

It's a bug in b4 that I overlooked. Public-inbox emits mboxrd-formatted 
.mbox files, while Python's mailbox.mbox consumes mboxo only. The main 
distinction between the two is precisely that mboxrd will convert 
">From " into ">>From " in an attempt to avoid corruption during
escape/unescape (it didn't end up fixing the problem 100% and mostly 
introduced incompatibilities like this one).

I have a fix in master/stable-0.6.y and I'll release a 0.6.2 before the 
end of the week.

Thanks for the report.

-K
