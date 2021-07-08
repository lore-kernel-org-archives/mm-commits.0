Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED9DC07E96
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 18:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1752D61417
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 18:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhGHSmD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Jul 2021 14:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhGHSmD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jul 2021 14:42:03 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192DCC061574
        for <mm-commits@vger.kernel.org>; Thu,  8 Jul 2021 11:39:20 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s15so9883128edt.13
        for <mm-commits@vger.kernel.org>; Thu, 08 Jul 2021 11:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZbVTQJiWMi7n2BAEqeIc/TSnkT4lgC/n0nesP0M/E38=;
        b=NozJVPtm7R5JYV3+i9kA9FozPErjP5t6bLpakXOVQjFpwDyPe+2KPRkXiZ/dwxqF2w
         05REBgRyFck+UzCb4hHZEzkAaMxlf6qmmc+5+C/928ZWG3CQSQqVA3dZ+jOXnzbjbnkv
         HSNqC2aLjov4MbCalHNyU86FbyP/3WFg5gpaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZbVTQJiWMi7n2BAEqeIc/TSnkT4lgC/n0nesP0M/E38=;
        b=ojmAu9QmovNwvc2tciIiXKiGypq46NAhDiezLefg7UclO3CX5ia7FTjGV3kkPP/vlq
         LBfWNdUY0SEXbGU5h8xNcIcUolKd2dDRoLl2BztOZbmzucuMjpSz2FbSEXV0cqdKRnjA
         /GjCzOia0c8ZjCUGRj3yksfeGX791pZ8dQS7wtsvE9Twx+EIRH/F6GTj+7WonkkEY+4P
         KMUnxfKYZBYZ9twAe/fK2oYDU5lgeZBpZyWGN15VijDfEJhENRFnACiC3O4sgDCLYgv6
         bjtyPiLTp6/BakpfUvFmWPvR8exiwUpK0d8uK2Iqks2DMEU6u/UtIDjXqUjlyWFouz2u
         qBew==
X-Gm-Message-State: AOAM531sp+qpWVU9ekVx3bOZ1pHMsABgpErYDOmNOG5kYGzLrgEFt81D
        mQcuFr/hY8M7MoMz4h21ObSHPRcVczzl/dXNyUw=
X-Google-Smtp-Source: ABdhPJytc5xoWkDIhc3WAOQBuRj0QJ7ez7NmBgADIfZiI4IqZo8R0MzVn1RyTK/hkK1zn5IsQhCrCw==
X-Received: by 2002:a05:6402:18c4:: with SMTP id x4mr11980657edy.350.1625769558651;
        Thu, 08 Jul 2021 11:39:18 -0700 (PDT)
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com. [209.85.218.50])
        by smtp.gmail.com with ESMTPSA id y9sm1332845ejd.52.2021.07.08.11.39.18
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Jul 2021 11:39:18 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id b2so11372912ejg.8
        for <mm-commits@vger.kernel.org>; Thu, 08 Jul 2021 11:39:18 -0700 (PDT)
X-Received: by 2002:a05:6512:3585:: with SMTP id m5mr24756940lfr.253.1625769547347;
 Thu, 08 Jul 2021 11:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210707175950.eceddb86c6c555555d4730e2@linux-foundation.org>
 <20210708010803.i6RiDHM3L%akpm@linux-foundation.org> <CAHk-=whWxnQW=2Rx8uj01nGMGK3oOS9fJZCe6atVP7and5DkWg@mail.gmail.com>
 <YOaLPVFwQDBMcTMD@linux.ibm.com>
In-Reply-To: <YOaLPVFwQDBMcTMD@linux.ibm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 8 Jul 2021 11:38:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=whEZT3f+-oDZ4kdz31GxxJ9QD_P1XrMBnM8DamdF9QHDg@mail.gmail.com>
Message-ID: <CAHk-=whEZT3f+-oDZ4kdz31GxxJ9QD_P1XrMBnM8DamdF9QHDg@mail.gmail.com>
Subject: Re: [patch 11/54] mm: introduce memfd_secret system call to create
 "secret" memory areas
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoph Lameter <cl@linux.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>,
        Roman Gushchin <guro@fb.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>,
        Peter Anvin <hpa@zytor.com>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Wed, Jul 7, 2021 at 10:22 PM Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> This feature is off by default and should be explicitly enabled by a system
> administrator.

I really don't think that matters, since people would go "oh, I want
secretmem" without being aware of the consequences.

But:

> When it is enabled, a user cannot exceed RLIMIT_MEMLOCK.

I had missed that, even though it was mentioned in the long commit
description. I just read the patch, and was looking at the
secretmem_file_create() and missed how the the limit was there in the
mmap path.

So I'm fine with this.

I still suspect that the "don't hibernate" should maybe at least alert
the sysadmin about *why* the hibernate failed, but let's see if that
ends up being an actual problem.

                 Linus
