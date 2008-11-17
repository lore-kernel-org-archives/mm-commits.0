From: akpm@linux-foundation.org
Subject: + viafb-fix-releasing-of-proc-viafb-subtree.patch added to -mm tree
Date: Sun, 16 Nov 2008 17:21:10 -0800
Message-ID: <200811170121.mAH1LAjK026127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752604AbYKQBVT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Nov 2008 20:21:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bonbons@linux-vserver.org, JosephChan@via.com.tw


The patch titled
     viafb: fix releasing of /proc/viafb/ subtree
has been added to the -mm tree.  Its filename is
     viafb-fix-releasing-of-proc-viafb-subtree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: viafb: fix releasing of /proc/viafb/ subtree
=46rom: Bruno Pr=E9mont <bonbons@linux-vserver.org>

When unloading viafb module it does not remove it's /proc/viafb/ subtre=
e
which causes multiple viafb directories to appear below proc when
mobprobing viafb and also lets kernel WARN() on duplicate proc entries:

[  145.458387] WARNING: at /usr/src/linux-2.6.28-rc3-git6/fs/proc/gener=
ic.c:551 proc_register+0xe6/0x160()
[  145.458945] proc_dir_entry '/proc/viafb' already registered
[  145.459278] Modules linked in: viafb(+) i2c_algo_bit cfbcopyarea cfb=
imgblt cfbfillrect snd_hda_intel snd_pcm snd_timer snd soundcore snd_pa=
ge_alloc sg via_agp agpgart [last unloaded: drm]
[  145.460647] Pid: 1904, comm: modprobe Tainted: G        W  2.6.28-rc=
3-git6 #4
[  145.461064] Call Trace:
[  145.461248]  [<c01066f1>] ? dump_stack+0x1/0x80
[  145.461533]  [<c01228a3>] warn_slowpath+0x63/0x80
[  145.461851]  [<c0253ec9>] ? idr_get_empty_slot+0xe9/0x250
[  145.462186]  [<c0254120>] ? ida_get_new_above+0xf0/0x150
[  145.462528]  [<c019fb86>] proc_register+0xe6/0x160
[  145.462827]  [<c019fdc6>] proc_mkdir_mode+0x36/0x50
[  145.463135]  [<c019fdef>] proc_mkdir+0xf/0x20
[  145.463457]  [<f807173c>] viafb_init+0x73c/0xc86 [viafb]
[  145.463823]  [<f8071000>] ? viafb_init+0x0/0xc86 [viafb]
[  145.464147]  [<c010111d>] do_one_initcall+0x2d/0x160
[  145.464460]  [<c01a6543>] ? sysfs_add_file+0x13/0x20
[  145.464786]  [<c015f031>] ? vfree+0x21/0x30
[  145.465049]  [<c01433b5>] ? load_module+0x1215/0x1500
[  145.465381]  [<c014e455>] ? __alloc_pages_internal+0x95/0x400
[  145.465755]  [<c0143723>] sys_init_module+0x83/0x1a0
[  145.466065]  [<c016ceed>] ? sys_read+0x3d/0x70
[  145.466354]  [<c0103bc1>] sysenter_do_call+0x12/0x25
[  145.466653] ---[ end trace c84b37826e16748c ]---

Signed-off-by: Bruno Pr=E9mont <bonbons@linux-vserver.org>
Cc: <JosephChan@via.com.tw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/via/viafbdev.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff -puN drivers/video/via/viafbdev.c~viafb-fix-releasing-of-proc-viaf=
b-subtree drivers/video/via/viafbdev.c
--- a/drivers/video/via/viafbdev.c~viafb-fix-releasing-of-proc-viafb-su=
btree
+++ a/drivers/video/via/viafbdev.c
@@ -2046,30 +2046,30 @@ static int viafb_vt1636_proc_write(struc
 	return count;
 }
=20
-static void viafb_init_proc(struct proc_dir_entry *viafb_entry)
+static void viafb_init_proc(struct proc_dir_entry **viafb_entry)
 {
 	struct proc_dir_entry *entry;
-	viafb_entry =3D proc_mkdir("viafb", NULL);
+	*viafb_entry =3D proc_mkdir("viafb", NULL);
 	if (viafb_entry) {
-		entry =3D create_proc_entry("dvp0", 0, viafb_entry);
+		entry =3D create_proc_entry("dvp0", 0, *viafb_entry);
 		if (entry) {
 			entry->owner =3D THIS_MODULE;
 			entry->read_proc =3D viafb_dvp0_proc_read;
 			entry->write_proc =3D viafb_dvp0_proc_write;
 		}
-		entry =3D create_proc_entry("dvp1", 0, viafb_entry);
+		entry =3D create_proc_entry("dvp1", 0, *viafb_entry);
 		if (entry) {
 			entry->owner =3D THIS_MODULE;
 			entry->read_proc =3D viafb_dvp1_proc_read;
 			entry->write_proc =3D viafb_dvp1_proc_write;
 		}
-		entry =3D create_proc_entry("dfph", 0, viafb_entry);
+		entry =3D create_proc_entry("dfph", 0, *viafb_entry);
 		if (entry) {
 			entry->owner =3D THIS_MODULE;
 			entry->read_proc =3D viafb_dfph_proc_read;
 			entry->write_proc =3D viafb_dfph_proc_write;
 		}
-		entry =3D create_proc_entry("dfpl", 0, viafb_entry);
+		entry =3D create_proc_entry("dfpl", 0, *viafb_entry);
 		if (entry) {
 			entry->owner =3D THIS_MODULE;
 			entry->read_proc =3D viafb_dfpl_proc_read;
@@ -2078,7 +2078,7 @@ static void viafb_init_proc(struct proc_
 		if (VT1636_LVDS =3D=3D viaparinfo->chip_info->lvds_chip_info.
 			lvds_chip_name || VT1636_LVDS =3D=3D
 		    viaparinfo->chip_info->lvds_chip_info2.lvds_chip_name) {
-			entry =3D create_proc_entry("vt1636", 0, viafb_entry);
+			entry =3D create_proc_entry("vt1636", 0, *viafb_entry);
 			if (entry) {
 				entry->owner =3D THIS_MODULE;
 				entry->read_proc =3D viafb_vt1636_proc_read;
@@ -2097,6 +2097,7 @@ static void viafb_remove_proc(struct pro
 	remove_proc_entry("dfpl", viafb_entry);
 	remove_proc_entry("vt1636", viafb_entry);
 	remove_proc_entry("vt1625", viafb_entry);
+	remove_proc_entry("viafb", NULL);
 }
=20
 static int __devinit via_pci_probe(void)
@@ -2358,7 +2359,7 @@ static int __devinit via_pci_probe(void)
 		  viafbinfo->node, viafbinfo->fix.id, default_var.xres,
 		  default_var.yres, default_var.bits_per_pixel);
=20
-	viafb_init_proc(viaparinfo->proc_entry);
+	viafb_init_proc(&viaparinfo->proc_entry);
 	viafb_init_dac(IGA2);
 	return 0;
 }
_

Patches currently in -mm which might be from bonbons@linux-vserver.org =
are

viafb-fix-releasing-of-proc-viafb-subtree.patch
viafb-fix-crashes-due-to-4k-stack-overflow.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
