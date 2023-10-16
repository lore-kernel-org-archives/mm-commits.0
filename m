Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEDECDB465
	for <mm-commits@archiver.kernel.org>; Mon, 16 Oct 2023 14:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbjJPOL1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 16 Oct 2023 10:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233529AbjJPOL0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 16 Oct 2023 10:11:26 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFCFED
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 07:11:24 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-99bdeae1d0aso737029666b.1
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 07:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697465483; x=1698070283; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NfeN1/cIDW4FSonLOYgq9VC9LqgWPCA8otMtI71xuEQ=;
        b=T53E8PB7YPIL2AOWrHBQjHbaHvI3rMgcvKwBHDKLKR8wZvDmPPM2n3KQ6KLWat0S+s
         yIk/iwKudRBXy1OXS1sBnuRuHE2WSfiKNmjOVZjzq6sSM7tEBxh79xaZYh3g5sELwm2s
         XIamYi5JHo/V+X+pfWhqsi21J3yp3UoVzO73Zn4pM9TiSpyUY+fkeD1g1nPdZvjT2VoE
         k2ahJ/nCZJoJZ3Lfzje8d+x7wZ9ORSFZE70FsII0wxvwLyw7LwF1P87lnsurBNL5HZEC
         cqL6ZH2e3U5bkL8Dk7v9L57t3mCtcIFKIqIxWyYzau9ngVxYmWSVnMIZsKKAn/JJT91Q
         hG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697465483; x=1698070283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NfeN1/cIDW4FSonLOYgq9VC9LqgWPCA8otMtI71xuEQ=;
        b=PVhnb+69+KJ7Pk2cBiBJUWkCzmqA9Zj1pTU8LQxaSVQgObNR2bLFAAH2I9YZ/zAH6K
         Cz4q6bmHvbHQMcKxvdwZqquwexyJEC8atQlofAw1SfZCvq+Ezx4G79/6+X5XN+MnPtAe
         wmf0kQ4Sx/R4+SQNqr4qhTl33IOmVpz9AO516zOSbGmLpHx5G2rzBwm45b4xvfdS/1n1
         hS1OTp6LdCQ9L/nBIKKv1qtRUoys5UOHkymEP9tDCHLeAtoMNlRBpoVNdO/jieq81P4Z
         wXhXs9cJ7Cyh043utJoaUx6yRJ7qRHoLSyriILclzqLFV9t/Unsyf69GRRlI1S75Flyl
         nLoQ==
X-Gm-Message-State: AOJu0YygectBi4HBZkkrvpR1sgrRf5uvqFViWclpNBbbBiD1VVPK7GtF
        STxB/gWJph0CtphQ/xkpzeOPBRfzNLJAygT8Ht/M58SjtC8=
X-Google-Smtp-Source: AGHT+IFr9FHaGJ1EOisep9+YuFwipeZqQDEXWTi/K7Io/A3sccydQBW0R/5sjBrWQIJggxc+JyuljceSv7i8nqFsexk=
X-Received: by 2002:a17:907:7f0b:b0:9bf:5696:9153 with SMTP id
 qf11-20020a1709077f0b00b009bf56969153mr5524161ejc.57.1697465482623; Mon, 16
 Oct 2023 07:11:22 -0700 (PDT)
MIME-Version: 1.0
References: <20231010005309.79E1CC433C7@smtp.kernel.org> <20231012091305.GP3303@kernel.org>
In-Reply-To: <20231012091305.GP3303@kernel.org>
From:   Liam Ni <zhiguangni01@gmail.com>
Date:   Mon, 16 Oct 2023 22:11:11 +0800
Message-ID: <CACZJ9cUtU=gO9-9f0uXfcNbuuob2P=wPp0HiZ1OOZCYn3iRiOw@mail.gmail.com>
Subject: Re: + numa-improve-the-efficiency-of-calculating-pages-loss.patch
 added to mm-unstable branch
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, mingo@redhat.com, luto@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, bp@alien8.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Thu, 12 Oct 2023 at 17:14, Mike Rapoport <rppt@kernel.org> wrote:
>
> On Mon, Oct 09, 2023 at 05:52:59PM -0700, Andrew Morton wrote:
> >
> > The patch titled
> >      Subject: NUMA: improve the efficiency of calculating pages loss
>
> We don't calculate the lost pages here, but pages with no NUMA node
> assigned. How about
>
> NUMA: optimize detection of memory with no node id assigned by firmware
>
thanks, i will send patch v5.


> >  arch/x86/mm/numa.c       |   33 +--------------------------------
>
> arch/loongarch/kernel/numa.c copied the same check from x86, it should be
> updated as well.

In the previous version=EF=BC=88patch v3=EF=BC=89, I submitted a patch to l=
oongarch,
but there was no response.
 How about submitting the patch to loongarch after the patch v5 is
merged into the mainline?

>
> >  include/linux/memblock.h |    1 +
> >  mm/memblock.c            |   21 +++++++++++++++++++++
> >  3 files changed, 23 insertions(+), 32 deletions(-)
> >
> > --- a/arch/x86/mm/numa.c~numa-improve-the-efficiency-of-calculating-pag=
es-loss
> > +++ a/arch/x86/mm/numa.c
> > @@ -448,37 +448,6 @@ int __node_distance(int from, int to)
> >  EXPORT_SYMBOL(__node_distance);
> >
> >  /*
> > - * Sanity check to catch more bad NUMA configurations (they are amazin=
gly
> > - * common).  Make sure the nodes cover all memory.
> > - */
> > -static bool __init numa_meminfo_cover_memory(const struct numa_meminfo=
 *mi)
> > -{
> > -     u64 numaram, e820ram;
> > -     int i;
> > -
> > -     numaram =3D 0;
> > -     for (i =3D 0; i < mi->nr_blks; i++) {
> > -             u64 s =3D mi->blk[i].start >> PAGE_SHIFT;
> > -             u64 e =3D mi->blk[i].end >> PAGE_SHIFT;
> > -             numaram +=3D e - s;
> > -             numaram -=3D __absent_pages_in_range(mi->blk[i].nid, s, e=
);
> > -             if ((s64)numaram < 0)
> > -                     numaram =3D 0;
> > -     }
> > -
> > -     e820ram =3D max_pfn - absent_pages_in_range(0, max_pfn);
> > -
> > -     /* We seem to lose 3 pages somewhere. Allow 1M of slack. */
> > -     if ((s64)(e820ram - numaram) >=3D (1 << (20 - PAGE_SHIFT))) {
> > -             printk(KERN_ERR "NUMA: nodes only cover %LuMB of your %Lu=
MB e820 RAM. Not used.\n",
> > -                    (numaram << PAGE_SHIFT) >> 20,
> > -                    (e820ram << PAGE_SHIFT) >> 20);
> > -             return false;
> > -     }
> > -     return true;
> > -}
> > -
> > -/*
> >   * Mark all currently memblock-reserved physical memory (which covers =
the
> >   * kernel's own memory ranges) as hot-unswappable.
> >   */
> > @@ -583,7 +552,7 @@ static int __init numa_register_memblks(
> >                       return -EINVAL;
> >               }
> >       }
> > -     if (!numa_meminfo_cover_memory(mi))
> > +     if (!memblock_validate_numa_coverage(SZ_1M))
> >               return -EINVAL;
> >
> >       /* Finally register nodes. */
> > --- a/include/linux/memblock.h~numa-improve-the-efficiency-of-calculati=
ng-pages-loss
> > +++ a/include/linux/memblock.h
> > @@ -123,6 +123,7 @@ int memblock_physmem_add(phys_addr_t bas
> >  void memblock_trim_memory(phys_addr_t align);
> >  bool memblock_overlaps_region(struct memblock_type *type,
> >                             phys_addr_t base, phys_addr_t size);
> > +bool memblock_validate_numa_coverage(const u64 limit);
> >  int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
> >  int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
> >  int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
> > --- a/mm/memblock.c~numa-improve-the-efficiency-of-calculating-pages-lo=
ss
> > +++ a/mm/memblock.c
> > @@ -734,6 +734,27 @@ int __init_memblock memblock_add(phys_ad
> >       return memblock_add_range(&memblock.memory, base, size, MAX_NUMNO=
DES, 0);
> >  }
> >
>
> Please add kernel-doc description.
>
> > +bool __init_memblock memblock_validate_numa_coverage(const u64 limit)
>
> I think threshold is better name than limit here.
>
> > +{
> > +     unsigned long lose_pg =3D 0;
>
> The pages we count are not lost, they just don't have node id assigned.
> I'm inclined to use plain nr_pages rather that try to invent descriptive
> but yet short name here.
>
> > +     unsigned long start_pfn, end_pfn;
> > +     int nid, i;
> > +
> > +     /* calculate lose page */
> > +     for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &ni=
d) {
> > +             if (nid =3D=3D NUMA_NO_NODE)
> > +                     lose_pg +=3D end_pfn - start_pfn;
> > +     }
> > +
> > +     if (lose_pg >=3D limit) {
>
> The caller defines the limit in bytes, and here you compare it with pages=
.
>
> > +             pr_err("NUMA: We lost %ld pages.\n", lose_pg);
>
> I believe a better message would be:
>
>                 mem_size_mb =3D memblock_phys_mem_size() >> 20;
>                 pr_err("NUMA: no nodes coverage for %luMB of %luMB RAM\n"=
,
>                        (nr_pages << PAGE_SHIFT) >> 20, mem_size_mb);
>
>
> > +             return false;
> > +     }
> > +
> > +     return true;
> > +}
> > +
> > +
> >  /**
> >   * memblock_isolate_range - isolate given range into disjoint memblock=
s
> >   * @type: memblock type to isolate range for
> > _
> >
> > Patches currently in -mm which might be from zhiguangni01@gmail.com are
> >
> > numa-improve-the-efficiency-of-calculating-pages-loss.patch
> >
>
> --
> Sincerely yours,
> Mike.
