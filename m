From: akpm@linux-foundation.org
Subject: + bootmem-avoid-freeing-to-bootmem-after-bootmem-is-done.patch
 added to -mm tree
Date: Mon, 27 Jul 2015 16:07:15 -0700
Message-ID: <55b6b9a3.qBPH9+3nP3v9feFs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728AbbG0XHQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 27 Jul 2015 19:07:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@ezchip.com, isimatu.yasuaki@jp.fujitsu.com, mgorman@suse.de, paulmcquad@gmail.com, penberg@kernel.org, tangchen@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: bootmem: avoid freeing to bootmem after bootmem is done
has been added to the -mm tree.  Its filename is
     bootmem-avoid-freeing-to-bootmem-after-bootmem-is-done.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/bootmem-avoid-freeing-to-bootmem-after-bootmem-is-done.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/bootmem-avoid-freeing-to-bootmem-after-bootmem-is-done.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chris Metcalf <cmetcalf@ezchip.com>
Subject: bootmem: avoid freeing to bootmem after bootmem is done

Bootmem isn't popular any more, but some architectures still use it, and
freeing to bootmem after calling free_all_bootmem_core() can end up
scribbling over random memory.  Instead, make sure the kernel generates a
warning in this case by ensuring the node_bootmem_map field is non-NULL
when are freeing or marking bootmem.

An instance of this bug was just fixed in the tile architecture ("tile:
use free_bootmem_late() for initrd") and catching this case more widely
seems like a good thing.

Signed-off-by: Chris Metcalf <cmetcalf@ezchip.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Paul McQuade <paulmcquad@gmail.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/bootmem.c~bootmem-avoid-freeing-to-bootmem-after-bootmem-is-done mm/bootmem.c
--- a/mm/bootmem.c~bootmem-avoid-freeing-to-bootmem-after-bootmem-is-done
+++ a/mm/bootmem.c
@@ -236,6 +236,7 @@ static unsigned long __init free_all_boo
 	count += pages;
 	while (pages--)
 		__free_pages_bootmem(page++, cur++, 0);
+	bdata->node_bootmem_map = NULL;
 
 	bdebug("nid=%td released=%lx\n", bdata - bootmem_node_data, count);
 
@@ -294,6 +295,9 @@ static void __init __free(bootmem_data_t
 		sidx + bdata->node_min_pfn,
 		eidx + bdata->node_min_pfn);
 
+	if (WARN_ON(bdata->node_bootmem_map == NULL))
+		return;
+
 	if (bdata->hint_idx > sidx)
 		bdata->hint_idx = sidx;
 
@@ -314,6 +318,9 @@ static int __init __reserve(bootmem_data
 		eidx + bdata->node_min_pfn,
 		flags);
 
+	if (WARN_ON(bdata->node_bootmem_map == NULL))
+		return 0;
+
 	for (idx = sidx; idx < eidx; idx++)
 		if (test_and_set_bit(idx, bdata->node_bootmem_map)) {
 			if (exclusive) {
_

Patches currently in -mm which might be from cmetcalf@ezchip.com are

signal-fix-information-leak-in-copy_siginfo_from_user32.patch
smpboot-fix-memory-leak-on-error-handling.patch
smpboot-make-cleanup-to-mirror-setup.patch
smpboot-allow-to-pass-the-cpumask-on-per-cpu-thread-registration.patch
watchdog-simplify-housekeeping-affinity-with-the-appropriate-mask.patch
bootmem-avoid-freeing-to-bootmem-after-bootmem-is-done.patch
lib-bitmapc-correct-a-code-style-and-do-some-optimization.patch
lib-bitmapc-fix-a-special-string-handling-bug-in-__bitmap_parselist.patch
lib-bitmapc-bitmap_parselist-can-accept-string-with-whitespaces-on-head-or-tail.patch
linux-next.patch

