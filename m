From: akpm@linux-foundation.org
Subject: + vmtxt-document-min_free_pages-as-critical-for-correctness.patch added to -mm tree
Date: Fri, 05 Oct 2007 16:28:07 -0700
Message-ID: <200710052328.l95NS7iu030489@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45058 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763962AbXJEX2N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 19:28:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, pavel@suse.cz


The patch titled
     vm.txt: document min_free_pages as critical for correctness
has been added to the -mm tree.  Its filename is
     vmtxt-document-min_free_pages-as-critical-for-correctness.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: vm.txt: document min_free_pages as critical for correctness
From: Pavel Machek <pavel@ucw.cz>

min_free_pages is critical for correctness, document it as such.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Documentation/sysctl/vm.txt~vmtxt-document-min_free_pages-as-critical-for-correctness Documentation/sysctl/vm.txt
--- a/Documentation/sysctl/vm.txt~vmtxt-document-min_free_pages-as-critical-for-correctness
+++ a/Documentation/sysctl/vm.txt
@@ -112,6 +112,12 @@ of kilobytes free.  The VM uses this num
 value for each lowmem zone in the system.  Each lowmem zone gets 
 a number of reserved free pages based proportionally on its size.
 
+Some minimal ammount of memory is needed to satisfy PF_MEMALLOC
+allocations; if you set this to lower than 1024KB, your system will
+become subtly broken, and prone to deadlock under high loads.
+
+Setting this too high will OOM your machine instantly.
+
 ==============================================================
 
 percpu_pagelist_fraction
_

Patches currently in -mm which might be from pavel@ucw.cz are

hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch
acpi-clean-up-acpi_enter_sleep_state_prep.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
make-kernel-power-maincsuspend_enter-static.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
s2ram-kill-old-debugging-junk.patch
hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
hibernation-check-if-acpi-is-enabled-during-restore-in-the-right-place.patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-fix.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
kdump-documentation-cleanups.patch
vmtxt-document-min_free_pages-as-critical-for-correctness.patch
