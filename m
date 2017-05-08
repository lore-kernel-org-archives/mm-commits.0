From: akpm@linux-foundation.org
Subject: [patch 015/114] drivers/misc/vmw_vmci/vmci_queue_pair.c:
 fix a couple integer overflow tests
Date: Mon, 08 May 2017 15:55:14 -0700
Message-ID: <20170508225514.5J5_e3Qkt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45824 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751940AbdEHWzP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:55:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dan.carpenter@oracle.com, gregkh@linuxfoundation.org, jhansen@vmware.com, mhocko@suse.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/misc/vmw_vmci/vmci_queue_pair.c: fix a couple integer overflow tests

The "DIV_ROUND_UP(size, PAGE_SIZE)" operation can overflow if "size" is
more than ULLONG_MAX - PAGE_SIZE.

Link: http://lkml.kernel.org/r/20170322111950.GA11279@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jorgen Hansen <jhansen@vmware.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
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
