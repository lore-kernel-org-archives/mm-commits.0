From: akpm@osdl.org
Subject: + use-__u64-rather-than-u64-in-parisc-statfs-structs.patch added to -mm tree
Date: Sun, 28 Jan 2007 16:26:40 -0800
Message-ID: <200701290026.l0T0QeIR006984@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43416 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933012AbXA2A0o (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 28 Jan 2007 19:26:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, kyle@mcmartin.ca


The patch titled
     use __u64 rather than u64 in parisc statfs structs
has been added to the -mm tree.  Its filename is
     use-__u64-rather-than-u64-in-parisc-statfs-structs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: use __u64 rather than u64 in parisc statfs structs
From: Mike Frysinger <vapier@gentoo.org>

Use __u64 rather than u64 in the struct statfs64 exported to userspace.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-parisc/statfs.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN include/asm-parisc/statfs.h~use-__u64-rather-than-u64-in-parisc-statfs-structs include/asm-parisc/statfs.h
--- a/include/asm-parisc/statfs.h~use-__u64-rather-than-u64-in-parisc-statfs-structs
+++ a/include/asm-parisc/statfs.h
@@ -30,11 +30,11 @@ struct statfs {
 struct statfs64 {
 	long f_type;
 	long f_bsize;
-	u64 f_blocks;
-	u64 f_bfree;
-	u64 f_bavail;
-	u64 f_files;
-	u64 f_ffree;
+	__u64 f_blocks;
+	__u64 f_bfree;
+	__u64 f_bavail;
+	__u64 f_files;
+	__u64 f_ffree;
 	__kernel_fsid_t f_fsid;
 	long f_namelen;
 	long f_frsize;
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
use-__u8-__u32-in-userspace-ioctl-defines-for-i2o.patch
use-__u8-rather-than-u8-in-userspace-size-defines-in-hdregh.patch
search-a-little-harder-for-mkimage.patch
use-__u64-rather-than-u64-in-parisc-statfs-structs.patch
use-__u32-rather-than-u32-in-userspace-ioctls-in-usbdevice_fsh.patch
some-rtc-documentation-updates.patch
