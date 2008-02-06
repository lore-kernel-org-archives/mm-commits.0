From: akpm@linux-foundation.org
Subject: + reduce-large-do_mount-stack-usage-with-noinlines.patch added to -mm tree
Date: Wed, 06 Feb 2008 15:17:25 -0800
Message-ID: <200802062317.m16NHP7c003009@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50269 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932628AbYBFXSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 18:18:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com, arjan@infradead.org


The patch titled
     reduce large do_mount stack usage with noinlines
has been added to the -mm tree.  Its filename is
     reduce-large-do_mount-stack-usage-with-noinlines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reduce large do_mount stack usage with noinlines
From: Eric Sandeen <sandeen@redhat.com>

do_mount() uses a whopping 616 bytes of stack on x86_64 in 2.6.24-mm1,
largely thanks to gcc inlining the various helper functions.

noinlining these can slim it down a lot; on my box this patch gets it down
to 168, which is mostly the struct nameidata nd; left on the stack.

These functions are called only as do_mount() helpers; none of them should
be in any path that would see a performance benefit from inlining...

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namespace.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff -puN fs/namespace.c~reduce-large-do_mount-stack-usage-with-noinlines fs/namespace.c
--- a/fs/namespace.c~reduce-large-do_mount-stack-usage-with-noinlines
+++ a/fs/namespace.c
@@ -1295,8 +1295,9 @@ out_unlock:
 
 /*
  * recursively change the type of the mountpoint.
+ * noinline this do_mount helper to save do_mount stack space.
  */
-static int do_change_type(struct nameidata *nd, int flag)
+static noinline int do_change_type(struct nameidata *nd, int flag)
 {
 	struct vfsmount *m, *mnt = nd->path.mnt;
 	int recurse = flag & MS_REC;
@@ -1319,8 +1320,10 @@ static int do_change_type(struct nameida
 
 /*
  * do loopback mount.
+ * noinline this do_mount helper to save do_mount stack space.
  */
-static int do_loopback(struct nameidata *nd, char *old_name, int recurse)
+static noinline int do_loopback(struct nameidata *nd, char *old_name,
+				int recurse)
 {
 	struct nameidata old_nd;
 	struct vfsmount *mnt = NULL;
@@ -1386,8 +1389,9 @@ static int change_mount_flags(struct vfs
  * change filesystem flags. dir should be a physical root of filesystem.
  * If you've mounted a non-root directory somewhere and want to do remount
  * on it - tough luck.
+ * noinline this do_mount helper to save do_mount stack space.
  */
-static int do_remount(struct nameidata *nd, int flags, int mnt_flags,
+static noinline int do_remount(struct nameidata *nd, int flags, int mnt_flags,
 		      void *data)
 {
 	int err;
@@ -1425,7 +1429,10 @@ static inline int tree_contains_unbindab
 	return 0;
 }
 
-static int do_move_mount(struct nameidata *nd, char *old_name)
+/*
+ * noinline this do_mount helper to save do_mount stack space.
+ */
+static noinline int do_move_mount(struct nameidata *nd, char *old_name)
 {
 	struct nameidata old_nd, parent_nd;
 	struct vfsmount *p;
@@ -1504,8 +1511,9 @@ out:
 /*
  * create a new mount for userspace and request it to be added into the
  * namespace's tree
+ * noinline this do_mount helper to save do_mount stack space.
  */
-static int do_new_mount(struct nameidata *nd, char *type, int flags,
+static noinline int do_new_mount(struct nameidata *nd, char *type, int flags,
 			int mnt_flags, char *name, void *data)
 {
 	struct vfsmount *mnt;
_

Patches currently in -mm which might be from sandeen@redhat.com are

origin.patch
ext2-change-the-default-behaviour-on-error.patch
address-hfs-on-disk-corruption-robustness-review-comments.patch
ecryptfs-make-show_options-reflect-actual-mount-options.patch
ecryptfs-remove-debug-as-mount-option-and-warn-if-set-via-modprobe.patch
ecryptfs-check-for-existing-key_tfm-at-mount-time.patch
ext3-change-the-default-behaviour-on-error.patch
reduce-large-do_mount-stack-usage-with-noinlines.patch
