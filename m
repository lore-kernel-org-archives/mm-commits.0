From: akpm@linux-foundation.org
Subject: + cxgb3-missing-cpl-handler-and-register-setting.patch added to -mm tree
Date: Tue, 10 Apr 2007 14:41:23 -0700
Message-ID: <200704102141.l3ALfNOu018205@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47009 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbXDJVld (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 17:41:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: divy@chelsio.com


The patch titled
     cxgb3: missing CPL handler and register setting
has been added to the -mm tree.  Its filename is
     cxgb3-missing-cpl-handler-and-register-setting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: cxgb3: missing CPL handler and register setting
From: Divy Le Ray <divy@chelsio.com>

Remove specific CPL handler.  Add missing CPL handler.  Add missing register
setting when the interface is brought up.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/cxgb3_main.c    |    2 ++
 drivers/net/cxgb3/cxgb3_offload.c |   14 ++------------
 drivers/net/cxgb3/regs.h          |    6 ++++++
 3 files changed, 10 insertions(+), 12 deletions(-)

diff -puN drivers/net/cxgb3/cxgb3_main.c~cxgb3-missing-cpl-handler-and-register-setting drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~cxgb3-missing-cpl-handler-and-register-setting
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -770,6 +770,8 @@ static int cxgb_up(struct adapter *adap)
 		if (err)
 			goto out;
 
+		t3_write_reg(adap, A_ULPRX_TDDP_PSZ, V_HPZ0(PAGE_SHIFT - 12));
+
 		err = setup_sge_qsets(adap);
 		if (err)
 			goto out;
diff -puN drivers/net/cxgb3/cxgb3_offload.c~cxgb3-missing-cpl-handler-and-register-setting drivers/net/cxgb3/cxgb3_offload.c
--- a/drivers/net/cxgb3/cxgb3_offload.c~cxgb3-missing-cpl-handler-and-register-setting
+++ a/drivers/net/cxgb3/cxgb3_offload.c
@@ -743,17 +743,6 @@ static int do_act_establish(struct t3cde
 	}
 }
 
-static int do_set_tcb_rpl(struct t3cdev *dev, struct sk_buff *skb)
-{
-	struct cpl_set_tcb_rpl *rpl = cplhdr(skb);
-
-	if (rpl->status != CPL_ERR_NONE)
-		printk(KERN_ERR
-		       "Unexpected SET_TCB_RPL status %u for tid %u\n",
-		       rpl->status, GET_TID(rpl));
-	return CPL_RET_BUF_DONE;
-}
-
 static int do_trace(struct t3cdev *dev, struct sk_buff *skb)
 {
 	struct cpl_trace_pkt *p = cplhdr(skb);
@@ -1215,7 +1204,8 @@ void __init cxgb3_offload_init(void)
 	t3_register_cpl_handler(CPL_CLOSE_CON_RPL, do_hwtid_rpl);
 	t3_register_cpl_handler(CPL_ABORT_REQ_RSS, do_abort_req_rss);
 	t3_register_cpl_handler(CPL_ACT_ESTABLISH, do_act_establish);
-	t3_register_cpl_handler(CPL_SET_TCB_RPL, do_set_tcb_rpl);
+	t3_register_cpl_handler(CPL_SET_TCB_RPL, do_hwtid_rpl);
+	t3_register_cpl_handler(CPL_GET_TCB_RPL, do_hwtid_rpl);
 	t3_register_cpl_handler(CPL_RDMA_TERMINATE, do_term);
 	t3_register_cpl_handler(CPL_RDMA_EC_STATUS, do_hwtid_rpl);
 	t3_register_cpl_handler(CPL_TRACE_PKT, do_trace);
diff -puN drivers/net/cxgb3/regs.h~cxgb3-missing-cpl-handler-and-register-setting drivers/net/cxgb3/regs.h
--- a/drivers/net/cxgb3/regs.h~cxgb3-missing-cpl-handler-and-register-setting
+++ a/drivers/net/cxgb3/regs.h
@@ -1234,9 +1234,15 @@
 
 #define A_ULPRX_ISCSI_TAGMASK 0x514
 
+#define S_HPZ0    0
+#define M_HPZ0    0xf
+#define V_HPZ0(x) ((x) << S_HPZ0)
+#define G_HPZ0(x) (((x) >> S_HPZ0) & M_HPZ0)
+
 #define A_ULPRX_TDDP_LLIMIT 0x51c
 
 #define A_ULPRX_TDDP_ULIMIT 0x520
+#define A_ULPRX_TDDP_PSZ 0x528
 
 #define A_ULPRX_STAG_LLIMIT 0x52c
 
_

Patches currently in -mm which might be from divy@chelsio.com are

cxgb3-avoid-deadlock-with-mac-watchdog.patch
cxgb3-mac-watchdog-update.patch
cxgb3-missing-cpl-handler-and-register-setting.patch
