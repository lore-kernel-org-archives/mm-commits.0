From: akpm@linux-foundation.org
Subject: - jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch removed from -mm tree
Date: Wed, 04 Apr 2007 19:00:23 -0700
Message-ID: <200704050200.l3520N0n004816@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38032 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286AbXDECAd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 4 Apr 2007 22:00:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     JFFS2: Delete everything related to obsolete JFFS2_PROC option
has been removed from the -mm tree.  Its filename was
     jffs2-delete-everything-related-to-obsolete-jffs2_proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: JFFS2: Delete everything related to obsolete JFFS2_PROC option
From: "Robert P. J. Day" <rpjday@mindspring.com>

Delete everything related to the apparently non-existent kernel config
option JFFS2_PROC.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/compr.c |  138 ---------------------------------------------
 fs/jffs2/compr.h |   10 ---
 2 files changed, 148 deletions(-)

diff -puN fs/jffs2/compr.c~jffs2-delete-everything-related-to-obsolete-jffs2_proc fs/jffs2/compr.c
--- a/fs/jffs2/compr.c~jffs2-delete-everything-related-to-obsolete-jffs2_proc
+++ a/fs/jffs2/compr.c
@@ -268,144 +268,6 @@ int jffs2_unregister_compressor(struct j
         return 0;
 }
 
-#ifdef CONFIG_JFFS2_PROC
-
-#define JFFS2_STAT_BUF_SIZE 16000
-
-char *jffs2_list_compressors(void)
-{
-        struct jffs2_compressor *this;
-        char *buf, *act_buf;
-
-        act_buf = buf = kmalloc(JFFS2_STAT_BUF_SIZE,GFP_KERNEL);
-        list_for_each_entry(this, &jffs2_compressor_list, list) {
-                act_buf += sprintf(act_buf, "%10s priority:%d ", this->name, this->priority);
-                if ((this->disabled)||(!this->compress))
-                        act_buf += sprintf(act_buf,"disabled");
-                else
-                        act_buf += sprintf(act_buf,"enabled");
-                act_buf += sprintf(act_buf,"\n");
-        }
-        return buf;
-}
-
-char *jffs2_stats(void)
-{
-        struct jffs2_compressor *this;
-        char *buf, *act_buf;
-
-        act_buf = buf = kmalloc(JFFS2_STAT_BUF_SIZE,GFP_KERNEL);
-
-        act_buf += sprintf(act_buf,"JFFS2 compressor statistics:\n");
-        act_buf += sprintf(act_buf,"%10s   ","none");
-        act_buf += sprintf(act_buf,"compr: %d blocks (%d)  decompr: %d blocks\n", none_stat_compr_blocks,
-                           none_stat_compr_size, none_stat_decompr_blocks);
-        spin_lock(&jffs2_compressor_list_lock);
-        list_for_each_entry(this, &jffs2_compressor_list, list) {
-                act_buf += sprintf(act_buf,"%10s ",this->name);
-                if ((this->disabled)||(!this->compress))
-                        act_buf += sprintf(act_buf,"- ");
-                else
-                        act_buf += sprintf(act_buf,"+ ");
-                act_buf += sprintf(act_buf,"compr: %d blocks (%d/%d)  decompr: %d blocks ", this->stat_compr_blocks,
-                                   this->stat_compr_new_size, this->stat_compr_orig_size,
-                                   this->stat_decompr_blocks);
-                act_buf += sprintf(act_buf,"\n");
-        }
-        spin_unlock(&jffs2_compressor_list_lock);
-
-        return buf;
-}
-
-char *jffs2_get_compression_mode_name(void)
-{
-        switch (jffs2_compression_mode) {
-        case JFFS2_COMPR_MODE_NONE:
-                return "none";
-        case JFFS2_COMPR_MODE_PRIORITY:
-                return "priority";
-        case JFFS2_COMPR_MODE_SIZE:
-                return "size";
-        }
-        return "unkown";
-}
-
-int jffs2_set_compression_mode_name(const char *name)
-{
-        if (!strcmp("none",name)) {
-                jffs2_compression_mode = JFFS2_COMPR_MODE_NONE;
-                return 0;
-        }
-        if (!strcmp("priority",name)) {
-                jffs2_compression_mode = JFFS2_COMPR_MODE_PRIORITY;
-                return 0;
-        }
-        if (!strcmp("size",name)) {
-                jffs2_compression_mode = JFFS2_COMPR_MODE_SIZE;
-                return 0;
-        }
-        return 1;
-}
-
-static int jffs2_compressor_Xable(const char *name, int disabled)
-{
-        struct jffs2_compressor *this;
-        spin_lock(&jffs2_compressor_list_lock);
-        list_for_each_entry(this, &jffs2_compressor_list, list) {
-                if (!strcmp(this->name, name)) {
-                        this->disabled = disabled;
-                        spin_unlock(&jffs2_compressor_list_lock);
-                        return 0;
-                }
-        }
-        spin_unlock(&jffs2_compressor_list_lock);
-        printk(KERN_WARNING "JFFS2: compressor %s not found.\n",name);
-        return 1;
-}
-
-int jffs2_enable_compressor_name(const char *name)
-{
-        return jffs2_compressor_Xable(name, 0);
-}
-
-int jffs2_disable_compressor_name(const char *name)
-{
-        return jffs2_compressor_Xable(name, 1);
-}
-
-int jffs2_set_compressor_priority(const char *name, int priority)
-{
-        struct jffs2_compressor *this,*comp;
-        spin_lock(&jffs2_compressor_list_lock);
-        list_for_each_entry(this, &jffs2_compressor_list, list) {
-                if (!strcmp(this->name, name)) {
-                        this->priority = priority;
-                        comp = this;
-                        goto reinsert;
-                }
-        }
-        spin_unlock(&jffs2_compressor_list_lock);
-        printk(KERN_WARNING "JFFS2: compressor %s not found.\n",name);
-        return 1;
-reinsert:
-        /* list is sorted in the order of priority, so if
-           we change it we have to reinsert it into the
-           good place */
-        list_del(&comp->list);
-        list_for_each_entry(this, &jffs2_compressor_list, list) {
-                if (this->priority < comp->priority) {
-                        list_add(&comp->list, this->list.prev);
-                        spin_unlock(&jffs2_compressor_list_lock);
-                        return 0;
-                }
-        }
-        list_add_tail(&comp->list, &jffs2_compressor_list);
-        spin_unlock(&jffs2_compressor_list_lock);
-        return 0;
-}
-
-#endif
-
 void jffs2_free_comprbuf(unsigned char *comprbuf, unsigned char *orig)
 {
         if (orig != comprbuf)
diff -puN fs/jffs2/compr.h~jffs2-delete-everything-related-to-obsolete-jffs2_proc fs/jffs2/compr.h
--- a/fs/jffs2/compr.h~jffs2-delete-everything-related-to-obsolete-jffs2_proc
+++ a/fs/jffs2/compr.h
@@ -76,16 +76,6 @@ int jffs2_decompress(struct jffs2_sb_inf
 
 void jffs2_free_comprbuf(unsigned char *comprbuf, unsigned char *orig);
 
-#ifdef CONFIG_JFFS2_PROC
-int jffs2_enable_compressor_name(const char *name);
-int jffs2_disable_compressor_name(const char *name);
-int jffs2_set_compression_mode_name(const char *mode_name);
-char *jffs2_get_compression_mode_name(void);
-int jffs2_set_compressor_priority(const char *mode_name, int priority);
-char *jffs2_list_compressors(void);
-char *jffs2_stats(void);
-#endif
-
 /* Compressor modules */
 /* These functions will be called by jffs2_compressors_init/exit */
 
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
git-powerpc.patch
remove-unused-header-file-arch-ppc-syslib-cpc710h.patch
remove-unused-header-file-arch-powerpc-platforms-83xx-mpc834x_itxh.patch
git-drm.patch
git-input.patch
git-mtd.patch
git-netdev-all.patch
delete-unused-header-file-linux-sdla_frh.patch
delete-unused-header-file-linux-if_wanpipe_commonh.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
