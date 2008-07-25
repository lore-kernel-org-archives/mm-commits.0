From: akpm@linux-foundation.org
Subject: - dcdbas-use-memory_read_from_buffer.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:01:57 -0700
Message-ID: <200807252301.m6PN1vRZ003757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755014AbYGYXGv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:06:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, Douglas_Warzecha@dell.com, Matt_Domsch@dell.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     dcdbas: use memory_read_from_buffer()
has been removed from the -mm tree.  Its filename was
     dcdbas-use-memory_read_from_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dcdbas: use memory_read_from_buffer()
From: Akinobu Mita <akinobu.mita@gmail.com>

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/firmware/dcdbas.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN drivers/firmware/dcdbas.c~dcdbas-use-memory_read_from_buffer drivers/firmware/dcdbas.c
--- a/drivers/firmware/dcdbas.c~dcdbas-use-memory_read_from_buffer
+++ a/drivers/firmware/dcdbas.c
@@ -152,20 +152,11 @@ static ssize_t smi_data_read(struct kobj
 			     struct bin_attribute *bin_attr,
 			     char *buf, loff_t pos, size_t count)
 {
-	size_t max_read;
 	ssize_t ret;
 
 	mutex_lock(&smi_data_lock);
-
-	if (pos >= smi_data_buf_size) {
-		ret = 0;
-		goto out;
-	}
