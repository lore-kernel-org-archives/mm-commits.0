From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
 added to -mm tree
Date: Tue, 10 Jun 2014 15:42:01 -0700
Message-ID: <539789b9.DL3+7cjQ5U8rIrYH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbaFJWmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 18:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, toshi.kani@hp.com, fabf@skynet.be

Subject: + mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch added to -mm tree
To: fabf@skynet.be,toshi.kani@hp.com
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 15:42:01 -0700


The patch titled
     Subject: mm/memory_hotplug.c: add __meminit to grow_zone_span/grow_pgdat_span
has been added to the -mm tree.  Its filename is
     mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: mm/memory_hotplug.c: add __meminit to grow_zone_span/grow_pgdat_span

grow_zone_span and grow_pgdat_span are only called by
__meminit __add_zone

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span
+++ a/mm/memory_hotplug.c
@@ -284,8 +284,8 @@ void register_page_bootmem_info_node(str
 }
 #endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
 
-static void grow_zone_span(struct zone *zone, unsigned long start_pfn,
-			   unsigned long end_pfn)
+static void __meminit grow_zone_span(struct zone *zone, unsigned long start_pfn,
+				     unsigned long end_pfn)
 {
 	unsigned long old_zone_end_pfn;
 
@@ -427,8 +427,8 @@ out_fail:
 	return -1;
 }
 
-static void grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
-			    unsigned long end_pfn)
+static void __meminit grow_pgdat_span(struct pglist_data *pgdat, unsigned long start_pfn,
+				      unsigned long end_pfn)
 {
 	unsigned long old_pgdat_end_pfn = pgdat_end_pfn(pgdat);
 
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
mm-memory_hotplugc-add-__meminit-to-grow_zone_span-grow_pgdat_span.patch
fs-isofs-logging-clean-up.patch
linux-next.patch
init-mainc-code-clean-up.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch
kernel-watchdogc-convert-printk-pr_warning-to-pr_foo.patch

