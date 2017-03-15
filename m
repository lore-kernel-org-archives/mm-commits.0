From: akpm@linux-foundation.org
Subject: + megasas-remove-expensive-inline-from-megasas_return_cmd.patch
 added to -mm tree
Date: Wed, 15 Mar 2017 14:49:23 -0700
Message-ID: <58c9b6e3.Aa8M44DxQcdvBYby%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753063AbdCOVtZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 17:49:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, James.Bottomley@HansenPartnership.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/scsi/megaraid: remove expensive inline from megasas_return_cmd
has been added to the -mm tree.  Its filename is
     megasas-remove-expensive-inline-from-megasas_return_cmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/megasas-remove-expensive-inline-from-megasas_return_cmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/megasas-remove-expensive-inline-from-megasas_return_cmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Uday Lingala <uday.lingala@avagotech.com>
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

Patches currently in -mm which might be from ak@linux.intel.com are

trace-move-trace_seq_overflowed-out-of-line.patch
sched-out-of-line-__update_load_avg.patch
kref-remove-warn_on-for-null-release-functions.patch
out-of-line-dma_alloc-free_attrs.patch
megasas-remove-expensive-inline-from-megasas_return_cmd.patch
remove-expensive-warn_on-in-pagefault_disabled_dec.patch

