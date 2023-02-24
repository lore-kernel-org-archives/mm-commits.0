Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD12C7EE23
	for <mm-commits@archiver.kernel.org>; Fri, 24 Feb 2023 16:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbjBXQNh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Feb 2023 11:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjBXQNg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2023 11:13:36 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B40C2BF1D
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 08:13:34 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id cy6so51251227edb.5
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 08:13:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uaxBJSgWqvLaoOMxWgJIqaQBEgKPvnccLZuHzDiq+NA=;
        b=BpwwamzG5OF5Y/Wholvr8UuQC8co6VGUxBK9PHdD8OUSHaQY6t6OCRKE3tYMwFqtvY
         BpxSTehtRoXcyoO6a5GVqmEdBXeJ6c8oE9YuWGTwUkaB9I7oGJflZ9Gt1J5VU2pgxzfb
         UEfYLbkrCzmH2UZy3e1QalYwtuQgpdE346IwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uaxBJSgWqvLaoOMxWgJIqaQBEgKPvnccLZuHzDiq+NA=;
        b=N/91jQ42nheEb1Vg5zJo4I0Cj2AfIdaOYKe1f91+OQfAHy3b5M5JY+l/qq7i+KB2eO
         /QG3BoaumSegY8FsA82SmilT+YmK0B0fmkaloymaFff2+EZSWlRr2fK8+Km0FY+O4XSE
         G/rq+c+Ij6Vij89eYMwGHz+Hvps2xVf8LAUwKRMwuy2EF+Icb5PVHGTpwsUnKzFhVVcb
         Bh8DVgJL1J0aVq+3uBRJGy2qZBL+e4cRKYBW8x8x8rOpR8V89porCftVQxu8unniHUuo
         XzcaOHuzN+WTpm5yJyLUuLeBs9SX0G2nuKTFlMJX9BAeAwJljHmkQsbqe8vJHGhf06eI
         RkHQ==
X-Gm-Message-State: AO0yUKVjpXyZ2VvjFofAdrxNtKkwc1htPk3LjYXbQzVNUji29sn5VG6U
        493ol5Spp743+znLdR5L2MlCK6ni7GTPISFeDcq+SQ==
X-Google-Smtp-Source: AK7set/8kXx3xued3Nta+mtgpPPVwDuHk6UbPF9waUTNuI6bpIaJHe5clg6SBSDEi+KwSLpTiyZhCQ==
X-Received: by 2002:a05:6402:658:b0:4ac:bd84:43d8 with SMTP id u24-20020a056402065800b004acbd8443d8mr16831833edx.8.1677255212067;
        Fri, 24 Feb 2023 08:13:32 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id w15-20020a50c44f000000b004af70c4b4a7sm1879105edf.97.2023.02.24.08.13.31
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 08:13:31 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id o12so57156668edb.9
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 08:13:31 -0800 (PST)
X-Received: by 2002:a50:9ecd:0:b0:4ac:c720:207c with SMTP id
 a71-20020a509ecd000000b004acc720207cmr6674555edf.5.1677255210884; Fri, 24 Feb
 2023 08:13:30 -0800 (PST)
MIME-Version: 1.0
References: <2009825.1677229488@warthog.procyon.org.uk> <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com>
 <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
 <2134430.1677240738@warthog.procyon.org.uk> <2214157.1677250083@warthog.procyon.org.uk>
In-Reply-To: <2214157.1677250083@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 08:13:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjz8sE9Dd_f7tER_APsCPRPDdt_Dykn8X62SGrbfzCpoA@mail.gmail.com>
Message-ID: <CAHk-=wjz8sE9Dd_f7tER_APsCPRPDdt_Dykn8X62SGrbfzCpoA@mail.gmail.com>
Subject: Re: [RFC][PATCH] cifs, afs: Revert changes to {cifs,afs}_writepages_region()
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

On Fri, Feb 24, 2023 at 6:48 AM David Howells <dhowells@redhat.com> wrote:
>
> Here's a more complex patch that reverts Vishal's patch to afs and your
> changes to cifs back to the point where find_get_pages_range_tag() was
> being used to get a single folio and then replace that with a function,
> filemap_get_folio_tag() that just gets a single folio.  An alternative way
> of doing this would be to make filemap_get_folios_tag() take a limit count.

Ack. I think this is the right thing to do.

Except we should at a minimum split this into two patches, with the
first one introducing that filemap_get_folio_tag() helper function
that makes the whole find_get_pages_range_tag() conversion much
simpler.

In fact, probably three patches - infrastructure, cifs and afs
separately. Just to make each patch simpler to look at for people who
care about that particular area.

And I'd still like to know why that 'skips' logic exists, it seems to
be shared with afs. The fact that it actually seems to change
semantics by your testing makes me even more suspicious of it than I
was when I was doing that "skip_write" thing.

(But the change I did was to treat _all_ the skipped writes the same,
while the old - and your revert - behavior is to only do the skip
counting for the "already under writeback" case. But it still stinks
to me).

                 Linus
