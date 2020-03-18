From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch added to -mm
 tree
Date: Tue, 17 Mar 2020 21:08:17 -0700
Message-ID: <20200318040817.c4iK5GCcn%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726478AbgCREIS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 18 Mar 2020 00:08:18 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: hv_balloon-dont-check-for-memhp_auto_online-manually-fix
has been added to the -mm tree.  Its filename is
     hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch

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
Subject: hv_balloon-dont-check-for-memhp_auto_online-manually-fix

needs changelog ;)

Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hv/hv_balloon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/hv_balloon.c~hv_balloon-dont-check-for-memhp_auto_online-manually-fix
+++ a/drivers/hv/hv_balloon.c
@@ -1700,8 +1700,8 @@ static int balloon_probe(struct hv_devic
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 	set_online_page_callback(&hv_online_page);
-	register_memory_notifier(&hv_memory_nb);
 	init_completion(&dm_device.ol_waitevent);
+	register_memory_notifier(&hv_memory_nb);
 #endif
 
 	hv_set_drvdata(dev, &dm_device);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-fix-null-pointer-dereference-in-__mem_cgroup_usage_unregister_event-fix.patch
mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch
mm.patch
mm-gup-track-foll_pin-pages-fix-2-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
