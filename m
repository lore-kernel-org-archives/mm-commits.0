Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 964FCC07E96
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 20:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8071C61876
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 20:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbhGHUQV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jul 2021 16:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhGHUQU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2021 16:16:20 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A294C061574
        for <mm-commits@vger.kernel.org>; Thu,  8 Jul 2021 13:13:38 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4GLSCy5R6nzQjxR;
        Thu,  8 Jul 2021 22:13:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id 8vLmEryLhLnZ; Thu,  8 Jul 2021 22:13:30 +0200 (CEST)
Date:   Thu, 8 Jul 2021 22:13:23 +0200
From:   Hagen Paul Pfeifer <hagen@jauu.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Mike Rapoport <rppt@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        Roman Gushchin <guro@fb.com>, Peter Anvin <hpa@zytor.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Linux-MM <linux-mm@kvack.org>, kernel test robot <lkp@intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ingo Molnar <mingo@redhat.com>, mm-commits@vger.kernel.org,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        Shakeel Butt <shakeelb@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tycho Andersen <tycho@tycho.ws>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [patch 11/54] mm: introduce memfd_secret system call to create
 "secret" memory areas
Message-ID: <YOdcY5SYIjPDO7nG@laniakea>
References: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
 <20210708010803.i6RiDHM3L%akpm@linux-foundation.org>
 <CAHk-=whWxnQW=2Rx8uj01nGMGK3oOS9fJZCe6atVP7and5DkWg@mail.gmail.com>
 <YOaLPVFwQDBMcTMD@linux.ibm.com>
 <CAHk-=whEZT3f+-oDZ4kdz31GxxJ9QD_P1XrMBnM8DamdF9QHDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whEZT3f+-oDZ4kdz31GxxJ9QD_P1XrMBnM8DamdF9QHDg@mail.gmail.com>
X-Key-Id: 98350C22
X-Key-Fingerprint: 490F 557B 6C48 6D7E 5706 2EA2 4A22 8D45 9835 0C22
X-GPG-Key: gpg --recv-keys --keyserver wwwkeys.eu.pgp.net 98350C22
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -1.41 / 15.00 / 15.00
X-Rspamd-Queue-Id: B6F3C22F
X-Rspamd-UID: 4926c9
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

* Linus Torvalds | 2021-07-08 11:38:51 [-0700]:

Hello Mike, Linus

>> This feature is off by default and should be explicitly enabled by a system
>> administrator.
>>
>> When it is enabled, a user cannot exceed RLIMIT_MEMLOCK.

Just an idea/proposal:

this feature could be granted based on capabilities (new or existing one,
hopefully not CAP_SYS_ADMIN). Capabilities would provide a very convenient,
simple and fine granular way to use this, at least from a user perspective. Or
do I forget something Mike? 

If capability is the way, I think RLIMIT_MEMLOCK would also be redundant
in my view. It would be "just another parameter" which can only be set wrong
(too low or too high) and somehow always wrong by default. But yes, it doesn't
really hurt either, so I personally wouldn't care about that knob.

Hagen


