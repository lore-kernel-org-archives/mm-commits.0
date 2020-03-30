From: akpm@linux-foundation.org
Subject: + mm-mmap-add-trace-point-of-vm_unmapped_area-fix.patch
 added to -mm tree
Date: Mon, 30 Mar 2020 14:19:38 -0700
Message-ID: <20200330211938.fEX8biPQL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728453AbgC3VTj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 30 Mar 2020 17:19:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bp@suse.de, jaewon31.kim@samsung.com, mm-commits@vger.kernel.org, vbabka@suse.cz, walken@google.com, willy@infradead.org


The patch titled
     Subject: mm-mmap-add-trace-point-of-vm_unmapped_area-fix
has been added to the -mm tree.  Its filename is
     mm-mmap-add-trace-point-of-vm_unmapped_area-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmap-add-trace-point-of-vm_unmapped_area-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmap-add-trace-point-of-vm_unmapped_area-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-mmap-add-trace-point-of-vm_unmapped_area-fix

prefix address printk with 0x, per Matthew

Cc: Borislav Petkov <bp@suse.de>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michel Lespinasse <walken@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/mmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/mmap.h~mm-mmap-add-trace-point-of-vm_unmapped_area-fix
+++ a/include/trace/events/mmap.h
@@ -35,7 +35,7 @@ TRACE_EVENT(vm_unmapped_area,
 		__entry->align_offset = info->align_offset;
 	),
 
-	TP_printk("addr=%lx err=%ld total_vm=0x%lx flags=0x%lx len=0x%lx lo=0x%lx hi=0x%lx mask=0x%lx ofs=0x%lx\n",
+	TP_printk("addr=0x%lx err=%ld total_vm=0x%lx flags=0x%lx len=0x%lx lo=0x%lx hi=0x%lx mask=0x%lx ofs=0x%lx\n",
 		IS_ERR_VALUE(__entry->addr) ? 0 : __entry->addr,
 		IS_ERR_VALUE(__entry->addr) ? __entry->addr : 0,
 		__entry->total_vm, __entry->flags, __entry->length,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
mm-gup-track-foll_pin-pages-fix-2-fix.patch
mm-swap-make-page_evictable-inline-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-mmap-add-trace-point-of-vm_unmapped_area-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
