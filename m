From: akpm@linux-foundation.org
Subject: + block-replace-strnicmp-with-strncasecmp.patch added to -mm tree
Date: Thu, 18 Sep 2014 14:36:07 -0700
Message-ID: <541b5047.WsnmT1TMzOH5HHs2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755783AbaIRVgI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 17:36:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: block: replace strnicmp with strncasecmp
has been added to the -mm tree.  Its filename is
     block-replace-strnicmp-with-strncasecmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/block-replace-strnicmp-with-strncasecmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/block-replace-strnicmp-with-strncasecmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: block: replace strnicmp with strncasecmp

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics and a
slightly buggy strncasecmp.  The latter is the POSIX name, so strnicmp was
renamed to strncasecmp, and strnicmp made into a wrapper for the new
strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in the
future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/partitions/mac.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN block/partitions/mac.c~block-replace-strnicmp-with-strncasecmp block/partitions/mac.c
--- a/block/partitions/mac.c~block-replace-strnicmp-with-strncasecmp
+++ a/block/partitions/mac.c
@@ -81,7 +81,7 @@ int mac_partition(struct parsed_partitio
 			be32_to_cpu(part->start_block) * (secsize/512),
 			be32_to_cpu(part->block_count) * (secsize/512));
 
-		if (!strnicmp(part->type, "Linux_RAID", 10))
+		if (!strncasecmp(part->type, "Linux_RAID", 10))
 			state->parts[slot].flags = ADDPART_FLAG_RAID;
 #ifdef CONFIG_PPC_PMAC
 		/*
@@ -100,7 +100,7 @@ int mac_partition(struct parsed_partitio
 				goodness++;
 
 			if (strcasecmp(part->type, "Apple_UNIX_SVR2") == 0
-			    || (strnicmp(part->type, "Linux", 5) == 0
+			    || (strncasecmp(part->type, "Linux", 5) == 0
 			        && strcasecmp(part->type, "Linux_swap") != 0)) {
 				int i, l;
 
@@ -109,13 +109,13 @@ int mac_partition(struct parsed_partitio
 				if (strcmp(part->name, "/") == 0)
 					goodness++;
 				for (i = 0; i <= l - 4; ++i) {
-					if (strnicmp(part->name + i, "root",
+					if (strncasecmp(part->name + i, "root",
 						     4) == 0) {
 						goodness += 2;
 						break;
 					}
 				}
-				if (strnicmp(part->name, "swap", 4) == 0)
+				if (strncasecmp(part->name, "swap", 4) == 0)
 					goodness--;
 			}
 
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

linux-next.patch
lib-string-remove-duplicated-function.patch
lib-string-make-all-calls-to-strnicmp-into-calls-to-strncasecmp.patch
arm-replace-strnicmp-with-strncasecmp.patch
block-replace-strnicmp-with-strncasecmp.patch
netfilter-replace-strnicmp-with-strncasecmp.patch
video-fbdev-replace-strnicmp-with-strncasecmp.patch
cifs-replace-strnicmp-with-strncasecmp.patch
ocfs2-replace-strnicmp-with-strncasecmp.patch
isofs-replace-strnicmp-with-strncasecmp.patch
batman-adv-replace-strnicmp-with-strncasecmp.patch
acpi-battery-replace-strnicmp-with-strncasecmp.patch
cpufreq-replace-strnicmp-with-strncasecmp.patch
cpuidle-replace-strnicmp-with-strncasecmp.patch
scsi-replace-strnicmp-with-strncasecmp.patch
ib_srpt-replace-strnicmp-with-strncasecmp.patch
input-edt-ft5x06-replace-strnicmp-with-strncasecmp.patch
altera-stapl-replace-strnicmp-with-strncasecmp.patch
thinkpad_acpi-replace-strnicmp-with-strncasecmp.patch
pnp-replace-strnicmp-with-strncasecmp.patch
s390-cio-replace-strnicmp-with-strncasecmp.patch
staging-r8188eu-replace-strnicmp-with-strncasecmp.patch
thermal-replace-strnicmp-with-strncasecmp.patch
kdb-replace-strnicmp-with-strncasecmp.patch

