From: akpm@linux-foundation.org
Subject: + fbcon-dont-use-vc_resize-on-initialization.patch added to -mm tree
Date: Thu, 30 Jul 2009 16:12:02 -0700
Message-ID: <200907302312.n6UNC33C003450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064AbZG3XM1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 30 Jul 2009 19:12:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, catalin.marinas@arm.com, krzysztof.h1@poczta.fm, penberg@cs.helsinki.fi


The patch titled
     fbcon: don't use vc_resize() on initialization
has been added to the -mm tree.  Its filename is
     fbcon-dont-use-vc_resize-on-initialization.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fbcon: don't use vc_resize() on initialization
From: Johannes Weiner <hannes@cmpxchg.org>

Catalin and kmemleak spotted a leak of a VC screen buffer in
vc_allocate() due to the following chain of events:

	vc_allocate()
	  visual_init(init=1)
	    vc->vc_sw->con_init(init=1)
              fbcon_init()
	        vc_resize()
	          vc->screen_buf = kmalloc()
	  vc->screen_buf = kmalloc()

The common way for the VC drivers is to set the screen dimension
parameters manually in the init case and only call vc_resize() for
!init - which allocates a screen buffer according to the new
dimensions.

fbcon instead would do vc_resize() unconditionally and afterwards set
the dimensions manually (again) for !init - i.e. completely upside
down.  The vc_resize() allocated buffer would then get lost by
vc_allocate() allocating a fresh one.

Use vc_resize() only for actual resizing to close the leak.

Set the dimensions manually only in initialization mode to remove the
redundant setting in resize mode.

The kmemleak trace from Catalin:

unreferenced object 0xde158000 (size 12288):
  comm "Xorg", pid 1439, jiffies 4294961016
  hex dump (first 32 bytes):
    20 00 20 00 20 00 20 00 20 00 20 00 20 00 20 00   . . . . . . . .
    20 00 20 00 20 00 20 00 20 00 20 00 20 00 20 00   . . . . . . . .
  backtrace:
    [<c006f74b>] __save_stack_trace+0x17/0x1c
    [<c006f81d>] create_object+0xcd/0x188
    [<c01f5457>] kmemleak_alloc+0x1b/0x3c
    [<c006e303>] __kmalloc+0xdb/0xe8
    [<c012cc4b>] vc_do_resize+0x73/0x1e0
    [<c012cdf1>] vc_resize+0x15/0x18
    [<c011afc1>] fbcon_init+0x1f9/0x2b8
    [<c0129e87>] visual_init+0x9f/0xdc
    [<c012aff3>] vc_allocate+0x7f/0xfc
    [<c012b087>] con_open+0x17/0x80
    [<c0120e43>] tty_open+0x1f7/0x2e4
    [<c0072fa1>] chrdev_open+0x101/0x118
    [<c006ffad>] __dentry_open+0x105/0x1cc
    [<c00700fd>] nameidata_to_filp+0x2d/0x38
    [<c00788cd>] do_filp_open+0x2c1/0x54c
    [<c006fdff>] do_sys_open+0x3b/0xb4

Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/console/fbcon.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/console/fbcon.c~fbcon-dont-use-vc_resize-on-initialization drivers/video/console/fbcon.c
--- a/drivers/video/console/fbcon.c~fbcon-dont-use-vc_resize-on-initialization
+++ a/drivers/video/console/fbcon.c
@@ -1082,7 +1082,6 @@ static void fbcon_init(struct vc_data *v
 	new_rows = FBCON_SWAP(ops->rotate, info->var.yres, info->var.xres);
 	new_cols /= vc->vc_font.width;
 	new_rows /= vc->vc_font.height;
-	vc_resize(vc, new_cols, new_rows);
 
 	/*
 	 * We must always set the mode. The mode of the previous console
@@ -1111,10 +1110,11 @@ static void fbcon_init(struct vc_data *v
 	 *  vc_{cols,rows}, but we must not set those if we are only
 	 *  resizing the console.
 	 */
-	if (!init) {
+	if (init) {
 		vc->vc_cols = new_cols;
 		vc->vc_rows = new_rows;
-	}
+	} else
+		vc_resize(vc, new_cols, new_rows);
 
 	if (logo)
 		fbcon_prepare_logo(vc, info, cols, rows, new_cols, new_rows);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
fbcon-dont-use-vc_resize-on-initialization.patch
mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
vmscan-use-add_page_to_lru_list-helper-function.patch
vmscan-move-pgdeactivate-modification-to-shrink_active_list.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch

