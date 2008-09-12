From: akpm@linux-foundation.org
Subject: + apci-dump-slit.patch added to -mm tree
Date: Fri, 12 Sep 2008 13:29:58 -0700
Message-ID: <200809122029.m8CKTwSR002496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58370 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720AbYILUaw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Sep 2008 16:30:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yhlu.kernel@gmail.com, lenb@kernel.org, mingo@elte.hu


The patch titled
     apci: dump slit
has been added to the -mm tree.  Its filename is
     apci-dump-slit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: apci: dump slit
From: Yinghai Lu <yhlu.kernel@gmail.com>

(akpm: apparently this has something to do with BIOS bugs)

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/numa.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/acpi/numa.c~apci-dump-slit drivers/acpi/numa.c
--- a/drivers/acpi/numa.c~apci-dump-slit
+++ a/drivers/acpi/numa.c
@@ -150,6 +150,14 @@ static __init int slit_valid(struct acpi
 {
 	int i, j;
 	int d = slit->locality_count;
+	printk(KERN_DEBUG "ACPI: SLIT: nodes = %d\n", d);
+	for (i = 0; i < d; i++) {
+		for (j = 0; j < d; j++)  {
+			u8 val = slit->entry[d*i + j];
+			printk(" %d", val);
+		}
+		printk("\n");
+	}
 	for (i = 0; i < d; i++) {
 		for (j = 0; j < d; j++)  {
 			u8 val = slit->entry[d*i + j];
_

Patches currently in -mm which might be from yhlu.kernel@gmail.com are

origin.patch
linux-next.patch
apci-dump-slit.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
pci-fix-merging-left-out-for-bar-print-out-v2.patch
dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol.patch
dyn_array-fix-typo.patch
net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch

