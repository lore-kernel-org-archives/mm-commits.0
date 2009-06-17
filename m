From: akpm@linux-foundation.org
Subject: [merged] documentation-accounting-getdelaysc-intialize-the-variable-before-using-it.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:38 -0700
Message-ID: <200906171837.n5HIbcVQ003632@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52714 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757170AbZFQSrS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:47:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jaswinder@kernel.org, balbir@in.ibm.com, jaswinderrajput@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Documentation/accounting/getdelays.c intialize the variable before using it
has been removed from the -mm tree.  Its filename was
     documentation-accounting-getdelaysc-intialize-the-variable-before-using-it.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/accounting/getdelays.c intialize the variable before using it
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix compilation warning:

Documentation/accounting/getdelays.c: In function `main':
Documentation/accounting/getdelays.c:249: warning: `cmd_type' may be used uninitialized in this function

This is in fact a false positive.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Acked-by: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/accounting/getdelays.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-intialize-the-variable-before-using-it Documentation/accounting/getdelays.c
--- a/Documentation/accounting/getdelays.c~documentation-accounting-getdelaysc-intialize-the-variable-before-using-it
+++ a/Documentation/accounting/getdelays.c
@@ -246,7 +246,8 @@ void print_ioacct(struct taskstats *t)
 
 int main(int argc, char *argv[])
 {
-	int c, rc, rep_len, aggr_len, len2, cmd_type;
+	int c, rc, rep_len, aggr_len, len2;
+	int cmd_type = TASKSTATS_CMD_ATTR_UNSPEC;
 	__u16 id;
 	__u32 mypid;
 
_

Patches currently in -mm which might be from jaswinder@kernel.org are

origin.patch
linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
x86-apic-io_apicc-dmar_msi_type-should-be-static.patch
ia64-msi_ia64c-dmar_msi_type-should-be-static.patch
documentation-connector-cn_testc-comment-unused-cn_test_want_notify.patch
sysctlc-remove-unused-variable.patch

