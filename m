From: akpm@linux-foundation.org
Subject: [merged]
 kernel-provide-a-__smp_call_function_single-stub-for-config_smp.patch
 removed from -mm tree
Date: Fri, 15 Nov 2013 12:09:17 -0800
Message-ID: <52867f6d.TGguKNQeX2pO0yQW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3KOUJS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:09:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de, axboe@kernel.dk, hch@infradead.org

Subject: [merged] kernel-provide-a-__smp_call_function_single-stub-for-config_smp.patch removed from -mm tree
To: hch@infradead.org,axboe@kernel.dk,hch@lst.de,jack@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:09:17 -0800


The patch titled
     Subject: kernel: provide a __smp_call_function_single stub for !CONFIG_SMP
has been removed from the -mm tree.  Its filename was
     kernel-provide-a-__smp_call_function_single-stub-for-config_smp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@infradead.org>
Subject: kernel: provide a __smp_call_function_single stub for !CONFIG_SMP

Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/up.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN kernel/up.c~kernel-provide-a-__smp_call_function_single-stub-for-config_smp kernel/up.c
--- a/kernel/up.c~kernel-provide-a-__smp_call_function_single-stub-for-config_smp
+++ a/kernel/up.c
@@ -22,6 +22,17 @@ int smp_call_function_single(int cpu, vo
 }
 EXPORT_SYMBOL(smp_call_function_single);
 
+void __smp_call_function_single(int cpu, struct call_single_data *csd,
+				int wait)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	csd->func(csd->info);
+	local_irq_restore(flags);
+}
+EXPORT_SYMBOL(__smp_call_function_single);
+
 int on_each_cpu(smp_call_func_t func, void *info, int wait)
 {
 	unsigned long flags;
_

Patches currently in -mm which might be from hch@infradead.org are

origin.patch
kernel-use-lockless-list-for-smp_call_function_single.patch
blk-mq-use-__smp_call_function_single-directly.patch
linux-next.patch

