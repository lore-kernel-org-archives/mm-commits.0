From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-add-module_put-on-error-path-in-rtc_proc_open.patch removed from -mm tree
Date: Mon, 14 Feb 2011 12:19:26 -0800
Message-ID: <201102142019.p1EKJQLv022986@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046Ab1BNUUT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Feb 2011 15:20:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cromlehg@gmail.com, a.zummo@towertech.it, strakh@ispras.ru, mm-commits@vger.kernel.org


The patch titled
     drivers/rtc/rtc-proc.c: add module_put on error path in rtc_proc_open()
has been removed from the -mm tree.  Its filename was
     drivers-rtc-add-module_put-on-error-path-in-rtc_proc_open.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/rtc/rtc-proc.c: add module_put on error path in rtc_proc_open()
From: Alexander Strakh <cromlehg@gmail.com>

In file drivers/rtc/rtc-proc.c seq_open() can return -ENOMEM.

 86        if (!try_module_get(THIS_MODULE))
 87                return -ENODEV;
 88
 89        return single_open(file, rtc_proc_show, rtc);

In this case before exiting (line 89) from rtc_proc_open
the module_put(THIS_MODULE) must be called.

Found by Linux Device Drivers Verification Project

Signed-off-by: Alexander Strakh <strakh@ispras.ru>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-proc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-proc.c~drivers-rtc-add-module_put-on-error-path-in-rtc_proc_open drivers/rtc/rtc-proc.c
--- a/drivers/rtc/rtc-proc.c~drivers-rtc-add-module_put-on-error-path-in-rtc_proc_open
+++ a/drivers/rtc/rtc-proc.c
@@ -81,12 +81,16 @@ static int rtc_proc_show(struct seq_file
 
 static int rtc_proc_open(struct inode *inode, struct file *file)
 {
+	int ret;
 	struct rtc_device *rtc = PDE(inode)->data;
 
 	if (!try_module_get(THIS_MODULE))
 		return -ENODEV;
 
-	return single_open(file, rtc_proc_show, rtc);
+	ret = single_open(file, rtc_proc_show, rtc);
+	if (ret)
+		module_put(THIS_MODULE);
+	return ret;
 }
 
 static int rtc_proc_release(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from cromlehg@gmail.com are

origin.patch
linux-next.patch

