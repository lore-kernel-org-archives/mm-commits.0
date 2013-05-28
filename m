From: akpm@linux-foundation.org
Subject: +
 mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch added to -mm tree
Date: Tue, 28 May 2013 13:18:29 -0700
Message-ID: <51a51115.V2lUWMVpEi0BcdRu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab3E1US3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 16:18:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gang.chen@asianux.com

Subject: + mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch added to -mm tree
To: gang.chen@asianux.com
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 13:18:29 -0700


The patch titled
     Subject: mm/page_alloc.c: add additional checking and return value for the 'table->data'
has been added to the -mm tree.  Its filename is
     mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
kernel-audit_treec-audit_add_tree_rule-protect-rule-from-kill_rules.patch
kernel-auditfilterc-fix-leak-in-audit_add_rule-error-path.patch
posix-timers-correctly-get-dying-task-time-sample-in-posix_cpu_timer_schedule.patch
mm-page_allocc-add-additional-checking-and-return-value-for-the-table-data.patch

