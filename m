From: akpm@linux-foundation.org
Subject: + extable-skip-sorting-if-the-table-is-empty.patch added to -mm
 tree
Date: Mon, 12 Aug 2013 14:37:13 -0700
Message-ID: <52095589.ZNLRi/VeYSB6Vj4X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab3HLVhO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Aug 2013 17:37:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mingo@kernel.org, hpa@linux.intel.com, david.daney@cavium.com, bp@suse.de, u.kleine-koenig@pengutronix.de

Subject: + extable-skip-sorting-if-the-table-is-empty.patch added to -mm tree
To: u.kleine-koenig@pengutronix.de,bp@suse.de,david.daney@cavium.com,hpa@linux.intel.com,mingo@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 12 Aug 2013 14:37:13 -0700


The patch titled
     Subject: extable: skip sorting if the table is empty
has been added to the -mm tree.  Its filename is
     extable-skip-sorting-if-the-table-is-empty.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/extable-skip-sorting-if-the-table-is-empty.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/extable-skip-sorting-if-the-table-is-empty.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Subject: extable: skip sorting if the table is empty

At least on ARM no-MMU the extable is empty and so there is nothing to
sort. So add a check for the table to be empty which effectively only
changes that the misleading pr_notice is suppressed.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: David Daney <david.daney@cavium.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/extable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/extable.c~extable-skip-sorting-if-the-table-is-empty kernel/extable.c
--- a/kernel/extable.c~extable-skip-sorting-if-the-table-is-empty
+++ a/kernel/extable.c
@@ -41,7 +41,7 @@ u32 __initdata main_extable_sort_needed
 /* Sort the kernel's built-in exception table */
 void __init sort_main_extable(void)
 {
-	if (main_extable_sort_needed) {
+	if (main_extable_sort_needed && __stop___ex_table > __start___ex_table) {
 		pr_notice("Sorting __ex_table...\n");
 		sort_extable(__start___ex_table, __stop___ex_table);
 	}
_

Patches currently in -mm which might be from u.kleine-koenig@pengutronix.de are

linux-next.patch
extable-skip-sorting-if-the-table-is-empty.patch

