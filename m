From: akpm@linux-foundation.org
Subject: + kernel-resourcec-make-reallocate_resource-static.patch added to -mm tree
Date: Thu, 13 Feb 2014 14:46:16 -0800
Message-ID: <52fd4b38.FPW9The2mDwIrT/b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36901 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbaBMWqR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Feb 2014 17:46:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, daeseok.youn@gmail.com

Subject: + kernel-resourcec-make-reallocate_resource-static.patch added to -mm tree
To: daeseok.youn@gmail.com,rientjes@google.com
From: akpm@linux-foundation.org
Date: Thu, 13 Feb 2014 14:46:16 -0800


The patch titled
     Subject: kernel/resource.c: make reallocate_resource() static
has been added to the -mm tree.  Its filename is
     kernel-resourcec-make-reallocate_resource-static.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-resourcec-make-reallocate_resource-static.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-resourcec-make-reallocate_resource-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: kernel/resource.c: make reallocate_resource() static

sparse says:

kernel/resource.c:518:5: warning:
 symbol 'reallocate_resource' was not declared. Should it be static?

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/resource.c~kernel-resourcec-make-reallocate_resource-static kernel/resource.c
--- a/kernel/resource.c~kernel-resourcec-make-reallocate_resource-static
+++ a/kernel/resource.c
@@ -515,7 +515,7 @@ static int find_resource(struct resource
  * @newsize: new size of the resource descriptor
  * @constraint: the size and alignment constraints to be met.
  */
-int reallocate_resource(struct resource *root, struct resource *old,
+static int reallocate_resource(struct resource *root, struct resource *old,
 			resource_size_t newsize,
 			struct resource_constraint  *constraint)
 {
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

kernel-resourcec-make-reallocate_resource-static.patch
linux-next.patch

