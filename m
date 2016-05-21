From: akpm@linux-foundation.org
Subject: [patch 104/162] radix tree test suite: rebuild when headers
 change
Date: Fri, 20 May 2016 17:01:48 -0700
Message-ID: <573fa56c.rpbXqXFlZomixs1Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52918 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbcEUABt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 20:01:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, jack@suse.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, neilb@suse.de, willy@linux.intel.com

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
