From: akpm@linux-foundation.org
Subject: + vt-drop-bootmem-slab-memory-distinction.patch added to -mm tree
Date: Tue, 14 Jul 2009 16:03:12 -0700
Message-ID: <200907142303.n6EN3Dkk016737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754355AbZGNXEO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jul 2009 19:04:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, alan@lxorguk.ukuu.org.uk, catalin.marinas@arm.com, penberg@cs.helsinki.fi


The patch titled
     vt: drop bootmem/slab memory distinction
has been added to the -mm tree.  Its filename is
     vt-drop-bootmem-slab-memory-distinction.patch

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
Subject: vt: drop bootmem/slab memory distinction
From: Johannes Weiner <hannes@cmpxchg.org>

Bootmem is not used for the vt screen buffer anymore as slab is now
available at the time the console is initialized.

Get rid of the now superfluous distinction between slab and bootmem,
it's always slab.

This also fixes a kmalloc leak which Catalin described thusly:


Commit a5f4f52e ("vt: use kzalloc() instead of the bootmem allocator")
replaced the alloc_bootmem() with kzalloc() but didn't set vc_kmalloced to
1 and the memory block is later leaked.  The corresponding kmemleak trace:

unreferenced object 0xdf828000 (size 8192):
  comm "swapper", pid 0, jiffies 4294937296
  backtrace:
    [<c006d473>] __save_stack_trace+0x17/0x1c
    [<c000d869>] log_early+0x55/0x84
    [<c01cfa4b>] kmemleak_alloc+0x33/0x3c
    [<c006c013>] __kmalloc+0xd7/0xe4
    [<c00108c7>] con_init+0xbf/0x1b8
    [<c0010149>] console_init+0x11/0x20
    [<c0008797>] start_kernel+0x137/0x1e4


Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Tested-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vt.c              |   12 +++---------
 include/linux/console_struct.h |    1 -
 2 files changed, 3 insertions(+), 10 deletions(-)

diff -puN drivers/char/vt.c~vt-drop-bootmem-slab-memory-distinction drivers/char/vt.c
--- a/drivers/char/vt.c~vt-drop-bootmem-slab-memory-distinction
+++ a/drivers/char/vt.c
@@ -769,14 +769,12 @@ int vc_allocate(unsigned int currcons)	/
 	    visual_init(vc, currcons, 1);
 	    if (!*vc->vc_uni_pagedir_loc)
 		con_set_default_unimap(vc);
-	    if (!vc->vc_kmalloced)
-		vc->vc_screenbuf = kmalloc(vc->vc_screenbuf_size, GFP_KERNEL);
+	    vc->vc_screenbuf = kmalloc(vc->vc_screenbuf_size, GFP_KERNEL);
 	    if (!vc->vc_screenbuf) {
 		kfree(vc);
 		vc_cons[currcons].d = NULL;
 		return -ENOMEM;
 	    }
-	    vc->vc_kmalloced = 1;
 	    vc_init(vc, vc->vc_rows, vc->vc_cols, 1);
 	    vcs_make_sysfs(currcons);
 	    atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
@@ -912,10 +910,8 @@ static int vc_do_resize(struct tty_struc
 	if (new_scr_end > new_origin)
 		scr_memsetw((void *)new_origin, vc->vc_video_erase_char,
 			    new_scr_end - new_origin);
-	if (vc->vc_kmalloced)
-		kfree(vc->vc_screenbuf);
+	kfree(vc->vc_screenbuf);
 	vc->vc_screenbuf = newscreen;
-	vc->vc_kmalloced = 1;
 	vc->vc_screenbuf_size = new_screen_size;
 	set_origin(vc);
 
@@ -995,8 +991,7 @@ void vc_deallocate(unsigned int currcons
 		vc->vc_sw->con_deinit(vc);
 		put_pid(vc->vt_pid);
 		module_put(vc->vc_sw->owner);
-		if (vc->vc_kmalloced)
-			kfree(vc->vc_screenbuf);
+		kfree(vc->vc_screenbuf);
 		if (currcons >= MIN_NR_CONSOLES)
 			kfree(vc);
 		vc_cons[currcons].d = NULL;
@@ -2881,7 +2876,6 @@ static int __init con_init(void)
 		INIT_WORK(&vc_cons[currcons].SAK_work, vc_SAK);
 		visual_init(vc, currcons, 1);
 		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
-		vc->vc_kmalloced = 0;
 		vc_init(vc, vc->vc_rows, vc->vc_cols,
 			currcons || !vc->vc_sw->con_save_screen);
 	}
diff -puN include/linux/console_struct.h~vt-drop-bootmem-slab-memory-distinction include/linux/console_struct.h
--- a/include/linux/console_struct.h~vt-drop-bootmem-slab-memory-distinction
+++ a/include/linux/console_struct.h
@@ -89,7 +89,6 @@ struct vc_data {
 	unsigned int	vc_need_wrap	: 1;
 	unsigned int	vc_can_do_color	: 1;
 	unsigned int	vc_report_mouse : 2;
-	unsigned int	vc_kmalloced	: 1;
 	unsigned char	vc_utf		: 1;	/* Unicode UTF-8 encoding */
 	unsigned char	vc_utf_count;
 		 int	vc_utf_char;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

vt-drop-bootmem-slab-memory-distinction.patch
mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch

