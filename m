From: akpm@linux-foundation.org
Subject: + kvm-replace-test_and_set_bit_le-in-mark_page_dirty_in_slot-with-set_bit_le.patch added to -mm tree
Date: Tue, 18 Sep 2012 16:21:53 -0700
Message-ID: <20120918232154.1DD571E0048@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:32915 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab2IRXVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 19:21:55 -0400
Received: by yenq6 with SMTP id q6so62148yen.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 16:21:54 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yoshikawa.takuya@oss.ntt.co.jp, avi@redhat.com, mtosatti@redhat.com


The patch titled
     Subject: kvm: replace test_and_set_bit_le() in mark_page_dirty_in_slot() with set_bit_le()
has been added to the -mm tree.  Its filename is
     kvm-replace-test_and_set_bit_le-in-mark_page_dirty_in_slot-with-set_bit_le.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1566,8 +1566,7 @@ void mark_page_dirty_in_slot(struct kvm 
 	if (memslot && memslot->dirty_bitmap) {
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 
-		/* TODO: introduce set_bit_le() and use it */
-		test_and_set_bit_le(rel_gfn, memslot->dirty_bitmap);
+		set_bit_le(rel_gfn, memslot->dirty_bitmap);
 	}
 }
 
_

Patches currently in -mm which might be from yoshikawa.takuya@oss.ntt.co.jp are

linux-next.patch
sfc-use-standard-__clearset_bit_le-functions.patch
drivers-net-ethernet-dec-tulip-use-standard-__set_bit_le-function.patch
bitops-introduce-generic-clearset_bit_le.patch
powerpc-bitops-introduce-clearset_bit_le.patch
kvm-replace-test_and_set_bit_le-in-mark_page_dirty_in_slot-with-set_bit_le.patch

