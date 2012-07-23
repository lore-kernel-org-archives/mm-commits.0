From: akpm@linux-foundation.org
Subject: [merged] selinux-fix-something.patch removed from -mm tree
Date: Mon, 23 Jul 2012 14:31:15 -0700
Message-ID: <20120723213116.049CB200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:58755 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab2GWVjb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 17:39:31 -0400
Received: by weyr1 with SMTP id r1so346596wey.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 14:39:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eparis@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: selinux: fix something
has been removed from the -mm tree.  Its filename was
     selinux-fix-something.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eric Paris <eparis@redhat.com>
Subject: selinux: fix something



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 security/selinux/hooks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN security/selinux/hooks.c~selinux-fix-something security/selinux/hooks.c
--- a/security/selinux/hooks.c~selinux-fix-something
+++ a/security/selinux/hooks.c
@@ -2717,7 +2717,7 @@ static int selinux_inode_setattr(struct 
 			ATTR_ATIME_SET | ATTR_MTIME_SET | ATTR_TIMES_SET))
 		return dentry_has_perm(cred, dentry, FILE__SETATTR);
 
-	if (ia_valid & ATTR_SIZE)
+	if ((ia_valid & ATTR_SIZE) && selinux_policycap_openperm)
 		av |= FILE__OPEN;
 
 	return dentry_has_perm(cred, dentry, av);
_

Patches currently in -mm which might be from eparis@redhat.com are

linux-next.patch
selinux-tag-avc-cache-alloc-as-non-critical.patch
mm-methods-for-teaching-filesystems-about-pg_swapcache-pages.patch
mm-add-support-for-a-filesystem-to-activate-swap-files-and-use-direct_io-for-writing-swap-pages.patch
mm-swap-implement-generic-handler-for-swap_activate.patch
mm-add-get_kernel_page-for-pinning-of-kernel-addresses-for-i-o.patch
mm-add-support-for-direct_io-to-highmem-pages.patch
nfs-teach-the-nfs-client-how-to-treat-pg_swapcache-pages.patch
nfs-disable-data-cache-revalidation-for-swapfiles.patch
nfs-enable-swap-on-nfs.patch
nfs-prevent-page-allocator-recursions-with-swap-over-nfs.patch
swapfile-avoid-dereferencing-bd_disk-during-swap_entry_free-for-network-storage.patch

