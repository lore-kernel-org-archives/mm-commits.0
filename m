Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9AE8C4332F
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 21:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbjKIV6Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 16:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbjKIV6Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 16:58:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 488473AA8
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 13:57:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699567061;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4KUq63iqB9ih1wTMLocBuMbwBouZfEhOWYa201pFqtQ=;
        b=Q++BAUPnG/gjZsnIe4xfxgBkWngtzuOI5r/JnWVl8SzWolvLJm5l+Wiu7AEqs+C/5E2YoM
        zKaK7FWuQ4doy0//7cIe6bb66y2GV5EiPkw4xGEZJ05VYSyHS3khjusjDdRk8NCz/Oiv1Y
        GZXbJr0YRPfnmjbkkfk2I5S76SS2iVY=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-GE1QJge4Oi6cg_nUTneATw-1; Thu, 09 Nov 2023 16:57:40 -0500
X-MC-Unique: GE1QJge4Oi6cg_nUTneATw-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6c334d2fd40so1423702b3a.2
        for <mm-commits@vger.kernel.org>; Thu, 09 Nov 2023 13:57:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699567059; x=1700171859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4KUq63iqB9ih1wTMLocBuMbwBouZfEhOWYa201pFqtQ=;
        b=fUZLIO4K8d+fxnwUg6Y6PzQg2XGBSGT6v8+qADHOpH3Kz152TJSR4itRy2vjIXSlms
         +Jfao5ARM+PeDOm3OwL25weFhFDGhzL9gySSEr0tPyMit9dBi5RUoONHqlLXdcnuPfOu
         BmYfyw13GMLi6EWfLnBf+Tqohgj5jlX1fbmKiljykHIbM9mXyFb6HGFTRafXd96GpkgV
         Zg+AiIKM0OBRdE+CHVwoRWUqpX3S/yF1X1h5IVhMBTeOH+ywI+E+PHoxoHOBnlHVDyHp
         6E28Emz0dwlOz2sFji6GXp4lh3tNbP4tQiumopERjvLhh+EHNMW/IfOyeSSuFDSjH0HY
         ouEw==
X-Gm-Message-State: AOJu0Yyftekxu9zkgvl4jHpzVslMTBmOwKtzsiacaexKjYGbn2OhvEQz
        Knyr6csEF+uV4IfTd6rYwJdgU/jghRRzokJ0Jh2SEx9DWMLeiw/jbhSjFYVWfo+jgyKIaD0A/vt
        Jci9//DOTsMeMCS5DBpOzDI6JYTFVRKLoHvKE/Q==
X-Received: by 2002:a05:6a20:7289:b0:180:1b3b:d560 with SMTP id o9-20020a056a20728900b001801b3bd560mr6969411pzk.41.1699567058903;
        Thu, 09 Nov 2023 13:57:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFYBxWLj2GURLryey7dCO5Mnk4+QVL7mqHZZYfHPqZc2q9UnjZWKViPpkMJ2HG5RrsQiPo7CEIhhF/HGbD0D34=
X-Received: by 2002:a05:6a20:7289:b0:180:1b3b:d560 with SMTP id
 o9-20020a056a20728900b001801b3bd560mr6969405pzk.41.1699567058628; Thu, 09 Nov
 2023 13:57:38 -0800 (PST)
MIME-Version: 1.0
References: <20231109215449.006A9C433C8@smtp.kernel.org>
In-Reply-To: <20231109215449.006A9C433C8@smtp.kernel.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Thu, 9 Nov 2023 22:57:27 +0100
Message-ID: <CAHc6FU7hnOVQh=P_-su5HzroH4SxXHPc9QuUv9qP8rPbs57xyQ@mail.gmail.com>
Subject: Re: + mm-add-folio_fill_tail-and-use-it-in-iomap.patch added to
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

On Thu, Nov 9, 2023 at 10:55=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
> The patch titled
>      Subject: mm: add folio_fill_tail() and use it in iomap
> has been added to the -mm mm-unstable branch.  Its filename is
>      mm-add-folio_fill_tail-and-use-it-in-iomap.patch
>
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree=
/patches/mm-add-folio_fill_tail-and-use-it-in-iomap.patch
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
> Subject: mm: add folio_fill_tail() and use it in iomap
> Date: Tue, 7 Nov 2023 21:26:41 +0000
>
> The iomap code was limited to PAGE_SIZE bytes; generalise it to cover
> an arbitrary-sized folio, and move it to be a common helper.
>
> Link: https://lkml.kernel.org/r/20231107212643.3490372-3-willy@infradead.=
org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Andreas Gruenbacher <agruenba@redhat.com>
> Cc: Darrick J. Wong <djwong@kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/iomap/buffered-io.c  |   14 ++------------
>  include/linux/highmem.h |   38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 40 insertions(+), 12 deletions(-)
>
> --- a/fs/iomap/buffered-io.c~mm-add-folio_fill_tail-and-use-it-in-iomap
> +++ a/fs/iomap/buffered-io.c
> @@ -305,28 +305,18 @@ static int iomap_read_inline_data(const
>  {
>         const struct iomap *iomap =3D iomap_iter_srcmap(iter);
>         size_t size =3D i_size_read(iter->inode) - iomap->offset;
> -       size_t poff =3D offset_in_page(iomap->offset);
>         size_t offset =3D offset_in_folio(folio, iomap->offset);
> -       void *addr;
>
>         if (folio_test_uptodate(folio))
>                 return 0;
>
> -       if (WARN_ON_ONCE(size > PAGE_SIZE - poff))
> -               return -EIO;
> -       if (WARN_ON_ONCE(size > PAGE_SIZE -
> -                        offset_in_page(iomap->inline_data)))
> -               return -EIO;
>         if (WARN_ON_ONCE(size > iomap->length))
>                 return -EIO;
>         if (offset > 0)
>                 ifs_alloc(iter->inode, folio, iter->flags);
>
> -       addr =3D kmap_local_folio(folio, offset);
> -       memcpy(addr, iomap->inline_data, size);
> -       memset(addr + size, 0, PAGE_SIZE - poff - size);
> -       kunmap_local(addr);
> -       iomap_set_range_uptodate(folio, offset, PAGE_SIZE - poff);
> +       folio_fill_tail(folio, offset, iomap->inline_data, size);
> +       iomap_set_range_uptodate(folio, offset, folio_size(folio) - offse=
t);
>         return 0;
>  }
>
> --- a/include/linux/highmem.h~mm-add-folio_fill_tail-and-use-it-in-iomap
> +++ a/include/linux/highmem.h
> @@ -522,6 +522,44 @@ static inline __must_check void *folio_z
>  }
>
>  /**
> + * folio_fill_tail - Copy some data to a folio and pad with zeroes.
> + * @folio: The destination folio.
> + * @offset: The offset into @folio at which to start copying.
> + * @from: The data to copy.
> + * @len: How many bytes of data to copy.
> + *
> + * This function is most useful for filesystems which support inline dat=
a.
> + * When they want to copy data from the inode into the page cache, this
> + * function does everything for them.  It supports large folios even on
> + * HIGHMEM configurations.
> + */
> +static inline void folio_fill_tail(struct folio *folio, size_t offset,
> +               const char *from, size_t len)
> +{
> +       char *to =3D kmap_local_folio(folio, offset);
> +
> +       VM_BUG_ON(offset + len > folio_size(folio));
> +
> +       if (folio_test_highmem(folio)) {
> +               size_t max =3D PAGE_SIZE - offset_in_page(offset);
> +
> +               while (len > max) {
> +                       memcpy(to, from, max);
> +                       kunmap_local(to);
> +                       len -=3D max;
> +                       from +=3D max;
> +                       offset +=3D max;
> +                       max =3D PAGE_SIZE;
> +                       to =3D kmap_local_folio(folio, offset);
> +               }
> +       }
> +
> +       memcpy(to, from, len);
> +       to =3D folio_zero_tail(folio, offset, to);

Please note the fix to this patch which I've just posted,

to =3D folio_zero_tail(folio, offset + len, to + len);

> +       kunmap_local(to);
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

