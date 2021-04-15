Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0790DC43461
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 20:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB27461153
	for <mm-commits@archiver.kernel.org>; Thu, 15 Apr 2021 20:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhDOUZu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Apr 2021 16:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235458AbhDOUZs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Apr 2021 16:25:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 591486103D;
        Thu, 15 Apr 2021 20:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618518324;
        bh=valUYtXAR7CD00fR+byNMsNNJ0KzqtfXt9jWKRBNlCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1YB8HWy3e+sehs/QVBZ8Tfs8W34va13pZzSvCdLHIfJEDzXrEklNlhaI60y00w9/J
         /GvJmAFcASfTTOg34aTHKs/ECuWcYPqxnFvqRx3R23nTMe2S5kct9KBdpDRkpIay4t
         5r4+hhS+/uuQOisSeoUfpw0B/QbfXVDpOj11fp28=
Date:   Thu, 15 Apr 2021 13:25:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     Andrey Konovalov <andreyknvl@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        Evgenii Stepanov <eugenis@google.com>,
        Alexander Potapenko <glider@google.com>,
        mm-commits@vger.kernel.org
Subject: Re: +
 kasan-fix-kasan_byte_accessible-to-be-consistent-with-actual-checks.patch
 added to -mm tree
Message-Id: <20210415132523.0bab5614dd0bd27fb404c850@linux-foundation.org>
In-Reply-To: <CAMn1gO5uTZ0ubXFpZBJTi+KaCmrrjHYrr1BhJQScEr=7WAUquw@mail.gmail.com>
References: <20210406014615.ccKage_oR%akpm@linux-foundation.org>
        <CAMn1gO5uTZ0ubXFpZBJTi+KaCmrrjHYrr1BhJQScEr=7WAUquw@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 15 Apr 2021 11:17:01 -0700 Peter Collingbourne <pcc@google.com> wrote:

> 
> Thanks for picking up this patch. It looks like you added it after the
> "kasan: initialize shadow to TAG_INVALID for SW_TAGS" patch in your
> series, but I think it would make more sense for it to appear before
> that one, i.e. apply something like this patch to
> https://www.ozlabs.org/~akpm/mmotm/series :

I made that change.
