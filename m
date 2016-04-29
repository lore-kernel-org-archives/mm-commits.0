From: akpm@linux-foundation.org
Subject: [merged]
 kexec-export-offsetpagecompound_head-to-find-out-compound-tail-page.patch
 removed from -mm tree
Date: Fri, 29 Apr 2016 15:05:12 -0700
Message-ID: <5723da98./9/R85LZ+bdfGitQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45383 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018AbcD2WFN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ats-kumagai@wm.jp.nec.com, dyoung@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: export OFFSET(page.compound_head) to find out compound tail page
has been removed from the -mm tree.  Its filename was
     kexec-export-offsetpagecompound_head-to-find-out-compound-tail-page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Atsushi Kumagai <ats-kumagai@wm.jp.nec.com>
Subject: kexec: export OFFSET(page.compound_head) to find out compound tail page

PageAnon() always look at head page to check PAGE_MAPPING_ANON and tail
page's page->mapping has just a poisoned data since 1c290f642101e6 ("mm:
sanitize page->mapping for tail pages").

If makedumpfile checks page->mapping of a compound tail page to
distinguish anonymous page as usual, it must fail in newer kernel.  So
it's necessary to export OFFSET(page.compound_head) to avoid checking
compound tail pages.

The problem is that unnecessary hugepages won't be removed from a dump
file in kernels 4.5.x and later.  This means that extra disk space would
be consumed.  It's a problem, but not critical.

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


