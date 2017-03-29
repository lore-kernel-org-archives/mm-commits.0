From: akpm@linux-foundation.org
Subject: + vmci-fix-a-couple-integer-overflow-tests.patch added to -mm
 tree
Date: Wed, 29 Mar 2017 15:49:11 -0700
Message-ID: <58dc39e7.Aq0jF5vfknkdhevw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39376 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932607AbdC2WtN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Mar 2017 18:49:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, acking@vmware.com, gregkh@linuxfoundation.org, jhansen@vmware.com, mhocko@suse.com, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/misc/vmw_vmci/vmci_queue_pair.c: fix a couple integer overflow tests
has been added to the -mm tree.  Its filename is
     vmci-fix-a-couple-integer-overflow-tests.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmci-fix-a-couple-integer-overflow-tests.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmci-fix-a-couple-integer-overflow-tests.patch

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
Subject: drivers/misc/vmw_vmci/vmci_queue_pair.c: fix a couple integer overflow tests

The "DIV_ROUND_UP(size, PAGE_SIZE)" operation can overflow if "size" is
more than ULLONG_MAX - PAGE_SIZE.

Link: http://lkml.kernel.org/r/20170322111950.GA11279@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jorgen Hansen <jhansen@vmware.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Andy King <acking@vmware.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/vmw_vmci/vmci_queue_pair.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/misc/vmw_vmci/vmci_queue_pair.c~vmci-fix-a-couple-integer-overflow-tests drivers/misc/vmw_vmci/vmci_queue_pair.c
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c~vmci-fix-a-couple-integer-overflow-tests
+++ a/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -298,8 +298,11 @@ static void *qp_alloc_queue(u64 size, u3
 	size_t pas_size;
 	size_t vas_size;
 	size_t queue_size = sizeof(*queue) + sizeof(*queue->kernel_if);
-	const u64 num_pages = DIV_ROUND_UP(size, PAGE_SIZE) + 1;
+	u64 num_pages;
 
+	if (size > SIZE_MAX - PAGE_SIZE)
+		return NULL;
+	num_pages = DIV_ROUND_UP(size, PAGE_SIZE) + 1;
 	if (num_pages >
 		 (SIZE_MAX - queue_size) /
 		 (sizeof(*queue->kernel_if->u.g.pas) +
@@ -624,9 +627,12 @@ static struct vmci_queue *qp_host_alloc_
 {
 	struct vmci_queue *queue;
 	size_t queue_page_size;
-	const u64 num_pages = DIV_ROUND_UP(size, PAGE_SIZE) + 1;
+	u64 num_pages;
 	const size_t queue_size = sizeof(*queue) + sizeof(*(queue->kernel_if));
 
+	if (size > SIZE_MAX - PAGE_SIZE)
+		return NULL;
+	num_pages = DIV_ROUND_UP(size, PAGE_SIZE) + 1;
 	if (num_pages > (SIZE_MAX - queue_size) /
 		 sizeof(*queue->kernel_if->u.h.page))
 		return NULL;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

vmci-fix-a-couple-integer-overflow-tests.patch

