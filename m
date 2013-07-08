From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:44 -0700
Message-ID: <51db1238.87HAfHGuW0oQqaB/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3GHTZy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: [merged] mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch removed from -mm tree
To: gang.chen@asianux.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:44 -0700


The patch titled
     Subject: mm/page_alloc.c: add additional checking and return value for the 'table->data'
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Gang <gang.chen@asianux.com>
Subject: mm/page_alloc.c: add additional checking and return value for the 'table->data'

- check the length of the procfs data before copying it into a fixed
  size array.

- when __parse_numa_zonelist_order() fails, save the error code for
  return.

- 'char*' --> 'char *' coding style fix

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data
+++ a/mm/page_alloc.c
@@ -3256,18 +3256,25 @@ int numa_zonelist_order_handler(ctl_tabl
 	static DEFINE_MUTEX(zl_order_mutex);
 
 	mutex_lock(&zl_order_mutex);
-	if (write)
-		strcpy(saved_string, (char*)table->data);
+	if (write) {
+		if (strlen((char *)table->data) >= NUMA_ZONELIST_ORDER_LEN) {
+			ret = -EINVAL;
+			goto out;
+		}
+		strcpy(saved_string, (char *)table->data);
+	}
 	ret = proc_dostring(table, write, buffer, length, ppos);
 	if (ret)
 		goto out;
 	if (write) {
 		int oldval = user_zonelist_order;
-		if (__parse_numa_zonelist_order((char*)table->data)) {
+
+		ret = __parse_numa_zonelist_order((char *)table->data);
+		if (ret) {
 			/*
 			 * bogus value.  restore saved string
 			 */
-			strncpy((char*)table->data, saved_string,
+			strncpy((char *)table->data, saved_string,
 				NUMA_ZONELIST_ORDER_LEN);
 			user_zonelist_order = oldval;
 		} else if (oldval != user_zonelist_order) {
_

Patches currently in -mm which might be from gang.chen@asianux.com are

origin.patch
linux-next.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
include-linux-interrupth-add-dummy-irq_set_irq_wake-for-generic_hardirqs.patch

