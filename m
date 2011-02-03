From: akpm@linux-foundation.org
Subject: + drivers-rtc-add-module_put-on-error-path-in-rtc_proc_open.patch added to -mm tree
Date: Thu, 03 Feb 2011 12:20:04 -0800
Message-ID: <201102032020.p13KK45m022567@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750920Ab1BCUUf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Feb 2011 15:20:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cromlehg@gmail.com, a.zummo@towertech.it, strakh@ispras.ru


The patch titled
     drivers/rtc/rtc-proc.c: add module_put on error path in rtc_proc_open()
has been added to the -mm tree.  Its filename is
     drivers-rtc-add-module_put-on-error-path-in-rtc_proc_open.patch

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

drivers-rtc-add-module_put-on-error-path-in-rtc_proc_open.patch

