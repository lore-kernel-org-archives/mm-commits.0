From: akpm@linux-foundation.org
Subject: + autofs-remove-autofs_devid_len.patch added to -mm tree
Date: Thu, 11 Aug 2016 20:07:18 -0700
Message-ID: <57ad3d66.0A9Anh6oAZtQ24VK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbcHLDHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Aug 2016 23:07:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kusumi.tomohiro@gmail.com, ikent@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs: remove AUTOFS_DEVID_LEN
has been added to the -mm tree.  Its filename is
     autofs-remove-autofs_devid_len.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs-remove-autofs_devid_len.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs-remove-autofs_devid_len.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
