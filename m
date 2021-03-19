Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8B4C433E9
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 16:15:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9A9E61989
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 16:15:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhCSQOx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 12:14:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230186AbhCSQOf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 12:14:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F364A6197D;
        Fri, 19 Mar 2021 16:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616170475;
        bh=5eSwQ9jfV6xDA1P8qFVlpPtNnDl6Wqa1hz2BOWVjcqI=;
        h=Date:From:To:Subject:From;
        b=jSKSp1HuaQmehLYFw1oXunHm8JpNQoNjLZ8sVMcJB/VUe01r8zU7SV7nJw1H3y0Kr
         la1xP03hJP8/sD0NEHpk8vui89XtoFD4WkBJDnXpg1ZoisfJfkbW5AOOIIwi+koAhz
         hDPTJnkK2D8g5A8oL5QuPqlreKDXqNmBoMnrkhm4=
Date:   Fri, 19 Mar 2021 09:14:34 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, osalvador@suse.de,
        songmuchun@bytedance.com, vbabka@suse.cz
Subject:  +
 mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_contig_migrate_range.patch
 added to -mm tree
Message-ID: <20210319161434.-lQNLAK_P%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,page_alloc: bail out earlier on -ENOMEM in alloc_contig_mi=
grate_range
has been added to the -mm tree.  Its filename is
     mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_contig_migrate_range.=
patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmpage_alloc-bail-out-earlier=
-on-enomem-in-alloc_contig_migrate_range.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmpage_alloc-bail-out-earlier=
-on-enomem-in-alloc_contig_migrate_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_alloc: bail out earlier on -ENOMEM in alloc_contig_migrate=
_range


alloc_contig_range lacks the ability to handle HugeTLB pages.  This can be
problematic for some users, e.g: CMA and virtio-mem, where those users
will fail the call if alloc_contig_range ever sees a HugeTLB page, even
when those pages lay in ZONE_MOVABLE and are free.  That problem can be
easily solved by replacing the page in the free hugepage pool.

In-use HugeTLB are no exception though, as those can be isolated and
migrated as any other LRU or Movable page.

This patchset aims for improving
alloc_contig_range->isolate_migratepages_block, so HugeTLB pages can be
recognized and handled.

Since we also need to start reporting errors down the chain (e.g: -ENOMEM
due to not be able to allocate a new hugetlb page),
isolate_migratepages_{range,block} interfaces need to change to start
reporting error codes instead of the pfn =3D=3D 0 vs pfn !=3D 0 scheme it is
using right now.

=46rom now on, isolate_migratepages_block will not return the next pfn to be
scanned anymore, but -EINTR, -ENOMEM or 0, so we the next pfn to be
scanned will be recorded in cc->migrate_pfn field (as it is already done
in isolate_migratepages_range()).

Below is an insight from David (thanks), where the problem can clearly be
seen:

 "Start a VM with 4G. Hotplug 1G via virtio-mem and online it to
  ZONE_MOVABLE. Allocate 512 huge pages.

  [root@localhost ~]# cat /proc/meminfo
  MemTotal:        5061512 kB
  MemFree:         3319396 kB
  MemAvailable:    3457144 kB
  ...
  HugePages_Total:     512
  HugePages_Free:      512
  HugePages_Rsvd:        0
  HugePages_Surp:        0
  Hugepagesize:       2048 kB

  The huge pages get partially allocate from ZONE_MOVABLE. Try unplugging
  1G via virtio-mem (remember, all ZONE_MOVABLE). Inside the guest:

  [  180.058992] alloc_contig_range: [1b8000, 1c0000) PFNs busy
  [  180.060531] alloc_contig_range: [1b8000, 1c0000) PFNs busy
  [  180.061972] alloc_contig_range: [1b8000, 1c0000) PFNs busy
  [  180.063413] alloc_contig_range: [1b8000, 1c0000) PFNs busy
  [  180.064838] alloc_contig_range: [1b8000, 1c0000) PFNs busy
  [  180.065848] alloc_contig_range: [1bfc00, 1c0000) PFNs busy
  [  180.066794] alloc_contig_range: [1bfc00, 1c0000) PFNs busy
  [  180.067738] alloc_contig_range: [1bfc00, 1c0000) PFNs busy
  [  180.068669] alloc_contig_range: [1bfc00, 1c0000) PFNs busy
  [  180.069598] alloc_contig_range: [1bfc00, 1c0000) PFNs busy"

And then with this patchset running:

"Same experiment with ZONE_MOVABLE:

a) Free huge pages: all memory can get unplugged again.

b) Allocated/populated but idle huge pages: all memory can get unplugged
   again.

c) Allocated/populated but all 512 huge pages are read/written in a
   loop: all memory can get unplugged again, but I get a single

[  121.192345] alloc_contig_range: [180000, 188000) PFNs busy

Most probably because it happened to try migrating a huge page while it
was busy.  As virtio-mem retries on ZONE_MOVABLE a couple of times, it can
deal with this temporary failure.

Last but not least, I did something extreme:

  # cat /proc/meminfo
  MemTotal:        5061568 kB
  MemFree:          186560 kB
  MemAvailable:     354524 kB
  ...
  HugePages_Total:    2048
  HugePages_Free:     2048
  HugePages_Rsvd:        0
  HugePages_Surp:        0

Triggering unplug would require to dissolve+alloc - which now fails when
trying to allocate an additional ~512 huge pages (1G).

As expected, I can properly see memory unplug not fully succeeding.  + I
get a fairly continuous stream of

[  226.611584] alloc_contig_range: [19f400, 19f800) PFNs busy
...

But more importantly, the hugepage count remains stable, as configured
by the admin (me):

HugePages_Total:    2048
HugePages_Free:     2048
HugePages_Rsvd:        0
HugePages_Surp:        0"


This patch (of 5):

Currently, __alloc_contig_migrate_range can generate -EINTR, -ENOMEM or
-EBUSY, and report them down the chain.  The problem is that when
migrate_pages() reports -ENOMEM, we keep going till we exhaust all the
try-attempts (5 at the moment) instead of bailing out.

migrate_pages() bails out right away on -ENOMEM because it is considered a
fatal error.  Do the same here instead of keep going and retrying.  Note
that this is not fixing a real issue, just a cosmetic change.  Although we
can save some cycles by backing off ealier

Link: https://lkml.kernel.org/r/20210319132004.4341-1-osalvador@suse.de
Link: https://lkml.kernel.org/r/20210319132004.4341-2-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_cont=
ig_migrate_range
+++ a/mm/page_alloc.c
@@ -8543,7 +8543,7 @@ static int __alloc_contig_migrate_range(
 			}
 			tries =3D 0;
 		} else if (++tries =3D=3D 5) {
-			ret =3D ret < 0 ? ret : -EBUSY;
+			ret =3D -EBUSY;
 			break;
 		}
=20
@@ -8553,6 +8553,12 @@ static int __alloc_contig_migrate_range(
=20
 		ret =3D migrate_pages(&cc->migratepages, alloc_migration_target,
 				NULL, (unsigned long)&mtc, cc->mode, MR_CONTIG_RANGE);
+		/*
+		 * On -ENOMEM, migrate_pages() bails out right away. It is pointless
+		 * to retry again over this error, so do the same here.
+		 */
+		if (ret =3D=3D -ENOMEM)
+			break;
 	}
 	if (ret < 0) {
 		alloc_contig_dump_pages(&cc->migratepages);
_

Patches currently in -mm which might be from osalvador@suse.de are

x86-vmemmap-drop-handling-of-4k-unaligned-vmemmap-range.patch
x86-vmemmap-drop-handling-of-1gb-vmemmap-ranges.patch
x86-vmemmap-handle-unpopulated-sub-pmd-ranges.patch
x86-vmemmap-optimize-for-consecutive-sections-in-partial-populated-pmds.pat=
ch
mmpage_alloc-bail-out-earlier-on-enomem-in-alloc_contig_migrate_range.patch
mmcompaction-let-isolate_migratepages_rangeblock-return-error-codes.patch
mm-make-alloc_contig_range-handle-free-hugetlb-pages.patch
mm-make-alloc_contig_range-handle-in-use-hugetlb-pages.patch
mmpage_alloc-drop-unnecessary-checks-from-pfn_range_valid_contig.patch

