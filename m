From: akpm@linux-foundation.org
Subject: [patch 038/102] autofs: remove AUTOFS_DEVID_LEN
Date: Tue, 11 Oct 2016 13:52:51 -0700
Message-ID: <57fd5123.+o2eFClvTCobCJrj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37919 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753186AbcJKUxG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:53:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, kusumi.tomohiro@gmail.com, ikent@redhat.com

From: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Subject: autofs: remove AUTOFS_DEVID_LEN

This macro was never used by neither kernel nor userspace, and also
doesn't represent "devid length" in bytes.  (unless it was added to mean
something else).

Link: http://lkml.kernel.org/r/20160812024820.12352.21210.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@gmail.com>
Signed-off-by: Ian Kent <ikent@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/auto_dev-ioctl.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/auto_dev-ioctl.h~autofs-remove-autofs_devid_len include/linux/auto_dev-ioctl.h
--- a/include/linux/auto_dev-ioctl.h~autofs-remove-autofs_devid_len
+++ a/include/linux/auto_dev-ioctl.h
@@ -18,8 +18,6 @@
 #define AUTOFS_DEV_IOCTL_VERSION_MAJOR	1
 #define AUTOFS_DEV_IOCTL_VERSION_MINOR	0
 
-#define AUTOFS_DEVID_LEN		16
