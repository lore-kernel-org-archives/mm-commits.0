From: akpm@linux-foundation.org
Subject: + compat_ioctl-remove-vt-specific-ioctl-handlers.patch added to -mm tree
Date: Thu, 15 Oct 2009 16:03:10 -0700
Message-ID: <200910152303.n9FN3AY9016763@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763092AbZJOXDz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 19:03:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnd@arndb.de, gregkh@suse.de


The patch titled
     compat_ioctl: remove VT specific ioctl handlers
has been added to the -mm tree.  Its filename is
     compat_ioctl-remove-vt-specific-ioctl-handlers.patch

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
Subject: compat_ioctl: remove VT specific ioctl handlers
From: Arnd Bergmann <arnd@arndb.de>

The VT driver now handles all of these ioctls directly, so we can remove
the handlers from common code.

These are the only handlers that require the BKL because they directly
perform the ioctl action rather than just converting the data structures. 
Once they are gone, we can remove the BKL from the remaining ioctl
conversion handlers.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/compat_ioctl.c~compat_ioctl-remove-vt-specific-ioctl-handlers fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~compat_ioctl-remove-vt-specific-ioctl-handlers
+++ a/fs/compat_ioctl.c
@@ -1039,161 +1039,6 @@ static int mt_ioctl_trans(unsigned int f
 
 #endif /* CONFIG_BLOCK */
 
-#ifdef CONFIG_VT
-
-static int vt_check(struct file *file)
-{
-	struct tty_struct *tty;
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct vc_data *vc;
-	
-	if (file->f_op->unlocked_ioctl != tty_ioctl)
-		return -EINVAL;
-	                
-	tty = (struct tty_struct *)file->private_data;
-	if (tty_paranoia_check(tty, inode, "tty_ioctl"))
-		return -EINVAL;
-	                                                
-	if (tty->ops->ioctl != vt_ioctl)
-		return -EINVAL;
-
-	vc = (struct vc_data *)tty->driver_data;
-	if (!vc_cons_allocated(vc->vc_num)) 	/* impossible? */
-		return -ENOIOCTLCMD;
-
-	/*
-	 * To have permissions to do most of the vt ioctls, we either have
-	 * to be the owner of the tty, or have CAP_SYS_TTY_CONFIG.
-	 */
-	if (current->signal->tty == tty || capable(CAP_SYS_TTY_CONFIG))
-		return 1;
-	return 0;                                                    
-}
-
-struct consolefontdesc32 {
-	unsigned short charcount;       /* characters in font (256 or 512) */
-	unsigned short charheight;      /* scan lines per character (1-32) */
-	compat_caddr_t chardata;	/* font data in expanded form */
-};
-
-static int do_fontx_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg, struct file *file)
-{
-	struct consolefontdesc32 __user *user_cfd = compat_ptr(arg);
-	struct console_font_op op;
-	compat_caddr_t data;
-	int i, perm;
-
-	perm = vt_check(file);
-	if (perm < 0) return perm;
-	
-	switch (cmd) {
-	case PIO_FONTX:
-		if (!perm)
-			return -EPERM;
-		op.op = KD_FONT_OP_SET;
-		op.flags = 0;
-		op.width = 8;
-		if (get_user(op.height, &user_cfd->charheight) ||
-		    get_user(op.charcount, &user_cfd->charcount) ||
-		    get_user(data, &user_cfd->chardata))
-			return -EFAULT;
-		op.data = compat_ptr(data);
-		return con_font_op(vc_cons[fg_console].d, &op);
-	case GIO_FONTX:
-		op.op = KD_FONT_OP_GET;
-		op.flags = 0;
-		op.width = 8;
-		if (get_user(op.height, &user_cfd->charheight) ||
-		    get_user(op.charcount, &user_cfd->charcount) ||
-		    get_user(data, &user_cfd->chardata))
-			return -EFAULT;
-		if (!data)
-			return 0;
-		op.data = compat_ptr(data);
-		i = con_font_op(vc_cons[fg_console].d, &op);
-		if (i)
-			return i;
-		if (put_user(op.height, &user_cfd->charheight) ||
-		    put_user(op.charcount, &user_cfd->charcount) ||
-		    put_user((compat_caddr_t)(unsigned long)op.data,
-				&user_cfd->chardata))
-			return -EFAULT;
-		return 0;
-	}
-	return -EINVAL;
-}
-
-struct console_font_op32 {
-	compat_uint_t op;        /* operation code KD_FONT_OP_* */
-	compat_uint_t flags;     /* KD_FONT_FLAG_* */
-	compat_uint_t width, height;     /* font size */
-	compat_uint_t charcount;
-	compat_caddr_t data;    /* font data with height fixed to 32 */
-};
-                                        
-static int do_kdfontop_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg, struct file *file)
-{
-	struct console_font_op op;
-	struct console_font_op32 __user *fontop = compat_ptr(arg);
-	int perm = vt_check(file), i;
-	struct vc_data *vc;
-	
-	if (perm < 0) return perm;
-	
-	if (copy_from_user(&op, fontop, sizeof(struct console_font_op32)))
-		return -EFAULT;
-	if (!perm && op.op != KD_FONT_OP_GET)
-		return -EPERM;
-	op.data = compat_ptr(((struct console_font_op32 *)&op)->data);
-	op.flags |= KD_FONT_FLAG_OLD;
-	vc = ((struct tty_struct *)file->private_data)->driver_data;
-	i = con_font_op(vc, &op);
-	if (i)
-		return i;
-	((struct console_font_op32 *)&op)->data = (unsigned long)op.data;
-	if (copy_to_user(fontop, &op, sizeof(struct console_font_op32)))
-		return -EFAULT;
-	return 0;
-}
-
-struct unimapdesc32 {
-	unsigned short entry_ct;
-	compat_caddr_t entries;
-};
-
-static int do_unimap_ioctl(unsigned int fd, unsigned int cmd, unsigned long arg, struct file *file)
-{
-	struct unimapdesc32 tmp;
-	struct unimapdesc32 __user *user_ud = compat_ptr(arg);
-	int perm = vt_check(file);
-	struct vc_data *vc;
-
-	if (perm < 0)
-		return perm;
-	if (copy_from_user(&tmp, user_ud, sizeof tmp))
-		return -EFAULT;
-	if (tmp.entries)
-		if (!access_ok(VERIFY_WRITE, compat_ptr(tmp.entries),
-				tmp.entry_ct*sizeof(struct unipair)))
-			return -EFAULT;
-	vc = ((struct tty_struct *)file->private_data)->driver_data;
-	switch (cmd) {
-	case PIO_UNIMAP:
-		if (!perm)
-			return -EPERM;
-		return con_set_unimap(vc, tmp.entry_ct,
-						compat_ptr(tmp.entries));
-	case GIO_UNIMAP:
-		if (!perm && fg_console != vc->vc_num)
-			return -EPERM;
-		return con_get_unimap(vc, tmp.entry_ct, &(user_ud->entry_ct),
-						compat_ptr(tmp.entries));
-	}
-	return 0;
-}
-
-#endif /* CONFIG_VT */
-
 static int do_smb_getmountuid(unsigned int fd, unsigned int cmd, unsigned long arg)
 {
 	mm_segment_t old_fs = get_fs();
@@ -1867,11 +1712,7 @@ COMPATIBLE_IOCTL(STOP_ARRAY_RO)
 COMPATIBLE_IOCTL(RESTART_ARRAY_RW)
 COMPATIBLE_IOCTL(GET_BITMAP_FILE)
 ULONG_IOCTL(SET_BITMAP_FILE)
-/* Big K */
-COMPATIBLE_IOCTL(PIO_FONT)
-COMPATIBLE_IOCTL(GIO_FONT)
-COMPATIBLE_IOCTL(PIO_CMAP)
-COMPATIBLE_IOCTL(GIO_CMAP)
+/* Keyboard -- can be removed once tty3270 uses ops->compat_ioctl */
 ULONG_IOCTL(KDSIGACCEPT)
 COMPATIBLE_IOCTL(KDGETKEYCODE)
 COMPATIBLE_IOCTL(KDSETKEYCODE)
@@ -1895,12 +1736,6 @@ COMPATIBLE_IOCTL(KDGKBLED)
 ULONG_IOCTL(KDSKBLED)
 COMPATIBLE_IOCTL(KDGETLED)
 ULONG_IOCTL(KDSETLED)
-COMPATIBLE_IOCTL(GIO_SCRNMAP)
-COMPATIBLE_IOCTL(PIO_SCRNMAP)
-COMPATIBLE_IOCTL(GIO_UNISCRNMAP)
-COMPATIBLE_IOCTL(PIO_UNISCRNMAP)
-COMPATIBLE_IOCTL(PIO_FONTRESET)
-COMPATIBLE_IOCTL(PIO_UNIMAPCLR)
 #ifdef CONFIG_BLOCK
 /* Big S */
 COMPATIBLE_IOCTL(SCSI_IOCTL_GET_IDLUN)
@@ -1924,20 +1759,6 @@ COMPATIBLE_IOCTL(TUNSETOFFLOAD)
 COMPATIBLE_IOCTL(TUNSETTXFILTER)
 COMPATIBLE_IOCTL(TUNGETSNDBUF)
 COMPATIBLE_IOCTL(TUNSETSNDBUF)
-/* Big V */
-COMPATIBLE_IOCTL(VT_SETMODE)
-COMPATIBLE_IOCTL(VT_GETMODE)
-COMPATIBLE_IOCTL(VT_GETSTATE)
-COMPATIBLE_IOCTL(VT_OPENQRY)
-ULONG_IOCTL(VT_ACTIVATE)
-ULONG_IOCTL(VT_WAITACTIVE)
-ULONG_IOCTL(VT_RELDISP)
-ULONG_IOCTL(VT_DISALLOCATE)
-COMPATIBLE_IOCTL(VT_RESIZE)
-COMPATIBLE_IOCTL(VT_RESIZEX)
-COMPATIBLE_IOCTL(VT_LOCKSWITCH)
-COMPATIBLE_IOCTL(VT_UNLOCKSWITCH)
-COMPATIBLE_IOCTL(VT_GETHIFONTMASK)
 /* Little p (/dev/rtc, /dev/envctrl, etc.) */
 COMPATIBLE_IOCTL(RTC_AIE_ON)
 COMPATIBLE_IOCTL(RTC_AIE_OFF)
@@ -2533,13 +2354,6 @@ HANDLE_IOCTL(MTIOCPOS32, mt_ioctl_trans)
 #endif
 #define AUTOFS_IOC_SETTIMEOUT32 _IOWR(0x93,0x64,unsigned int)
 HANDLE_IOCTL(AUTOFS_IOC_SETTIMEOUT32, ioc_settimeout)
-#ifdef CONFIG_VT
-HANDLE_IOCTL(PIO_FONTX, do_fontx_ioctl)
-HANDLE_IOCTL(GIO_FONTX, do_fontx_ioctl)
-HANDLE_IOCTL(PIO_UNIMAP, do_unimap_ioctl)
-HANDLE_IOCTL(GIO_UNIMAP, do_unimap_ioctl)
-HANDLE_IOCTL(KDFONTOP, do_kdfontop_ioctl)
-#endif
 /* One SMB ioctl needs translations. */
 #define SMB_IOC_GETMOUNTUID_32 _IOR('u', 1, compat_uid_t)
 HANDLE_IOCTL(SMB_IOC_GETMOUNTUID_32, do_smb_getmountuid)
_

Patches currently in -mm which might be from arnd@arndb.de are

origin.patch
linux-next.patch
compat_ioctl-remove-vt-specific-ioctl-handlers.patch
compat_ioctl-do-not-hold-bkl-in-handlers.patch

