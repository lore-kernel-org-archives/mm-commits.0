From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch added
 to -mm tree
Date: Mon, 19 Dec 2016 14:27:13 -0800
Message-ID: <58585ec1.nTmOn68PbzMbzY4A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43950 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbcLSW0N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:26:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "omited" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "omited" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  omited||omitted
  omiting||omitting

Link: http://lkml.kernel.org/r/1481573103-11329-26-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |    2 +-
 drivers/nfc/pn533/pn533.c                          |    2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |    2 +-
 scripts/spelling.txt                               |    2 ++
 4 files changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c~scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c~scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -1416,7 +1416,7 @@ static unsigned int xdigit2int(unsigned
  * <pattern data>[/<pattern mask>][@<anchor>]
  *
  * Up to 2 filter patterns can be specified.  If 2 are supplied the first one
- * must be anchored at 0.  An omited mask is taken as a mask of 1s, an omitted
+ * must be anchored at 0.  An omitted mask is taken as a mask of 1s, an omitted
  * anchor is taken as 0.
  */
 static ssize_t mps_trc_write(struct file *file, const char __user *buf,
diff -puN drivers/nfc/pn533/pn533.c~scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances drivers/nfc/pn533/pn533.c
--- a/drivers/nfc/pn533/pn533.c~scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances
+++ a/drivers/nfc/pn533/pn533.c
@@ -487,7 +487,7 @@ static int pn533_send_cmd_async(struct p
 /*
  * pn533_send_cmd_direct_async
  *
- * The function sends a piority cmd directly to the chip omiting the cmd
+ * The function sends a piority cmd directly to the chip omitting the cmd
  * queue. It's intended to be used by chaining mechanism of received responses
  * where the host has to request every single chunk of data before scheduling
  * next cmd from the queue.
diff -puN drivers/scsi/fcoe/fcoe_ctlr.c~scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances drivers/scsi/fcoe/fcoe_ctlr.c
--- a/drivers/scsi/fcoe/fcoe_ctlr.c~scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances
+++ a/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1387,7 +1387,7 @@ static void fcoe_ctlr_recv_clr_vlink(str
 	/*
 	 * Actually need to subtract 'sizeof(*mp) - sizeof(*wp)' from 'rlen'
 	 * before determining max Vx_Port descriptor but a buggy FCF could have
-	 * omited either or both MAC Address and Name Identifier descriptors
+	 * omitted either or both MAC Address and Name Identifier descriptors
 	 */
 	num_vlink_desc = rlen / sizeof(*vp);
 	if (num_vlink_desc)
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -711,6 +711,8 @@ occure||occurred
 occured||occurred
 occuring||occurring
 offet||offset
+omited||omitted
+omiting||omitting
 omitt||omit
 ommiting||omitting
 ommitted||omitted
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-swith-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-swithc-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-user-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-union-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-an-one-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-partiton-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-aligment-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-algined-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-efective-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-embeded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-againt-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-neded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-unneded-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-initialiazation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-comsumer-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overrided-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-applys-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-explictely-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-omited-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disassocation-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-deintialized-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwritting-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overwriten-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-therfore-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-followings-pattern-and-fix-typo-instances.patch

