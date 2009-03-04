From: akpm@linux-foundation.org
Subject: + i810-fix-kernel-crash-fix-when-struct-fb_var_screeninfo-is-supplied.patch added to -mm tree
Date: Wed, 04 Mar 2009 15:13:03 -0800
Message-ID: <200903042313.n24ND3pW014301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307AbZCDXNr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Mar 2009 18:13:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.cuella@supinfo.com, jkosina@suse.cz, krzysztof.h1@poczta.fm


The patch titled
     i810: fix kernel crash fix when struct fb_var_screeninfo is supplied
has been added to the -mm tree.  Its filename is
     i810-fix-kernel-crash-fix-when-struct-fb_var_screeninfo-is-supplied.patch

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
Subject: i810: fix kernel crash fix when struct fb_var_screeninfo is supplied
From: Samuel CUELLA <samuel.cuella@supinfo.com>

Prevent the kernel from being crashed by a divide-by-zero operation when
supplied an incorrectly filled 'struct fb_var_screeninfo' from userland.

Previously i810_main.c:1005 (i810_check_params) was using the global
'yres' symbol previously defined at i810_main.c:145 as a module parameter
value holder (i810_main.c:2174).  If i810fb is compiled-in or if this
param doesn't get a default value, this direct usage leads to a
divide-by-zero at i810_main.c:1005 (i810_check_params).  The patch simply
replace the 'yres' global, perhaps undefined symbol usage by a given
parameter structure lookup.

This problem occurs with directfb, mplayer -vo fbdev, SDL library.
It was also reported ( but non solved ) at : http://mail.directfb.org/pipermail/directfb-dev/2008-March/004050.html
Sample code to reproduce :

/*Comile with gcc crashfb.c -o crashfb*/
#include <fcntl.h>
#include <linux/fb.h>
#include <stdio.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <string.h>
#include <stdlib.h>

#define FB "/dev/fb0"

int main(){
        int fd;
        int rv;
        struct fb_var_screeninfo vinfo;

        fd = open(FB,O_RDWR);
        if( fd ){
                vinfo.xres = 800;
                vinfo.yres = 600;
                rv =ioctl(fd, FBIOPUT_VSCREENINFO, &vinfo);
        }
        return(rv);
}

Leads to this crash dump:
divide error: 0000 [#1]
last sysfs file: /sys/kernel/uevent_seqnum
Modules linked in:

Pid: 4058, comm: crashfb Not tainted (2.6.28 #4)
EIP: 0060:[<c02558c8>] EFLAGS: 00010202 CPU: 0
EIP is at i810fb_check_var+0x428/0x520
EAX: 00400000 EBX: ce9d5e44 ECX: 001209a0 EDX: 00000000
ESI: 00000020 EDI: 00000004 EBP: 00000000 ESP: ce9d5d0c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process crashfb (pid: 4058, ti=ce9d4000 task=cf8af0e0 task.ti=ce9d4000)
Stack:
 c014f993 00000000 00000001 00000000 00000000 00400000 0000001a cf811000
 08048268 cf81123c 00000258 00000320 ffffffed cf811015 ce9d5e45 cf811000
 c0224821 ce9d5e44 ce9b09a0 00000000 00012000 00000000 c0111a89 00000001
Call Trace:
 [<c014f993>] handle_mm_fault+0x5c3/0x650
 [<c0224821>] fb_set_var+0x61/0x2d0
 [<c0111a89>] do_page_fault+0x3a9/0x8b0
 [<c016c935>] do_lookup+0x65/0x1a0
 [<c02257aa>] fb_ioctl+0x21a/0x3c0
 [<c014f577>] handle_mm_fault+0x1a7/0x650
 [<c0225590>] fb_ioctl+0x0/0x3c0
 [<c017077f>] vfs_ioctl+0x1f/0x70
 [<c017096c>] do_vfs_ioctl+0x5c/0x430
 [<c0111a89>] do_page_fault+0x3a9/0x8b0
 [<c0170d7d>] sys_ioctl+0x3d/0x70
 [<c0103af9>] sysenter_do_call+0x12/0x25
Code: c0 0f 44 d0 89 54 24 04 e8 b6 5a ec ff b8 ea ff ff ff 83 c4 30 5b 5e 5f 5d c3 8b 2d ac 0e 4a c0 31 d2 89 f7 8b 44 24 14 c1 ef 03 <f7> f5 31 d2 f7 f7 3b 03 89 c7 0f 83 3c fd ff ff 89 c2 89 f1 89
EIP: [<c02558c8>] i810fb_check_var+0x428/0x520 SS:ESP 0068:ce9d5d0c
---[ end trace 1840767f449d222e ]---

Despite this dump says that EIP was in 'i810fb_check_var' the divide by
zero truly occurs in 'i810_check_params' called by 'i810fb_check_var'
(i810_main.c:1466).

Signed-off-by: Samuel CUELLA <samuel.cuella@supinfo.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/i810/i810_main.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/i810/i810_main.c~i810-fix-kernel-crash-fix-when-struct-fb_var_screeninfo-is-supplied drivers/video/i810/i810_main.c
--- a/drivers/video/i810/i810_main.c~i810-fix-kernel-crash-fix-when-struct-fb_var_screeninfo-is-supplied
+++ a/drivers/video/i810/i810_main.c
@@ -993,6 +993,8 @@ static int i810_check_params(struct fb_v
 	struct i810fb_par *par = info->par;
 	int line_length, vidmem, mode_valid = 0, retval = 0;
 	u32 vyres = var->yres_virtual, vxres = var->xres_virtual;
+	u32 yres = info->var.yres;
+
 	/*
 	 *  Memory limit
 	 */
_

Patches currently in -mm which might be from samuel.cuella@supinfo.com are

i810-fix-kernel-crash-fix-when-struct-fb_var_screeninfo-is-supplied.patch

