From: akpm@linux-foundation.org
Subject: [to-be-updated] vt-add-ioctl-commands-to-dev-vcsan-to-get-put-the-current-palette-of-the-given-tty.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:20:44 -0700
Message-ID: <200904011820.n31IKi5O003093@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759359AbZDASW4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 14:22:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sed@free.fr, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     vt: add ioctl commands to /dev/vcsaN to get/put the current palette of the given tty
has been removed from the -mm tree.  Its filename was
     vt-add-ioctl-commands-to-dev-vcsan-to-get-put-the-current-palette-of-the-given-tty.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vt: add ioctl commands to /dev/vcsaN to get/put the current palette of the given tty
From: Cedric Roux <sed@free.fr>

A ioctl interface and two ioctl commands added to /dev/vcsaN to get/put
the current palette of the given tty.

This patch exists because there is no way to get the current installed
palette of a given tty.  The PIO_CMAP and GIO_CMAP in vt_ioctl.c:vt_ioctl
play with the global default colormap.  And /dev/vcsaN don't dump the
palette through their read interface.  And since a user may change colors
of a given tty by escape sequences, one should be able to retrieve the
palette through /dev/vcsaN, leading to this patch.

Some points I am not fully confident with:

- vt.c:set_colormap is now used in vc_screen.c so cannot be static
  anymore.
  The goal of this patch is to allow read access to the palette,
  I can remove the PIO_CMAP case and make set_colormap static again.
  This case is there because /dev/vcsaN is read/write so the access
  to the palette should also be read/write. (Or I can do it
  differently, no problem, just tell me how.)

- the palette is returned as it is stored in the kernel, without
  taking into account color_table. So if a userland program
  gets an attribute for a given character, it won't match
  with the palette information. Say the user reads 0xXY through
  /dev/vcsa and takes Y as an index in the palette, it will return
  a bad color. One should do palette[color_table[Y]] to get the real
  color.

  Two "solutions" to this "problem" (it might be an non-issue):
    + export the palette by indexing with color_table:
      I don't like it.
    + let the userland program deal with that:
      the program may open a tty, send escape sequences to
      set the current color, write a character at a given position
      (through the tty, not /dev/vcs) and read back the attribute
      through /dev/vcsa this time. She will see what attribute
      corresponds to what color she sets by using escape sequences.

  If the color_table is non-mutable, all this is a non-issue.
  Userland programs just store the color_table and live with that.
  I've seen no code that modifies the color_table, so I bet it's
  non-mutable. (May it change in the future?)

- lock_kernel() is called. Maybe it's not necessary? I'm not
  confident enough. You decide.

- release_console_sem() is called before calling copy_from/to_user
  as is done in vcs_write/vcs_read, once again I am not confident
  with that.

Signed-off-by: Cedric Roux <sed@free.fr>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vc_screen.c |   66 +++++++++++++++++++++++++++++++++++++
 drivers/char/vt.c        |    3 -
 include/linux/vt_kern.h  |    1 
 3 files changed, 68 insertions(+), 2 deletions(-)

diff -puN drivers/char/vc_screen.c~vt-add-ioctl-commands-to-dev-vcsan-to-get-put-the-current-palette-of-the-given-tty drivers/char/vc_screen.c
--- a/drivers/char/vc_screen.c~vt-add-ioctl-commands-to-dev-vcsan-to-get-put-the-current-palette-of-the-given-tty
+++ a/drivers/char/vc_screen.c
@@ -19,6 +19,8 @@
  * machek@k332.feld.cvut.cz - modified not to send characters to wrong console
  *	 - fixed some fatal off-by-one bugs (0-- no longer == -1 -> looping and looping and looping...)
  *	 - making it shorter - scr_readw are macros which expand in PRETTY long code
+ *
+ * Colormap put/get for /dev/vcsaN, Cedric Roux <sed@free.fr>, March 2009.
  */
 
 #include <linux/kernel.h>
@@ -470,11 +472,75 @@ vcs_open(struct inode *inode, struct fil
 	return ret;
 }
 
+static long
+vcs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	unsigned int currcons = iminor(file->f_path.dentry->d_inode);
+	struct vc_data *vc;
+	unsigned char pal[16*3];
+	long ret = 0;
+
+	/* access only defined for /dev/vcsaN, not /dev/vcsN */
+	if (currcons < 128)
+		return -ENOTTY;
+
+	lock_kernel();
+
+	acquire_console_sem();
+
+	currcons &= 127;
+	if (currcons == 0)
+		currcons = fg_console;
+	else
+		currcons--;
+	if (!vc_cons_allocated(currcons)) {
+		ret = -ENXIO;
+		goto unlock_out;
+	}
+	vc = vc_cons[currcons].d;
+
+	switch (cmd) {
+	case PIO_CMAP:
+		release_console_sem();
+		ret = copy_from_user(pal, (void __user *)arg, 16*3);
+		acquire_console_sem();
+
+		if (ret) {
+			ret = -EFAULT;
+			goto unlock_out;
+		}
+		memcpy(vc->vc_palette, pal, 16*3);
+		set_palette(vc);
+		break;
+	case GIO_CMAP:
+		release_console_sem();
+		ret = copy_to_user((void __user *)arg, vc->vc_palette, 16*3);
+		acquire_console_sem();
+
+		if (ret) {
+			ret = -EFAULT;
+			goto unlock_out;
+		}
+		break;
+	default:
+		ret = -ENOIOCTLCMD;
+		break;
+	}
+
+unlock_out:
+	release_console_sem();
+
+	unlock_kernel();
+
+	return ret;
+}
+
 static const struct file_operations vcs_fops = {
 	.llseek		= vcs_lseek,
 	.read		= vcs_read,
 	.write		= vcs_write,
 	.open		= vcs_open,
+	.unlocked_ioctl	= vcs_ioctl,
 };
 
 static struct class *vc_class;
diff -puN drivers/char/vt.c~vt-add-ioctl-commands-to-dev-vcsan-to-get-put-the-current-palette-of-the-given-tty drivers/char/vt.c
--- a/drivers/char/vt.c~vt-add-ioctl-commands-to-dev-vcsan-to-get-put-the-current-palette-of-the-given-tty
+++ a/drivers/char/vt.c
@@ -156,7 +156,6 @@ static void set_cursor(struct vc_data *v
 static void hide_cursor(struct vc_data *vc);
 static void console_callback(struct work_struct *ignored);
 static void blank_screen_t(unsigned long dummy);
-static void set_palette(struct vc_data *vc);
 
 static int printable;		/* Is console ready for printing? */
 int default_utf8 = true;
@@ -3754,7 +3753,7 @@ void poke_blanked_console(void)
  *	Palettes
  */
 
-static void set_palette(struct vc_data *vc)
+void set_palette(struct vc_data *vc)
 {
 	WARN_CONSOLE_UNLOCKED();
 
diff -puN include/linux/vt_kern.h~vt-add-ioctl-commands-to-dev-vcsan-to-get-put-the-current-palette-of-the-given-tty include/linux/vt_kern.h
--- a/include/linux/vt_kern.h~vt-add-ioctl-commands-to-dev-vcsan-to-get-put-the-current-palette-of-the-given-tty
+++ a/include/linux/vt_kern.h
@@ -97,6 +97,7 @@ void reset_vc(struct vc_data *vc);
 extern int unbind_con_driver(const struct consw *csw, int first, int last,
 			     int deflt);
 int vty_init(const struct file_operations *console_fops);
+void set_palette(struct vc_data *vc);
 
 /*
  * vc_screen.c shares this temporary buffer with the console write code so that
_

Patches currently in -mm which might be from sed@free.fr are

vt-add-ioctl-commands-to-dev-vcsan-to-get-put-the-current-palette-of-the-given-tty.patch

