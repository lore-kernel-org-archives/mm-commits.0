Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3554C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 22:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjKIWBC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 17:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjKIWBB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 17:01:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A6A3ABF
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 14:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699567212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3zZru6cU9xc/sIdRtIzOX/O7RK7O3ypGajuNqjY4rrM=;
        b=eOAWh3leBmGIZ2J5QOlIEBi1TAHAuM0SHvZtrRKjYvETBgcxGmQECPiiHBDm8iKAgtAarE
        YqR9/j6Ui84xD2ebDYNDmlnohpPZ/ue7nHvOdN4chwJulhNnXmN4ELus0ycXSgUNQj8pIV
        4WuTR5zcfugmo+Fo4DvbU5IkBB3G24g=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-602-QdIsffWnPRyykZSnP07p5g-1; Thu, 09 Nov 2023 17:00:11 -0500
X-MC-Unique: QdIsffWnPRyykZSnP07p5g-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1cc3130ba31so13128995ad.0
        for <mm-commits@vger.kernel.org>; Thu, 09 Nov 2023 14:00:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699567210; x=1700172010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3zZru6cU9xc/sIdRtIzOX/O7RK7O3ypGajuNqjY4rrM=;
        b=hDvGQ8PlICxrvAuCABioG0Lsarx2zXtc4CXOqegZwE2D2k97kU8Zr6shAKiswu2apr
         wSVH76xeExVq3P1sccx6jOzvO7Teeq5ODRrg4L6uJxq3m5Zxth8InF1J7LI+NE8uCX9w
         +wT1FtdmBMy/ayqGL2ZigiT/tF+/9igSV47JACV0f6PduGtiLYB1ICMMv6jTDDqcAxyh
         VyqVqHwYeRmbRuLCvUlmfQrwAAEZUic4Dr8HmBZ/kpxQg7wrD3LmAMiU2PGrnpuTFXkI
         vMTHq1zLjf+nG0hX2qVDr4xwaaH1CFZSfqmWLDYW80fY5vGye4K/0IXflM8czzWkDaSw
         Y6wQ==
X-Gm-Message-State: AOJu0YwbDTHPEVrZdpiduKlRQv9EO6alhW7lUafGR/OXfqLz4X0GnCwa
        c1GCSR9NRM14OKWfqjm/wfIJMzOAbPObJyv+ste4BrkSl9gFpXctwCaitmpBZxELci6M7ekFF2m
        rx1ZuK5UWzHTaZ3UUu+C01jInCzLi9PM9vmxsBu91LbrsWw==
X-Received: by 2002:a17:902:d502:b0:1cc:6dfa:ca55 with SMTP id b2-20020a170902d50200b001cc6dfaca55mr7503816plg.25.1699567209666;
        Thu, 09 Nov 2023 14:00:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGgaVkz6vjfUojZuBR9P2LQYgMfhArLuxTDgjep7JT+uslbXfg0I2OHpJNKa34kKbvBB1vEegOK+NW8XbzMmTI=
X-Received: by 2002:a17:902:d502:b0:1cc:6dfa:ca55 with SMTP id
 b2-20020a170902d50200b001cc6dfaca55mr7503777plg.25.1699567209232; Thu, 09 Nov
 2023 14:00:09 -0800 (PST)
MIME-Version: 1.0
References: <20231109215447.9B830C433C8@smtp.kernel.org>
In-Reply-To: <20231109215447.9B830C433C8@smtp.kernel.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 9 Nov 2023 22:59:57 +0100
Message-ID: <CAHc6FU40iYop8n6_kL3U4kCcBjhq2e0tJRjepSP_ZpLgWt6QyA@mail.gmail.com>
Subject: Re: + mm-add-folio_zero_tail-and-use-it-in-ext4.patch added to
 mm-unstable branch
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, tytso@mit.edu, djwong@kernel.org,
        adilger.kernel@dilger.ca, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, Nov 9, 2023 at 10:54=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> The patch titled
>      Subject: mm: add folio_zero_tail() and use it in ext4
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-add-folio_zero_tail-and-use-it-in-ext4.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-add-folio_zero_tail-and-use-it-in-ext4.patch
>
> This patch will later appear in the mm-unstable branch at
>     git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
>
> *** Remember to use Documentation/process/submit-checklist.rst when testi=
ng your code ***
>
> The -mm tree is included into linux-next via the mm-everything
> branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> and is updated there every 2-3 working days
>
> ------------------------------------------------------
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Subject: mm: add folio_zero_tail() and use it in ext4
> Date: Tue, 7 Nov 2023 21:26:40 +0000
>
> Patch series "Add folio_zero_tail() and folio_fill_tail()".
>
> I'm trying to make it easier for filesystems with tailpacking / stuffing =
/
> inline data to use folios.  The primary function here is
> folio_fill_tail().  You give it a pointer to memory where the data
> currently is, and it takes care of copying it into the folio at that
> offset.  That works for gfs2 & iomap.  Then There's Ext4.  Rather than gi=
n
> up some kind of specialist "Here's a two pointers to two blocks of memory=
"
> routine, just let it do its current thing, and let it call
> folio_zero_tail(), which is also called by folio_fill_tail().
>
> Other filesystems can be converted later; these ones seemed like good
> examples as they're already partly or completely converted to folios.
>
>
> This patch (of 3):
>
> Instead of unmapping the folio after copying the data to it, then mapping
> it again to zero the tail, provide folio_zero_tail() to zero the tail of
> an already-mapped folio.
>
> Link: https://lkml.kernel.org/r/20231107212643.3490372-1-willy@infradead.=
org
> Link: https://lkml.kernel.org/r/20231107212643.3490372-2-willy@infradead.=
org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Andreas Gruenbacher <agruenba@redhat.com>
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/ext4/inline.c        |    3 +--
>  include/linux/highmem.h |   38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+), 2 deletions(-)
>
> --- a/fs/ext4/inline.c~mm-add-folio_zero_tail-and-use-it-in-ext4
> +++ a/fs/ext4/inline.c
> @@ -502,9 +502,8 @@ static int ext4_read_inline_folio(struct
>         BUG_ON(len > PAGE_SIZE);
>         kaddr =3D kmap_local_folio(folio, 0);
>         ret =3D ext4_read_inline_data(inode, kaddr, len, &iloc);
> -       flush_dcache_folio(folio);
> +       kaddr =3D folio_zero_tail(folio, len, kaddr + len);
>         kunmap_local(kaddr);
> -       folio_zero_segment(folio, len, folio_size(folio));
>         folio_mark_uptodate(folio);
>         brelse(iloc.bh);
>
> --- a/include/linux/highmem.h~mm-add-folio_zero_tail-and-use-it-in-ext4
> +++ a/include/linux/highmem.h
> @@ -484,6 +484,44 @@ static inline void memcpy_to_folio(struc
>  }
>
>  /**
> + * folio_zero_tail - Zero the tail of a folio.
> + * @folio: The folio to zero.
> + * @kaddr: The address the folio is currently mapped to.
> + * @offset: The byte offset in the folio to start zeroing at.

And the order of the arguments in the description is still wrong.

> + *
> + * If you have already used kmap_local_folio() to map a folio, written
> + * some data to it and now need to zero the end of the folio (and flush
> + * the dcache), you can use this function.  If you do not have the
> + * folio kmapped (eg the folio has been partially populated by DMA),
> + * use folio_zero_range() or folio_zero_segment() instead.
> + *
> + * Return: An address which can be passed to kunmap_local().
> + */
> +static inline __must_check void *folio_zero_tail(struct folio *folio,
> +               size_t offset, void *kaddr)
> +{
> +       size_t len =3D folio_size(folio) - offset;
> +
> +       if (folio_test_highmem(folio)) {
> +               size_t max =3D PAGE_SIZE - offset_in_page(offset);
> +
> +               while (len > max) {
> +                       memset(kaddr, 0, max);
> +                       kunmap_local(kaddr);
> +                       len -=3D max;
> +                       offset +=3D max;
> +                       max =3D PAGE_SIZE;
> +                       kaddr =3D kmap_local_folio(folio, offset);
> +               }
> +       }
> +
> +       memset(kaddr, 0, len);
> +       flush_dcache_folio(folio);
> +
> +       return kaddr;
> +}
> +
> +/**
>   * memcpy_from_file_folio - Copy some bytes from a file folio.
>   * @to: The destination buffer.
>   * @folio: The folio to copy from.
> _
>
> Patches currently in -mm which might be from willy@infradead.org are
>
> mm-add-folio_zero_tail-and-use-it-in-ext4.patch
> mm-add-folio_fill_tail-and-use-it-in-iomap.patch
> gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch
> mm-remove-test_set_page_writeback.patch
> afs-do-not-test-the-return-value-of-folio_start_writeback.patch
> smb-do-not-test-the-return-value-of-folio_start_writeback.patch
> mm-return-void-from-folio_start_writeback-and-related-functions.patch
> mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
> mm-convert-__do_fault-to-use-a-folio.patch
> mm-use-mapping_evict_folio-in-truncate_error_page.patch
> mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
> mm-convert-isolate_page-to-mf_isolate_folio.patch
> mm-remove-invalidate_inode_page.patch
>

Thanks,
Andreas

