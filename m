From: akpm@linux-foundation.org
Subject: [merged]
 drivers-misc-sgi-gru-grufilec-fix-info-leak-in-gru_get_config_info.patch
 removed from -mm tree
Date: Thu, 13 Jun 2013 11:58:00 -0700
Message-ID: <51ba1638.DhVN1Yz+nHxWAzDQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37116 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646Ab3FMS6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:58:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sivanich@sgi.com, holt@sgi.com, dan.carpenter@oracle.com

Subject: [merged] drivers-misc-sgi-gru-grufilec-fix-info-leak-in-gru_get_config_info.patch removed from -mm tree
To: dan.carpenter@oracle.com,holt@sgi.com,sivanich@sgi.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:58:00 -0700


The patch titled
     Subject: drivers/misc/sgi-gru/grufile.c: fix info leak in gru_get_config_info()
has been removed from the -mm tree.  Its filename was
     drivers-misc-sgi-gru-grufilec-fix-info-leak-in-gru_get_config_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: drivers/misc/sgi-gru/grufile.c: fix info leak in gru_get_config_info()

The "info.fill" array isn't initialized so it can leak uninitialized stack
information to user space.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Robin Holt <holt@sgi.com>
Acked-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sgi-gru/grufile.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/sgi-gru/grufile.c~drivers-misc-sgi-gru-grufilec-fix-info-leak-in-gru_get_config_info drivers/misc/sgi-gru/grufile.c
--- a/drivers/misc/sgi-gru/grufile.c~drivers-misc-sgi-gru-grufilec-fix-info-leak-in-gru_get_config_info
+++ a/drivers/misc/sgi-gru/grufile.c
@@ -172,6 +172,7 @@ static long gru_get_config_info(unsigned
 		nodesperblade = 2;
 	else
 		nodesperblade = 1;
+	memset(&info, 0, sizeof(info));
 	info.cpus = num_online_cpus();
 	info.nodes = num_online_nodes();
 	info.blades = info.nodes / nodesperblade;
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
linux-next.patch
fanotify-info-leak-in-copy_event_to_user.patch
configfs-use-capped-length-for-store_attribute.patch
drivers-cdrom-cdromc-use-kzalloc-for-failing-hardware.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix.patch
mm-vmallocc-unbreak-__vunmap.patch
errh-is_err-can-accept-__user-pointers.patch
drivers-misc-sgi-gru-grufaultc-fix-a-sanity-test-in-gru_set_context_option.patch
rbtree-remove-unneeded-include.patch
rbtree-remove-unneeded-include-fix.patch
minix-bug-widening-a-binary-not-operation.patch
documentation-codingstyle-allow-multiple-return-statements-per-function.patch
mwave-fix-info-leak-in-mwave_ioctl.patch

