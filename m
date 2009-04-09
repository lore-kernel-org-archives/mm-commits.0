From: akpm@linux-foundation.org
Subject: + gru-update-gru-kernel-self-tests.patch added to -mm tree
Date: Thu, 09 Apr 2009 15:37:44 -0700
Message-ID: <200904092237.n39MbioS032657@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759886AbZDIWjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 18:39:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: steiner@sgi.com


The patch titled
     gru: update gru kernel self tests
has been added to the -mm tree.  Its filename is
     gru-update-gru-kernel-self-tests.patch

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
Subject: gru: update gru kernel self tests
From: Jack Steiner <steiner@sgi.com>

Change the kernel self tests that can be optionally executed on GRU
initialization.  This is primarily for testing.

Eliminate the BUG statements on failure and return bad status.  Add ioctl
interface to execute the tests on demand.

Signed-off-by: Jack Steiner <steiner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c      |    3 
 drivers/misc/sgi-gru/grukservices.c |  154 +++++++++++++++++++++++---
 drivers/misc/sgi-gru/grulib.h       |    3 
 drivers/misc/sgi-gru/grutables.h    |    2 
 4 files changed, 146 insertions(+), 16 deletions(-)

diff -puN drivers/misc/sgi-gru/grufile.c~gru-update-gru-kernel-self-tests drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~gru-update-gru-kernel-self-tests
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -250,6 +250,9 @@ static long gru_file_unlocked_ioctl(stru
 	case GRU_USER_CALL_OS:
 		err = gru_handle_user_call_os(arg);
 		break;
+	case GRU_KTEST:
+		err = gru_ktest(arg);
+		break;
 	case GRU_GET_CONFIG_INFO:
 		err = gru_get_config_info(arg);
 		break;
diff -puN drivers/misc/sgi-gru/grukservices.c~gru-update-gru-kernel-self-tests drivers/misc/sgi-gru/grukservices.c
--- a/drivers/misc/sgi-gru/grukservices.c~gru-update-gru-kernel-self-tests
+++ a/drivers/misc/sgi-gru/grukservices.c
@@ -846,13 +846,14 @@ EXPORT_SYMBOL_GPL(gru_copy_gpa);
 /* ------------------- KERNEL QUICKTESTS RUN AT STARTUP ----------------*/
 /* 	Temp - will delete after we gain confidence in the GRU		*/
 
-int quicktest(void)
+static int quicktest0(unsigned long arg)
 {
 	unsigned long word0;
 	unsigned long word1;
 	void *cb;
 	void *dsr;
 	unsigned long *p;
+	int ret = -EIO;
 
 	if (gru_get_cpu_resources(GRU_CACHE_LINE_BYTES, &cb, &dsr))
 		return MQE_BUG_NO_RESOURCES;
@@ -861,26 +862,152 @@ int quicktest(void)
 	word1 = 0;
 
 	gru_vload(cb, uv_gpa(&word0), gru_get_tri(dsr), XTYPE_DW, 1, 1, IMA);
-	if (gru_wait(cb) != CBS_IDLE)
-		BUG();
+	if (gru_wait(cb) != CBS_IDLE) {
+		printk(KERN_DEBUG "GRU quicktest0: CBR failure 1\n");
+		goto done;
+	}
 
-	if (*p != MAGIC)
-		BUG();
+	if (*p != MAGIC) {
+		printk(KERN_DEBUG "GRU: quicktest0 bad magic 0x%lx\n", *p);
+		goto done;
+	}
 	gru_vstore(cb, uv_gpa(&word1), gru_get_tri(dsr), XTYPE_DW, 1, 1, IMA);
-	if (gru_wait(cb) != CBS_IDLE)
-		BUG();
-	gru_free_cpu_resources(cb, dsr);
+	if (gru_wait(cb) != CBS_IDLE) {
+		printk(KERN_DEBUG "GRU quicktest0: CBR failure 2\n");
+		goto done;
+	}
 
 	if (word0 != word1 || word1 != MAGIC) {
-		printk
-		    ("GRU quicktest err: found 0x%lx, expected 0x%lx\n",
+		printk(KERN_DEBUG
+		       "GRU quicktest0 err: found 0x%lx, expected 0x%lx\n",
 		     word1, MAGIC);
-		BUG();		/* ZZZ should not be fatal */
+		goto done;
 	}
+	ret = 0;
 
-	return 0;
+done:
+	gru_free_cpu_resources(cb, dsr);
+	return ret;
 }
 
+#define ALIGNUP(p, q)	((void *)(((unsigned long)(p) + (q) - 1) & ~(q - 1)))
+
+static int quicktest1(unsigned long arg)
+{
+	struct gru_message_queue_desc mqd;
+	void *p, *mq;
+	unsigned long *dw;
+	int i, ret = -EIO;
+	char mes[GRU_CACHE_LINE_BYTES], *m;
+
+	/* Need  1K cacheline aligned that does not cross page boundary */
+	p = kmalloc(4096, 0);
+	mq = ALIGNUP(p, 1024);
+	memset(mes, 0xee, sizeof(mes));
+	dw = mq;
+
+	gru_create_message_queue(&mqd, mq, 8 * GRU_CACHE_LINE_BYTES, 0, 0, 0);
+	for (i = 0; i < 6; i++) {
+		mes[8] = i;
+		do {
+			ret = gru_send_message_gpa(&mqd, mes, sizeof(mes));
+		} while (ret == MQE_CONGESTION);
+		if (ret)
+			break;
+	}
+	if (ret != MQE_QUEUE_FULL || i != 4)
+		goto done;
+
+	for (i = 0; i < 6; i++) {
+		m = gru_get_next_message(&mqd);
+		if (!m || m[8] != i)
+			break;
+		gru_free_message(&mqd, m);
+	}
+	ret = (i == 4) ? 0 : -EIO;
+
+done:
+	kfree(p);
+	return ret;
+}
+
+static int quicktest2(unsigned long arg)
+{
+	static struct completion cmp;
+	static int inited;
+	unsigned long han;
+	int blade_id = 0;
+	int numcb = 4;
+	int ret = 0;
+	unsigned long *buf;
+	void *cb0, *cb;
+	int i, k, istatus, bytes;
+
+	bytes = numcb * 4 * 8;
+	buf = kmalloc(bytes, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	ret = -EBUSY;
+	if (!inited)
+		init_completion(&cmp);
+	inited = 1;
+	han = gru_reserve_async_resources(blade_id, numcb, 0, &cmp);
+	if (!han)
+		goto done;
+
+	gru_lock_async_resource(han, &cb0, NULL);
+	memset(buf, 0xee, bytes);
+	for (i = 0; i < numcb; i++)
+		gru_vset(cb0 + i * GRU_HANDLE_STRIDE, uv_gpa(&buf[i * 4]), 0,
+				XTYPE_DW, 4, 1, IMA_INTERRUPT);
+
+	ret = 0;
+	for (k = 0; k < numcb; k++) {
+		gru_wait_async_cbr(han);
+		for (i = 0; i < numcb; i++) {
+			cb = cb0 + i * GRU_HANDLE_STRIDE;
+			istatus = gru_check_status(cb);
+			if (istatus == CBS_ACTIVE)
+				continue;
+			if (istatus == CBS_EXCEPTION)
+				ret = -EFAULT;
+			else if (buf[i] || buf[i + 1] || buf[i + 2] ||
+					buf[i + 3])
+				ret = -EIO;
+		}
+	}
+	BUG_ON(cmp.done);
+
+	gru_unlock_async_resource(han);
+	gru_release_async_resources(han);
+done:
+	kfree(buf);
+	return ret;
+}
+
+/*
+ * Debugging only. User hook for various kernel tests
+ * of driver & gru.
+ */
+int gru_ktest(unsigned long arg)
+{
+	int ret = -EINVAL;
+
+	switch (arg & 0xff) {
+	case 0:
+		ret = quicktest0(arg);
+		break;
+	case 1:
+		ret = quicktest1(arg);
+		break;
+	case 2:
+		ret = quicktest2(arg);
+		break;
+	}
+	return ret;
+
+}
 
 int gru_kservices_init(struct gru_state *gru)
 {
@@ -891,9 +1018,6 @@ int gru_kservices_init(struct gru_state 
 		return 0;
 
 	init_rwsem(&bs->bs_kgts_sema);
-
-	if (gru_options & GRU_QUICKLOOK)
-		quicktest();
 	return 0;
 }
 
diff -puN drivers/misc/sgi-gru/grulib.h~gru-update-gru-kernel-self-tests drivers/misc/sgi-gru/grulib.h
--- a/drivers/misc/sgi-gru/grulib.h~gru-update-gru-kernel-self-tests
+++ a/drivers/misc/sgi-gru/grulib.h
@@ -56,6 +56,9 @@
 /* Get some config options (primarily for tests & emulator) */
 #define GRU_GET_CONFIG_INFO		_IOWR(GRU_IOCTL_NUM, 51, void *)
 
+/* Various kernel self-tests */
+#define GRU_KTEST			_IOWR(GRU_IOCTL_NUM, 52, void *)
+
 #define CONTEXT_WINDOW_BYTES(th)        (GRU_GSEG_PAGESIZE * (th))
 #define THREAD_POINTER(p, th)		(p + GRU_GSEG_PAGESIZE * (th))
 
diff -puN drivers/misc/sgi-gru/grutables.h~gru-update-gru-kernel-self-tests drivers/misc/sgi-gru/grutables.h
--- a/drivers/misc/sgi-gru/grutables.h~gru-update-gru-kernel-self-tests
+++ a/drivers/misc/sgi-gru/grutables.h
@@ -258,7 +258,6 @@ extern struct mcs_op_statistic mcs_op_st
 
 #define OPT_DPRINT	1
 #define OPT_STATS	2
-#define GRU_QUICKLOOK	4
 
 
 #define IRQ_GRU			110	/* Starting IRQ number for interrupts */
@@ -662,6 +661,7 @@ extern int gru_fault(struct vm_area_stru
 extern struct gru_mm_struct *gru_register_mmu_notifier(void);
 extern void gru_drop_mmu_notifier(struct gru_mm_struct *gms);
 
+extern int gru_ktest(unsigned long arg);
 extern void gru_flush_tlb_range(struct gru_mm_struct *gms, unsigned long start,
 					unsigned long len);
 
_

Patches currently in -mm which might be from steiner@sgi.com are

gru-bug-fixes-for-gru-exception-handling.patch
gru-dump-chiplet-state.patch
gru-dynamic-allocation-of-kernel-contexts.patch
gru-change-context-load-and-unload.patch
gru-support-cch_allocate-for-kernel-threads.patch
gru-change-resource-assignment-for-kernel-threads.patch
gru-support-contexts-with-zero-dsrs-or-cbrs.patch
gru-fix-handling-of-mesq-failures.patch
gru-check-context-state-on-reload.patch
gru-support-instruction-completion-interrupts.patch
gru-support-for-asynchronous-gru-instructions.patch
gru-update-gru-kernel-self-tests.patch
gru-update-to-rev-09-of-gru-spec.patch

