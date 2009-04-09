From: akpm@linux-foundation.org
Subject: + initramfs-fix-initramfs-to-work-with-hardlinked-init.patch added to -mm tree
Date: Thu, 09 Apr 2009 16:25:36 -0700
Message-ID: <200904092325.n39NPaLK020690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761869AbZDIX2s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 19:28:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rmrobert@vmware.com, dhowells@redhat.com, hpa@zytor.com, lethal@linux-sh.org


The patch titled
     initramfs: fix initramfs to work with hardlinked init
has been added to the -mm tree.  Its filename is
     initramfs-fix-initramfs-to-work-with-hardlinked-init.patch

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
Subject: initramfs: fix initramfs to work with hardlinked init
From: Randy Robertson <rmrobert@vmware.com>

Change cb6ff208076b5f434db1b8c983429269d719cef5 ("NOMMU: Support XIP on
initramfs") seems to have broken booting from initramfs with /sbin/init
being a hardlink.

It seems like the logic required for XIP on nommu, i.e.  ftruncate to
reported cpio header file size (body_len) is broken for hardlinks, which
have a reported size of 0, and the truncate thus nukes the contents of the
file (in my case busybox), making boot impossible and ending with runaway
loop modprobe binfmt-0000 - and of course 0000 is not a valid binary
format.

My fix is to only call ftruncate if size is non-zero which fixes things
for me, but I'm not certain whether this will break XIP for those files on
nommu systems, although I would guess not.

Signed-off-by: Randy Robertson <rmrobert@vmware.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN init/initramfs.c~initramfs-fix-initramfs-to-work-with-hardlinked-init init/initramfs.c
--- a/init/initramfs.c~initramfs-fix-initramfs-to-work-with-hardlinked-init
+++ a/init/initramfs.c
@@ -310,7 +310,8 @@ static int __init do_name(void)
 			if (wfd >= 0) {
 				sys_fchown(wfd, uid, gid);
 				sys_fchmod(wfd, mode);
-				sys_ftruncate(wfd, body_len);
+				if (body_len)
+					sys_ftruncate(wfd, body_len);
 				vcollected = kstrdup(collected, GFP_KERNEL);
 				state = CopyFile;
 			}
_

Patches currently in -mm which might be from rmrobert@vmware.com are

initramfs-fix-initramfs-to-work-with-hardlinked-init.patch

