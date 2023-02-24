Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7622DC6FA8E
	for <mm-commits@archiver.kernel.org>; Fri, 24 Feb 2023 18:59:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjBXS7H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Feb 2023 13:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjBXS7H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2023 13:59:07 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73E31B2D3
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 10:59:05 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id da10so1197729edb.3
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 10:59:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NMnVSOBNjx/bLYJdwnuGcoM5T1w2ljOwTVkJXGhR6M0=;
        b=eWQ6+GCDYq4xlis6g6EYwAVl52jMYKuUTk3zY+p+53ydE3hQ74JQM9gRwxmg6yQ1PG
         I4sYQi4RcndqPaPfC84dr7nGp75cTWH9kg5YGrvgeMaWdI6Oa7D05Bhi5rkvPZd0BgOB
         VQFz/Hi4WG//M2RSv0IAcgVNHZTS2XAMHEaCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NMnVSOBNjx/bLYJdwnuGcoM5T1w2ljOwTVkJXGhR6M0=;
        b=kkojb5d1pj7W0HyjCvRt8WQm6v9r3gIOXrsuKpnJuaqyugFsCckzIKmpqTNZNHGF6h
         14wAd2rUWjpg6E0M1C3Oia7J/niw5/7aa0E69lVvtxl6Q5i7CaDKfw/etQ61n+qwh8+Q
         h1XXxLZwqD1ocfnTIkfB7P0pmjK2G2BkuZTXJrYdl4yZe+zHHnPFB9rjogcJyHrPrwqi
         Bq2okSoNF1npk8PrXmtnvfjg/vSUSUiO+ZKGqeN9YteaWB/M4QtVALiwtvego57ApyBL
         kBlYyaY32AMDEpj6J+97rGUhWD1uLPymnp65msZtm00tt8oBwMYJUiU1/FyLz2HvQHAo
         v65Q==
X-Gm-Message-State: AO0yUKVU+BMq6LVqKdmhetpzeQY3+sjaNBaMh8Krc6jDqPi2sgM8r4Gz
        pqdvNuxB/l8XAztEW6xwDZV/mqyvcvAjR6l8Np6L2A==
X-Google-Smtp-Source: AK7set+da9t8AMYh1flgAqSOPbdD2FgwjPkbSRDBsnU2Gi+dJ5Ca8j0m4vnMyO3/XdLesqG84UgYbg==
X-Received: by 2002:a05:6402:755:b0:4ad:6ca7:6134 with SMTP id p21-20020a056402075500b004ad6ca76134mr17069418edy.30.1677265143736;
        Fri, 24 Feb 2023 10:59:03 -0800 (PST)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id m18-20020a17090607d200b008d044ede804sm6926635ejc.163.2023.02.24.10.59.02
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 10:59:02 -0800 (PST)
Received: by mail-ed1-f51.google.com with SMTP id i34so1104197eda.7
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 10:59:02 -0800 (PST)
X-Received: by 2002:a17:907:988c:b0:877:747e:f076 with SMTP id
 ja12-20020a170907988c00b00877747ef076mr10995913ejc.0.1677265142065; Fri, 24
 Feb 2023 10:59:02 -0800 (PST)
MIME-Version: 1.0
References: <2009825.1677229488@warthog.procyon.org.uk> <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com>
 <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
 <2134430.1677240738@warthog.procyon.org.uk> <2213409.1677249075@warthog.procyon.org.uk>
 <CAHk-=whFKL4VuFBWvenG8fAgfvbf36PDgouUSx47rZDWr9BkJw@mail.gmail.com> <2385284.1677259167@warthog.procyon.org.uk>
In-Reply-To: <2385284.1677259167@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 10:58:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiAQZUZCEH1OxFb3Oa_mqz69tagdXHnKuYd_rwRHba5Cw@mail.gmail.com>
Message-ID: <CAHk-=wiAQZUZCEH1OxFb3Oa_mqz69tagdXHnKuYd_rwRHba5Cw@mail.gmail.com>
Subject: Re: [RFC][PATCH] cifs: Fix cifs_writepages_region()
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <stfrench@microsoft.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Paulo Alcantara <pc@cjr.nz>,
        Matthew Wilcox <willy@infradead.org>,
        Huang Ying <ying.huang@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Xin Hao <xhao@linux.alibaba.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Fri, Feb 24, 2023 at 9:19 AM David Howells <dhowells@redhat.com> wrote:
>
> The skip thing, in my code, is only used in WB_SYNC_NONE mode.  If we hit 5
> things in progress or rescheduling is required, we return to the caller on the
> basis that conflicting flushes appear to be happening in other threads.

Ahh. *That* is the difference, and I didn't realize.

I made all the skip-write cases the same, and I really meant for that
case to only trigger for WB_SYNC_NONE, but I stupidly didn't notice
that the whole folio_test_dirty() re-test case was done without that
WB_SYNC_NONE case that all the other cases had.

Mea culpa, mea maxima culpa. That was just me being stupid.

So that case isn't actually a "skip write" case at all, it's actually
a "no write needed at all" case.

Your original patch is the right fix, and I was just being silly for
having not realized.

I'll apply that minimal fix for now - I think the right thing to do is
your bigger patch, but that needs more thinking (or at least splitting
up).

Sorry for the confusion, and thanks for setting me straight,

                  Linus
