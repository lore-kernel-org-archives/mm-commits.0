Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C07C07E95
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 23:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30687613F3
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 23:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhGBXeC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jul 2021 19:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhGBXeC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2021 19:34:02 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EF44C061762
        for <mm-commits@vger.kernel.org>; Fri,  2 Jul 2021 16:31:28 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y4so10521006pfi.9
        for <mm-commits@vger.kernel.org>; Fri, 02 Jul 2021 16:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4RgxpSUmeNYw37wLP1txgl1j/I61lxg9dBYUCNf/TkY=;
        b=TCzxWXOta/Z78+kMSBk5ORXKcK5q/EnV0Jm553jkFSytzbo2UWj/b1we+pb6MTX6ZO
         tYrMaAjtSHOSFfF7ENiKpF5DjHyi4GwfP+iNroIsOZkZhJzPx90f2W4xSSP7Pbk4kGe3
         k/ZG6MyaHHHvzvxNhnuL0CPKo97K5IDZkRbGg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4RgxpSUmeNYw37wLP1txgl1j/I61lxg9dBYUCNf/TkY=;
        b=RTMmqX17OZ16zZFAloEGYTZj1BHsiNWLJNIMF0AEArmU7GdDG+Y07QUUBPsfflBP8+
         xNkP+JhDbDT+Ccif3W3sf2B74pNIaeF2E3jVtajfmMLFnRTEMSNH7KHl/jt4a4yuArfq
         gALGfiXADcywCleTMtf49u0IjaRfSGUjVrywuosxC8EKbmFvYtot26Hew8sHT1ko13vJ
         zEvOWc9/FOWVDq7iD3RhQi2jg3v8CANYWlvw/Cz1YvH/5eFLX5IWLNZewcoLiEoi5PtH
         KsbZysV7Rg93Y8gEGwhQdl0Ez8GF24yUDlxnBnB/efEiAkFQ7bLCKNZNDBcUA/vwWokw
         zPaw==
X-Gm-Message-State: AOAM530j6fSH2ZkIVcCQJmIuGiHkfcTrCleKFCF4xtd8IP0x/DuM4wJH
        BWlJRmvuwuDzW6EthxEsvvnLDg==
X-Google-Smtp-Source: ABdhPJw0TQZJ5BpJHyCRBO8TMGnv404m8Hu8rwVxZMVH+G9biu3SfRgZIrkvPX53nJm4X2JQHvIZMQ==
X-Received: by 2002:a63:1a4f:: with SMTP id a15mr2324055pgm.313.1625268688123;
        Fri, 02 Jul 2021 16:31:28 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d127sm4547508pfc.50.2021.07.02.16.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 16:31:27 -0700 (PDT)
Date:   Fri, 2 Jul 2021 16:31:26 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Jonathan Corbet <corbet@lwn.net>, Helge Deller <deller@gmx.de>,
        Alexey Gladkov <gladkov.alexey@gmail.com>, hridya@google.com,
        jamorris@linux.microsoft.com, Jann Horn <jannh@google.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Kalesh Singh <kaleshsingh@google.com>,
        Linux-MM <linux-mm@kvack.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Minchan Kim <minchan@kernel.org>, mm-commits@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Szabolcs Nagy <szabolcs.nagy@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Michel Lespinasse <walken@google.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [patch 142/192] procfs: allow reading fdinfo with
 PTRACE_MODE_READ
Message-ID: <202107021626.913478E@keescook>
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
 <20210701015444.ZOZaFPX0b%akpm@linux-foundation.org>
 <202107021047.CC57ED634@keescook>
 <CAHk-=wiGcrds=Q7+utqPE7irvcsGfEY_qvp1+T7x67xdHbuSEA@mail.gmail.com>
 <87pmw0ih4e.fsf@disp2133>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmw0ih4e.fsf@disp2133>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Jul 02, 2021 at 03:40:49PM -0500, Eric W. Biederman wrote:
> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > On Fri, Jul 2, 2021 at 11:43 AM Kees Cook <keescook@chromium.org> wrote:
> >>
> >> Uhm, this is only checked in open(), and never again? Is this safe in
> >> the face of exec or pid re-use?
> 
> Exec does not change the file descriptor table.

Ah yeah, good point. I've been thinking too much about vmas.

> The open holds a reference to the proc inode.  The proc inode holds the
> struct pid of the task and the file descriptor number.  References using
> struct pid do not suffer from userspace pid rollover issues.

Okay, cool.

> So the only issue I see is file descriptor reuse after an exec,
> that changes the processes struct cred.

Right -- the info leak would be snooping on what a privileged process
was doing with a given fd? Similar stuff has been used to do typing
pattern analysis with login passwords, but that's a stretch here, I
think. Hmm.

> Assuming we care it would probably be worth a bug fix patch to check
> something.

Sounds good.

-- 
Kees Cook
