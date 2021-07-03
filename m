Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168F7C07E97
	for <mm-commits@archiver.kernel.org>; Sat,  3 Jul 2021 21:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E36E1613E4
	for <mm-commits@archiver.kernel.org>; Sat,  3 Jul 2021 21:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhGCVqd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 3 Jul 2021 17:46:33 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:55866 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhGCVqd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 3 Jul 2021 17:46:33 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lznQW-00GLBZ-RO; Sat, 03 Jul 2021 15:43:53 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:54402 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lznQV-000GiC-Br; Sat, 03 Jul 2021 15:43:52 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrei Vagin <avagin@gmail.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Jonathan Corbet <corbet@lwn.net>, Helge Deller <deller@gmx.de>,
        Alexey Gladkov <gladkov.alexey@gmail.com>,
        Hridya Valsaraju <hridya@google.com>,
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
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
        <20210701015444.ZOZaFPX0b%akpm@linux-foundation.org>
        <202107021047.CC57ED634@keescook>
        <CAHk-=wiGcrds=Q7+utqPE7irvcsGfEY_qvp1+T7x67xdHbuSEA@mail.gmail.com>
        <87pmw0ih4e.fsf@disp2133> <202107021626.913478E@keescook>
        <CAHk-=wi+-7LiS_seHErerr-J_MmTv6uY07kOoYkgHwGnPNdbqQ@mail.gmail.com>
Date:   Sat, 03 Jul 2021 16:43:16 -0500
In-Reply-To: <CAHk-=wi+-7LiS_seHErerr-J_MmTv6uY07kOoYkgHwGnPNdbqQ@mail.gmail.com>
        (Linus Torvalds's message of "Fri, 2 Jul 2021 17:15:42 -0700")
Message-ID: <87zgv3gjkb.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lznQV-000GiC-Br;;;mid=<87zgv3gjkb.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+DjxjAzG2PvLQOu5MjPvb2E9KccIflr+E=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [patch 142/192] procfs: allow reading fdinfo with PTRACE_MODE_READ
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, Jul 2, 2021 at 4:31 PM Kees Cook <keescook@chromium.org> wrote:
>>
>> Right -- the info leak would be snooping on what a privileged process
>> was doing with a given fd? Similar stuff has been used to do typing
>> pattern analysis with login passwords, but that's a stretch here, I
>> think. Hmm.
>
> So I think you'd see the directory list, but generally that's just the
> file descriptor numbers.
>
> Which is information you shouldn't have access to, but it's probably
> not very *interesting* information.
>
> I think it would be worth fixing but possibly not a very high
> priority.

It is not just the directory whose permission changed but the individual
files in that directory.

You can also see the position, flags, mnt_id, and soon inode number
of fdinfo files you open before a suid exec.

Knowing what file someone is reading on a particular file descriptor
number and how far they are in reading that file sounds like a side
channel someone can do something with.

Eric
