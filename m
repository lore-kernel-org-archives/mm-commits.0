From: akpm@linux-foundation.org
Subject: [merged] kvm-replace-test_and_set_bit_le-in-mark_page_dirty_in_slot-with-set_bit_le.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:15:27 -0700
Message-ID: <20121005201527.9FE01100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:62099 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757189Ab2JEUP2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:15:28 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so235203ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:15:28 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yoshikawa.takuya@oss.ntt.co.jp, avi@redhat.com, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kvm: replace test_and_set_bit_le() in mark_page_dirty_in_slot() with set_bit_le()
has been removed from the -mm tree.  Its filename was
     kvm-replace-test_and_set_bit_le-in-mark_page_dirty_in_slot-with-set_bit_le.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: kvm: replace test_and_set_bit_le() in mark_page_dirty_in_slot() with set_bit_le()

Now that we have defined generic set_bit_le() we do not need to use
test_and_set_bit_le() for atomically setting a bit.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 virt/kvm/kvm_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN virt/kvm/kvm_main.c~kvm-replace-test_and_set_bit_le-in-mark_page_dirty_in_slot-with-set_bit_le virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~kvm-replace-test_and_set_bit_le-in-mark_page_dirty_in_slot-with-set_bit_le
+++ a/virt/kvm/kvm_main.c
@@ -1568,8 +1568,7 @@ void mark_page_dirty_in_slot(struct kvm 
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
-		/* TODO: introduce set_bit_le() and use it */
-		test_and_set_bit_le(rel_gfn, memslot->dirty_bitmap);
+		set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
 
_

Patches currently in -mm which might be from yoshikawa.takuya@oss.ntt.co.jp are

origin.patch

