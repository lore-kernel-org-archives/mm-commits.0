From: akpm@linux-foundation.org
Subject: [patch 05/15] initramfs: fix disabling of initramfs (and its
 compression)
Date: Fri, 02 Jun 2017 14:46:22 -0700
Message-ID: <5931dcae.MxYzfQAdHipxwPig%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51424 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVqX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:46:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, f.fainelli@gmail.com, daniel.thompson@linaro.org, mmarek@suse.cz, npiggin@gmail.com, pebolle@tiscali.nl, ppandit@redhat.com

From: Florian Fainelli <f.fainelli@gmail.com>
Subject: initramfs: fix disabling of initramfs (and its compression)

db2aa7fd15e8 ("initramfs: allow again choice of the embedded initram
compression algorithm") introduced the possibility to select the initramfs
compression algorithm from Kconfig and while this is a nice feature it
broke the use case described below.

Here is what my build system does:

- kernel is initially configured not to have an initramfs included

- build the user space root file system

- re-configure the kernel to have an initramfs included
  (CONFIG_INITRAMFS_SOURCE="/path/to/romfs") and set relevant
  CONFIG_INITRAMFS options, in my case, no compression option
  (CONFIG_INITRAMFS_COMPRESSION_NONE)

- kernel is re-built with these options -> kernel+initramfs image is
  copied

- kernel is re-built again without these options -> kernel image is
  copied

Building a kernel without an initramfs means setting this option:

CONFIG_INITRAMFS_SOURCE="" (and this one only)

whereas building a kernel with an initramfs means setting these options:

CONFIG_INITRAMFS_SOURCE="/home/fainelli/work/uclinux-rootfs/romfs
/home/fainelli/work/uclinux-rootfs/misc/initramfs.dev"
CONFIG_INITRAMFS_ROOT_UID=1000
CONFIG_INITRAMFS_ROOT_GID=1000
CONFIG_INITRAMFS_COMPRESSION_NONE=y
CONFIG_INITRAMFS_COMPRESSION=""

db2aa7fd15e85 ("initramfs: allow again choice of the embedded initram
compression algorithm") is problematic because
CONFIG_INITRAMFS_COMPRESSION which is used to determine the
initramfs_data.cpio extension/compression is a string, and due to how
Kconfig works it will evaluate in order, how to assign it.

Setting CONFIG_INITRAMFS_COMPRESSION_NONE with CONFIG_INITRAMFS_SOURCE=""
cannot possibly work (because of the depends on INITRAMFS_SOURCE!=""
imposed on CONFIG_INITRAMFS_COMPRESSION ) yet we still get
CONFIG_INITRAMFS_COMPRESSION assigned to ".gz" because CONFIG_RD_GZIP=y is
set in my kernel, even when there is no initramfs being built.

So we basically end-up generating two initramfs_data.cpio* files, one
without extension, and one with .gz.  This causes usr/Makefile to track
usr/initramfs_data.cpio.gz, and not usr/initramfs_data.cpio anymore, that
is also largely problematic after 9e3596b0c6539e ("kbuild: initramfs
cleanup, set target from Kconfig") because we used to track all possible
initramfs_data files in the $(targets) variable before that commit.

The end result is that the kernel with an initramfs clearly does not
contain what we expect it to, it has a stale initramfs_data.cpio file
built into it, and we keep re-generating an initramfs_data.cpio.gz file
which is not the one that we want to include in the kernel image proper.

The fix consists in hiding CONFIG_INITRAMFS_COMPRESSION when
CONFIG_INITRAMFS_SOURCE="".  This puts us back in a state to the pre-4.10
behavior where we can properly disable and re-enable initramfs within the
same kernel .config file, and be in control of what
CONFIG_INITRAMFS_COMPRESSION is set to.

Fixes: db2aa7fd15e8 ("initramfs: allow again choice of the embedded initram compression algorithm")
Fixes: 9e3596b0c653 ("kbuild: initramfs cleanup, set target from Kconfig")
Link: http://lkml.kernel.org/r/20170521033337.6197-1-f.fainelli@gmail.com
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Nicholas Piggin <npiggin@gmail.com>
Cc: P J P <ppandit@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 usr/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN usr/Kconfig~initramfs-fix-disabling-of-initramfs-and-its-compression usr/Kconfig
--- a/usr/Kconfig~initramfs-fix-disabling-of-initramfs-and-its-compression
+++ a/usr/Kconfig
@@ -220,6 +220,7 @@ config INITRAMFS_COMPRESSION_LZ4
 endchoice
 
 config INITRAMFS_COMPRESSION
+	depends on INITRAMFS_SOURCE!=""
 	string
 	default ""      if INITRAMFS_COMPRESSION_NONE
 	default ".gz"   if INITRAMFS_COMPRESSION_GZIP
_
