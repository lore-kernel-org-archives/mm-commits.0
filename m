Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 890BDC07E95
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 20:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6480C6140E
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jul 2021 20:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhGBUnu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jul 2021 16:43:50 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:53904 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbhGBUnt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jul 2021 16:43:49 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:55808)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lzPyM-0073sy-Tq; Fri, 02 Jul 2021 14:41:14 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:38594 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lzPyJ-00EZPD-4H; Fri, 02 Jul 2021 14:41:13 -0600
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
References: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
        <20210701015444.ZOZaFPX0b%akpm@linux-foundation.org>
        <202107021047.CC57ED634@keescook>
        <CAHk-=wiGcrds=Q7+utqPE7irvcsGfEY_qvp1+T7x67xdHbuSEA@mail.gmail.com>
Date:   Fri, 02 Jul 2021 15:40:49 -0500
In-Reply-To: <CAHk-=wiGcrds=Q7+utqPE7irvcsGfEY_qvp1+T7x67xdHbuSEA@mail.gmail.com>
        (Linus Torvalds's message of "Fri, 2 Jul 2021 12:00:00 -0700")
Message-ID: <87pmw0ih4e.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lzPyJ-00EZPD-4H;;;mid=<87pmw0ih4e.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Walr0xnK3iphgi7sLpDM10HrXonu8+P8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [patch 142/192] procfs: allow reading fdinfo with PTRACE_MODE_READ
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Fri, Jul 2, 2021 at 11:43 AM Kees Cook <keescook@chromium.org> wrote:
>>
>> Uhm, this is only checked in open(), and never again? Is this safe in
>> the face of exec or pid re-use?

Exec does not change the file descriptor table.

The open holds a reference to the proc inode.  The proc inode holds the
struct pid of the task and the file descriptor number.  References using
struct pid do not suffer from userspace pid rollover issues.

So the only issue I see is file descriptor reuse after an exec,
that changes the processes struct cred.

Assuming we care it would probably be worth a bug fix patch to check
something.


Eric
