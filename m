From: akpm@linux-foundation.org
Subject: + mm-hmm-remove-redundant-variable-align_end.patch added to -mm
 tree
Date: Thu, 02 Nov 2017 14:53:31 -0700
Message-ID: <59fb93db.yXR8Ug91PdKf/YzB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40974 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932201AbdKBVxc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 2 Nov 2017 17:53:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: colin.king@canonical.com, jglisse@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hmm: remove redundant variable align_end
has been added to the -mm tree.  Its filename is
     mm-hmm-remove-redundant-variable-align_end.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hmm-remove-redundant-variable-align_end.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hmm-remove-redundant-variable-align_end.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-rmap-remove-redundant-variable-cend.patch
zram-make-function-zram_page_end_io-static.patch
mm-hmm-remove-redundant-variable-align_end.patch
fat-remove-redundant-assignment-of-0-to-slots.patch

