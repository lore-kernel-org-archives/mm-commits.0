From: akpm@linux-foundation.org
Subject: + mm-vmallocc-unbreak-__vunmap.patch added to -mm tree
Date: Mon, 10 Jun 2013 16:44:46 -0700
Message-ID: <51b664ee.P+17+m+zv+IqFZy+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab3FJXo5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jun 2013 19:44:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, dan.carpenter@oracle.com

Subject: + mm-vmallocc-unbreak-__vunmap.patch added to -mm tree
To: dan.carpenter@oracle.com,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 10 Jun 2013 16:44:46 -0700


The patch titled
     Subject: mm/vmalloc.c: unbreak __vunmap()
has been added to the -mm tree.  Its filename is
     mm-vmallocc-unbreak-__vunmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm/vmalloc.c: unbreak __vunmap()

There is an extra semi-colon so the function always returns.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-vmallocc-unbreak-__vunmap mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-unbreak-__vunmap
+++ a/mm/vmalloc.c
@@ -1453,7 +1453,7 @@ static void __vunmap(const void *addr, i
 		return;
 
 	if (WARN(!PAGE_ALIGNED(addr), "Trying to vfree() bad address (%p)\n",
-			addr));
+			addr))
 		return;
 
 	area = remove_vm_area(addr);
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

linux-next.patch
drivers-misc-sgi-gru-grufilec-fix-info-leak-in-gru_get_config_info.patch
configfs-use-capped-length-for-store_attribute.patch
drivers-cdrom-cdromc-use-kzalloc-for-failing-hardware.patch
mm-vmallocc-unbreak-__vunmap.patch
errh-is_err-can-accept-__user-pointers.patch
drivers-misc-sgi-gru-grufaultc-fix-a-sanity-test-in-gru_set_context_option.patch
rbtree-remove-unneeded-include.patch
rbtree-remove-unneeded-include-fix.patch
minix-bug-widening-a-binary-not-operation.patch
documentation-codingstyle-allow-multiple-return-statements-per-function.patch
mwave-fix-info-leak-in-mwave_ioctl.patch

