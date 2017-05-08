From: akpm@linux-foundation.org
Subject: [patch 086/114] drivers/scsi/megaraid: remove expensive
 inline from megasas_return_cmd
Date: Mon, 08 May 2017 15:58:53 -0700
Message-ID: <20170508225853.4NDgMLcml%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47328 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752908AbdEHW6y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:58:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, kashyap.desai@avagotech.com, mm-commits@vger.kernel.org, sumit.saxena@avagotech.com, torvalds@linux-foundation.org

From: Andi Kleen <ak@linux.intel.com>
Subject: drivers/scsi/megaraid: remove expensive inline from megasas_return_cmd

Remove an inline from a fairly big function that is used often.  It's
unlikely that calling or not calling it makes a lot of difference.

Saves around 8k text in my kernel.

   text    data     bss     dec     hex filename
9047801 5367568 11116544        25531913        1859609 vmlinux-before-megasas
9039417 5367568 11116544        25523529        1857549 vmlinux-megasas

Link: http://lkml.kernel.org/r/20170315021431.13107-7-andi@firstfloor.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid/megaraid_sas_base.c~megasas-remove-expensive-inline-from-megasas_return_cmd drivers/scsi/megaraid/megaraid_sas_base.c
--- a/drivers/scsi/megaraid/megaraid_sas_base.c~megasas-remove-expensive-inline-from-megasas_return_cmd
+++ a/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -244,7 +244,7 @@ struct megasas_cmd *megasas_get_cmd(stru
  * @instance:		Adapter soft state
  * @cmd:		Command packet to be returned to free command pool
  */
-inline void
+void
 megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
 	unsigned long flags;
_
