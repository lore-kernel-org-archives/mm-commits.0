From: akpm@linux-foundation.org
Subject: +
 kexec-export-offsetpagecompound_head-to-find-out-compound-tail-page.patch
 added to -mm tree
Date: Fri, 01 Apr 2016 13:25:11 -0700
Message-ID: <56fed927.u0BKlegKH/klHmBj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbcDAUZN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2016 16:25:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ats-kumagai@wm.jp.nec.com, dyoung@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: export OFFSET(page.compound_head) to find out compound tail page
has been added to the -mm tree.  Its filename is
     kexec-export-offsetpagecompound_head-to-find-out-compound-tail-page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kexec-export-offsetpagecompound_head-to-find-out-compound-tail-page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kexec-export-offsetpagecompound_head-to-find-out-compound-tail-page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Atsushi Kumagai <ats-kumagai@wm.jp.nec.com>
Subject: kexec: export OFFSET(page.compound_head) to find out compound tail page

PageAnon() always look at head page to check PAGE_MAPPING_ANON and tail
page's page->mapping has just a poisoned data since commit 1c290f642101e6.

If makedumpfile checks page->mapping of an compound tail page to
distinguish anonymous page as usual, it must fail in newer kernel.  So
it's necessary to export OFFSET(page.compound_head) to avoid checking
compound tail pages.

Signed-off-by: Atsushi Kumagai <ats-kumagai@wm.jp.nec.com>
Acked-by: Dave Young <dyoung@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/kexec_core.c~kexec-export-offsetpagecompound_head-to-find-out-compound-tail-page kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-export-offsetpagecompound_head-to-find-out-compound-tail-page
+++ a/kernel/kexec_core.c
@@ -1417,6 +1417,7 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(page, private);
 	VMCOREINFO_OFFSET(page, compound_dtor);
 	VMCOREINFO_OFFSET(page, compound_order);
+	VMCOREINFO_OFFSET(page, compound_head);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
 #ifdef CONFIG_FLAT_NODE_MEM_MAP
_

Patches currently in -mm which might be from ats-kumagai@wm.jp.nec.com are

kexec-update-vmcoreinfo-for-compound_order-dtor.patch
kexec-export-offsetpagecompound_head-to-find-out-compound-tail-page.patch

