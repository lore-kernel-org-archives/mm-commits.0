From: akpm@linux-foundation.org
Subject: + target-fix-read_capacity_16-regression.patch added to -mm tree
Date: Mon, 07 Mar 2011 15:45:51 -0800
Message-ID: <201103072345.p27Njp6F002625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44122 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754358Ab1CGXqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2011 18:46:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nab@linux-iscsi.org, bjarvismn@gmail.com, hch@lst.de


The patch titled
     target: fix READ_CAPACITY_16 regression
has been added to the -mm tree.  Its filename is
     target-fix-read_capacity_16-regression.patch

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
Subject: target: fix READ_CAPACITY_16 regression
From: Nicholas Bellinger <nab@linux-iscsi.org>

Fix a regression for READ_CAPACITY to trigger SAI READ_CAPACITY_16 for >=
0xffffffff virtual backends.  This occured during v4.0.0-rc6 when the
backend read_capacity* handlers where moved into generic target_core_cdb.c
code, and the 'unsigned long long blocks_long' piece was dropped from
target_emulate_readcapacity().

This fix has been tested with TCM_Loop on .38-rc7 with lio-4.1 and is
working as expected with large block virtual backends:

[67826.897061] TARGET_CORE[loopback]->TPG[1]_LUN[0] - Adding READ-WRITE access for LUN in Demo Mode
[67826.897061] scsi 7:0:1:0: Direct-Access     LIO-ORG  FILEIO           4.0  PQ: 0 ANSI: 5
[67826.900933] sd 7:0:1:0: [sdd] 2621440000001 512-byte logical blocks: (1.34 PB/1.19 PiB)
[67826.901510] sd 7:0:1:0: [sdd] Write Protect is off
[67826.901684] sd 7:0:1:0: [sdd] Mode Sense: 2f 00 00 00

Reported-by: Ben Jarvis <bjarvismn@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Cc James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/target/target_core_cdb.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN drivers/target/target_core_cdb.c~target-fix-read_capacity_16-regression drivers/target/target_core_cdb.c
--- a/drivers/target/target_core_cdb.c~target-fix-read_capacity_16-regression
+++ a/drivers/target/target_core_cdb.c
@@ -667,7 +667,13 @@ target_emulate_readcapacity(struct se_cm
 {
 	struct se_device *dev = SE_DEV(cmd);
 	unsigned char *buf = cmd->t_task->t_task_buf;
-	u32 blocks = dev->transport->get_blocks(dev);
+	unsigned long long blocks_long = dev->transport->get_blocks(dev);
+	u32 blocks;
+
+	if (blocks_long >= 0x00000000ffffffff)
+		blocks = 0xffffffff;
+	else
+		blocks = (u32)blocks_long;
 
 	buf[0] = (blocks >> 24) & 0xff;
 	buf[1] = (blocks >> 16) & 0xff;
_

Patches currently in -mm which might be from nab@linux-iscsi.org are

linux-next.patch
target-fix-read_capacity_16-regression.patch

