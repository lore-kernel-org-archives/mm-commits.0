From: akpm@linux-foundation.org
Subject: [merged] initramfs-support-initrd-that-is-bigger-than-2gib.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:41:24 -0700
Message-ID: <53ea6de4.Lt+ARH+/8/VPf8po%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ig0-f202.google.com ([209.85.213.202]:39857 "EHLO
	mail-ig0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbaHLTlZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:41:25 -0400
Received: by mail-ig0-f202.google.com with SMTP id r2so1069744igi.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:41:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, dan@danweeks.net, geert@linux-m68k.org, hpa@zytor.com, mingo@elte.hu, penguin-kernel@i-love.sakura.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: initramfs: support initrd that is bigger than 2GiB
has been removed from the -mm tree.  Its filename was
     initramfs-support-initrd-that-is-bigger-than-2gib.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: initramfs: support initrd that is bigger than 2GiB

When initrd (compressed or not) is used, kernel report data corrupted with
/dev/ram0.

The root cause:
During initramfs checking, if it is initrd, it will be transferred to
/initrd.image with sys_write.
sys_write only support 2G-4K write, so if the initrd ram is more than
that, /initrd.image will not complete at all.

Add local xwrite to loop calling sys_write to workaround the problem.

Also need to use xwrite in write_buffer() to handle:
image is uncompressed cpio and there is one big file (>2G) in it.
   unpack_to_rootfs ===> write_buffer ===> actions[]/do_copy

At the same time, we don't need to worry about sys_read/sys_write in
do_mounts_rd.c::crd_load.  As decompressor will have fill/flush and local
buffer that is smaller than 2G.

Test with uncompressed initrd, and compressed ones with gz, bz2, lzma,xz,
lzop.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: "Daniel M. Weeks" <dan@danweeks.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/initramfs.c |   36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff -puN init/initramfs.c~initramfs-support-initrd-that-is-bigger-than-2gib init/initramfs.c
--- a/init/initramfs.c~initramfs-support-initrd-that-is-bigger-than-2gib
+++ a/init/initramfs.c
@@ -19,6 +19,29 @@
 #include <linux/syscalls.h>
 #include <linux/utime.h>
 
+static ssize_t __init xwrite(int fd, const char *p, size_t count)
+{
+	ssize_t out = 0;
+
+	/* sys_write only can write MAX_RW_COUNT aka 2G-4K bytes at most */
+	while (count) {
+		ssize_t rv = sys_write(fd, p, count);
+
+		if (rv < 0) {
+			if (rv == -EINTR || rv == -EAGAIN)
+				continue;
+			return out ? out : rv;
+		} else if (rv == 0)
+			break;
+
+		p += rv;
+		out += rv;
+		count -= rv;
+	}
+
+	return out;
+}
+
 static __initdata char *message;
 static void __init error(char *x)
 {
@@ -346,7 +369,7 @@ static int __init do_name(void)
 static int __init do_copy(void)
 {
 	if (count >= body_len) {
-		sys_write(wfd, victim, body_len);
+		xwrite(wfd, victim, body_len);
 		sys_close(wfd);
 		do_utime(vcollected, mtime);
 		kfree(vcollected);
@@ -354,7 +377,7 @@ static int __init do_copy(void)
 		state = SkipIt;
 		return 0;
 	} else {
-		sys_write(wfd, victim, count);
+		xwrite(wfd, victim, count);
 		body_len -= count;
 		eat(count);
 		return 1;
@@ -603,8 +626,13 @@ static int __init populate_rootfs(void)
 		fd = sys_open("/initrd.image",
 			      O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
-			sys_write(fd, (char *)initrd_start,
-					initrd_end - initrd_start);
+			ssize_t written = xwrite(fd, (char *)initrd_start,
+						initrd_end - initrd_start);
+
+			if (written != initrd_end - initrd_start)
+				pr_err("/initrd.image: incomplete write (%zd != %ld)\n",
+				       written, initrd_end - initrd_start);
+
 			sys_close(fd);
 			free_initrd();
 		}
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
linux-next.patch

