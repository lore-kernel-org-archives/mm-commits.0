From: akpm@linux-foundation.org
Subject: + mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch added to -mm tree
Date: Tue, 03 Apr 2007 18:21:23 -0700
Message-ID: <200704040121.l341LNOA008783@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51863 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966233AbXDDBVg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 21:21:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, edward@namesys.com, vs@namesys.com


The patch titled
     mm: clean up and kernelify shrinker registration
has been added to the -mm tree.  Its filename is
     mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

vmi-paravirt-ops-bugfix-for-2621.patch
git-kbuild.patch
git-net.patch
allow-per-cpu-variables-to-be-page-aligned.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
____call_usermodehelper-dont-flush_signals.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
