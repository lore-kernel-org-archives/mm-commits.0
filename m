From: akpm@linux-foundation.org
Subject: + powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch added to -mm tree
Date: Fri, 26 Jun 2009 13:41:45 -0700
Message-ID: <200906262041.n5QKfjKS000991@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48803 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbZFZUmV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 16:42:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, benh@kernel.crashing.org, galak@gate.crashing.org, gorcunov@gmail.com, waite@skycomputers.com


The patch titled
     powerpc: Sky CPU: redundant or incorrect tests on unsigned
has been added to the -mm tree.  Its filename is
     powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned.patch

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
Subject: powerpc: Sky CPU: redundant or incorrect tests on unsigned
From: Roel Kluin <roel.kluin@gmail.com>

count is unsigned and cannot be less than 0.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Brian Waite <waite@skycomputers.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hdpuftrs/hdpu_cpustate.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/misc/hdpuftrs/hdpu_cpustate.c~powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned drivers/misc/hdpuftrs/hdpu_cpustate.c
--- a/drivers/misc/hdpuftrs/hdpu_cpustate.c~powerpc-sky-cpu-redundant-or-incorrect-tests-on-unsigned
+++ a/drivers/misc/hdpuftrs/hdpu_cpustate.c
@@ -121,8 +121,6 @@ static ssize_t cpustate_read(struct file
 {
 	unsigned char data;
 
-	if (count < 0)
-		return -EFAULT;
 	if (count == 0)
 		return 0;
 
@@ -137,9 +135,6 @@ static ssize_t cpustate_write(struct fil
 {
 	unsigned char data;
 
-	if (count < 0)
-		return -EFAULT;
