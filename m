From: akpm@linux-foundation.org
Subject: [folded] libfs-make-simple_read_from_buffer-conventional-fix-2.patch removed from -mm tree
Date: Thu, 02 Apr 2009 12:41:46 -0700
Message-ID: <200904021941.n32JfkGR013038@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753197AbZDBTsL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Apr 2009 15:48:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hpa@zytor.com, mingo@elte.hu, rostedt@goodmis.org, srostedt@redhat.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     libfs-make-simple_read_from_buffer-conventional-fix-2
has been removed from the -mm tree.  Its filename was
     libfs-make-simple_read_from_buffer-conventional-fix-2.patch

This patch was dropped because it was folded into libfs-make-simple_read_from_buffer-conventional.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: libfs-make-simple_read_from_buffer-conventional-fix-2
From: "H. Peter Anvin" <hpa@zytor.com>

Looking at the whole function, the code nowhere else looks for the case
count == 0, and as a result we end up returning -EFAULT for count == 0.

However, rather than backing out the above I think this is the better fix
for that problem.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <srostedt@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/libfs.c~libfs-make-simple_read_from_buffer-conventional-fix-2 fs/libfs.c
--- a/fs/libfs.c~libfs-make-simple_read_from_buffer-conventional-fix-2
+++ a/fs/libfs.c
@@ -530,7 +530,7 @@ ssize_t simple_read_from_buffer(void __u
 
 	if (pos < 0)
 		return -EINVAL;
-	if (pos >= available)
+	if (pos >= available || !count)
 		return 0;
 	if (count > available - pos)
 		count = available - pos;
_

Patches currently in -mm which might be from hpa@zytor.com are

origin.patch
linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
x86-simplify-highmem-related-kconfig-entries.patch
libfs-make-simple_read_from_buffer-conventional.patch
libfs-make-simple_read_from_buffer-conventional-fix-2.patch
tty-pty-lookup-retval-fixup.patch
signals-remove-handler-parameter-to-tracehook-functions.patch
sgi-gru-exclude-uv-definitions-on-32-bit-x86.patch
sgi-gru-add-definitions-of-x86_64-gru-mmrs.patch
sgi-gru-add-macros-for-using-the-uv-hub-to-send-interrupts.patch
preadv-pwritev-add-preadv-and-pwritev-system-calls.patch

