From: akpm@linux-foundation.org
Subject: + hfsplus-add-__init-to-hfsplus_create_attr_tree_cache.patch
 added to -mm tree
Date: Mon, 10 Mar 2014 13:59:02 -0700
Message-ID: <531e2796.OLMDAGb7UXwaNzRy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40943 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128AbaCJU7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Mar 2014 16:59:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: + hfsplus-add-__init-to-hfsplus_create_attr_tree_cache.patch added to -mm tree
To: fabf@skynet.be
From: akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 13:59:02 -0700


The patch titled
     Subject: fs/hfsplus/attributes.c: add __init to hfsplus_create_attr_tree_cache()
has been added to the -mm tree.  Its filename is
     hfsplus-add-__init-to-hfsplus_create_attr_tree_cache.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hfsplus-add-__init-to-hfsplus_create_attr_tree_cache.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hfsplus-add-__init-to-hfsplus_create_attr_tree_cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/hfsplus/attributes.c: add __init to hfsplus_create_attr_tree_cache()

hfsplus_create_attr_tree_cache is only called by __init init_hfsplus_fs

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/attributes.c |    2 +-
 fs/hfsplus/hfsplus_fs.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/hfsplus/attributes.c~hfsplus-add-__init-to-hfsplus_create_attr_tree_cache fs/hfsplus/attributes.c
--- a/fs/hfsplus/attributes.c~hfsplus-add-__init-to-hfsplus_create_attr_tree_cache
+++ a/fs/hfsplus/attributes.c
@@ -11,7 +11,7 @@
 
 static struct kmem_cache *hfsplus_attr_tree_cachep;
 
-int hfsplus_create_attr_tree_cache(void)
+int __init hfsplus_create_attr_tree_cache(void)
 {
 	if (hfsplus_attr_tree_cachep)
 		return -EEXIST;
diff -puN fs/hfsplus/hfsplus_fs.h~hfsplus-add-__init-to-hfsplus_create_attr_tree_cache fs/hfsplus/hfsplus_fs.h
--- a/fs/hfsplus/hfsplus_fs.h~hfsplus-add-__init-to-hfsplus_create_attr_tree_cache
+++ a/fs/hfsplus/hfsplus_fs.h
@@ -367,7 +367,7 @@ typedef int (*search_strategy_t)(struct
  */
 
 /* attributes.c */
-int hfsplus_create_attr_tree_cache(void);
+int __init hfsplus_create_attr_tree_cache(void);
 void hfsplus_destroy_attr_tree_cache(void);
 hfsplus_attr_entry *hfsplus_alloc_attr_entry(void);
 void hfsplus_destroy_attr_entry(hfsplus_attr_entry *entry_p);
_

Patches currently in -mm which might be from fabf@skynet.be are

fs-cifs-cifsfsc-add-__init-to-cifs_init_inodecache.patch
sys_sysfs-add-config_sysfs_syscall.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
fs-efs-superc-add-__init-to-init_inodecache.patch
fs-minix-inodec-add-__init-to-init_inodecache.patch
befs-replace-kmalloc-memset-0-by-kzalloc.patch
fs-befs-linuxvfsc-add-__init-to-befs_init_inodecache.patch
coda-add-__init-to-init_inodecache.patch
fs-ufs-superc-add-__init-to-init_inodecache.patch
ufs-sb-mutex-merge-mutex_destroy.patch
documentation-filesystems-ntfstxt-remove-changelog-reference.patch
fs-adfs-superc-add-__init-to-init_inodecache.patch
affs-add-__init-to-init_inodecache.patch
fs-affs-dirc-unlock-brelse-dir-on-failure-code-clean-up.patch
fs-bfs-inodec-add-__init-to-init_inodecache.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
linux-next.patch
hfsplus-add-__init-to-hfsplus_create_attr_tree_cache.patch

