From: akpm@linux-foundation.org
Subject: [merged] configfs-unexport-make-static-config_item_init.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:36:23 -0700
Message-ID: <5591ac47.9wdzerJyHcZoKqau%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50122 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbbF2UgY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:36:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jlbec@evilplan.org, mm-commits@vger.kernel.org


The patch titled
     Subject: configfs: unexport/make static config_item_init()
has been removed from the -mm tree.  Its filename was
     configfs-unexport-make-static-config_item_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: configfs: unexport/make static config_item_init()

config_item_init() is only used in item.c

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/configfs/item.c       |    3 +--
 include/linux/configfs.h |    1 -
 2 files changed, 1 insertion(+), 3 deletions(-)

diff -puN fs/configfs/item.c~configfs-unexport-make-static-config_item_init fs/configfs/item.c
--- a/fs/configfs/item.c~configfs-unexport-make-static-config_item_init
+++ a/fs/configfs/item.c
@@ -47,12 +47,11 @@ static void config_item_release(struct k
  *	config_item_init - initialize item.
  *	@item:	item in question.
  */
-void config_item_init(struct config_item *item)
+static void config_item_init(struct config_item *item)
 {
 	kref_init(&item->ci_kref);
 	INIT_LIST_HEAD(&item->ci_entry);
 }
-EXPORT_SYMBOL(config_item_init);
 
 /**
  *	config_item_set_name - Set the name of an item
diff -puN include/linux/configfs.h~configfs-unexport-make-static-config_item_init include/linux/configfs.h
--- a/include/linux/configfs.h~configfs-unexport-make-static-config_item_init
+++ a/include/linux/configfs.h
@@ -71,7 +71,6 @@ static inline char *config_item_name(str
 	return item->ci_name;
 }
 
-extern void config_item_init(struct config_item *);
 extern void config_item_init_type_name(struct config_item *item,
 				       const char *name,
 				       struct config_item_type *type);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-affs-inodec-remove-unneeded-initialization.patch
fs-affs-amigaffsc-remove-unneeded-initialization.patch
fs-affs-symlinkc-remove-unneeded-err-variable.patch
w1-masters-omap_hdq-add-support-for-1-wire-mode.patch
linux-next.patch

