From: akpm@linux-foundation.org
Subject: + drivers-base-memoryc-fix-memory_dev_init-long-delay-v2.patch added to -mm tree
Date: Mon, 30 Jan 2012 13:54:46 -0800
Message-ID: <20120130215447.0FC42A00B1@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:52355 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752028Ab2A3Vyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Jan 2012 16:54:49 -0500
Received: by eekb15 with SMTP id b15so236854eek.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Jan 2012 13:54:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, gregkh@suse.de, holt@sgi.com, kay.sievers@vrfy.org, nfont@austin.ibm.com


The patch titled
     Subject: drivers-base-memoryc-fix-memory_dev_init-long-delay-v2
has been added to the -mm tree.  Its filename is
     drivers-base-memoryc-fix-memory_dev_init-long-delay-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: drivers-base-memoryc-fix-memory_dev_init-long-delay-v2

-v2: check the sections_per_block, and update cc list

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Nathan Fontenot <nfont@austin.ibm.com>
Cc: Robin Holt <holt@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/base/memory.c~drivers-base-memoryc-fix-memory_dev_init-long-delay-v2 drivers/base/memory.c
--- a/drivers/base/memory.c~drivers-base-memoryc-fix-memory_dev_init-long-delay-v2
+++ a/drivers/base/memory.c
@@ -579,8 +579,9 @@ static int add_memory_section(int nid, s
 
 	mutex_lock(&mem_sysfs_mutex);
 
-	/* don't need to find memory block for BOOT */
-	if (context != BOOT)
+	if (context == BOOT && sections_per_block == 1) {
+		/* don't need to find memory block in this case */
+	} else
 		mem = find_memory_block(section);
 
 	if (mem) {
_
Subject: Subject: drivers-base-memoryc-fix-memory_dev_init-long-delay-v2

Patches currently in -mm which might be from yinghai@kernel.org are

linux-next.patch
drivers-base-memoryc-fix-memory_dev_init-long-delay.patch
drivers-base-memoryc-fix-memory_dev_init-long-delay-v2.patch
x86-mm-fix-the-size-calculation-of-mapping-tables.patch

