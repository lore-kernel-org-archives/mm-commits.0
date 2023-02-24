Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88F5BC7EE22
	for <mm-commits@archiver.kernel.org>; Fri, 24 Feb 2023 16:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjBXQGi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Feb 2023 11:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBXQGi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2023 11:06:38 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B408584A8
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 08:06:36 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id eg37so52827546edb.12
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 08:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p1FN9nq7chgygC5NWZzWMsQda297W5OS4KEAh+SuMus=;
        b=ROuAwM4tAg+0iPPS4RRwf6U41AYovrmQQIr053RV82OWjRNJcwmgCd6EQZWBUDcuGl
         /YVUiED8jw7JQASfhrW9ek4MlJhqfPYCZ1uL7j8YbV641zREe/AnXkbLos/4aIYT+sxu
         AZKf48FLhcgz6ZmoERs6q2Q6vFuFae0IFc4mo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p1FN9nq7chgygC5NWZzWMsQda297W5OS4KEAh+SuMus=;
        b=Vg30ZlrdcMXH5jKU0q6vsPB8dyjYha8M5RaV7kGGJ3LpKEVla7V3cWJpGcCVJg+Xdv
         LN53wcftRZf3Imz6C1todvGzyeSKiS2gd/rJWWhLTpQtO9wmxr6K3PCDU2S7WqZMOH62
         Z3vCIhG4+ElXAfpWgdc6UNSYSP+ZV/2IkGiJDyZ+dQreGimNTNBzJBpwg39RLQa2jk3W
         D0rjay6HgdxJErO5NYA0LG61Vn7WzRO95AvJR/LCTmyT1t03hLvwfV4D5YfiKT/jj6vk
         dbI0Cu3UZasFnaTaI4ZyhMprBNY7TzQSaEU4vSGfJH+X9uPlVvKNrlGMcXyNFBcPc0ZT
         x2hw==
X-Gm-Message-State: AO0yUKXcwd/np6nP4m4rzs73QSYtk1ZxfuPh++X4CYvH5ued7f5gkwng
        dltYidbRHUOqnOFsC7Bb220XCzxrGfdSq4QfkkbwZQ==
X-Google-Smtp-Source: AK7set8S66tD3nccJeDEagsIHBqVs453Gd+roP32gCGm8i7IHpf/KWCOqxiO+g5pEU5Fy01dVCzosg==
X-Received: by 2002:a17:906:40c9:b0:8b1:75a0:57fa with SMTP id a9-20020a17090640c900b008b175a057famr27821819ejk.43.1677254794601;
        Fri, 24 Feb 2023 08:06:34 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id y14-20020a1709064b0e00b008c979c74732sm7434828eju.156.2023.02.24.08.06.33
        for <mm-commits@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 08:06:33 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id d30so15418439eda.4
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2023 08:06:33 -0800 (PST)
X-Received: by 2002:a50:9fae:0:b0:4ab:4d34:9762 with SMTP id
 c43-20020a509fae000000b004ab4d349762mr7669709edf.5.1677254793184; Fri, 24 Feb
 2023 08:06:33 -0800 (PST)
MIME-Version: 1.0
References: <2009825.1677229488@warthog.procyon.org.uk> <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com>
 <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
 <2134430.1677240738@warthog.procyon.org.uk> <2213409.1677249075@warthog.procyon.org.uk>
In-Reply-To: <2213409.1677249075@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 08:06:16 -0800
X-Gmail-Original-Message-ID: <CAHk-=whFKL4VuFBWvenG8fAgfvbf36PDgouUSx47rZDWr9BkJw@mail.gmail.com>
Message-ID: <CAHk-=whFKL4VuFBWvenG8fAgfvbf36PDgouUSx47rZDWr9BkJw@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary="00000000000025890805f57450f3"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--00000000000025890805f57450f3
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 24, 2023 at 6:31 AM David Howells <dhowells@redhat.com> wrote:
>
> Here's the simplest fix for cifs_writepages_region() that gets it to work.

Hmm. The commit message for this is wrong.

> Fix the cifs_writepages_region() to just skip over members of the batch that
> have been cleaned up rather than retrying them.

It never retried them. The "skip_write" code did that same

                        start += folio_size(folio);
                        continue;

that your patch does, but it *also* had that

                        if (skips >= 5 || need_resched()) {

thing to just stop writing entirely.

> I'm not entirely sure why it fixes it, though.

Yes. Strange. Because it does the exact same thing as the "Oh, the
trylock worked, but it was still under writeback or fscache" did. I
just merged all the "skip write" cases.

But the code is clearly (a) not working and (b) the whole skip count
and need_resched() logic is a bit strange to begin with.

Can you humor me, and try if just removing that skip count thing
instead? IOW, this attached patch? Because that whole "let's stop
writing if we need to reschedule" sounds truly odd (we have a
cond_resched(), although it's per folio batch, not per-folio), and the
skip count logic doesn't make much sense to me either.

SteveF?

              Linus

--00000000000025890805f57450f3
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_leiq6lh00>
X-Attachment-Id: f_leiq6lh00

IGZzL2NpZnMvZmlsZS5jIHwgMTIgLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTIgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9maWxlLmMgYi9mcy9jaWZzL2ZpbGUuYwpp
bmRleCA1MzY1YTMyOTkwODguLjcwNjFkMjYzMzE1ZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9maWxl
LmMKKysrIGIvZnMvY2lmcy9maWxlLmMKQEAgLTI4NTgsNyArMjg1OCw2IEBAIHN0YXRpYyBpbnQg
Y2lmc193cml0ZXBhZ2VzX3JlZ2lvbihzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZywKIAkJ
CQkgIGxvZmZfdCBzdGFydCwgbG9mZl90IGVuZCwgbG9mZl90ICpfbmV4dCkKIHsKIAlzdHJ1Y3Qg
Zm9saW9fYmF0Y2ggZmJhdGNoOwotCWludCBza2lwcyA9IDA7CiAKIAlmb2xpb19iYXRjaF9pbml0
KCZmYmF0Y2gpOwogCWRvIHsKQEAgLTI5MjcsMTcgKzI5MjYsNiBAQCBzdGF0aWMgaW50IGNpZnNf
d3JpdGVwYWdlc19yZWdpb24oc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcsCiAJCQlyZXR1
cm4gcmV0OwogCiBza2lwX3dyaXRlOgotCQkJLyoKLQkJCSAqIFRvbyBtYW55IHNraXBwZWQgd3Jp
dGVzLCBvciBuZWVkIHRvIHJlc2NoZWR1bGU/Ci0JCQkgKiBUcmVhdCBpdCBhcyBhIHdyaXRlIGVy
cm9yIHdpdGhvdXQgYW4gZXJyb3IgY29kZS4KLQkJCSAqLwotCQkJaWYgKHNraXBzID49IDUgfHwg
bmVlZF9yZXNjaGVkKCkpIHsKLQkJCQlyZXQgPSAwOwotCQkJCWdvdG8gd3JpdGVfZXJyb3I7Ci0J
CQl9Ci0KLQkJCS8qIE90aGVyd2lzZSwganVzdCBza2lwIHRoYXQgZm9saW8gYW5kIGdvIG9uIHRv
IHRoZSBuZXh0ICovCi0JCQlza2lwcysrOwogCQkJc3RhcnQgKz0gZm9saW9fc2l6ZShmb2xpbyk7
CiAJCQljb250aW51ZTsKIAkJfQo=
--00000000000025890805f57450f3--
