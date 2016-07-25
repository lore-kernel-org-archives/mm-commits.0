From: akpm@linux-foundation.org
Subject: + kexec-add-resriction-on-the-kexec_load-update.patch added to
 -mm tree
Date: Mon, 25 Jul 2016 13:27:00 -0700
Message-ID: <57967614.RI1/Ym2P6dyuNJ3c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45558 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbcGYU1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Jul 2016 16:27:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zhongjiang@huawei.com, dyoung@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: fix the add restriction on the kexec_load
has been added to the -mm tree.  Its filename is
     kexec-add-resriction-on-the-kexec_load-update.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-add-resriction-on-the-kexec_load-update.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-add-resriction-on-the-kexec_load-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhong jiang <zhongjiang@huawei.com>
Subject: kexec: fix the add restriction on the kexec_load

Because segments size is in bytes, while totalram_pages is in pages
so we should fix it.

Link: http://lkml.kernel.org/r/579353BE.9010600@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/kexec_core.c~kexec-add-resriction-on-the-kexec_load-update kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-add-resriction-on-the-kexec_load-update
+++ a/kernel/kexec_core.c
@@ -221,13 +221,13 @@ int sanity_check_segment_list(struct kim
 	 * allocating pages, which can cause a soft lockup.
 	 */
 	for (i = 0; i < nr_segments; i++) {
-		if (image->segment[i].memsz > (totalram_pages / 2))
+		if (image->segment[i].memsz > (totalram_pages << 12) / 2)
 			return -EINVAL;
 
 		total_segments += image->segment[i].memsz;
 	}
 
-	if (total_segments > (totalram_pages / 2))
+	if (total_segments > (totalram_pages << 12) / 2)
 		return -EINVAL;
 
 	/*
_

Patches currently in -mm which might be from zhongjiang@huawei.com are

mm-hugetlb-fix-race-when-migrate-pages.patch
mm-update-the-comment-in-__isolate_free_page.patch
mm-page_owner-align-with-pageblock_nr-pages.patch
kexec-add-resriction-on-the-kexec_load.patch
kexec-add-resriction-on-the-kexec_load-update.patch

