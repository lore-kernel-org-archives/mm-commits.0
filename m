From: akpm@linux-foundation.org
Subject: +
 init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs.patch added to -mm tree
Date: Wed, 09 Oct 2013 14:48:57 -0700
Message-ID: <5255cf49.whzHVUOEushH0olh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55440 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab3JIVs6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Oct 2013 17:48:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, prasad@redhat.com

Subject: + init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs.patch added to -mm tree
To: prasad@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 09 Oct 2013 14:48:57 -0700


The patch titled
     Subject: init/do_mounts_rd.c: fix NULL pointer dereference while loading initramfs
has been added to the -mm tree.  Its filename is
     init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: P J P <prasad@redhat.com>
Subject: init/do_mounts_rd.c: fix NULL pointer dereference while loading initramfs

Make menuconfig allows one to choose compression format of an initial
ramdisk image.  But this choice does not result in duly compressed initial
ramdisk image.  Because - $ make install - does not pass on the selected
compression choice to the dracut(8) tool, which creates the initramfs
file.  dracut(8) generates the image with the default compression, ie. 
gzip(1).

If a user chose any other compression instead of gzip(1), it leads to a
crash due to NULL pointer dereference in crd_load(), caused by a NULL
function pointer returned by the 'decompress_method()' routine.  Because
the initramfs image is gzip(1) compressed, whereas the kernel knows only
to decompress the chosen format and not gzip(1).

This patch replaces the crash by an explicit panic() call with an
appropriate error message. This shall prevent the kernel from
eventually panicking in: init/do_mounts.c: mount_block_root() with
  -> panic("VFS: Unable to mount root fs on %s", b);

Signed-off-by: P J P <prasad@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/do_mounts_rd.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN init/do_mounts_rd.c~init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs init/do_mounts_rd.c
--- a/init/do_mounts_rd.c~init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs
+++ a/init/do_mounts_rd.c
@@ -342,6 +342,13 @@ static int __init crd_load(int in_fd, in
 	int result;
 	crd_infd = in_fd;
 	crd_outfd = out_fd;
+
+	if (!deco) {
+		pr_emerg("Invalid decompression routine: %p; "
+				 "Select appropriate config option.\n", deco);
+		panic("Could not decompress initial ramdisk image.");
+	}
+
 	result = deco(NULL, 0, compr_fill, compr_flush, NULL, NULL, error);
 	if (decompress_error)
 		result = 1;
_

Patches currently in -mm which might be from prasad@redhat.com are

init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch

