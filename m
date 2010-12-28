From: akpm@linux-foundation.org
Subject: + ramoops-dont-overflow-over-non-allocated-regions.patch added to -mm tree
Date: Mon, 27 Dec 2010 16:55:03 -0800
Message-ID: <201012280055.oBS0tPNL004086@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753169Ab0L1Azf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Dec 2010 19:55:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, kyungmin.park@samsung.com, marco.stornelli@gmail.com, stable@kernel.org


The patch titled
     ramoops: don't overflow over non-allocated regions
has been added to the -mm tree.  Its filename is
     ramoops-dont-overflow-over-non-allocated-regions.patch

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
Subject: ramoops: don't overflow over non-allocated regions
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Current code mis-calculates the ramoops header size, leading to an
overflow over the next record at best, or over a non-allocated region at
worst.  Fix that calculation.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Marco Stornelli <marco.stornelli@gmail.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ramoops.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN drivers/char/ramoops.c~ramoops-dont-overflow-over-non-allocated-regions drivers/char/ramoops.c
--- a/drivers/char/ramoops.c~ramoops-dont-overflow-over-non-allocated-regions
+++ a/drivers/char/ramoops.c
@@ -29,7 +29,6 @@
 #include <linux/ramoops.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
-#define RAMOOPS_HEADER_SIZE   (5 + sizeof(struct timeval))
 
 #define RECORD_SIZE 4096
 
@@ -65,8 +64,8 @@ static void ramoops_do_dump(struct kmsg_
 			struct ramoops_context, dump);
 	unsigned long s1_start, s2_start;
 	unsigned long l1_cpy, l2_cpy;
-	int res;
-	char *buf;
+	int res, hdr_size;
+	char *buf, *buf_orig;
 	struct timeval timestamp;
 
 	/* Only dump oopses if dump_oops is set */
@@ -74,6 +73,8 @@ static void ramoops_do_dump(struct kmsg_
 		return;
 
 	buf = (char *)(cxt->virt_addr + (cxt->count * RECORD_SIZE));
+	buf_orig = buf;
+
 	memset(buf, '\0', RECORD_SIZE);
 	res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
 	buf += res;
@@ -81,8 +82,9 @@ static void ramoops_do_dump(struct kmsg_
 	res = sprintf(buf, "%lu.%lu\n", (long)timestamp.tv_sec, (long)timestamp.tv_usec);
 	buf += res;
 
-	l2_cpy = min(l2, (unsigned long)(RECORD_SIZE - RAMOOPS_HEADER_SIZE));
-	l1_cpy = min(l1, (unsigned long)(RECORD_SIZE - RAMOOPS_HEADER_SIZE) - l2_cpy);
+	hdr_size = buf - buf_orig;
+	l2_cpy = min(l2, (unsigned long)(RECORD_SIZE - hdr_size));
+	l1_cpy = min(l1, (unsigned long)(RECORD_SIZE - hdr_size) - l2_cpy);
 
 	s2_start = l2 - l2_cpy;
 	s1_start = l1 - l1_cpy;
_

Patches currently in -mm which might be from darwish.07@gmail.com are

ramoops-dont-overflow-over-non-allocated-regions.patch
ramoops-fix-types-remove-typecasts.patch

