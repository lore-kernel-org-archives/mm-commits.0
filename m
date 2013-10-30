From: akpm@linux-foundation.org
Subject: +
 drivers-memstick-core-mspro_blockc-fix-attributes-array-allocation.patch
 added to -mm tree
Date: Wed, 30 Oct 2013 15:34:46 -0700
Message-ID: <52718986.to3TGDqy0tF4AdxJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3J3Wer (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Oct 2013 18:34:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tj@kernel.org, oakad@yahoo.com, maximlevitsky@gmail.com, mina86@mina86.com

Subject: + drivers-memstick-core-mspro_blockc-fix-attributes-array-allocation.patch added to -mm tree
To: mina86@mina86.com,maximlevitsky@gmail.com,oakad@yahoo.com,tj@kernel.org,viro@zeniv.linux.org.uk
From: akpm@linux-foundation.org
Date: Wed, 30 Oct 2013 15:34:46 -0700


The patch titled
     Subject: drivers/memstick/core/mspro_block.c: fix attributes array allocation
has been added to the -mm tree.  Its filename is
     drivers-memstick-core-mspro_blockc-fix-attributes-array-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-memstick-core-mspro_blockc-fix-attributes-array-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-memstick-core-mspro_blockc-fix-attributes-array-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: drivers/memstick/core/mspro_block.c: fix attributes array allocation

attrs field of attribute_group structure is a pointer to a pointer (as in
an array of pointers) rather than pointer to attribute struct (as in an
array of structures), so when allocating size of the pointer sholud be
used instead of the structure it is pointing to.

While at it, also change the call to use kcalloc rather than kzalloc.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alex Dubov <oakad@yahoo.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/memstick/core/mspro_block.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/memstick/core/mspro_block.c~drivers-memstick-core-mspro_blockc-fix-attributes-array-allocation drivers/memstick/core/mspro_block.c
--- a/drivers/memstick/core/mspro_block.c~drivers-memstick-core-mspro_blockc-fix-attributes-array-allocation
+++ a/drivers/memstick/core/mspro_block.c
@@ -1023,8 +1023,8 @@ static int mspro_block_read_attributes(s
 	} else
 		attr_count = attr->count;
 
-	msb->attr_group.attrs = kzalloc((attr_count + 1)
-					* sizeof(struct attribute),
+	msb->attr_group.attrs = kcalloc(attr_count + 1,
+					sizeof(*msb->attr_group.attrs),
 					GFP_KERNEL);
 	if (!msb->attr_group.attrs) {
 		rc = -ENOMEM;
_

Patches currently in -mm which might be from mina86@mina86.com are

memblock-factor-out-of-top-down-allocation.patch
memblock-introduce-bottom-up-allocation-mode.patch
x86-mm-factor-out-of-top-down-direct-mapping-setup.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up.patch
x86-acpi-crash-kdump-do-reserve_crashkernel-after-srat-is-parsed.patch
mem-hotplug-introduce-movable_node-boot-option.patch
drivers-memstick-core-mspro_blockc-fix-attributes-array-allocation.patch
linux-next.patch
debugging-keep-track-of-page-owners-fix-2.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix.patch

