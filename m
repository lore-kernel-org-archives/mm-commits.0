From: akpm@linux-foundation.org
Subject: +
 scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch added
 to -mm tree
Date: Mon, 19 Dec 2016 14:26:27 -0800
Message-ID: <58585e93.Chz/mYQV7JM8jay9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43882 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932519AbcLSWZ2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Dec 2016 17:25:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "varible" pattern and fix typo instances
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances.patch

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
Subject: scripts/spelling.txt: add "varible" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  varible||variable

While we are here, tidy up the comment blocks that fit in a single
line for drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c and
net/sctp/transport.c.

Link: http://lkml.kernel.org/r/1481573103-11329-11-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/scsi/ChangeLog.megaraid_sas          |    2 +-
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |    4 +---
 drivers/net/wimax/i2400m/usb-fw.c                  |    2 +-
 kernel/torture.c                                   |    2 +-
 net/sctp/transport.c                               |    4 +---
 scripts/spelling.txt                               |    1 +
 6 files changed, 6 insertions(+), 9 deletions(-)

diff -puN Documentation/scsi/ChangeLog.megaraid_sas~scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances Documentation/scsi/ChangeLog.megaraid_sas
--- a/Documentation/scsi/ChangeLog.megaraid_sas~scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances
+++ a/Documentation/scsi/ChangeLog.megaraid_sas
@@ -549,7 +549,7 @@ ii.	Reduced by 1 max cmds sent to FW fro
 3 Older Version   : 00.00.03.02
 
 i.	Send stop adapter to FW & Dump pending FW cmds before declaring adapter dead.
-	New varible added to set dbg level.
+	New variable added to set dbg level.
 ii.	Disable interrupt made as fn pointer as they are different for 1068 / 1078
 iii.	Frame count optimization. Main frame can contain 2 SGE for 64 bit SGLs and
 	3 SGE for 32 bit SGL
diff -puN drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c~scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c~scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances
+++ a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -849,9 +849,7 @@ static void i40e_free_vf_res(struct i40e
 		wr32(hw, reg_idx, reg);
 		i40e_flush(hw);
 	}
-	/* reset some of the state varibles keeping
-	 * track of the resources
-	 */
+	/* reset some of the state variables keeping track of the resources */
 	vf->num_queue_pairs = 0;
 	vf->vf_states = 0;
 	clear_bit(I40E_VF_STAT_INIT, &vf->vf_states);
diff -puN drivers/net/wimax/i2400m/usb-fw.c~scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances drivers/net/wimax/i2400m/usb-fw.c
--- a/drivers/net/wimax/i2400m/usb-fw.c~scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances
+++ a/drivers/net/wimax/i2400m/usb-fw.c
@@ -237,7 +237,7 @@ void __i2400mu_bm_notif_cb(struct urb *u
  *
  * @i2400m: device descriptor
  * @urb: urb to use
- * @completion: completion varible to complete when done
+ * @completion: completion variable to complete when done
  *
  * Data is always read to i2400m->bm_ack_buf
  */
diff -puN kernel/torture.c~scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances kernel/torture.c
--- a/kernel/torture.c~scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances
+++ a/kernel/torture.c
@@ -311,7 +311,7 @@ EXPORT_SYMBOL_GPL(torture_random);
 /*
  * Variables for shuffling.  The idea is to ensure that each CPU stays
  * idle for an extended period to test interactions with dyntick idle,
- * as well as interactions with any per-CPU varibles.
+ * as well as interactions with any per-CPU variables.
  */
 struct shuffle_task {
 	struct list_head st_l;
diff -puN net/sctp/transport.c~scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances net/sctp/transport.c
--- a/net/sctp/transport.c~scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances
+++ a/net/sctp/transport.c
@@ -630,9 +630,7 @@ void sctp_transport_reset(struct sctp_tr
 	t->srtt = 0;
 	t->rttvar = 0;
 
-	/* Reset these additional varibles so that we have a clean
-	 * slate.
-	 */
+	/* Reset these additional variables so that we have a clean slate. */
 	t->partial_bytes_acked = 0;
 	t->flight_size = 0;
 	t->error_count = 0;
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-varible-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -1092,6 +1092,7 @@ vaid||valid
 vaild||valid
 valide||valid
 variantions||variations
+varible||variable
 varient||variant
 vaule||value
 verbse||verbose
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

