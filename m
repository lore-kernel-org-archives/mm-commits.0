From: akpm@linux-foundation.org
Subject: + linuxpps-core-support-sysfs-not-needed-variables-removed.patch added to -mm tree
Date: Tue, 02 Dec 2008 23:50:19 -0800
Message-ID: <200812030750.mB37oJ3K026674@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52347 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbYLCHu0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Dec 2008 02:50:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it


The patch titled
     pps sysfs: not needed variables removed.
has been added to the -mm tree.  Its filename is
     linuxpps-core-support-sysfs-not-needed-variables-removed.patch

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
Subject: pps sysfs: not needed variables removed.
From: Rodolfo Giometti <giometti@linux.it>

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/sysfs.c |    6 ------
 1 file changed, 6 deletions(-)

diff -puN drivers/pps/sysfs.c~linuxpps-core-support-sysfs-not-needed-variables-removed drivers/pps/sysfs.c
--- a/drivers/pps/sysfs.c~linuxpps-core-support-sysfs-not-needed-variables-removed
+++ a/drivers/pps/sysfs.c
@@ -41,7 +41,6 @@ static ssize_t pps_show_assert(struct de
 			(long long) pps->assert_tu.sec, pps->assert_tu.nsec,
 			pps->assert_sequence);
 }
-DEVICE_ATTR(assert, S_IRUGO, pps_show_assert, NULL);
 
 static ssize_t pps_show_clear(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -55,7 +54,6 @@ static ssize_t pps_show_clear(struct dev
 			(long long) pps->clear_tu.sec, pps->clear_tu.nsec,
 			pps->clear_sequence);
 }
-DEVICE_ATTR(clear, S_IRUGO, pps_show_clear, NULL);
 
 static ssize_t pps_show_mode(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -64,7 +62,6 @@ static ssize_t pps_show_mode(struct devi
 
 	return sprintf(buf, "%4x\n", pps->info.mode);
 }
-DEVICE_ATTR(mode, S_IRUGO, pps_show_mode, NULL);
 
 static ssize_t pps_show_echo(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -73,7 +70,6 @@ static ssize_t pps_show_echo(struct devi
 
 	return sprintf(buf, "%d\n", !!pps->info.echo);
 }
-DEVICE_ATTR(echo, S_IRUGO, pps_show_echo, NULL);
 
 static ssize_t pps_show_name(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -82,7 +78,6 @@ static ssize_t pps_show_name(struct devi
 
 	return sprintf(buf, "%s\n", pps->info.name);
 }
-DEVICE_ATTR(name, S_IRUGO, pps_show_name, NULL);
 
 static ssize_t pps_show_path(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -91,7 +86,6 @@ static ssize_t pps_show_path(struct devi
 
 	return sprintf(buf, "%s\n", pps->info.path);
 }
-DEVICE_ATTR(path, S_IRUGO, pps_show_path, NULL);
 
 struct device_attribute pps_attrs[] = {
 	__ATTR(assert, S_IRUGO, pps_show_assert, NULL),
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch
linuxpps-core-support.patch
linuxpps-core-support-sysfs-not-needed-variables-removed.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch
linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch

