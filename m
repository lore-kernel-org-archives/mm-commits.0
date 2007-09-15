From: akpm@linux-foundation.org
Subject: + fix-build-with-config_compat=y-and-config_block=n.patch added to -mm tree
Date: Fri, 14 Sep 2007 17:45:01 -0700
Message-ID: <200709150045.l8F0j2iu032207@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728AbXIOAp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 20:45:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aherrman@arcor.de, agk@redhat.com, dhowells@redhat.com


The patch titled
     Fix build with CONFIG_COMPAT=y and CONFIG_BLOCK=n
has been added to the -mm tree.  Its filename is
     fix-build-with-config_compat=y-and-config_block=n.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix build with CONFIG_COMPAT=y and CONFIG_BLOCK=n
From: aherrman@arcor.de

Due to commit 02a5e0acb3cb85d80d0fe834e366d38a92bbaa22
kernel build is broken if (CONFIG_COMPAT && ! CONFIG_BLOCK):

  CC      fs/compat_ioctl.o
In file included from include/linux/raid/md_k.h:19,
                 from include/linux/raid/md.h:54,
                 from fs/compat_ioctl.c:25:
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:40: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:48: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h:51: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:64: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_merge_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:78: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h: In bio_list_:
include/linux/raid/../../../drivers/md/dm-bio-list.h:90: error: dereferencing pointer to incomplete type
include/linux/raid/../../../drivers/md/dm-bio-list.h:94: error: dereferencing pointer to incomplete type
make[1]: *** [fs/compat_ioctl.o] Error 1
make: *** [fs] Error 2

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
Acked-By: David Howells <dhowells@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-bio-list.h |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/md/dm-bio-list.h~fix-build-with-config_compat=y-and-config_block=n drivers/md/dm-bio-list.h
--- a/drivers/md/dm-bio-list.h~fix-build-with-config_compat=y-and-config_block=n
+++ a/drivers/md/dm-bio-list.h
@@ -9,6 +9,8 @@
 
 #include <linux/bio.h>
 
+#ifdef CONFIG_BLOCK
+
 struct bio_list {
 	struct bio *head;
 	struct bio *tail;
@@ -106,4 +108,5 @@ static inline struct bio *bio_list_get(s
 	return bio;
 }
 
+#endif /* CONFIG_BLOCK */
 #endif
_

Patches currently in -mm which might be from aherrman@arcor.de are

fix-build-with-config_compat=y-and-config_block=n.patch
radeonfb-fix-setting-of-ppll_ref_div-for-rv370-5b60.patch
