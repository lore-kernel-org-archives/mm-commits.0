Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B10FC11F66
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 727C661474
	for <mm-commits@archiver.kernel.org>; Thu,  1 Jul 2021 01:52:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238488AbhGABy7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:54:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238416AbhGABy7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 30 Jun 2021 21:54:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1C0861468;
        Thu,  1 Jul 2021 01:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625104349;
        bh=nAZaYso07xxJt9fyRje9fi45hhdPx6s78HxSrE8uJL8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=xjcez30Lf9aKMSeZQrCsm3tqEwNJhovvIOkJS+9QViG2tUDu3Gejf5dYXExh8Jd2P
         NiJeab7EyqkndnY1r+og2G28HFfe9O47RAEkn12hxiCdXORlhf/7Zta6f6u0X0DoF5
         ErRRg6pW3PfoiyQOhnmL5KZiSW2LZwQvirJzmUUU=
Date:   Wed, 30 Jun 2021 18:52:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aarcange@redhat.com, akpm@linux-foundation.org, arnd@arndb.de,
        chris@zankel.net, dave.hansen@intel.com, david@redhat.com,
        deller@gmx.de, eike-kernel@sf-tec.de, hughd@google.com,
        ink@jurassic.park.msu.ru, James.Bottomley@HansenPartnership.com,
        jannh@google.com, jcmvbkbc@gmail.com, jgg@ziepe.ca,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        linuxram@us.ibm.com, mattst88@gmail.com, mhocko@suse.com,
        mike.kravetz@oracle.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, mst@redhat.com, osalvador@suse.de,
        peterx@redhat.com, riel@surriel.com, rth@twiddle.net,
        shuah@kernel.org, torvalds@linux-foundation.org,
        tsbogend@alpha.franken.de, vbabka@suse.cz, willy@infradead.org
Subject:  [patch 099/192] mm/madvise: introduce
 MADV_POPULATE_(READ|WRITE) to prefault page tables
Message-ID: <20210701015228.QXA77Jpli%akpm@linux-foundation.org>
In-Reply-To: <20210630184624.9ca1937310b0dd5ce66b30e7@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: David Hildenbrand <david@redhat.com>
Subject: mm/madvise: introduce MADV_POPULATE_(READ|WRITE) to prefault page tables

I. Background: Sparse Memory Mappings

When we manage sparse memory mappings dynamically in user space - also
sometimes involving MAP_NORESERVE - we want to dynamically populate/
discard memory inside such a sparse memory region.  Example users are
hypervisors (especially implementing memory ballooning or similar
technologies like virtio-mem) and memory allocators.  In addition, we want
to fail in a nice way (instead of generating SIGBUS) if populating does
not succeed because we are out of backend memory (which can happen easily
with file-based mappings, especially tmpfs and hugetlbfs).

While MADV_DONTNEED, MADV_REMOVE and FALLOC_FL_PUNCH_HOLE allow for
reliably discarding memory for most mapping types, there is no generic
approach to populate page tables and preallocate memory.

Although mmap() supports MAP_POPULATE, it is not applicable to the concept
of sparse memory mappings, where we want to populate/discard dynamically
and avoid expensive/problematic remappings.  In addition, we never
actually report errors during the final populate phase - it is best-effort
only.

fallocate() can be used to preallocate file-based memory and fail in a
safe way.  However, it cannot really be used for any private mappings on
anonymous files via memfd due to COW semantics.  In addition, fallocate()
does not actually populate page tables, so we still always get pagefaults
on first access - which is sometimes undesired (i.e., real-time workloads)
and requires real prefaulting of page tables, not just a preallocation of
backend storage.  There might be interesting use cases for sparse memory
regions along with mlockall(MCL_ONFAULT) which fallocate() cannot satisfy
as it does not prefault page tables.

II. On preallcoation/prefaulting from user space

Because we don't have a proper interface, what applications (like QEMU and
databases) end up doing is touching (i.e., reading+writing one byte to not
overwrite existing data) all individual pages.

However, that approach
1) Can result in wear on storage backing, because we end up reading/writing
   each page; this is especially a problem for dax/pmem.
2) Can result in mmap_sem contention when prefaulting via multiple
   threads.
3) Requires expensive signal handling, especially to catch SIGBUS in case
   of hugetlbfs/shmem/file-backed memory. For example, this is
   problematic in hypervisors like QEMU where SIGBUS handlers might already
   be used by other subsystems concurrently to e.g, handle hardware errors.
   "Simply" doing preallocation concurrently from other thread is not that
   easy.

III. On MADV_WILLNEED

Extending MADV_WILLNEED is not an option because
1. It would change the semantics: "Expect access in the near future." and
   "might be a good idea to read some pages" vs. "Definitely populate/
   preallocate all memory and definitely fail on errors.".
2. Existing users (like virtio-balloon in QEMU when deflating the balloon)
   don't want populate/prealloc semantics. They treat this rather as a hint
   to give a little performance boost without too much overhead - and don't
   expect that a lot of memory might get consumed or a lot of time
   might be spent.

IV. MADV_POPULATE_READ and MADV_POPULATE_WRITE

Let's introduce MADV_POPULATE_READ and MADV_POPULATE_WRITE, inspired by
MAP_POPULATE, with the following semantics:
1. MADV_POPULATE_READ can be used to prefault page tables just like
   manually reading each individual page. This will not break any COW
   mappings. The shared zero page might get mapped and no backend storage
   might get preallocated -- allocation might be deferred to
   write-fault time. Especially shared file mappings require an explicit
   fallocate() upfront to actually preallocate backend memory (blocks in
   the file system) in case the file might have holes.
2. If MADV_POPULATE_READ succeeds, all page tables have been populated
   (prefaulted) readable once.
3. MADV_POPULATE_WRITE can be used to preallocate backend memory and
   prefault page tables just like manually writing (or
   reading+writing) each individual page. This will break any COW
   mappings -- e.g., the shared zeropage is never populated.
4. If MADV_POPULATE_WRITE succeeds, all page tables have been populated
   (prefaulted) writable once.
5. MADV_POPULATE_READ and MADV_POPULATE_WRITE cannot be applied to special
   mappings marked with VM_PFNMAP and VM_IO. Also, proper access
   permissions (e.g., PROT_READ, PROT_WRITE) are required. If any such
   mapping is encountered, madvise() fails with -EINVAL.
6. If MADV_POPULATE_READ or MADV_POPULATE_WRITE fails, some page tables
   might have been populated.
7. MADV_POPULATE_READ and MADV_POPULATE_WRITE will return -EHWPOISON
   when encountering a HW poisoned page in the range.
8. Similar to MAP_POPULATE, MADV_POPULATE_READ and MADV_POPULATE_WRITE
   cannot protect from the OOM (Out Of Memory) handler killing the
   process.

While the use case for MADV_POPULATE_WRITE is fairly obvious (i.e.,
preallocate memory and prefault page tables for VMs), one issue is that
whenever we prefault pages writable, the pages have to be marked dirty,
because the CPU could dirty them any time.  while not a real problem for
hugetlbfs or dax/pmem, it can be a problem for shared file mappings: each
page will be marked dirty and has to be written back later when evicting.

MADV_POPULATE_READ allows for optimizing this scenario: Pre-read a whole
mapping from backend storage without marking it dirty, such that eviction
won't have to write it back.  As discussed above, shared file mappings
might require an explciit fallocate() upfront to achieve
preallcoation+prepopulation.

Although sparse memory mappings are the primary use case, this will also
be useful for other preallocate/prefault use cases where MAP_POPULATE is
not desired or the semantics of MAP_POPULATE are not sufficient: as one
example, QEMU users can trigger preallocation/prefaulting of guest RAM
after the mapping was created -- and don't want errors to be silently
suppressed.

Looking at the history, MADV_POPULATE was already proposed in 2013 [1],
however, the main motivation back than was performance improvements --
which should also still be the case.

V. Single-threaded performance comparison

I did a short experiment, prefaulting page tables on completely *empty
mappings/files* and repeated the experiment 10 times.  The results
correspond to the shortest execution time.  In general, the performance
benefit for huge pages is negligible with small mappings.

V.1: Private mappings

POPULATE_READ and POPULATE_WRITE is fastest.  Note that
Reading/POPULATE_READ will populate the shared zeropage where applicable
-- which result in short population times.

The fastest way to allocate backend storage (here: swap or huge pages) and
prefault page tables is POPULATE_WRITE.

V.2: Shared mappings

fallocate() is fastest, however, doesn't prefault page tables. 
POPULATE_WRITE is faster than simple writes and read/writes. 
POPULATE_READ is faster than simple reads.

Without a fd, the fastest way to allocate backend storage and prefault
page tables is POPULATE_WRITE.  With an fd, the fastest way is usually
FALLOCATE+POPULATE_READ or FALLOCATE+POPULATE_WRITE respectively; one
exception are actual files: FALLOCATE+Read is slightly faster than
FALLOCATE+POPULATE_READ.

The fastest way to allocate backend storage prefault page tables is
FALLOCATE+POPULATE_WRITE -- except when dealing with actual files; then,
FALLOCATE+POPULATE_READ is fastest and won't directly mark all pages as
dirty.

v.3: Detailed results

==================================================
2 MiB MAP_PRIVATE:
**************************************************
Anon 4 KiB     : Read                     :     0.119 ms
Anon 4 KiB     : Write                    :     0.222 ms
Anon 4 KiB     : Read/Write               :     0.380 ms
Anon 4 KiB     : POPULATE_READ            :     0.060 ms
Anon 4 KiB     : POPULATE_WRITE           :     0.158 ms
Memfd 4 KiB    : Read                     :     0.034 ms
Memfd 4 KiB    : Write                    :     0.310 ms
Memfd 4 KiB    : Read/Write               :     0.362 ms
Memfd 4 KiB    : POPULATE_READ            :     0.039 ms
Memfd 4 KiB    : POPULATE_WRITE           :     0.229 ms
Memfd 2 MiB    : Read                     :     0.030 ms
Memfd 2 MiB    : Write                    :     0.030 ms
Memfd 2 MiB    : Read/Write               :     0.030 ms
Memfd 2 MiB    : POPULATE_READ            :     0.030 ms
Memfd 2 MiB    : POPULATE_WRITE           :     0.030 ms
tmpfs          : Read                     :     0.033 ms
tmpfs          : Write                    :     0.313 ms
tmpfs          : Read/Write               :     0.406 ms
tmpfs          : POPULATE_READ            :     0.039 ms
tmpfs          : POPULATE_WRITE           :     0.285 ms
file           : Read                     :     0.033 ms
file           : Write                    :     0.351 ms
file           : Read/Write               :     0.408 ms
file           : POPULATE_READ            :     0.039 ms
file           : POPULATE_WRITE           :     0.290 ms
hugetlbfs      : Read                     :     0.030 ms
hugetlbfs      : Write                    :     0.030 ms
hugetlbfs      : Read/Write               :     0.030 ms
hugetlbfs      : POPULATE_READ            :     0.030 ms
hugetlbfs      : POPULATE_WRITE           :     0.030 ms
**************************************************
4096 MiB MAP_PRIVATE:
**************************************************
Anon 4 KiB     : Read                     :   237.940 ms
Anon 4 KiB     : Write                    :   708.409 ms
Anon 4 KiB     : Read/Write               :  1054.041 ms
Anon 4 KiB     : POPULATE_READ            :   124.310 ms
Anon 4 KiB     : POPULATE_WRITE           :   572.582 ms
Memfd 4 KiB    : Read                     :   136.928 ms
Memfd 4 KiB    : Write                    :   963.898 ms
Memfd 4 KiB    : Read/Write               :  1106.561 ms
Memfd 4 KiB    : POPULATE_READ            :    78.450 ms
Memfd 4 KiB    : POPULATE_WRITE           :   805.881 ms
Memfd 2 MiB    : Read                     :   357.116 ms
Memfd 2 MiB    : Write                    :   357.210 ms
Memfd 2 MiB    : Read/Write               :   357.606 ms
Memfd 2 MiB    : POPULATE_READ            :   356.094 ms
Memfd 2 MiB    : POPULATE_WRITE           :   356.937 ms
tmpfs          : Read                     :   137.536 ms
tmpfs          : Write                    :   954.362 ms
tmpfs          : Read/Write               :  1105.954 ms
tmpfs          : POPULATE_READ            :    80.289 ms
tmpfs          : POPULATE_WRITE           :   822.826 ms
file           : Read                     :   137.874 ms
file           : Write                    :   987.025 ms
file           : Read/Write               :  1107.439 ms
file           : POPULATE_READ            :    80.413 ms
file           : POPULATE_WRITE           :   857.622 ms
hugetlbfs      : Read                     :   355.607 ms
hugetlbfs      : Write                    :   355.729 ms
hugetlbfs      : Read/Write               :   356.127 ms
hugetlbfs      : POPULATE_READ            :   354.585 ms
hugetlbfs      : POPULATE_WRITE           :   355.138 ms
**************************************************
2 MiB MAP_SHARED:
**************************************************
Anon 4 KiB     : Read                     :     0.394 ms
Anon 4 KiB     : Write                    :     0.348 ms
Anon 4 KiB     : Read/Write               :     0.400 ms
Anon 4 KiB     : POPULATE_READ            :     0.326 ms
Anon 4 KiB     : POPULATE_WRITE           :     0.273 ms
Anon 2 MiB     : Read                     :     0.030 ms
Anon 2 MiB     : Write                    :     0.030 ms
Anon 2 MiB     : Read/Write               :     0.030 ms
Anon 2 MiB     : POPULATE_READ            :     0.030 ms
Anon 2 MiB     : POPULATE_WRITE           :     0.030 ms
Memfd 4 KiB    : Read                     :     0.412 ms
Memfd 4 KiB    : Write                    :     0.372 ms
Memfd 4 KiB    : Read/Write               :     0.419 ms
Memfd 4 KiB    : POPULATE_READ            :     0.343 ms
Memfd 4 KiB    : POPULATE_WRITE           :     0.288 ms
Memfd 4 KiB    : FALLOCATE                :     0.137 ms
Memfd 4 KiB    : FALLOCATE+Read           :     0.446 ms
Memfd 4 KiB    : FALLOCATE+Write          :     0.330 ms
Memfd 4 KiB    : FALLOCATE+Read/Write     :     0.454 ms
Memfd 4 KiB    : FALLOCATE+POPULATE_READ  :     0.379 ms
Memfd 4 KiB    : FALLOCATE+POPULATE_WRITE :     0.268 ms
Memfd 2 MiB    : Read                     :     0.030 ms
Memfd 2 MiB    : Write                    :     0.030 ms
Memfd 2 MiB    : Read/Write               :     0.030 ms
Memfd 2 MiB    : POPULATE_READ            :     0.030 ms
Memfd 2 MiB    : POPULATE_WRITE           :     0.030 ms
Memfd 2 MiB    : FALLOCATE                :     0.030 ms
Memfd 2 MiB    : FALLOCATE+Read           :     0.031 ms
Memfd 2 MiB    : FALLOCATE+Write          :     0.031 ms
Memfd 2 MiB    : FALLOCATE+Read/Write     :     0.031 ms
Memfd 2 MiB    : FALLOCATE+POPULATE_READ  :     0.030 ms
Memfd 2 MiB    : FALLOCATE+POPULATE_WRITE :     0.030 ms
tmpfs          : Read                     :     0.416 ms
tmpfs          : Write                    :     0.369 ms
tmpfs          : Read/Write               :     0.425 ms
tmpfs          : POPULATE_READ            :     0.346 ms
tmpfs          : POPULATE_WRITE           :     0.295 ms
tmpfs          : FALLOCATE                :     0.139 ms
tmpfs          : FALLOCATE+Read           :     0.447 ms
tmpfs          : FALLOCATE+Write          :     0.333 ms
tmpfs          : FALLOCATE+Read/Write     :     0.454 ms
tmpfs          : FALLOCATE+POPULATE_READ  :     0.380 ms
tmpfs          : FALLOCATE+POPULATE_WRITE :     0.272 ms
file           : Read                     :     0.191 ms
file           : Write                    :     0.511 ms
file           : Read/Write               :     0.524 ms
file           : POPULATE_READ            :     0.196 ms
file           : POPULATE_WRITE           :     0.434 ms
file           : FALLOCATE                :     0.004 ms
file           : FALLOCATE+Read           :     0.197 ms
file           : FALLOCATE+Write          :     0.554 ms
file           : FALLOCATE+Read/Write     :     0.480 ms
file           : FALLOCATE+POPULATE_READ  :     0.201 ms
file           : FALLOCATE+POPULATE_WRITE :     0.381 ms
hugetlbfs      : Read                     :     0.030 ms
hugetlbfs      : Write                    :     0.030 ms
hugetlbfs      : Read/Write               :     0.030 ms
hugetlbfs      : POPULATE_READ            :     0.030 ms
hugetlbfs      : POPULATE_WRITE           :     0.030 ms
hugetlbfs      : FALLOCATE                :     0.030 ms
hugetlbfs      : FALLOCATE+Read           :     0.031 ms
hugetlbfs      : FALLOCATE+Write          :     0.031 ms
hugetlbfs      : FALLOCATE+Read/Write     :     0.030 ms
hugetlbfs      : FALLOCATE+POPULATE_READ  :     0.030 ms
hugetlbfs      : FALLOCATE+POPULATE_WRITE :     0.030 ms
**************************************************
4096 MiB MAP_SHARED:
**************************************************
Anon 4 KiB     : Read                     :  1053.090 ms
Anon 4 KiB     : Write                    :   913.642 ms
Anon 4 KiB     : Read/Write               :  1060.350 ms
Anon 4 KiB     : POPULATE_READ            :   893.691 ms
Anon 4 KiB     : POPULATE_WRITE           :   782.885 ms
Anon 2 MiB     : Read                     :   358.553 ms
Anon 2 MiB     : Write                    :   358.419 ms
Anon 2 MiB     : Read/Write               :   357.992 ms
Anon 2 MiB     : POPULATE_READ            :   357.533 ms
Anon 2 MiB     : POPULATE_WRITE           :   357.808 ms
Memfd 4 KiB    : Read                     :  1078.144 ms
Memfd 4 KiB    : Write                    :   942.036 ms
Memfd 4 KiB    : Read/Write               :  1100.391 ms
Memfd 4 KiB    : POPULATE_READ            :   925.829 ms
Memfd 4 KiB    : POPULATE_WRITE           :   804.394 ms
Memfd 4 KiB    : FALLOCATE                :   304.632 ms
Memfd 4 KiB    : FALLOCATE+Read           :  1163.359 ms
Memfd 4 KiB    : FALLOCATE+Write          :   933.186 ms
Memfd 4 KiB    : FALLOCATE+Read/Write     :  1187.304 ms
Memfd 4 KiB    : FALLOCATE+POPULATE_READ  :  1013.660 ms
Memfd 4 KiB    : FALLOCATE+POPULATE_WRITE :   794.560 ms
Memfd 2 MiB    : Read                     :   358.131 ms
Memfd 2 MiB    : Write                    :   358.099 ms
Memfd 2 MiB    : Read/Write               :   358.250 ms
Memfd 2 MiB    : POPULATE_READ            :   357.563 ms
Memfd 2 MiB    : POPULATE_WRITE           :   357.334 ms
Memfd 2 MiB    : FALLOCATE                :   356.735 ms
Memfd 2 MiB    : FALLOCATE+Read           :   358.152 ms
Memfd 2 MiB    : FALLOCATE+Write          :   358.331 ms
Memfd 2 MiB    : FALLOCATE+Read/Write     :   358.018 ms
Memfd 2 MiB    : FALLOCATE+POPULATE_READ  :   357.286 ms
Memfd 2 MiB    : FALLOCATE+POPULATE_WRITE :   357.523 ms
tmpfs          : Read                     :  1087.265 ms
tmpfs          : Write                    :   950.840 ms
tmpfs          : Read/Write               :  1107.567 ms
tmpfs          : POPULATE_READ            :   922.605 ms
tmpfs          : POPULATE_WRITE           :   810.094 ms
tmpfs          : FALLOCATE                :   306.320 ms
tmpfs          : FALLOCATE+Read           :  1169.796 ms
tmpfs          : FALLOCATE+Write          :   933.730 ms
tmpfs          : FALLOCATE+Read/Write     :  1191.610 ms
tmpfs          : FALLOCATE+POPULATE_READ  :  1020.474 ms
tmpfs          : FALLOCATE+POPULATE_WRITE :   798.945 ms
file           : Read                     :   654.101 ms
file           : Write                    :  1259.142 ms
file           : Read/Write               :  1289.509 ms
file           : POPULATE_READ            :   661.642 ms
file           : POPULATE_WRITE           :  1106.816 ms
file           : FALLOCATE                :     1.864 ms
file           : FALLOCATE+Read           :   656.328 ms
file           : FALLOCATE+Write          :  1153.300 ms
file           : FALLOCATE+Read/Write     :  1180.613 ms
file           : FALLOCATE+POPULATE_READ  :   668.347 ms
file           : FALLOCATE+POPULATE_WRITE :   996.143 ms
hugetlbfs      : Read                     :   357.245 ms
hugetlbfs      : Write                    :   357.413 ms
hugetlbfs      : Read/Write               :   357.120 ms
hugetlbfs      : POPULATE_READ            :   356.321 ms
hugetlbfs      : POPULATE_WRITE           :   356.693 ms
hugetlbfs      : FALLOCATE                :   355.927 ms
hugetlbfs      : FALLOCATE+Read           :   357.074 ms
hugetlbfs      : FALLOCATE+Write          :   357.120 ms
hugetlbfs      : FALLOCATE+Read/Write     :   356.983 ms
hugetlbfs      : FALLOCATE+POPULATE_READ  :   356.413 ms
hugetlbfs      : FALLOCATE+POPULATE_WRITE :   356.266 ms
**************************************************

[1] https://lkml.org/lkml/2013/6/27/698

[akpm@linux-foundation.org: coding style fixes]
Link: https://lkml.kernel.org/r/20210419135443.12822-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Ram Pai <linuxram@us.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h     |    3 +
 arch/mips/include/uapi/asm/mman.h      |    3 +
 arch/parisc/include/uapi/asm/mman.h    |    3 +
 arch/xtensa/include/uapi/asm/mman.h    |    3 +
 include/uapi/asm-generic/mman-common.h |    3 +
 mm/gup.c                               |   58 ++++++++++++++++++++
 mm/internal.h                          |    3 +
 mm/madvise.c                           |   66 +++++++++++++++++++++++
 8 files changed, 142 insertions(+)

--- a/arch/alpha/include/uapi/asm/mman.h~mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -71,6 +71,9 @@
 #define MADV_COLD	20		/* deactivate these pages */
 #define MADV_PAGEOUT	21		/* reclaim these pages */
 
+#define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
+#define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
--- a/arch/mips/include/uapi/asm/mman.h~mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -98,6 +98,9 @@
 #define MADV_COLD	20		/* deactivate these pages */
 #define MADV_PAGEOUT	21		/* reclaim these pages */
 
+#define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
+#define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
--- a/arch/parisc/include/uapi/asm/mman.h~mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -52,6 +52,9 @@
 #define MADV_COLD	20		/* deactivate these pages */
 #define MADV_PAGEOUT	21		/* reclaim these pages */
 
+#define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
+#define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
+
 #define MADV_MERGEABLE   65		/* KSM may merge identical pages */
 #define MADV_UNMERGEABLE 66		/* KSM may not merge identical pages */
 
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -106,6 +106,9 @@
 #define MADV_COLD	20		/* deactivate these pages */
 #define MADV_PAGEOUT	21		/* reclaim these pages */
 
+#define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
+#define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
--- a/include/uapi/asm-generic/mman-common.h~mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables
+++ a/include/uapi/asm-generic/mman-common.h
@@ -72,6 +72,9 @@
 #define MADV_COLD	20		/* deactivate these pages */
 #define MADV_PAGEOUT	21		/* reclaim these pages */
 
+#define MADV_POPULATE_READ	22	/* populate (prefault) page tables readable */
+#define MADV_POPULATE_WRITE	23	/* populate (prefault) page tables writable */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
--- a/mm/gup.c~mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables
+++ a/mm/gup.c
@@ -1501,6 +1501,64 @@ long populate_vma_page_range(struct vm_a
 }
 
 /*
+ * faultin_vma_page_range() - populate (prefault) page tables inside the
+ *			      given VMA range readable/writable
+ *
+ * This takes care of mlocking the pages, too, if VM_LOCKED is set.
+ *
+ * @vma: target vma
+ * @start: start address
+ * @end: end address
+ * @write: whether to prefault readable or writable
+ * @locked: whether the mmap_lock is still held
+ *
+ * Returns either number of processed pages in the vma, or a negative error
+ * code on error (see __get_user_pages()).
+ *
+ * vma->vm_mm->mmap_lock must be held. The range must be page-aligned and
+ * covered by the VMA.
+ *
+ * If @locked is NULL, it may be held for read or write and will be unperturbed.
+ *
+ * If @locked is non-NULL, it must held for read only and may be released.  If
+ * it's released, *@locked will be set to 0.
+ */
+long faultin_vma_page_range(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end, bool write, int *locked)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long nr_pages = (end - start) / PAGE_SIZE;
+	int gup_flags;
+
+	VM_BUG_ON(!PAGE_ALIGNED(start));
+	VM_BUG_ON(!PAGE_ALIGNED(end));
+	VM_BUG_ON_VMA(start < vma->vm_start, vma);
+	VM_BUG_ON_VMA(end > vma->vm_end, vma);
+	mmap_assert_locked(mm);
+
+	/*
+	 * FOLL_TOUCH: Mark page accessed and thereby young; will also mark
+	 *	       the page dirty with FOLL_WRITE -- which doesn't make a
+	 *	       difference with !FOLL_FORCE, because the page is writable
+	 *	       in the page table.
+	 * FOLL_HWPOISON: Return -EHWPOISON instead of -EFAULT when we hit
+	 *		  a poisoned page.
+	 * FOLL_POPULATE: Always populate memory with VM_LOCKONFAULT.
+	 * !FOLL_FORCE: Require proper access permissions.
+	 */
+	gup_flags = FOLL_TOUCH | FOLL_POPULATE | FOLL_MLOCK | FOLL_HWPOISON;
+	if (write)
+		gup_flags |= FOLL_WRITE;
+
+	/*
+	 * See check_vma_flags(): Will return -EFAULT on incompatible mappings
+	 * or with insufficient permissions.
+	 */
+	return __get_user_pages(mm, start, nr_pages, gup_flags,
+				NULL, NULL, locked);
+}
+
+/*
  * __mm_populate - populate and/or mlock pages within a range of address space.
  *
  * This is used to implement mlock() and the MAP_POPULATE / MAP_LOCKED mmap
--- a/mm/internal.h~mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables
+++ a/mm/internal.h
@@ -345,6 +345,9 @@ void __vma_unlink_list(struct mm_struct
 #ifdef CONFIG_MMU
 extern long populate_vma_page_range(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, int *locked);
+extern long faultin_vma_page_range(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end,
+				   bool write, int *locked);
 extern void munlock_vma_pages_range(struct vm_area_struct *vma,
 			unsigned long start, unsigned long end);
 static inline void munlock_vma_pages_all(struct vm_area_struct *vma)
--- a/mm/madvise.c~mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables
+++ a/mm/madvise.c
@@ -53,6 +53,8 @@ static int madvise_need_mmap_write(int b
 	case MADV_COLD:
 	case MADV_PAGEOUT:
 	case MADV_FREE:
+	case MADV_POPULATE_READ:
+	case MADV_POPULATE_WRITE:
 		return 0;
 	default:
 		/* be safe, default to 1. list exceptions explicitly */
@@ -822,6 +824,61 @@ static long madvise_dontneed_free(struct
 		return -EINVAL;
 }
 
+static long madvise_populate(struct vm_area_struct *vma,
+			     struct vm_area_struct **prev,
+			     unsigned long start, unsigned long end,
+			     int behavior)
+{
+	const bool write = behavior == MADV_POPULATE_WRITE;
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long tmp_end;
+	int locked = 1;
+	long pages;
+
+	*prev = vma;
+
+	while (start < end) {
+		/*
+		 * We might have temporarily dropped the lock. For example,
+		 * our VMA might have been split.
+		 */
+		if (!vma || start >= vma->vm_end) {
+			vma = find_vma(mm, start);
+			if (!vma || start < vma->vm_start)
+				return -ENOMEM;
+		}
+
+		tmp_end = min_t(unsigned long, end, vma->vm_end);
+		/* Populate (prefault) page tables readable/writable. */
+		pages = faultin_vma_page_range(vma, start, tmp_end, write,
+					       &locked);
+		if (!locked) {
+			mmap_read_lock(mm);
+			locked = 1;
+			*prev = NULL;
+			vma = NULL;
+		}
+		if (pages < 0) {
+			switch (pages) {
+			case -EINTR:
+				return -EINTR;
+			case -EFAULT: /* Incompatible mappings / permissions. */
+				return -EINVAL;
+			case -EHWPOISON:
+				return -EHWPOISON;
+			default:
+				pr_warn_once("%s: unhandled return value: %ld\n",
+					     __func__, pages);
+				fallthrough;
+			case -ENOMEM:
+				return -ENOMEM;
+			}
+		}
+		start += pages * PAGE_SIZE;
+	}
+	return 0;
+}
+
 /*
  * Application wants to free up the pages and associated backing store.
  * This is effectively punching a hole into the middle of a file.
@@ -935,6 +992,9 @@ madvise_vma(struct vm_area_struct *vma,
 	case MADV_FREE:
 	case MADV_DONTNEED:
 		return madvise_dontneed_free(vma, prev, start, end, behavior);
+	case MADV_POPULATE_READ:
+	case MADV_POPULATE_WRITE:
+		return madvise_populate(vma, prev, start, end, behavior);
 	default:
 		return madvise_behavior(vma, prev, start, end, behavior);
 	}
@@ -955,6 +1015,8 @@ madvise_behavior_valid(int behavior)
 	case MADV_FREE:
 	case MADV_COLD:
 	case MADV_PAGEOUT:
+	case MADV_POPULATE_READ:
+	case MADV_POPULATE_WRITE:
 #ifdef CONFIG_KSM
 	case MADV_MERGEABLE:
 	case MADV_UNMERGEABLE:
@@ -1042,6 +1104,10 @@ process_madvise_behavior_valid(int behav
  *		easily if memory pressure happens.
  *  MADV_PAGEOUT - the application is not expected to use this memory soon,
  *		page out the pages in this range immediately.
+ *  MADV_POPULATE_READ - populate (prefault) page tables readable by
+ *		triggering read faults if required
+ *  MADV_POPULATE_WRITE - populate (prefault) page tables writable by
+ *		triggering write faults if required
  *
  * return values:
  *  zero    - success
_
