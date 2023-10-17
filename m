Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382D9CDB482
	for <mm-commits@archiver.kernel.org>; Tue, 17 Oct 2023 06:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjJQGJw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Oct 2023 02:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234513AbjJQGJv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2023 02:09:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EB8EA
        for <mm-commits@vger.kernel.org>; Mon, 16 Oct 2023 23:09:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8046C433C8;
        Tue, 17 Oct 2023 06:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697522988;
        bh=jP6ncgKvBwOjYIKGgvmBgCvrkQ9PZL2sRfNY+z7om/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YuadcoNxLS5LjN4mKNEgjnRiabKpqswT1D+1z0xz++WzSOBK8ZsnCbaD+Jl93b3JZ
         zEub76KmbkIGCFdifrQQx8q2dfXBkInEuauq5jbuBXpjbvXs6vqXIe24/b2Vc92PUd
         YkGEQ2iKhXAbCI1zEZCc8iMv+5/MxLx8sJeqg8Rnj/xiGwnlhqusYTfHnTRLzCqIIW
         J/7KAYJSLH0EKeQjxuaIKwPVJ9KXdq6GKuSpPUiR/PSr+fyk8pZDjw6ifdnPCtox1e
         qQ1MZSzW9fU1+jAcP8sK1IQb7baMkaiJTcdiuD7E9UIgOIGf8eDcQINO4yPP0IkDOx
         TbJ4hCvGHv8/A==
Date:   Tue, 17 Oct 2023 09:09:34 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Liam Ni <zhiguangni01@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, mingo@redhat.com, luto@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, bp@alien8.de
Subject: Re: + numa-improve-the-efficiency-of-calculating-pages-loss.patch
 added to mm-unstable branch
Message-ID: <20231017060934.GV3303@kernel.org>
References: <20231010005309.79E1CC433C7@smtp.kernel.org>
 <20231012091305.GP3303@kernel.org>
 <CACZJ9cUtU=gO9-9f0uXfcNbuuob2P=wPp0HiZ1OOZCYn3iRiOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACZJ9cUtU=gO9-9f0uXfcNbuuob2P=wPp0HiZ1OOZCYn3iRiOw@mail.gmail.com>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Oct 16, 2023 at 10:11:11PM +0800, Liam Ni wrote:
> On Thu, 12 Oct 2023 at 17:14, Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Mon, Oct 09, 2023 at 05:52:59PM -0700, Andrew Morton wrote:
> > >
> > > The patch titled
> > >      Subject: NUMA: improve the efficiency of calculating pages loss
> >
> > We don't calculate the lost pages here, but pages with no NUMA node
> > assigned. How about
> >
> > NUMA: optimize detection of memory with no node id assigned by firmware
> >
> thanks, i will send patch v5.
> 
> 
> > >  arch/x86/mm/numa.c       |   33 +--------------------------------
> >
> > arch/loongarch/kernel/numa.c copied the same check from x86, it should be
> > updated as well.
> 
> In the previous version（patch v3）, I submitted a patch to loongarch,
> but there was no response.
>  How about submitting the patch to loongarch after the patch v5 is
> merged into the mainline?

It's fine to include loongarch changes in v5.
 
> >
> > >  include/linux/memblock.h |    1 +
> > >  mm/memblock.c            |   21 +++++++++++++++++++++
> > >  3 files changed, 23 insertions(+), 32 deletions(-)
> > >
> > > --- a/arch/x86/mm/numa.c~numa-improve-the-efficiency-of-calculating-pages-loss
> > > +++ a/arch/x86/mm/numa.c
> > > @@ -448,37 +448,6 @@ int __node_distance(int from, int to)
> > >  EXPORT_SYMBOL(__node_distance);
> > >
> > >  /*
> > > - * Sanity check to catch more bad NUMA configurations (they are amazingly
> > > - * common).  Make sure the nodes cover all memory.
> > > - */
> > > -static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
> > > -{
> > > -     u64 numaram, e820ram;
> > > -     int i;
> > > -
> > > -     numaram = 0;
> > > -     for (i = 0; i < mi->nr_blks; i++) {
> > > -             u64 s = mi->blk[i].start >> PAGE_SHIFT;
> > > -             u64 e = mi->blk[i].end >> PAGE_SHIFT;
> > > -             numaram += e - s;
> > > -             numaram -= __absent_pages_in_range(mi->blk[i].nid, s, e);
> > > -             if ((s64)numaram < 0)
> > > -                     numaram = 0;
> > > -     }
> > > -
> > > -     e820ram = max_pfn - absent_pages_in_range(0, max_pfn);
> > > -
> > > -     /* We seem to lose 3 pages somewhere. Allow 1M of slack. */
> > > -     if ((s64)(e820ram - numaram) >= (1 << (20 - PAGE_SHIFT))) {
> > > -             printk(KERN_ERR "NUMA: nodes only cover %LuMB of your %LuMB e820 RAM. Not used.\n",
> > > -                    (numaram << PAGE_SHIFT) >> 20,
> > > -                    (e820ram << PAGE_SHIFT) >> 20);
> > > -             return false;
> > > -     }
> > > -     return true;
> > > -}
> > > -
> > > -/*
> > >   * Mark all currently memblock-reserved physical memory (which covers the
> > >   * kernel's own memory ranges) as hot-unswappable.
> > >   */
> > > @@ -583,7 +552,7 @@ static int __init numa_register_memblks(
> > >                       return -EINVAL;
> > >               }
> > >       }
> > > -     if (!numa_meminfo_cover_memory(mi))
> > > +     if (!memblock_validate_numa_coverage(SZ_1M))
> > >               return -EINVAL;
> > >
> > >       /* Finally register nodes. */
> > > --- a/include/linux/memblock.h~numa-improve-the-efficiency-of-calculating-pages-loss
> > > +++ a/include/linux/memblock.h
> > > @@ -123,6 +123,7 @@ int memblock_physmem_add(phys_addr_t bas
> > >  void memblock_trim_memory(phys_addr_t align);
> > >  bool memblock_overlaps_region(struct memblock_type *type,
> > >                             phys_addr_t base, phys_addr_t size);
> > > +bool memblock_validate_numa_coverage(const u64 limit);
> > >  int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
> > >  int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
> > >  int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
> > > --- a/mm/memblock.c~numa-improve-the-efficiency-of-calculating-pages-loss
> > > +++ a/mm/memblock.c
> > > @@ -734,6 +734,27 @@ int __init_memblock memblock_add(phys_ad
> > >       return memblock_add_range(&memblock.memory, base, size, MAX_NUMNODES, 0);
> > >  }
> > >
> >
> > Please add kernel-doc description.
> >
> > > +bool __init_memblock memblock_validate_numa_coverage(const u64 limit)
> >
> > I think threshold is better name than limit here.
> >
> > > +{
> > > +     unsigned long lose_pg = 0;
> >
> > The pages we count are not lost, they just don't have node id assigned.
> > I'm inclined to use plain nr_pages rather that try to invent descriptive
> > but yet short name here.
> >
> > > +     unsigned long start_pfn, end_pfn;
> > > +     int nid, i;
> > > +
> > > +     /* calculate lose page */
> > > +     for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
> > > +             if (nid == NUMA_NO_NODE)
> > > +                     lose_pg += end_pfn - start_pfn;
> > > +     }
> > > +
> > > +     if (lose_pg >= limit) {
> >
> > The caller defines the limit in bytes, and here you compare it with pages.
> >
> > > +             pr_err("NUMA: We lost %ld pages.\n", lose_pg);
> >
> > I believe a better message would be:
> >
> >                 mem_size_mb = memblock_phys_mem_size() >> 20;
> >                 pr_err("NUMA: no nodes coverage for %luMB of %luMB RAM\n",
> >                        (nr_pages << PAGE_SHIFT) >> 20, mem_size_mb);
> >
> >
> > > +             return false;
> > > +     }
> > > +
> > > +     return true;
> > > +}
> > > +
> > > +
> > >  /**
> > >   * memblock_isolate_range - isolate given range into disjoint memblocks
> > >   * @type: memblock type to isolate range for
> > > _
> > >
> > > Patches currently in -mm which might be from zhiguangni01@gmail.com are
> > >
> > > numa-improve-the-efficiency-of-calculating-pages-loss.patch
> > >
> >
> > --
> > Sincerely yours,
> > Mike.

-- 
Sincerely yours,
Mike.
