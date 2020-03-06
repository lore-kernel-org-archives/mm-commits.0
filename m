From: Andrew Morton <akpm@linux-foundation.org>
Subject: incoming
Date: Thu, 5 Mar 2020 22:27:51 -0800
Message-ID: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbgCFG1w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 6 Mar 2020 01:27:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, mm-commits@vger.kernel.org

7 fixes, based on 9f65ed5fe41ce08ed1cb1f6a950f9ec694c142ad:

    Mel Gorman <mgorman@techsingularity.net>:
      mm, numa: fix bad pmd by atomically check for pmd_trans_huge when marking page tables prot_numa

    Huang Ying <ying.huang@intel.com>:
      mm: fix possible PMD dirty bit lost in set_pmd_migration_entry()

    "Kirill A. Shutemov" <kirill@shutemov.name>:
      mm: avoid data corruption on CoW fault into PFN-mapped VMA

    OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
      fat: fix uninit-memory access for partial initialized inode

    Sebastian Andrzej Siewior <bigeasy@linutronix.de>:
      mm/z3fold.c: do not include rwlock.h directly

    Vlastimil Babka <vbabka@suse.cz>:
      mm, hotplug: fix page online with DEBUG_PAGEALLOC compiled but not enabled

    Miroslav Benes <mbenes@suse.cz>:
      arch/Kconfig: update HAVE_RELIABLE_STACKTRACE description

 arch/Kconfig        |    5 +++--
 fs/fat/inode.c      |   19 +++++++------------
 include/linux/mm.h  |    4 ++++
 mm/huge_memory.c    |    3 +--
 mm/memory.c         |   35 +++++++++++++++++++++++++++--------
 mm/memory_hotplug.c |    8 +++++++-
 mm/mprotect.c       |   38 ++++++++++++++++++++++++++++++++++++--
 mm/z3fold.c         |    1 -
 8 files changed, 85 insertions(+), 28 deletions(-)
