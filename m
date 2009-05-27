From: akpm@linux-foundation.org
Subject: + documentation-accounting-getdelaysc-intialize-the-variable-before-using-it.patch added to -mm tree
Date: Tue, 26 May 2009 23:54:48 -0700
Message-ID: <200905270654.n4R6smks023767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51732 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757659AbZE0Gz4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 02:55:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jaswinder@kernel.org, balbir@in.ibm.com, jaswinderrajput@gmail.com


The patch titled
     Documentation/accounting/getdelays.c intialize the variable before using it
has been added to the -mm tree.  Its filename is
     documentation-accounting-getdelaysc-intialize-the-variable-before-using-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Documentation/accounting/getdelays.c intialize the variable before using it
From: Jaswinder Singh Rajput <jaswinder@kernel.org>

Fix compilation warning:

Documentation/accounting/getdelays.c: In function `main':
Documentation/accounting/getdelays.c:249: warning: `cmd_type' may be used uninitialized in this function

This is in fact a false positive.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Balbir Singh <balbir@in.ibm.com>
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

linux-next.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
documentation-accounting-getdelaysc-intialize-the-variable-before-using-it.patch
sysctlc-remove-unused-variable.patch

