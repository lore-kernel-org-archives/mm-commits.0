From: akpm@linux-foundation.org
Subject: [folded] kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch removed from -mm tree
Date: Mon, 31 Oct 2011 16:49:54 -0700
Message-ID: <201110312349.p9VNnsSl023172@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:53530 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1JaXuX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Oct 2011 19:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan@mindstab.net, drepper@akkadia.org, jmorris@namei.org, kay.sievers@vrfy.org, lennart@poettering.net, mingo@elte.hu, rdunlap@xenotime.net, mm-commits@vger.


The patch titled
     Subject: kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix
has been removed from the -mm tree.  Its filename was
     kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix.patch

This patch was dropped because it was folded into kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix

make cap_last_cap const, per Ulrich

Cc: Dan Ballard <dan@mindstab.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: James Morris <jmorris@namei.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ulrich Drepper <drepper@akkadia.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/sysctl.c~kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel-fix
+++ a/kernel/sysctl.c
@@ -134,7 +134,7 @@ static int minolduid;
 static int min_percpu_pagelist_fract = 8;
 
 static int ngroups_max = NGROUPS_MAX;
-static int cap_last_cap = CAP_LAST_CAP;
+static const int cap_last_cap = CAP_LAST_CAP;
 
 #ifdef CONFIG_INOTIFY_USER
 #include <linux/inotify.h>
@@ -743,7 +743,7 @@ static struct ctl_table kern_table[] = {
 	},
 	{
 		.procname	= "cap_last_cap",
-		.data		= &cap_last_cap,
+		.data		= (void *)&cap_last_cap,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
dma-mapping-fix-sync_single_range_-dma-debugging.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
proc-self-numa_maps-restore-huge-tag-for-hugetlb-vmas.patch
mm-add-comments-to-explain-mm_struct-fields.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization.patch
mm-neaten-warn_alloc_failed.patch
debug-pagealloc-add-support-for-highmem-pages.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-munlock-use-mapcount-to-avoid-terrible-overhead.patch
kernel-sysctlc-add-cap_last_cap-to-proc-sys-kernel.patch
drivers-leds-leds-lp5521c-check-if-reset-is-successful-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch

