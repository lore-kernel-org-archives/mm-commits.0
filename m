From: akpm@linux-foundation.org
Subject: [folded] kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch removed from -mm tree
Date: Thu, 26 May 2011 16:22:18 -0700
Message-ID: <201105262322.p4QNMIrc026608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755301Ab1EZXWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 May 2011 19:22:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, rakib.mullick@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix
has been removed from the -mm tree.  Its filename was
     kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix.patch

This patch was dropped because it was folded into kernel-profilec-remove-some-duplicate-code-from-profile_hits.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix
From: Andrew Morton <akpm@linux-foundation.org>

make do_profile_hits static

Cc: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/profile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/profile.c~kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix kernel/profile.c
--- a/kernel/profile.c~kernel-profilec-remove-some-duplicate-code-from-profile_hits-fix
+++ a/kernel/profile.c
@@ -303,7 +303,7 @@ static void profile_discard_flip_buffers
 	mutex_unlock(&profile_flip_mutex);
 }
 
-void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
+static void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
 	unsigned long primary, secondary, flags, pc = (unsigned long)__pc;
 	int i, j, cpu;
@@ -415,7 +415,7 @@ out_free:
 #define profile_discard_flip_buffers()	do { } while (0)
 #define profile_cpu_callback		NULL
 
-void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
+static void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
 	unsigned long pc;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-video-mb862xx-mb862xxfbdrvc-needs-uaccessh.patch
drivers-bcma-host_pcic-needs-slabh.patch
include-linux-hugetlbh-needs-mm_typesh.patch
drivers-rtc-rtc-mrstc-use-release_mem_region-after-request_mem_region.patch
drivers-rtc-rtc-mxcc-remove-defines-already-included-in-rtch.patch
ufs-truncated-values-handling-64-bit-metadata.patch
documentation-accounting-getdelaysc-handle-sendto-failures.patch
documentation-configfs-examples-crash-fix.patch
mm-move-enum-vm_event_item-into-a-standalone-header-file.patch
memcg-reclaim-memory-from-nodes-in-round-robin-order.patch
add-the-pagefault-count-into-memcg-stats.patch
fs-partitions-efic-corrupted-guid-partition-tables-can-cause-kernel-oops.patch
kernel-profilec-remove-some-duplicate-code-from-profile_hits.patch
w1-add-maxim-dallas-ds2780-stand-alone-fuel-gauge-ic-support.patch

