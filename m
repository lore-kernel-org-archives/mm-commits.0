Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1F9C49EA6
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ECEE613B9
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 01:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232933AbhFYBlA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 21:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232917AbhFYBlA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 21:41:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EECB61220;
        Fri, 25 Jun 2021 01:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624585119;
        bh=fxwcqpwFNTl+xgFqPGvtlKulyFM/aLlc36bzjyNK3mc=;
        h=Date:From:To:Cc:Subject:From;
        b=zV88aU1uhcgcS749b2QjnNrUePy1GYWgRzMFPfCddl8WxM0dDYbDaxtODRRW6s6Nr
         to3o9FhOsQFluQKHUfN+0X7tXi516ncQYthh7Iys33JeP4MKF5sAzkqYeMAjdx6rjj
         3fArrTPh7GjiCbItLJTHztyc/InwPqe03ETnHVfk=
Date:   Thu, 24 Jun 2021 18:38:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: incoming
Message-Id: <20210624183838.ac3161ca4a43989665ac8b2f@linux-foundation.org>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

24 patches, based on 4a09d388f2ab382f217a764e6a152b3f614246f6.

Subsystems affected by this patch series:

  mm/thp
  nilfs2
  mm/vmalloc
  kthread
  mm/hugetlb
  mm/memory-failure
  mm/pagealloc
  MAINTAINERS
  mailmap

Subsystem: mm/thp

    Hugh Dickins <hughd@google.com>:
    Patch series "mm: page_vma_mapped_walk() cleanup and THP fixes":
      mm: page_vma_mapped_walk(): use page for pvmw->page
      mm: page_vma_mapped_walk(): settle PageHuge on entry
      mm: page_vma_mapped_walk(): use pmde for *pvmw->pmd
      mm: page_vma_mapped_walk(): prettify PVMW_MIGRATION block
      mm: page_vma_mapped_walk(): crossing page table boundary
      mm: page_vma_mapped_walk(): add a level of indentation
      mm: page_vma_mapped_walk(): use goto instead of while (1)
      mm: page_vma_mapped_walk(): get vma_address_end() earlier
      mm/thp: fix page_vma_mapped_walk() if THP mapped by ptes
      mm/thp: another PVMW_SYNC fix in page_vma_mapped_walk()

Subsystem: nilfs2

    Pavel Skripkin <paskripkin@gmail.com>:
      nilfs2: fix memory leak in nilfs_sysfs_delete_device_group

Subsystem: mm/vmalloc

    Claudio Imbrenda <imbrenda@linux.ibm.com>:
    Patch series "mm: add vmalloc_no_huge and use it", v4:
      mm/vmalloc: add vmalloc_no_huge
      KVM: s390: prepare for hugepage vmalloc

    Daniel Axtens <dja@axtens.net>:
      mm/vmalloc: unbreak kasan vmalloc support

Subsystem: kthread

    Petr Mladek <pmladek@suse.com>:
    Patch series "kthread_worker: Fix race between kthread_mod_delayed_work=
():
      kthread_worker: split code for canceling the delayed work timer
      kthread: prevent deadlock when kthread_mod_delayed_work() races with =
kthread_cancel_delayed_work_sync()

Subsystem: mm/hugetlb

    Hugh Dickins <hughd@google.com>:
      mm, futex: fix shared futex pgoff on shmem huge page

Subsystem: mm/memory-failure

    Tony Luck <tony.luck@intel.com>:
    Patch series "mm,hwpoison: fix sending SIGBUS for Action Required MCE",=
 v5:
      mm/memory-failure: use a mutex to avoid memory_failure() races

    Aili Yao <yaoaili@kingsoft.com>:
      mm,hwpoison: return -EHWPOISON to denote that the page has already be=
en poisoned

    Naoya Horiguchi <naoya.horiguchi@nec.com>:
      mm/hwpoison: do not lock page again when me_huge_page() successfully =
recovers

Subsystem: mm/pagealloc

    Rasmus Villemoes <linux@rasmusvillemoes.dk>:
      mm/page_alloc: __alloc_pages_bulk(): do bounds check before accessing=
 array

    Mel Gorman <mgorman@techsingularity.net>:
      mm/page_alloc: do bulk array bounds check after checking populated el=
ements

Subsystem: MAINTAINERS

    Marek Beh=FAn <kabel@kernel.org>:
      MAINTAINERS: fix Marek's identity again

Subsystem: mailmap

    Marek Beh=FAn <kabel@kernel.org>:
      mailmap: add Marek's other e-mail address and identity without diacri=
tics

 .mailmap                |    2=20
 MAINTAINERS             |    4=20
 arch/s390/kvm/pv.c      |    7 +
 fs/nilfs2/sysfs.c       |    1=20
 include/linux/hugetlb.h |   16 ---
 include/linux/pagemap.h |   13 +-
 include/linux/vmalloc.h |    1=20
 kernel/futex.c          |    3=20
 kernel/kthread.c        |   81 ++++++++++------
 mm/hugetlb.c            |    5 -
 mm/memory-failure.c     |   83 +++++++++++------
 mm/page_alloc.c         |    6 +
 mm/page_vma_mapped.c    |  233 +++++++++++++++++++++++++++----------------=
-----
 mm/vmalloc.c            |   41 ++++++--
 14 files changed, 297 insertions(+), 199 deletions(-)

