From: akpm@linux-foundation.org
Subject: [patch 11/78] autofs: remove duplicated AUTOFS_DEV_IOCTL_SIZE
 definition
Date: Mon, 27 Feb 2017 14:27:14 -0800
Message-ID: <58b4a7c2.4GAW46MEqE7rnXVG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44846 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbdB0W3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:29:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, tkusumi@tuxera.com, raven@themaw.net

From: Tomohiro Kusumi <tkusumi@tuxera.com>
Subject: autofs: remove duplicated AUTOFS_DEV_IOCTL_SIZE definition

This macro is already defined in uapi header.  Also use this macro where
possible.

Link: http://lkml.kernel.org/r/148577166656.9801.10322423666945951186.stgit@pluto.themaw.net
Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/dev-ioctl.c              |    2 --
 include/uapi/linux/auto_dev-ioctl.h |    4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/autofs4/dev-ioctl.c~autofs-remove-duplicated-autofs_dev_ioctl_size-definition fs/autofs4/dev-ioctl.c
--- a/fs/autofs4/dev-ioctl.c~autofs-remove-duplicated-autofs_dev_ioctl_size-definition
+++ a/fs/autofs4/dev-ioctl.c
@@ -38,8 +38,6 @@
  * which have been left busy at at service shutdown.
  */
 
-#define AUTOFS_DEV_IOCTL_SIZE	sizeof(struct autofs_dev_ioctl)
