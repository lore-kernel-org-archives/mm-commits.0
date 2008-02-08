From: akpm@linux-foundation.org
Subject: - reduce-large-do_mount-stack-usage-with-noinlines.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:21:14 -0800
Message-ID: <200802082020.m18KKtxW011267@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933333AbYBHUkF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 15:40:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, arjan@infradead.org, mm-commits@vger.kernel.org


The patch titled
     reduce large do_mount stack usage with noinlines
has been removed from the -mm tree.  Its filename was
     reduce-large-do_mount-stack-usage-with-noinlines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -936,8 +936,9 @@ out_unlock:
 
 /*
  * recursively change the type of the mountpoint.
+ * noinline this do_mount helper to save do_mount stack space.
  */
-static int do_change_type(struct nameidata *nd, int flag)
+static noinline int do_change_type(struct nameidata *nd, int flag)
 {
 	struct vfsmount *m, *mnt = nd->mnt;
 	int recurse = flag & MS_REC;
@@ -960,8 +961,10 @@ static int do_change_type(struct nameida
 
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
@@ -1010,8 +1013,9 @@ out:
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
@@ -1046,7 +1050,10 @@ static inline int tree_contains_unbindab
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
@@ -1121,8 +1128,9 @@ out:
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
