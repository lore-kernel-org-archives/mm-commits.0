From: akpm@linux-foundation.org
Subject: + radix-tree-test-suite-rebuild-when-headers-change.patch added
 to -mm tree
Date: Fri, 15 Apr 2016 22:58:06 -0700
Message-ID: <5711d46e.C6CZHfE2vrPbCgR1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbcDPF6H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 16 Apr 2016 01:58:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: radix tree test suite: rebuild when headers change
has been added to the -mm tree.  Its filename is
     radix-tree-test-suite-rebuild-when-headers-change.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/radix-tree-test-suite-rebuild-when-headers-change.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/radix-tree-test-suite-rebuild-when-headers-change.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: radix tree test suite: rebuild when headers change

When we make changes to radix-tree.h in the regular kernel source
(include/linux/radix-tree.h), we really want our test code to be rebuilt.

We also include a few other headers from tools/include and probably want
to rebuild if these have been changed.

Update the makefile so that all of our objects will be rebuilt when any of
the headers we depend on are changed.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Jan Kara <jack@suse.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN tools/testing/radix-tree/Makefile~radix-tree-test-suite-rebuild-when-headers-change tools/testing/radix-tree/Makefile
--- a/tools/testing/radix-tree/Makefile~radix-tree-test-suite-rebuild-when-headers-change
+++ a/tools/testing/radix-tree/Makefile
@@ -13,7 +13,7 @@ main:	$(OFILES)
 clean:
 	$(RM) -f $(TARGETS) *.o radix-tree.c
 
-$(OFILES): *.h */*.h
+$(OFILES): *.h */*.h ../../../include/linux/radix-tree.h ../../include/linux/*.h
 
 radix-tree.c: ../../../lib/radix-tree.c
 	sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < $< > $@
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

radix-tree-test-suite-allow-testing-other-fan-out-values.patch
radix-tree-test-suite-keep-regression-test-runs-short.patch
radix-tree-test-suite-rebuild-when-headers-change.patch
radix-tree-remove-unused-looping-macros.patch
radix-tree-add-support-for-multi-order-iterating.patch
radix-tree-test-suite-multi-order-iteration-test.patch
radix-tree-rewrite-radix_tree_tag_set.patch
radix-tree-rewrite-radix_tree_tag_clear.patch
radix-tree-rewrite-radix_tree_tag_get.patch
radix-tree-test-suite-add-multi-order-tag-test.patch
radix-tree-fix-radix_tree_dump-for-multi-order-entries.patch

