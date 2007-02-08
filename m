From: akpm@linux-foundation.org
Subject: - drivers-scsi-pcmcia-nsp_csh-removal-of-old.patch removed from -mm tree
Date: Thu, 08 Feb 2007 01:48:18 -0800
Message-ID: <200702080948.l189mIkX011029@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35743 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423180AbXBHJsW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Feb 2007 04:48:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michal.k.k.piotrowski@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/scsi/pcmcia/nsp_cs.h: removal of old scsi code
has been removed from the -mm tree.  Its filename was
     drivers-scsi-pcmcia-nsp_csh-removal-of-old.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/scsi/pcmcia/nsp_cs.h: removal of old scsi code
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/pcmcia/nsp_cs.h |   66 ---------------------------------
 1 file changed, 66 deletions(-)

diff -puN drivers/scsi/pcmcia/nsp_cs.h~drivers-scsi-pcmcia-nsp_csh-removal-of-old drivers/scsi/pcmcia/nsp_cs.h
--- a/drivers/scsi/pcmcia/nsp_cs.h~drivers-scsi-pcmcia-nsp_csh-removal-of-old
+++ a/drivers/scsi/pcmcia/nsp_cs.h
@@ -290,7 +290,6 @@ typedef struct _nsp_hw_data {
 #endif
 } nsp_hw_data;
 
-
 /****************************************************************************
  *
  */
@@ -302,22 +301,13 @@ static int        nsp_cs_config (struct 
 
 /* Linux SCSI subsystem specific functions */
 static struct Scsi_Host *nsp_detect     (struct scsi_host_template *sht);
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-static        int        nsp_detect_old (struct scsi_host_template *sht);
-static        int        nsp_release_old(struct Scsi_Host *shpnt);
-#endif
 static const  char      *nsp_info       (struct Scsi_Host *shpnt);
 static        int        nsp_proc_info  (
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
 	                                 struct Scsi_Host *host,
-#endif
 					 char   *buffer,
 					 char  **start,
 					 off_t   offset,
 					 int     length,
-#if !(LINUX_VERSION_CODE > KERNEL_VERSION(2,5,73))
-					 int     hostno,
-#endif
 					 int     inout);
 static int nsp_queuecommand(struct scsi_cmnd *SCpnt,
 			    void (* done)(struct scsi_cmnd *SCpnt));
@@ -356,7 +346,6 @@ static struct Scsi_Host *nsp_detect(stru
 static int  __init nsp_cs_init(void);
 static void __exit nsp_cs_exit(void);
 
-
 /* Debug */
 #ifdef NSP_DEBUG
 static void show_command (struct scsi_cmnd *SCpnt);
@@ -401,7 +390,6 @@ enum _burst_mode {
 	BURST_MEM32 = 2,
 };
 
-
 /**************************************************************************
  * SCSI messaage
  */
@@ -413,62 +401,8 @@ enum _burst_mode {
 
 #define MSG_EXT_SDTR         0x01
 
-
-/**************************************************************************
- * Compatibility functions
- */
-
-/* for Kernel 2.4 */
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0))
-#  define scsi_register_host(template)   scsi_register_module(MODULE_SCSI_HA, template)
-#  define scsi_unregister_host(template) scsi_unregister_module(MODULE_SCSI_HA, template)
-#  define scsi_host_put(host)            scsi_unregister(host)
-
-typedef void irqreturn_t;
-#  define IRQ_NONE      /* */
-#  define IRQ_HANDLED   /* */
-#  define IRQ_RETVAL(x) /* */
-
-/* This is ad-hoc version of scsi_host_get_next() */
-static inline struct Scsi_Host *scsi_host_get_next(struct Scsi_Host *host)
-{
-	if (host == NULL) {
-		return scsi_hostlist;
-	} else {
-		return host->next;
-	}
-}
-
-/* This is ad-hoc version of scsi_host_hn_get() */
-static inline struct Scsi_Host *scsi_host_hn_get(unsigned short hostno)
-{
-	struct Scsi_Host *host;
-
-	for (host = scsi_host_get_next(NULL); host != NULL;
-	     host = scsi_host_get_next(host)) {
-		if (host->host_no == hostno) {
-			break;
-		}
-	}
-
-	return host;
-}
-
-static void cs_error(struct pcmcia_device *handle, int func, int ret)
-{
-	error_info_t err = { func, ret };
-	pcmcia_report_error(handle, &err);
-}
-
-/* scatter-gather table */
-#  define BUFFER_ADDR (SCpnt->SCp.buffer->address)
-#endif
-
-/* for Kernel 2.6 */
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0))
 /* scatter-gather table */
 #  define BUFFER_ADDR ((char *)((unsigned int)(SCpnt->SCp.buffer->page) + SCpnt->SCp.buffer->offset))
-#endif
 
 #endif  /*__nsp_cs__*/
 /* end */
_

Patches currently in -mm which might be from michal.k.k.piotrowski@gmail.com are

git-ia64.patch
git-scsi-misc.patch
touchkit-ps-2-touchscreen-driver.patch
use-zvc-for-free_pages-fix-4.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes-3.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
reiser4-configh.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
