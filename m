From: akpm@linux-foundation.org
Subject: + arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
 added to -mm tree
Date: Wed, 16 Apr 2014 15:08:45 -0700
Message-ID: <534eff6d.jOmr9rsRgtdMa0Yk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596AbaDPWIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Apr 2014 18:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Wed, 16 Apr 2014 15:08:45 -0700


The patch titled
     Subject: arm: convert use of typedef ctl_table to struct ctl_table
has been added to the -mm tree.  Its filename is
     arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: arm: convert use of typedef ctl_table to struct ctl_table

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/isa.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/arm/kernel/isa.c~arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table arch/arm/kernel/isa.c
--- a/arch/arm/kernel/isa.c~arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table
+++ a/arch/arm/kernel/isa.c
@@ -20,7 +20,7 @@
 
 static unsigned int isa_membase, isa_portbase, isa_portshift;
 
-static ctl_table ctl_isa_vars[4] = {
+static struct ctl_table ctl_isa_vars[4] = {
 	{
 		.procname	= "membase",
 		.data		= &isa_membase, 
@@ -44,7 +44,7 @@ static ctl_table ctl_isa_vars[4] = {
 
 static struct ctl_table_header *isa_sysctl_header;
 
-static ctl_table ctl_isa[2] = {
+static struct ctl_table ctl_isa[2] = {
 	{
 		.procname	= "isa",
 		.mode		= 0555,
@@ -52,7 +52,7 @@ static ctl_table ctl_isa[2] = {
 	}, {}
 };
 
-static ctl_table ctl_bus[2] = {
+static struct ctl_table ctl_bus[2] = {
 	{
 		.procname	= "bus",
 		.mode		= 0555,
_

Patches currently in -mm which might be from joe@perches.com are

arm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ia64-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
tile-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
cdrom-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
random-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
parport-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
scsi-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
coda-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fscache-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
lockd-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
nfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
inotify-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ntfs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
fs-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
key-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
ipc-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
sysctl-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
security-convert-use-of-typedef-ctl_table-to-struct-ctl_table.patch
mm-utilc-add-kstrimdup.patch
checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test.patch
checkpatch-reduce-false-positives-for-missing-blank-line-after-declarations-test-fix.patch
init-mainc-dont-use-pr_debug.patch
linux-next.patch

