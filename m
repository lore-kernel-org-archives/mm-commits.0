From: akpm@osdl.org
Subject: - compat-fix-uaccess-handling.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:02:54 -0800
Message-ID: <200612072302.kB7N2s0u029905@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51884 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163819AbWLGXD1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: heiko.carstens@de.ibm.com, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     compat: fix uaccess handling
has been removed from the -mm tree.  Its filename was
     compat-fix-uaccess-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: compat: fix uaccess handling
From: Heiko Carstens <heiko.carstens@de.ibm.com>

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/compat.c       |   35 +++++++++++++++++++----------------
 fs/compat_ioctl.c |   33 ++++++++++++++++++++-------------
 2 files changed, 39 insertions(+), 29 deletions(-)

diff -puN fs/compat.c~compat-fix-uaccess-handling fs/compat.c
--- a/fs/compat.c~compat-fix-uaccess-handling
+++ a/fs/compat.c
@@ -1144,7 +1144,9 @@ asmlinkage long compat_sys_getdents64(un
 	lastdirent = buf.previous;
 	if (lastdirent) {
 		typeof(lastdirent->d_off) d_off = file->f_pos;
-		__put_user_unaligned(d_off, &lastdirent->d_off);
+		error = -EFAULT;
+		if (__put_user_unaligned(d_off, &lastdirent->d_off))
+			goto out_putf;
 		error = count - buf.count;
 	}
 
@@ -1611,14 +1613,14 @@ int compat_get_fd_set(unsigned long nr, 
 		nr &= ~1UL;
 		while (nr) {
 			unsigned long h, l;
-			__get_user(l, ufdset);
-			__get_user(h, ufdset+1);
+			if (__get_user(l, ufdset) || __get_user(h, ufdset+1))
+				return -EFAULT;
 			ufdset += 2;
 			*fdset++ = h << 32 | l;
 			nr -= 2;
 		}
-		if (odd)
-			__get_user(*fdset, ufdset);
+		if (odd && __get_user(*fdset, ufdset))
+			return -EFAULT;
 	} else {
 		/* Tricky, must clear full unsigned long in the
 		 * kernel fdset at the end, this makes sure that
@@ -1630,14 +1632,14 @@ int compat_get_fd_set(unsigned long nr, 
 }
 
 static
-void compat_set_fd_set(unsigned long nr, compat_ulong_t __user *ufdset,
-			unsigned long *fdset)
+int compat_set_fd_set(unsigned long nr, compat_ulong_t __user *ufdset,
+		      unsigned long *fdset)
 {
 	unsigned long odd;
 	nr = ROUND_UP(nr, __COMPAT_NFDBITS);
 
 	if (!ufdset)
-		return;
+		return 0;
 
 	odd = nr & 1UL;
 	nr &= ~1UL;
@@ -1645,13 +1647,14 @@ void compat_set_fd_set(unsigned long nr,
 		unsigned long h, l;
 		l = *fdset++;
 		h = l >> 32;
-		__put_user(l, ufdset);
-		__put_user(h, ufdset+1);
+		if (__put_user(l, ufdset) || __put_user(h, ufdset+1))
+			return -EFAULT;
 		ufdset += 2;
 		nr -= 2;
 	}
-	if (odd)
-		__put_user(*fdset, ufdset);
+	if (odd && __put_user(*fdset, ufdset))
+		return -EFAULT;
+	return 0;
 }
 
 
@@ -1726,10 +1729,10 @@ int compat_core_sys_select(int n, compat
 		ret = 0;
 	}
 
-	compat_set_fd_set(n, inp, fds.res_in);
-	compat_set_fd_set(n, outp, fds.res_out);
-	compat_set_fd_set(n, exp, fds.res_ex);
-
+	if (compat_set_fd_set(n, inp, fds.res_in) ||
+	    compat_set_fd_set(n, outp, fds.res_out) ||
+	    compat_set_fd_set(n, exp, fds.res_ex))
+		ret = -EFAULT;
 out:
 	kfree(bits);
 out_nofds:
diff -puN fs/compat_ioctl.c~compat-fix-uaccess-handling fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~compat-fix-uaccess-handling
+++ a/fs/compat_ioctl.c
@@ -211,8 +211,10 @@ static int do_video_stillpicture(unsigne
 	up_native =
 		compat_alloc_user_space(sizeof(struct video_still_picture));
 
-	put_user(compat_ptr(fp), &up_native->iFrame);
-	put_user(size, &up_native->size);
+	err =  put_user(compat_ptr(fp), &up_native->iFrame);
+	err |= put_user(size, &up_native->size);
+	if (err)
+		return -EFAULT;
 
 	err = sys_ioctl(fd, cmd, (unsigned long) up_native);
 
@@ -236,8 +238,10 @@ static int do_video_set_spu_palette(unsi
 	err |= get_user(length, &up->length);
 
 	up_native = compat_alloc_user_space(sizeof(struct video_spu_palette));
-	put_user(compat_ptr(palp), &up_native->palette);
-	put_user(length, &up_native->length);
+	err  = put_user(compat_ptr(palp), &up_native->palette);
+	err |= put_user(length, &up_native->length);
+	if (err)
+		return -EFAULT;
 
 	err = sys_ioctl(fd, cmd, (unsigned long) up_native);
 
@@ -2043,16 +2047,19 @@ static int serial_struct_ioctl(unsigned 
         struct serial_struct ss;
         mm_segment_t oldseg = get_fs();
         __u32 udata;
+	unsigned int base;
 
         if (cmd == TIOCSSERIAL) {
                 if (!access_ok(VERIFY_READ, ss32, sizeof(SS32)))
                         return -EFAULT;
                 if (__copy_from_user(&ss, ss32, offsetof(SS32, iomem_base)))
 			return -EFAULT;
-                __get_user(udata, &ss32->iomem_base);
+                if (__get_user(udata, &ss32->iomem_base))
+			return -EFAULT;
                 ss.iomem_base = compat_ptr(udata);
-                __get_user(ss.iomem_reg_shift, &ss32->iomem_reg_shift);
-                __get_user(ss.port_high, &ss32->port_high);
+                if (__get_user(ss.iomem_reg_shift, &ss32->iomem_reg_shift) ||
+		    __get_user(ss.port_high, &ss32->port_high))
+			return -EFAULT;
                 ss.iomap_base = 0UL;
         }
         set_fs(KERNEL_DS);
@@ -2063,12 +2070,12 @@ static int serial_struct_ioctl(unsigned 
                         return -EFAULT;
                 if (__copy_to_user(ss32,&ss,offsetof(SS32,iomem_base)))
 			return -EFAULT;
-                __put_user((unsigned long)ss.iomem_base  >> 32 ?
-                            0xffffffff : (unsigned)(unsigned long)ss.iomem_base,
-                            &ss32->iomem_base);
-                __put_user(ss.iomem_reg_shift, &ss32->iomem_reg_shift);
-                __put_user(ss.port_high, &ss32->port_high);
-
+		base = (unsigned long)ss.iomem_base  >> 32 ?
+			0xffffffff : (unsigned)(unsigned long)ss.iomem_base;
+		if (__put_user(base, &ss32->iomem_base) ||
+		    __put_user(ss.iomem_reg_shift, &ss32->iomem_reg_shift) ||
+		    __put_user(ss.port_high, &ss32->port_high))
+			return -EFAULT;
         }
         return err;
 }
_

Patches currently in -mm which might be from heiko.carstens@de.ibm.com are

origin.patch
git-s390.patch
s390-workqueue-fixes.patch
scsi-fix-uaccess-handling.patch

