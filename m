From: akpm@linux-foundation.org
Subject: - apci-dump-slit.patch removed from -mm tree
Date: Wed, 17 Sep 2008 14:11:54 -0700
Message-ID: <200809172111.m8HLBtKx030615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752979AbYIQVMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Sep 2008 17:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel@gmail.com, lenb@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     acpi: dump slit
has been removed from the -mm tree.  Its filename was
     apci-dump-slit.patch

This patch was dropped because it keeps changing and has no changelog

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: dump slit
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

linux-next.patch
apci-dump-slit.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
dyn_array-use-%pf-instead-of-print_fn_descriptor_symbol.patch
net-forcedeth-call-restore-mac-addr-in-nv_shutdown-path-v2.patch

