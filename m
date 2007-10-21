From: akpm@linux-foundation.org
Subject: - mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch removed from -mm tree
Date: Sun, 21 Oct 2007 16:46:56 -0700
Message-ID: <200710212346.l9LNkubv000619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46756 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751062AbXJUXrj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 21 Oct 2007 19:47:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, edward@namesys.com, vs@namesys.com, mm-commits@vger.kernel.org


The patch titled
     mm: clean up and kernelify shrinker registration
has been removed from the -mm tree.  Its filename was
     mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: mm: clean up and kernelify shrinker registration
From: Rusty Russell <rusty@rustcorp.com.au>

I can never remember what the function to register to receive VM pressure
is called.  I have to trace down from __alloc_pages() to find it.

It's called "set_shrinker()", and it needs Your Help.

1) Don't hide struct shrinker.  It contains no magic.
2) Don't allocate "struct shrinker".  It's not helpful.
3) Call them "register_shrinker" and "unregister_shrinker".
4) Call the function "shrink" not "shrinker".
5) Reduce the 17 lines of waffly comments to 13, but document it properly.

The comment in reiser4 makes me a little queasy.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Vladimir Saveliev <vs@namesys.com>
Cc: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/fsdata.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff -puN fs/reiser4/fsdata.c~mm-clean-up-and-kernelify-shrinker-registration-reiser4 fs/reiser4/fsdata.c
--- a/fs/reiser4/fsdata.c~mm-clean-up-and-kernelify-shrinker-registration-reiser4
+++ a/fs/reiser4/fsdata.c
@@ -7,7 +7,6 @@
 
 /* cache or dir_cursors */
 static struct kmem_cache *d_cursor_cache;
-static struct shrinker *d_cursor_shrinker;
 
 /* list of unused cursors */
 static LIST_HEAD(cursor_cache);
@@ -53,6 +52,18 @@ static int d_cursor_shrink(int nr, gfp_t
 	return d_cursor_unused;
 }
 
+/*
+ * actually, d_cursors are "priceless", because there is no way to
+ * recover information stored in them. On the other hand, we don't
+ * want to consume all kernel memory by them. As a compromise, just
+ * assign higher "seeks" value to d_cursor cache, so that it will be
+ * shrunk only if system is really tight on memory.
+ */
+static struct shrinker d_cursor_shrinker = {
+	.shrink = d_cursor_shrink,
+	.seeks = DEFAULT_SEEKS << 3,
+};
+
 /**
  * reiser4_init_d_cursor - create d_cursor cache
  *
@@ -66,20 +77,7 @@ int reiser4_init_d_cursor(void)
 	if (d_cursor_cache == NULL)
 		return RETERR(-ENOMEM);
 
-	/*
-	 * actually, d_cursors are "priceless", because there is no way to
-	 * recover information stored in them. On the other hand, we don't
-	 * want to consume all kernel memory by them. As a compromise, just
-	 * assign higher "seeks" value to d_cursor cache, so that it will be
-	 * shrunk only if system is really tight on memory.
-	 */
-	d_cursor_shrinker = set_shrinker(DEFAULT_SEEKS << 3,
-					 d_cursor_shrink);
-	if (d_cursor_shrinker == NULL) {
-		destroy_reiser4_cache(&d_cursor_cache);
-		d_cursor_cache = NULL;
-		return RETERR(-ENOMEM);
-	}
+	register_shrinker(&d_cursor_shrinker);
 	return 0;
 }
 
@@ -90,9 +88,7 @@ int reiser4_init_d_cursor(void)
  */
 void reiser4_done_d_cursor(void)
 {
-	BUG_ON(d_cursor_shrinker == NULL);
-	remove_shrinker(d_cursor_shrinker);
-	d_cursor_shrinker = NULL;
+	unregister_shrinker(&d_cursor_shrinker);
 
 	destroy_reiser4_cache(&d_cursor_cache);
 }
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
update-boot-spec-to-207.patch
add-weak-for-creating-weak-asm-labels.patch
i386-paravirt-boot-sequence.patch
git-kvm.patch
reiser4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
