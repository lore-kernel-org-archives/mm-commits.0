Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E28C4361B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 06:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFC1323118
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 06:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgLPGyE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Dec 2020 01:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgLPGyE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 16 Dec 2020 01:54:04 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF64C0613D6
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 22:53:23 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id a9so45675554lfh.2
        for <mm-commits@vger.kernel.org>; Tue, 15 Dec 2020 22:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JkvZSFt3PtP+BKQ8dL+TmMIMJL9D5skvgB/oM3zSYdE=;
        b=LtMlIJeAqP3xiZHhtQjHS+BaKbf9UporvklCQIPIerKTUq1zdKr9HdRhoX6STtyiEB
         CrxlhVZsO4lMEHaN+WQ/j2V9ESfCH7lN+EJJLI02Nqc7lAgMSuC5WWxoSIUmCtRnopQU
         2/oSoqeneoOI0N1c3IvK9DOCUfULPCYqAe+yJeb+N+Eb27gZXxNoELF5VOmRhmd+1XSl
         opK3Mp9J4OIWrUvJW3TRLdmL82ktUMY65HgIbqoukgBfqVtdvK/A5j4B1T1dfbh506bg
         KcSM7S6kyy3xTFMjbbEp7lIoq3iKRxrs1BZbmDV0GC7v/g+F3RS0sHLVEDpnhhjI8J7c
         RV3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JkvZSFt3PtP+BKQ8dL+TmMIMJL9D5skvgB/oM3zSYdE=;
        b=FjvTqT2DOdp86ixW+g6TESpnH+PUdnkDYp+MySTHdv5wAhP/J2JkcKoMQ2h8Q4lb4U
         KKp+tkc8Dc65s9rHv4uk61ug5RM/J1I7VCj5P8E3iZGJJPUAJp7IKpxrVXFaAWH+G/2r
         4L4kqADPZbzH18gtQ7B5vTUO3M5U6aKjW7EenxykxrKXv3DZNgRS2k3KDKNMbAZq+4pS
         Npa3EAhOkLAsnL/FTg+g7ylkgF01qUmQKRn9AThUEcWk3+vu52lHh9t5Zt6ym3OWRslT
         gMSBErNceeQ888NteAf4U1m8XZgilr9Fyq6wBsRpE4n5x6DuSSycxMzEc72G2cVYeodx
         DYTA==
X-Gm-Message-State: AOAM5309n+qqotMSXTgvq4lf6CJxK5mptZm9KFi1rhNK/4mvWfcGORP6
        kgngc4gy/7ENF6A6LYLueuhT+J8nwFvlrdLqC7fHLQ==
X-Google-Smtp-Source: ABdhPJwagbrb4tHMQIQE0xYXZrHoGSJ3r7+dZakyMu47yBiwZcrGBTgBaFo8UUwL3woith2S5AnURp4+vj9rgjDGXRs=
X-Received: by 2002:ac2:59ce:: with SMTP id x14mr12499801lfn.545.1608101601756;
 Tue, 15 Dec 2020 22:53:21 -0800 (PST)
MIME-Version: 1.0
References: <20201215204156.f05ec694b907845bcfab5c44@linux-foundation.org>
 <20201216044316.LYocMD9yH%akpm@linux-foundation.org> <CAHk-=wgkA+jbWhDTdOTYAjhYZgBt1jZmxtAMrQUFHmaZGMOV+Q@mail.gmail.com>
In-Reply-To: <CAHk-=wgkA+jbWhDTdOTYAjhYZgBt1jZmxtAMrQUFHmaZGMOV+Q@mail.gmail.com>
From:   David Gow <davidgow@google.com>
Date:   Wed, 16 Dec 2020 14:53:10 +0800
Message-ID: <CABVgOSk3bwm_E_dhS=G7qsBHd4oXHZkpYeNOx=CtLQUapy0GTQ@mail.gmail.com>
Subject: Re: [patch 18/95] lib/list_kunit: follow new file name convention for
 KUnit tests
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        Mark Brown <broonie@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        "Vaittinen, Matti" <matti.vaittinen@fi.rohmeurope.com>,
        mm-commits@vger.kernel.org, Vitor Massaru Iha <vitor@massaru.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hmm... sorry about this: it definitely shouldn't've happened.

I know the original patchset did have an issue (with one of the other
patches) that Andrew fixed while merging, so maybe it snuck through
while that was happening.

On Wed, Dec 16, 2020 at 2:02 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This is complete garbage, Andrew.
>
> In this patch, you change the name in the Makefile:
>
> On Tue, Dec 15, 2020 at 8:43 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > Subject: lib/list_kunit: follow new file name convention for KUnit tests
> >
> > Follow new file name convention for the KUnit tests.  Since we have
> > lib/*test*.c in a few variations, use 'kunit' suffix to distinguish usual
> > test cases with KUnit-based ones.
> ...
> > --- a/lib/Makefile~lib-list_kunit-follow-new-file-name-convention-for-kunit-tests
> > +++ a/lib/Makefile
> > @@ -350,6 +350,6 @@ obj-$(CONFIG_PLDMFW) += pldmfw/
> >
> >  # KUnit tests
> >  obj-$(CONFIG_BITFIELD_KUNIT) += bitfield_kunit.o
> > -obj-$(CONFIG_LIST_KUNIT_TEST) += list-test.o
> > +obj-$(CONFIG_LIST_KUNIT_TEST) += list_kunit.o
> >  obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
> >  obj-$(CONFIG_BITS_TEST) += test_bits.o
>
> but the actual *file* isn't changed.
>
> So there is no way in hell this will build.

This is interesting, as the original patch did rename it here:
https://lore.kernel.org/linux-kselftest/20201112180732.75589-1-andriy.shevchenko@linux.intel.com/

So something's definitely more muddled than just the renames being
expanded out...

>
> The file is _actually_ renamed in patch [20/95], which claims to do
> the lib/bits_kunit stuff, but actually does both the bits _and_ the
> list_kunit stuff.

And again, that rename is not in the bits_kunit patch in the original thread:
https://lore.kernel.org/linux-kselftest/20201112180732.75589-3-andriy.shevchenko@linux.intel.com/

>
> Making things worse, your use of substandard tools means that this
> garbage shows up as a patch that is over sixteen *hundred* lines long,
> when proper tooling would hav eactually shown it as a rename.
>
> It _should_ have been about 10 lines total.  Not 1600 lines that hide
> the problem and make it really nasty to see.
>
> That 1600 lines of noise is ignoring patch [19/95], which does the
> "linear_ranges_kunit" renaming, adding another ~500 lines of illegible
> garbage to my mailbox.
>
> At least that one got the Makefile right, although it was really hard
> to actually see that, considering how nasty and illegible the patch
> was due to renaming.
>
> Basically, I'm going to throw all these rename patches away. Not only
> were they were completely buggy, but they were also illegible because
> of your inferior tools.

Note that the three rename patches (list_kunit, linear_ranges_kunit,
and bits_kunit) were part of the same patchset as the following three
lib/cmdline{,_kunit} changes. Those don't depend on the earlier
patches, don't have renames, and seem to be fine from a cursory
glance, but the last one ([23/95]) did have some issues earlier (which
are now fixed).

>
> Don't send me any more rename patches until your tools can actually do renames.
>
>             Linus

My other thought is that this sort of patchset really makes more sense
to push through the kselftest/kunit branch anyway, as all of the
changes were really more KUnit related than anything else. Does it
make sense to re-submit this that way?

Cheers,
-- David
