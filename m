From: akpm@linux-foundation.org
Subject: + nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch added to
 -mm tree
Date: Mon, 03 Feb 2014 13:41:13 -0800
Message-ID: <52f00cf9.1S1BUg02hhyqFLWn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbaBCVlO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 16:41:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, konishi.ryusuke@lab.ntt.co.jp, andreas.rohner@gmx.net

Subject: + nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch added to -mm tree
To: andreas.rohner@gmx.net,konishi.ryusuke@lab.ntt.co.jp
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 13:41:13 -0800


The patch titled
     Subject: nilfs2: add struct nilfs_suinfo_update and flags
has been added to the -mm tree.  Its filename is
     nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andreas Rohner <andreas.rohner@gmx.net>
Subject: nilfs2: add struct nilfs_suinfo_update and flags

Add the nilfs_suinfo_update structure, which contains the information
needed to update one segment usage entry.  The flags specify, which fields
need to be updated.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nilfs2_fs.h |   42 ++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff -puN include/linux/nilfs2_fs.h~nilfs2-add-struct-nilfs_suinfo_update-and-flags include/linux/nilfs2_fs.h
--- a/include/linux/nilfs2_fs.h~nilfs2-add-struct-nilfs_suinfo_update-and-flags
+++ a/include/linux/nilfs2_fs.h
@@ -710,6 +710,48 @@ static inline int nilfs_suinfo_clean(con
 }
 
 /* ioctl */
+/**
+ * nilfs_suinfo_update - segment usage information update
+ * @sup_segnum: segment number
+ * @sup_flags: flags for which fields are active in sup_sui
+ * @sup_reserved: reserved necessary for alignment
+ * @sup_sui: segment usage information
+ */
+struct nilfs_suinfo_update {
+	__u64 sup_segnum;
+	__u32 sup_flags;
+	__u32 sup_reserved;
+	struct nilfs_suinfo sup_sui;
+};
+
+enum {
+	NILFS_SUINFO_UPDATE_LASTMOD,
+	NILFS_SUINFO_UPDATE_NBLOCKS,
+	NILFS_SUINFO_UPDATE_FLAGS,
+	__NR_NILFS_SUINFO_UPDATE_FIELDS,
+};
+
+#define NILFS_SUINFO_UPDATE_FNS(flag, name)				\
+static inline void							\
+nilfs_suinfo_update_set_##name(struct nilfs_suinfo_update *sup)		\
+{									\
+	sup->sup_flags |= 1UL << NILFS_SUINFO_UPDATE_##flag;		\
+}									\
+static inline void							\
+nilfs_suinfo_update_clear_##name(struct nilfs_suinfo_update *sup)	\
+{									\
+	sup->sup_flags &= ~(1UL << NILFS_SUINFO_UPDATE_##flag);		\
+}									\
+static inline int							\
+nilfs_suinfo_update_##name(const struct nilfs_suinfo_update *sup)	\
+{									\
+	return !!(sup->sup_flags & (1UL << NILFS_SUINFO_UPDATE_##flag));\
+}
+
+NILFS_SUINFO_UPDATE_FNS(LASTMOD, lastmod)
+NILFS_SUINFO_UPDATE_FNS(NBLOCKS, nblocks)
+NILFS_SUINFO_UPDATE_FNS(FLAGS, flags)
+
 enum {
 	NILFS_CHECKPOINT,
 	NILFS_SNAPSHOT,
_

Patches currently in -mm which might be from andreas.rohner@gmx.net are

nilfs2-add-struct-nilfs_suinfo_update-and-flags.patch
nilfs2-add-nilfs_sufile_set_suinfo-to-update-segment-usage.patch
nilfs2-implementation-of-nilfs_ioctl_set_suinfo-ioctl.patch

