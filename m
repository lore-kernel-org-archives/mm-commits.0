From: akpm@linux-foundation.org
Subject: [merged] mm-hmm-remove-redundant-variable-align_end.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:05:12 -0800
Message-ID: <20171116200512.QyThfAtNj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47562 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936777AbdKPUFP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:05:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm: remove redundant variable align_end
has been removed from the -mm tree.  Its filename was
     mm-hmm-remove-redundant-variable-align_end.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/hmm: remove redundant variable align_end

Variable align_end is assigned a value but it is never read, so the
variable is redundant and can be removed.  Cleans up the clang warning:
Value stored to 'align_end' is never read

Link: http://lkml.kernel.org/r/20171017143837.23207-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Reviewed-by: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hmm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/hmm.c~mm-hmm-remove-redundant-variable-align_end mm/hmm.c
--- a/mm/hmm.c~mm-hmm-remove-redundant-variable-align_end
+++ a/mm/hmm.c
@@ -803,11 +803,10 @@ static RADIX_TREE(hmm_devmem_radix, GFP_
 
 static void hmm_devmem_radix_release(struct resource *resource)
 {
-	resource_size_t key, align_start, align_size, align_end;
+	resource_size_t key, align_start, align_size;
 
 	align_start = resource->start & ~(PA_SECTION_SIZE - 1);
 	align_size = ALIGN(resource_size(resource), PA_SECTION_SIZE);
-	align_end = align_start + align_size - 1;
 
 	mutex_lock(&hmm_devmem_lock);
 	for (key = resource->start;
_

Patches currently in -mm which might be from colin.king@canonical.com are

fat-remove-redundant-assignment-of-0-to-slots.patch

