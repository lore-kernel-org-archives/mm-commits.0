From: akpm@linux-foundation.org
Subject: [merged] gru-dump-chiplet-state.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:48:30 -0700
Message-ID: <200906182248.n5IMmUWH007638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755109AbZFRWtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:49:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: steiner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     gru: dump chiplet state
has been removed from the -mm tree.  Its filename was
     gru-dump-chiplet-state.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gru: dump chiplet state
From: Jack Steiner <steiner@sgi.com>

Add support for dumpping the state of an entire GRU chiplet.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/Makefile    |    2 
 drivers/misc/sgi-gru/grufile.c   |    3 
 drivers/misc/sgi-gru/grukdump.c  |  218 +++++++++++++++++++++++++++++
 drivers/misc/sgi-gru/grulib.h    |   33 ++++
 drivers/misc/sgi-gru/grutables.h |   12 +
 5 files changed, 267 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sgi-gru/Makefile~gru-dump-chiplet-state drivers/misc/sgi-gru/Makefile
--- a/drivers/misc/sgi-gru/Makefile~gru-dump-chiplet-state
+++ a/drivers/misc/sgi-gru/Makefile
@@ -3,5 +3,5 @@ ifdef CONFIG_SGI_GRU_DEBUG
 endif
 
 obj-$(CONFIG_SGI_GRU) := gru.o
-gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o gruhandles.o
+gru-y := grufile.o grumain.o grufault.o grutlbpurge.o gruprocfs.o grukservices.o gruhandles.o grukdump.o
 
diff -puN drivers/misc/sgi-gru/grufile.c~gru-dump-chiplet-state drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-dump-chiplet-state
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -255,6 +255,9 @@ static long gru_file_unlocked_ioctl(stru
 	case GRU_GET_CONFIG_INFO:
 		err = gru_get_config_info(arg);
 		break;
+	case GRU_DUMP_CHIPLET_STATE:
+		err = gru_dump_chiplet_request(arg);
+		break;
 	}
 	return err;
 }
diff -puN /dev/null drivers/misc/sgi-gru/grukdump.c
--- /dev/null
+++ a/drivers/misc/sgi-gru/grukdump.c
@@ -0,0 +1,218 @@
+/*
+ * SN Platform GRU Driver
+ *
+ *            Dump GRU State
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ */
+
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/uaccess.h>
+#include <linux/delay.h>
+#include <linux/bitops.h>
+#include <asm/uv/uv_hub.h>
+#include "gru.h"
+#include "grutables.h"
+#include "gruhandles.h"
+#include "grulib.h"
+
+#define CCH_LOCK_ATTEMPTS	10
+
+static int gru_user_copy_handle(void __user **dp, void *s)
+{
+	if (copy_to_user(dp, s, GRU_HANDLE_BYTES))
+		return -1;
+	*dp += GRU_HANDLE_BYTES;
+	return 0;
+}
+
+static int gru_dump_context_data(void *grubase,
+			struct gru_context_configuration_handle *cch,
+			void __user *ubuf, int ctxnum, int dsrcnt)
+{
+	void *cb, *cbe, *tfh, *gseg;
+	int i, scr;
+
+	gseg = grubase + ctxnum * GRU_GSEG_STRIDE;
+	cb = gseg + GRU_CB_BASE;
+	cbe = grubase + GRU_CBE_BASE;
+	tfh = grubase + GRU_TFH_BASE;
+
+	for_each_cbr_in_allocation_map(i, &cch->cbr_allocation_map, scr) {
+		if (gru_user_copy_handle(&ubuf, cb))
+			goto fail;
+		if (gru_user_copy_handle(&ubuf, tfh + i * GRU_HANDLE_STRIDE))
+			goto fail;
+		if (gru_user_copy_handle(&ubuf, cbe + i * GRU_HANDLE_STRIDE))
+			goto fail;
+		cb += GRU_HANDLE_STRIDE;
+	}
+	if (dsrcnt)
+		memcpy(ubuf, gseg + GRU_DS_BASE, dsrcnt * GRU_HANDLE_STRIDE);
+	return 0;
+
+fail:
+	return -EFAULT;
+}
+
+static int gru_dump_tfm(struct gru_state *gru,
+		void __user *ubuf, void __user *ubufend)
+{
+	struct gru_tlb_fault_map *tfm;
+	int i, ret, bytes;
+
+	bytes = GRU_NUM_TFM * GRU_CACHE_LINE_BYTES;
+	if (bytes > ubufend - ubuf)
+		ret = -EFBIG;
+
+	for (i = 0; i < GRU_NUM_TFM; i++) {
+		tfm = get_tfm(gru->gs_gru_base_vaddr, i);
+		if (gru_user_copy_handle(&ubuf, tfm))
+			goto fail;
+	}
+	return GRU_NUM_TFM * GRU_CACHE_LINE_BYTES;
+
+fail:
+	return -EFAULT;
+}
+
+static int gru_dump_tgh(struct gru_state *gru,
+		void __user *ubuf, void __user *ubufend)
+{
+	struct gru_tlb_global_handle *tgh;
+	int i, ret, bytes;
+
+	bytes = GRU_NUM_TGH * GRU_CACHE_LINE_BYTES;
+	if (bytes > ubufend - ubuf)
+		ret = -EFBIG;
+
+	for (i = 0; i < GRU_NUM_TGH; i++) {
+		tgh = get_tgh(gru->gs_gru_base_vaddr, i);
+		if (gru_user_copy_handle(&ubuf, tgh))
+			goto fail;
+	}
+	return GRU_NUM_TGH * GRU_CACHE_LINE_BYTES;
+
+fail:
+	return -EFAULT;
+}
+
+static int gru_dump_context(struct gru_state *gru, int ctxnum,
+		void __user *ubuf, void __user *ubufend, char data_opt,
+		char lock_cch)
+{
+	struct gru_dump_context_header hdr;
+	struct gru_dump_context_header __user *uhdr = ubuf;
+	struct gru_context_configuration_handle *cch;
+	struct gru_thread_state *gts;
+	int try, cch_locked, cbrcnt = 0, dsrcnt = 0, bytes = 0, ret = 0;
+	void *grubase;
+
+	memset(&hdr, 0, sizeof(hdr));
+	grubase = gru->gs_gru_base_vaddr;
+	cch = get_cch(grubase, ctxnum);
+	for (try = 0; try < CCH_LOCK_ATTEMPTS; try++) {
+		cch_locked =  trylock_cch_handle(cch);
+		if (cch_locked)
+			break;
+		msleep(1);
+	}
+
+	ubuf += sizeof(hdr);
+	if (gru_user_copy_handle(&ubuf, cch))
+		goto fail;
+	bytes = sizeof(hdr) + GRU_CACHE_LINE_BYTES;
+
+	if (cch_locked || !lock_cch) {
+		gts = gru->gs_gts[ctxnum];
+		if (gts) {
+			hdr.pid = gts->ts_tgid_owner;
+			hdr.vaddr = gts->ts_vma->vm_start;
+		}
+		if (cch->state != CCHSTATE_INACTIVE) {
+			cbrcnt = hweight64(cch->cbr_allocation_map) *
+						GRU_CBR_AU_SIZE;
+			dsrcnt = data_opt ? hweight32(cch->dsr_allocation_map) *
+						GRU_DSR_AU_CL : 0;
+		}
+		bytes += (3 * cbrcnt + dsrcnt) * GRU_CACHE_LINE_BYTES;
+		if (bytes > ubufend - ubuf)
+			ret = -EFBIG;
+		else
+			ret = gru_dump_context_data(grubase, cch, ubuf, ctxnum,
+							dsrcnt);
+
+	}
+	if (cch_locked)
+		unlock_cch_handle(cch);
+	if (ret)
+		return ret;
+
+	hdr.magic = GRU_DUMP_MAGIC;
+	hdr.ctxnum = ctxnum;
+	hdr.cbrcnt = cbrcnt;
+	hdr.dsrcnt = dsrcnt;
+	hdr.cch_locked = cch_locked;
+	if (!ret && copy_to_user((void __user *)uhdr, &hdr, sizeof(hdr)))
+		ret = -EFAULT;
+
+	return ret ? ret : bytes;
+
+fail:
+	unlock_cch_handle(cch);
+	return -EFAULT;
+}
+
+int gru_dump_chiplet_request(unsigned long arg)
+{
+	struct gru_state *gru;
+	struct gru_dump_chiplet_state_req req;
+	void __user *ubuf;
+	void __user *ubufend;
+	int ctxnum, ret, cnt = 0;
+
+	if (copy_from_user(&req, (void __user *)arg, sizeof(req)))
+		return -EFAULT;
+
+	/* Currently, only dump by gid is implemented */
+	if (req.gid >= gru_max_gids || req.gid < 0)
+		return -EINVAL;
+
+	gru = GID_TO_GRU(req.gid);
+	ubuf = req.buf;
+	ubufend = req.buf + req.buflen;
+
+	ret = gru_dump_tfm(gru, ubuf, ubufend);
+	if (ret < 0)
+		goto fail;
+	ubuf += ret;
+
+	ret = gru_dump_tgh(gru, ubuf, ubufend);
+	if (ret < 0)
+		goto fail;
+	ubuf += ret;
+
+	for (ctxnum = 0; ctxnum < GRU_NUM_CCH; ctxnum++) {
+		if (req.ctxnum == ctxnum || req.ctxnum < 0) {
+			ret = gru_dump_context(gru, ctxnum, ubuf, ubufend,
+						req.data_opt, req.lock_cch);
+			if (ret < 0)
+				goto fail;
+			ubuf += ret;
+			cnt++;
+		}
+	}
+
+	if (copy_to_user((void __user *)arg, &req, sizeof(req)))
+		return -EFAULT;
+	return cnt;
+
+fail:
+	return ret;
+}
diff -puN drivers/misc/sgi-gru/grulib.h~gru-dump-chiplet-state drivers/misc/sgi-gru/grulib.h
--- a/drivers/misc/sgi-gru/grulib.h~gru-dump-chiplet-state
+++ a/drivers/misc/sgi-gru/grulib.h
@@ -47,6 +47,9 @@
 /* For fetching GRU chiplet status */
 #define GRU_GET_CHIPLET_STATUS		_IOWR(GRU_IOCTL_NUM, 10, void *)
 
+/* For dumpping GRU chiplet state */
+#define GRU_DUMP_CHIPLET_STATE		_IOWR(GRU_IOCTL_NUM, 11, void *)
+
 /* For user TLB flushing (primarily for tests) */
 #define GRU_USER_FLUSH_TLB		_IOWR(GRU_IOCTL_NUM, 50, void *)
 
@@ -84,6 +87,36 @@ struct gru_flush_tlb_req {
 };
 
 /*
+ * Structure used to pass TLB flush parameters to the driver
+ */
+enum {dcs_pid, dcs_gid};
+struct gru_dump_chiplet_state_req {
+	unsigned int	op;
+	int		gid;
+	int		ctxnum;
+	char		data_opt;
+	char		lock_cch;
+	pid_t		pid;
+	void		*buf;
+	size_t		buflen;
+	/* ---- output --- */
+	unsigned int	num_contexts;
+};
+
+#define GRU_DUMP_MAGIC	0x3474ab6c
+struct gru_dump_context_header {
+	unsigned int	magic;
+	unsigned char	gid;
+	unsigned char	ctxnum;
+	unsigned char	cbrcnt;
+	unsigned char	dsrcnt;
+	pid_t		pid;
+	unsigned long	vaddr;
+	int		cch_locked;
+	unsigned long	data[0];
+};
+
+/*
  * GRU configuration info (temp - for testing)
  */
 struct gru_config_info {
diff -puN drivers/misc/sgi-gru/grutables.h~gru-dump-chiplet-state drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-dump-chiplet-state
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -554,6 +554,12 @@ struct gru_blade_state {
 
 /* Lock hierarchy checking enabled only in emulator */
 
+/* 0 = lock failed, 1 = locked */
+static inline int __trylock_handle(void *h)
+{
+	return !test_and_set_bit(1, h);
+}
+
 static inline void __lock_handle(void *h)
 {
 	while (test_and_set_bit(1, h))
@@ -565,6 +571,11 @@ static inline void __unlock_handle(void 
 	clear_bit(1, h);
 }
 
+static inline int trylock_cch_handle(struct gru_context_configuration_handle *cch)
+{
+	return __trylock_handle(cch);
+}
+
 static inline void lock_cch_handle(struct gru_context_configuration_handle *cch)
 {
 	__lock_handle(cch);
@@ -606,6 +617,7 @@ extern void gts_drop(struct gru_thread_s
 extern void gru_tgh_flush_init(struct gru_state *gru);
 extern int gru_kservices_init(struct gru_state *gru);
 extern void gru_kservices_exit(struct gru_state *gru);
+extern int gru_dump_chiplet_request(unsigned long arg);
 extern irqreturn_t gru_intr(int irq, void *dev_id);
 extern int gru_handle_user_call_os(unsigned long address);
 extern int gru_user_flush_tlb(unsigned long arg);
_

Patches currently in -mm which might be from steiner@sgi.com are

origin.patch

