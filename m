From: akpm@linux-foundation.org
Subject: [merged] treewide-use-__printf-not-__attribute__formatprintf.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:14:32 -0700
Message-ID: <201111012114.pA1LEW2e032055@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29847 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KAVOi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:14:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: treewide: use __printf not __attribute__((format(printf,...)))
has been removed from the -mm tree.  Its filename was
     treewide-use-__printf-not-__attribute__formatprintf.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: treewide: use __printf not __attribute__((format(printf,...)))

Standardize the style for compiler based printf format verification.
Standardized the location of __printf too.

Done via script and a little typing.

$ grep -rPl --include=*.[ch] -w "__attribute__" * | \
  grep -vP "^(tools|scripts|include/linux/compiler-gcc.h)" | \
  xargs perl -n -i -e 'local $/; while (<>) { s/\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf\s*,\s*(.+)\s*,\s*(.+)\s*\)\s*\)\s*\)/__printf($1, $2)/g ; print; }'

[akpm@linux-foundation.org: revert arch bits]
Signed-off-by: Joe Perches <joe@perches.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/callc.c                   |    4 
 drivers/isdn/hisax/hisax.h                   |    4 
 drivers/isdn/hisax/isdnl1.h                  |    2 
 drivers/isdn/hisax/isdnl3.c                  |    2 
 drivers/isdn/hisax/st5481_d.c                |    4 
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h |    3 
 drivers/net/wireless/ath/ath.h               |    5 
 drivers/net/wireless/ath/ath5k/debug.h       |    4 
 drivers/net/wireless/ath/ath6kl/debug.h      |    4 
 drivers/net/wireless/b43/b43.h               |   12 -
 drivers/net/wireless/b43legacy/b43legacy.h   |   16 +-
 drivers/staging/iio/trigger.h                |    3 
 fs/ecryptfs/ecryptfs_kernel.h                |    2 
 fs/ext2/ext2.h                               |    8 -
 fs/ext4/ext4.h                               |   44 +++---
 fs/fat/fat.h                                 |    9 -
 fs/gfs2/glock.h                              |    2 
 fs/hpfs/hpfs_fn.h                            |    4 
 fs/nilfs2/nilfs.h                            |    8 -
 fs/ntfs/debug.h                              |   15 +-
 fs/ocfs2/super.h                             |   14 --
 fs/partitions/ldm.c                          |   16 +-
 fs/udf/udfdecl.h                             |    4 
 fs/ufs/ufs.h                                 |    9 -
 fs/xfs/xfs_message.h                         |   42 +++---
 include/asm-generic/bug.h                    |   11 -
 include/drm/drmP.h                           |   10 -
 include/linux/audit.h                        |   11 -
 include/linux/blktrace_api.h                 |    2 
 include/linux/device.h                       |  110 +++++++----------
 include/linux/dynamic_debug.h                |   19 +-
 include/linux/ext3_fs.h                      |   16 +-
 include/linux/fs.h                           |    4 
 include/linux/fscache-cache.h                |    8 -
 include/linux/gameport.h                     |    8 -
 include/linux/kallsyms.h                     |    5 
 include/linux/kdb.h                          |    9 -
 include/linux/kernel.h                       |   44 +++---
 include/linux/kexec.h                        |    4 
 include/linux/kmod.h                         |    4 
 include/linux/kobject.h                      |   26 +---
 include/linux/kthread.h                      |    4 
 include/linux/libata.h                       |   18 +-
 include/linux/mmiotrace.h                    |    8 -
 include/linux/netdevice.h                    |   34 ++---
 include/linux/printk.h                       |   12 -
 include/linux/quotaops.h                     |    2 
 include/linux/seq_file.h                     |    3 
 include/linux/trace_seq.h                    |    8 -
 include/net/bluetooth/bluetooth.h            |    2 
 include/net/netfilter/nf_log.h               |    3 
 include/net/sock.h                           |    4 
 include/sound/core.h                         |    4 
 include/sound/info.h                         |    4 
 include/sound/seq_kernel.h                   |    4 
 include/xen/hvc-console.h                    |    4 
 include/xen/xenbus.h                         |   12 -
 net/nfc/nfc.h                                |    2 
 net/rds/rds.h                                |    8 -
 net/sunrpc/svc.c                             |    5 
 sound/firewire/cmp.c                         |    2 
 61 files changed, 324 insertions(+), 350 deletions(-)

diff -puN drivers/isdn/hisax/callc.c~treewide-use-__printf-not-__attribute__formatprintf drivers/isdn/hisax/callc.c
--- a/drivers/isdn/hisax/callc.c~treewide-use-__printf-not-__attribute__formatprintf
+++ a/drivers/isdn/hisax/callc.c
@@ -65,7 +65,7 @@ hisax_findcard(int driverid)
 	return (struct IsdnCardState *) 0;
 }
 
-static __attribute__((format(printf, 3, 4))) void
+static __printf(3, 4) void
 link_debug(struct Channel *chanp, int direction, char *fmt, ...)
 {
 	va_list args;
@@ -1068,7 +1068,7 @@ init_d_st(struct Channel *chanp)
 	return 0;
 }
 
-static __attribute__((format(printf, 2, 3))) void
+static __printf(2, 3) void
 callc_debug(struct FsmInst *fi, char *fmt, ...)
 {
 	va_list args;
diff -puN drivers/isdn/hisax/hisax.h~treewide-use-__printf-not-__attribute__formatprintf drivers/isdn/hisax/hisax.h
--- a/drivers/isdn/hisax/hisax.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/drivers/isdn/hisax/hisax.h
@@ -1287,9 +1287,9 @@ int jiftime(char *s, long mark);
 
 int HiSax_command(isdn_ctrl * ic);
 int HiSax_writebuf_skb(int id, int chan, int ack, struct sk_buff *skb);
-__attribute__((format(printf, 3, 4)))
+__printf(3, 4)
 void HiSax_putstatus(struct IsdnCardState *cs, char *head, char *fmt, ...);
-__attribute__((format(printf, 3, 0)))
+__printf(3, 0)
 void VHiSax_putstatus(struct IsdnCardState *cs, char *head, char *fmt, va_list args);
 void HiSax_reportcard(int cardnr, int sel);
 int QuickHex(char *txt, u_char * p, int cnt);
diff -puN drivers/isdn/hisax/isdnl1.h~treewide-use-__printf-not-__attribute__formatprintf drivers/isdn/hisax/isdnl1.h
--- a/drivers/isdn/hisax/isdnl1.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/drivers/isdn/hisax/isdnl1.h
@@ -21,7 +21,7 @@
 #define B_XMTBUFREADY	1
 #define B_ACKPENDING	2
 
-__attribute__((format(printf, 2, 3)))
+__printf(2, 3)
 void debugl1(struct IsdnCardState *cs, char *fmt, ...);
 void DChannel_proc_xmt(struct IsdnCardState *cs);
 void DChannel_proc_rcv(struct IsdnCardState *cs);
diff -puN drivers/isdn/hisax/isdnl3.c~treewide-use-__printf-not-__attribute__formatprintf drivers/isdn/hisax/isdnl3.c
--- a/drivers/isdn/hisax/isdnl3.c~treewide-use-__printf-not-__attribute__formatprintf
+++ a/drivers/isdn/hisax/isdnl3.c
@@ -66,7 +66,7 @@ static char *strL3Event[] =
 	"EV_TIMEOUT",
 };
 
-static __attribute__((format(printf, 2, 3))) void
+static __printf(2, 3) void
 l3m_debug(struct FsmInst *fi, char *fmt, ...)
 {
 	va_list args;
diff -puN drivers/isdn/hisax/st5481_d.c~treewide-use-__printf-not-__attribute__formatprintf drivers/isdn/hisax/st5481_d.c
--- a/drivers/isdn/hisax/st5481_d.c~treewide-use-__printf-not-__attribute__formatprintf
+++ a/drivers/isdn/hisax/st5481_d.c
@@ -167,7 +167,7 @@ static struct FsmNode L1FnList[] __initd
 	{ST_L1_F8, EV_IND_RSY,           l1_ignore},
 };
 
-static __attribute__((format(printf, 2, 3)))
+static __printf(2, 3)
 void l1m_debug(struct FsmInst *fi, char *fmt, ...)
 {
 	va_list args;
@@ -270,7 +270,7 @@ static char *strDoutEvent[] =
 	"EV_DOUT_UNDERRUN",
 };
 
-static __attribute__((format(printf, 2, 3)))
+static __printf(2, 3)
 void dout_debug(struct FsmInst *fi, char *fmt, ...)
 {
 	va_list args;
diff -puN drivers/net/ethernet/mellanox/mlx4/mlx4_en.h~treewide-use-__printf-not-__attribute__formatprintf drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -581,8 +581,9 @@ extern const struct ethtool_ops mlx4_en_
  * printk / logging functions
  */
 
+__printf(3, 4)
 int en_print(const char *level, const struct mlx4_en_priv *priv,
-	     const char *format, ...) __attribute__ ((format (printf, 3, 4)));
+	     const char *format, ...);
 
 #define en_dbg(mlevel, priv, format, arg...)			\
 do {								\
diff -puN drivers/net/wireless/ath/ath.h~treewide-use-__printf-not-__attribute__formatprintf drivers/net/wireless/ath/ath.h
--- a/drivers/net/wireless/ath/ath.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/drivers/net/wireless/ath/ath.h
@@ -173,8 +173,7 @@ bool ath_hw_keyreset(struct ath_common *
 void ath_hw_cycle_counters_update(struct ath_common *common);
 int32_t ath_hw_get_listen_time(struct ath_common *common);
 
-extern __attribute__((format (printf, 2, 3)))
-void ath_printk(const char *level, const char *fmt, ...);
+extern __printf(2, 3) void ath_printk(const char *level, const char *fmt, ...);
 
 #define _ath_printk(level, common, fmt, ...)			\
 do {								\
@@ -258,7 +257,7 @@ do {									\
 
 #else
 
-static inline  __attribute__((format (printf, 3, 4)))
+static inline  __attribute__ ((format (printf, 3, 4)))
 void ath_dbg(struct ath_common *common, enum ATH_DEBUG dbg_mask,
 	     const char *fmt, ...)
 {
diff -puN drivers/net/wireless/ath/ath5k/debug.h~treewide-use-__printf-not-__attribute__formatprintf drivers/net/wireless/ath/ath5k/debug.h
--- a/drivers/net/wireless/ath/ath5k/debug.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/drivers/net/wireless/ath/ath5k/debug.h
@@ -141,10 +141,10 @@ ath5k_debug_printtxbuf(struct ath5k_hw *
 
 #include <linux/compiler.h>
 
-static inline void __attribute__ ((format (printf, 3, 4)))
+static inline __printf(3, 4) void
 ATH5K_DBG(struct ath5k_hw *ah, unsigned int m, const char *fmt, ...) {}
 
-static inline void __attribute__ ((format (printf, 3, 4)))
+static inline __printf(3, 4) void
 ATH5K_DBG_UNLIMIT(struct ath5k_hw *ah, unsigned int m, const char *fmt, ...)
 {}
 
diff -puN drivers/net/wireless/ath/ath6kl/debug.h~treewide-use-__printf-not-__attribute__formatprintf drivers/net/wireless/ath/ath6kl/debug.h
--- a/drivers/net/wireless/ath/ath6kl/debug.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/drivers/net/wireless/ath/ath6kl/debug.h
@@ -44,8 +44,8 @@ enum ATH6K_DEBUG_MASK {
 };
 
 extern unsigned int debug_mask;
-extern int ath6kl_printk(const char *level, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
+extern __printf(2, 3)
+int ath6kl_printk(const char *level, const char *fmt, ...);
 
 #define ath6kl_info(fmt, ...)				\
 	ath6kl_printk(KERN_INFO, fmt, ##__VA_ARGS__)
diff -puN drivers/net/wireless/b43/b43.h~treewide-use-__printf-not-__attribute__formatprintf drivers/net/wireless/b43/b43.h
--- a/drivers/net/wireless/b43/b43.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/drivers/net/wireless/b43/b43.h
@@ -1011,14 +1011,10 @@ static inline bool b43_using_pio_transfe
 }
 
 /* Message printing */
-void b43info(struct b43_wl *wl, const char *fmt, ...)
-    __attribute__ ((format(printf, 2, 3)));
-void b43err(struct b43_wl *wl, const char *fmt, ...)
-    __attribute__ ((format(printf, 2, 3)));
-void b43warn(struct b43_wl *wl, const char *fmt, ...)
-    __attribute__ ((format(printf, 2, 3)));
-void b43dbg(struct b43_wl *wl, const char *fmt, ...)
-    __attribute__ ((format(printf, 2, 3)));
+__printf(2, 3) void b43info(struct b43_wl *wl, const char *fmt, ...);
+__printf(2, 3) void b43err(struct b43_wl *wl, const char *fmt, ...);
+__printf(2, 3) void b43warn(struct b43_wl *wl, const char *fmt, ...);
+__printf(2, 3) void b43dbg(struct b43_wl *wl, const char *fmt, ...);
 
 
 /* A WARN_ON variant that vanishes when b43 debugging is disabled.
diff -puN drivers/net/wireless/b43legacy/b43legacy.h~treewide-use-__printf-not-__attribute__formatprintf drivers/net/wireless/b43legacy/b43legacy.h
--- a/drivers/net/wireless/b43legacy/b43legacy.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/drivers/net/wireless/b43legacy/b43legacy.h
@@ -810,15 +810,15 @@ struct b43legacy_lopair *b43legacy_get_l
 
 
 /* Message printing */
-void b43legacyinfo(struct b43legacy_wl *wl, const char *fmt, ...)
-		__attribute__((format(printf, 2, 3)));
-void b43legacyerr(struct b43legacy_wl *wl, const char *fmt, ...)
-		__attribute__((format(printf, 2, 3)));
-void b43legacywarn(struct b43legacy_wl *wl, const char *fmt, ...)
-		__attribute__((format(printf, 2, 3)));
+__printf(2, 3)
+void b43legacyinfo(struct b43legacy_wl *wl, const char *fmt, ...);
+__printf(2, 3)
+void b43legacyerr(struct b43legacy_wl *wl, const char *fmt, ...);
+__printf(2, 3)
+void b43legacywarn(struct b43legacy_wl *wl, const char *fmt, ...);
 #if B43legacy_DEBUG
-void b43legacydbg(struct b43legacy_wl *wl, const char *fmt, ...)
-		__attribute__((format(printf, 2, 3)));
+__printf(2, 3)
+void b43legacydbg(struct b43legacy_wl *wl, const char *fmt, ...);
 #else /* DEBUG */
 # define b43legacydbg(wl, fmt...) do { /* nothing */ } while (0)
 #endif /* DEBUG */
diff -puN drivers/staging/iio/trigger.h~treewide-use-__printf-not-__attribute__formatprintf drivers/staging/iio/trigger.h
--- a/drivers/staging/iio/trigger.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/drivers/staging/iio/trigger.h
@@ -115,8 +115,7 @@ void iio_trigger_poll_chained(struct iio
 
 irqreturn_t iio_trigger_generic_data_rdy_poll(int irq, void *private);
 
-struct iio_trigger *iio_allocate_trigger(const char *fmt, ...)
-	__attribute__((format(printf, 1, 2)));
+__printf(1, 2) struct iio_trigger *iio_allocate_trigger(const char *fmt, ...);
 void iio_free_trigger(struct iio_trigger *trig);
 
 #endif /* _IIO_TRIGGER_H_ */
diff -puN fs/ecryptfs/ecryptfs_kernel.h~treewide-use-__printf-not-__attribute__formatprintf fs/ecryptfs/ecryptfs_kernel.h
--- a/fs/ecryptfs/ecryptfs_kernel.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/ecryptfs/ecryptfs_kernel.h
@@ -514,7 +514,7 @@ ecryptfs_set_dentry_lower_mnt(struct den
 
 #define ecryptfs_printk(type, fmt, arg...) \
         __ecryptfs_printk(type "%s: " fmt, __func__, ## arg);
-__attribute__ ((format(printf, 1, 2)))
+__printf(1, 2)
 void __ecryptfs_printk(const char *fmt, ...);
 
 extern const struct file_operations ecryptfs_main_fops;
diff -puN fs/ext2/ext2.h~treewide-use-__printf-not-__attribute__formatprintf fs/ext2/ext2.h
--- a/fs/ext2/ext2.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/ext2/ext2.h
@@ -135,10 +135,10 @@ extern long ext2_compat_ioctl(struct fil
 struct dentry *ext2_get_parent(struct dentry *child);
 
 /* super.c */
-extern void ext2_error (struct super_block *, const char *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern void ext2_msg(struct super_block *, const char *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
+extern __printf(3, 4)
+void ext2_error(struct super_block *, const char *, const char *, ...);
+extern __printf(3, 4)
+void ext2_msg(struct super_block *, const char *, const char *, ...);
 extern void ext2_update_dynamic_rev (struct super_block *sb);
 extern void ext2_write_super (struct super_block *);
 
diff -puN fs/ext4/ext4.h~treewide-use-__printf-not-__attribute__formatprintf fs/ext4/ext4.h
--- a/fs/ext4/ext4.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/ext4/ext4.h
@@ -1878,40 +1878,40 @@ extern int ext4_group_extend(struct supe
 extern void *ext4_kvmalloc(size_t size, gfp_t flags);
 extern void *ext4_kvzalloc(size_t size, gfp_t flags);
 extern void ext4_kvfree(void *ptr);
-extern void __ext4_error(struct super_block *, const char *, unsigned int,
-			 const char *, ...)
-	__attribute__ ((format (printf, 4, 5)));
+extern __printf(4, 5)
+void __ext4_error(struct super_block *, const char *, unsigned int,
+		  const char *, ...);
 #define ext4_error(sb, message...)	__ext4_error(sb, __func__,	\
 						     __LINE__, ## message)
-extern void ext4_error_inode(struct inode *, const char *, unsigned int,
-			     ext4_fsblk_t, const char *, ...)
-	__attribute__ ((format (printf, 5, 6)));
-extern void ext4_error_file(struct file *, const char *, unsigned int,
-			    ext4_fsblk_t, const char *, ...)
-	__attribute__ ((format (printf, 5, 6)));
+extern __printf(5, 6)
+void ext4_error_inode(struct inode *, const char *, unsigned int, ext4_fsblk_t,
+		      const char *, ...);
+extern __printf(5, 6)
+void ext4_error_file(struct file *, const char *, unsigned int, ext4_fsblk_t,
+		     const char *, ...);
 extern void __ext4_std_error(struct super_block *, const char *,
 			     unsigned int, int);
-extern void __ext4_abort(struct super_block *, const char *, unsigned int,
-		       const char *, ...)
-	__attribute__ ((format (printf, 4, 5)));
+extern __printf(4, 5)
+void __ext4_abort(struct super_block *, const char *, unsigned int,
+		  const char *, ...);
 #define ext4_abort(sb, message...)	__ext4_abort(sb, __func__, \
 						       __LINE__, ## message)
-extern void __ext4_warning(struct super_block *, const char *, unsigned int,
-			  const char *, ...)
-	__attribute__ ((format (printf, 4, 5)));
+extern __printf(4, 5)
+void __ext4_warning(struct super_block *, const char *, unsigned int,
+		    const char *, ...);
 #define ext4_warning(sb, message...)	__ext4_warning(sb, __func__, \
 						       __LINE__, ## message)
-extern void ext4_msg(struct super_block *, const char *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
+extern __printf(3, 4)
+void ext4_msg(struct super_block *, const char *, const char *, ...);
 extern void __dump_mmp_msg(struct super_block *, struct mmp_struct *mmp,
 			   const char *, unsigned int, const char *);
 #define dump_mmp_msg(sb, mmp, msg)	__dump_mmp_msg(sb, mmp, __func__, \
 						       __LINE__, msg)
-extern void __ext4_grp_locked_error(const char *, unsigned int, \
-				    struct super_block *, ext4_group_t, \
-				    unsigned long, ext4_fsblk_t, \
-				    const char *, ...)
-	__attribute__ ((format (printf, 7, 8)));
+extern __printf(7, 8)
+void __ext4_grp_locked_error(const char *, unsigned int,
+			     struct super_block *, ext4_group_t,
+			     unsigned long, ext4_fsblk_t,
+			     const char *, ...);
 #define ext4_grp_locked_error(sb, grp, message...) \
 	__ext4_grp_locked_error(__func__, __LINE__, (sb), (grp), ## message)
 extern void ext4_update_dynamic_rev(struct super_block *sb);
diff -puN fs/fat/fat.h~treewide-use-__printf-not-__attribute__formatprintf fs/fat/fat.h
--- a/fs/fat/fat.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/fat/fat.h
@@ -326,15 +326,14 @@ extern int fat_fill_super(struct super_b
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
 /* fat/misc.c */
-extern void
-__fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
-	__attribute__ ((format (printf, 3, 4))) __cold;
+extern __printf(3, 4) __cold
+void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...);
 #define fat_fs_error(sb, fmt, args...)		\
 	__fat_fs_error(sb, 1, fmt , ## args)
 #define fat_fs_error_ratelimit(sb, fmt, args...) \
 	__fat_fs_error(sb, __ratelimit(&MSDOS_SB(sb)->ratelimit), fmt , ## args)
-void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...)
-	__attribute__ ((format (printf, 3, 4))) __cold;
+__printf(3, 4) __cold
+void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
 extern int fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
 extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
diff -puN fs/gfs2/glock.h~treewide-use-__printf-not-__attribute__formatprintf fs/gfs2/glock.h
--- a/fs/gfs2/glock.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/gfs2/glock.h
@@ -201,7 +201,7 @@ int gfs2_glock_nq_m(unsigned int num_gh,
 void gfs2_glock_dq_m(unsigned int num_gh, struct gfs2_holder *ghs);
 void gfs2_glock_dq_uninit_m(unsigned int num_gh, struct gfs2_holder *ghs);
 
-__attribute__ ((format(printf, 2, 3)))
+__printf(2, 3)
 void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...);
 
 /**
diff -puN fs/hpfs/hpfs_fn.h~treewide-use-__printf-not-__attribute__formatprintf fs/hpfs/hpfs_fn.h
--- a/fs/hpfs/hpfs_fn.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/hpfs/hpfs_fn.h
@@ -311,8 +311,8 @@ static inline struct hpfs_sb_info *hpfs_
 
 /* super.c */
 
-void hpfs_error(struct super_block *, const char *, ...)
-	__attribute__((format (printf, 2, 3)));
+__printf(2, 3)
+void hpfs_error(struct super_block *, const char *, ...);
 int hpfs_stop_cycles(struct super_block *, int, int *, int *, char *);
 unsigned hpfs_count_one_bitmap(struct super_block *, secno);
 
diff -puN fs/nilfs2/nilfs.h~treewide-use-__printf-not-__attribute__formatprintf fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/nilfs2/nilfs.h
@@ -276,10 +276,10 @@ int nilfs_fiemap(struct inode *inode, st
 /* super.c */
 extern struct inode *nilfs_alloc_inode(struct super_block *);
 extern void nilfs_destroy_inode(struct inode *);
-extern void nilfs_error(struct super_block *, const char *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern void nilfs_warning(struct super_block *, const char *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
+extern __printf(3, 4)
+void nilfs_error(struct super_block *, const char *, const char *, ...);
+extern __printf(3, 4)
+void nilfs_warning(struct super_block *, const char *, const char *, ...);
 extern struct nilfs_super_block *
 nilfs_read_super_block(struct super_block *, u64, int, struct buffer_head **);
 extern int nilfs_store_magic_and_option(struct super_block *,
diff -puN fs/ntfs/debug.h~treewide-use-__printf-not-__attribute__formatprintf fs/ntfs/debug.h
--- a/fs/ntfs/debug.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/ntfs/debug.h
@@ -30,8 +30,9 @@
 
 extern int debug_msgs;
 
-extern void __ntfs_debug(const char *file, int line, const char *function,
-	const char *format, ...) __attribute__ ((format (printf, 4, 5)));
+extern __printf(4, 5)
+void __ntfs_debug(const char *file, int line, const char *function,
+		  const char *format, ...);
 /**
  * ntfs_debug - write a debug level message to syslog
  * @f:		a printf format string containing the message
@@ -52,12 +53,14 @@ extern void ntfs_debug_dump_runlist(cons
 
 #endif	/* !DEBUG */
 
-extern void __ntfs_warning(const char *function, const struct super_block *sb,
-		const char *fmt, ...) __attribute__ ((format (printf, 3, 4)));
+extern  __printf(3, 4)
+void __ntfs_warning(const char *function, const struct super_block *sb,
+		    const char *fmt, ...);
 #define ntfs_warning(sb, f, a...)	__ntfs_warning(__func__, sb, f, ##a)
 
-extern void __ntfs_error(const char *function, const struct super_block *sb,
-		const char *fmt, ...) __attribute__ ((format (printf, 3, 4)));
+extern  __printf(3, 4)
+void __ntfs_error(const char *function, const struct super_block *sb,
+		  const char *fmt, ...);
 #define ntfs_error(sb, f, a...)		__ntfs_error(__func__, sb, f, ##a)
 
 #endif /* _LINUX_NTFS_DEBUG_H */
diff -puN fs/ocfs2/super.h~treewide-use-__printf-not-__attribute__formatprintf fs/ocfs2/super.h
--- a/fs/ocfs2/super.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/ocfs2/super.h
@@ -31,17 +31,15 @@ extern struct workqueue_struct *ocfs2_wq
 int ocfs2_publish_get_mount_state(struct ocfs2_super *osb,
 				  int node_num);
 
-void __ocfs2_error(struct super_block *sb,
-		   const char *function,
-		   const char *fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
+__printf(3, 4)
+void __ocfs2_error(struct super_block *sb, const char *function,
+		   const char *fmt, ...);
 
 #define ocfs2_error(sb, fmt, args...) __ocfs2_error(sb, __PRETTY_FUNCTION__, fmt, ##args)
 
-void __ocfs2_abort(struct super_block *sb,
-		   const char *function,
-		   const char *fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
+__printf(3, 4)
+void __ocfs2_abort(struct super_block *sb, const char *function,
+		   const char *fmt, ...);
 
 #define ocfs2_abort(sb, fmt, args...) __ocfs2_abort(sb, __PRETTY_FUNCTION__, fmt, ##args)
 
diff -puN fs/partitions/ldm.c~treewide-use-__printf-not-__attribute__formatprintf fs/partitions/ldm.c
--- a/fs/partitions/ldm.c~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/partitions/ldm.c
@@ -49,18 +49,20 @@
 #define ldm_error(f, a...) _ldm_printk (KERN_ERR,   __func__, f, ##a)
 #define ldm_info(f, a...)  _ldm_printk (KERN_INFO,  __func__, f, ##a)
 
-__attribute__ ((format (printf, 3, 4)))
-static void _ldm_printk (const char *level, const char *function,
-			 const char *fmt, ...)
+static __printf(3, 4)
+void _ldm_printk(const char *level, const char *function, const char *fmt, ...)
 {
-	static char buf[128];
+	struct va_format vaf;
 	va_list args;
 
 	va_start (args, fmt);
-	vsnprintf (buf, sizeof (buf), fmt, args);
-	va_end (args);
 
-	printk ("%s%s(): %s\n", level, function, buf);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk("%s%s(): %pV\n", level, function, &vaf);
+
+	va_end(args);
 }
 
 /**
diff -puN fs/udf/udfdecl.h~treewide-use-__printf-not-__attribute__formatprintf fs/udf/udfdecl.h
--- a/fs/udf/udfdecl.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/udf/udfdecl.h
@@ -112,8 +112,8 @@ struct extent_position {
 
 /* super.c */
 
-__attribute__((format(printf, 3, 4)))
-extern void udf_warning(struct super_block *, const char *, const char *, ...);
+extern __printf(3, 4) void udf_warning(struct super_block *, const char *,
+					const char *, ...);
 static inline void udf_updated_lvid(struct super_block *sb)
 {
 	struct buffer_head *bh = UDF_SB(sb)->s_lvid_bh;
diff -puN fs/ufs/ufs.h~treewide-use-__printf-not-__attribute__formatprintf fs/ufs/ufs.h
--- a/fs/ufs/ufs.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/ufs/ufs.h
@@ -117,9 +117,12 @@ extern int ufs_getfrag_block (struct ino
 extern const struct file_operations ufs_dir_operations;
 
 /* super.c */
-extern void ufs_warning (struct super_block *, const char *, const char *, ...) __attribute__ ((format (printf, 3, 4)));
-extern void ufs_error (struct super_block *, const char *, const char *, ...) __attribute__ ((format (printf, 3, 4)));
-extern void ufs_panic (struct super_block *, const char *, const char *, ...) __attribute__ ((format (printf, 3, 4)));
+extern __printf(3, 4)
+void ufs_warning(struct super_block *, const char *, const char *, ...);
+extern __printf(3, 4)
+void ufs_error(struct super_block *, const char *, const char *, ...);
+extern __printf(3, 4)
+void ufs_panic(struct super_block *, const char *, const char *, ...);
 
 /* symlink.c */
 extern const struct inode_operations ufs_fast_symlink_inode_operations;
diff -puN fs/xfs/xfs_message.h~treewide-use-__printf-not-__attribute__formatprintf fs/xfs/xfs_message.h
--- a/fs/xfs/xfs_message.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/fs/xfs/xfs_message.h
@@ -3,31 +3,29 @@
 
 struct xfs_mount;
 
-extern void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-extern void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-extern void xfs_alert_tag(const struct xfs_mount *mp, int tag,
-			 const char *fmt, ...)
-        __attribute__ ((format (printf, 3, 4)));
-extern void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-extern void xfs_err(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-extern void xfs_warn(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-extern void xfs_notice(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
-extern void xfs_info(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
+extern __printf(2, 3)
+void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...);
+extern __printf(2, 3)
+void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...);
+extern __printf(3, 4)
+void xfs_alert_tag(const struct xfs_mount *mp, int tag, const char *fmt, ...);
+extern __printf(2, 3)
+void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...);
+extern __printf(2, 3)
+void xfs_err(const struct xfs_mount *mp, const char *fmt, ...);
+extern __printf(2, 3)
+void xfs_warn(const struct xfs_mount *mp, const char *fmt, ...);
+extern __printf(2, 3)
+void xfs_notice(const struct xfs_mount *mp, const char *fmt, ...);
+extern __printf(2, 3)
+void xfs_info(const struct xfs_mount *mp, const char *fmt, ...);
 
 #ifdef DEBUG
-extern void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
-        __attribute__ ((format (printf, 2, 3)));
+extern __printf(2, 3)
+void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...);
 #else
-static inline void
-__attribute__ ((format (printf, 2, 3)))
-xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
+static inline __printf(2, 3)
+void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
 {
 }
 #endif
diff -puN include/asm-generic/bug.h~treewide-use-__printf-not-__attribute__formatprintf include/asm-generic/bug.h
--- a/include/asm-generic/bug.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/asm-generic/bug.h
@@ -61,11 +61,12 @@ struct bug_entry {
  */
 #ifndef __WARN_TAINT
 #ifndef __ASSEMBLY__
-extern void warn_slowpath_fmt(const char *file, const int line,
-		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
-extern void warn_slowpath_fmt_taint(const char *file, const int line,
-				    unsigned taint, const char *fmt, ...)
-	__attribute__((format(printf, 4, 5)));
+extern __printf(3, 4)
+void warn_slowpath_fmt(const char *file, const int line,
+		       const char *fmt, ...);
+extern __printf(4, 5)
+void warn_slowpath_fmt_taint(const char *file, const int line, unsigned taint,
+			     const char *fmt, ...);
 extern void warn_slowpath_null(const char *file, const int line);
 #define WANT_WARN_ON_SLOWPATH
 #endif
diff -puN include/drm/drmP.h~treewide-use-__printf-not-__attribute__formatprintf include/drm/drmP.h
--- a/include/drm/drmP.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/drm/drmP.h
@@ -122,12 +122,12 @@ struct drm_device;
  * using the DRM_DEBUG_KMS and DRM_DEBUG.
  */
 
-extern __attribute__((format (printf, 4, 5)))
+extern __printf(4, 5)
 void drm_ut_debug_printk(unsigned int request_level,
-				const char *prefix,
-				const char *function_name,
-				const char *format, ...);
-extern __attribute__((format (printf, 2, 3)))
+			 const char *prefix,
+			 const char *function_name,
+			 const char *format, ...);
+extern __printf(2, 3)
 int drm_err(const char *func, const char *format, ...);
 
 /***********************************************************************/
diff -puN include/linux/audit.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/audit.h
--- a/include/linux/audit.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/audit.h
@@ -584,14 +584,13 @@ extern int audit_signals;
 #ifdef CONFIG_AUDIT
 /* These are defined in audit.c */
 				/* Public API */
-extern void		    audit_log(struct audit_context *ctx, gfp_t gfp_mask,
-				      int type, const char *fmt, ...)
-				      __attribute__((format(printf,4,5)));
+extern __printf(4, 5)
+void audit_log(struct audit_context *ctx, gfp_t gfp_mask, int type,
+	       const char *fmt, ...);
 
 extern struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask, int type);
-extern void		    audit_log_format(struct audit_buffer *ab,
-					     const char *fmt, ...)
-			    __attribute__((format(printf,2,3)));
+extern __printf(2, 3)
+void audit_log_format(struct audit_buffer *ab, const char *fmt, ...);
 extern void		    audit_log_end(struct audit_buffer *ab);
 extern int		    audit_string_contains_control(const char *string,
 							  size_t len);
diff -puN include/linux/blktrace_api.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/blktrace_api.h
--- a/include/linux/blktrace_api.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/blktrace_api.h
@@ -170,7 +170,7 @@ extern void blk_trace_shutdown(struct re
 extern int do_blk_trace_setup(struct request_queue *q, char *name,
 			      dev_t dev, struct block_device *bdev,
 			      struct blk_user_trace_setup *buts);
-extern __attribute__((format(printf, 2, 3)))
+extern __printf(2, 3)
 void __trace_note_message(struct blk_trace *, const char *fmt, ...);
 
 /**
diff -puN include/linux/device.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/device.h
--- a/include/linux/device.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/device.h
@@ -622,8 +622,8 @@ static inline const char *dev_name(const
 	return kobject_name(&dev->kobj);
 }
 
-extern int dev_set_name(struct device *dev, const char *name, ...)
-			__attribute__((format(printf, 2, 3)));
+extern __printf(2, 3)
+int dev_set_name(struct device *dev, const char *name, ...);
 
 #ifdef CONFIG_NUMA
 static inline int dev_to_node(struct device *dev)
@@ -753,10 +753,10 @@ extern struct device *device_create_varg
 					  void *drvdata,
 					  const char *fmt,
 					  va_list vargs);
-extern struct device *device_create(struct class *cls, struct device *parent,
-				    dev_t devt, void *drvdata,
-				    const char *fmt, ...)
-				    __attribute__((format(printf, 5, 6)));
+extern __printf(5, 6)
+struct device *device_create(struct class *cls, struct device *parent,
+			     dev_t devt, void *drvdata,
+			     const char *fmt, ...);
 extern void device_destroy(struct class *cls, dev_t devt);
 
 /*
@@ -800,64 +800,56 @@ extern const char *dev_driver_string(con
 
 extern int __dev_printk(const char *level, const struct device *dev,
 			struct va_format *vaf);
-extern int dev_printk(const char *level, const struct device *dev,
-		      const char *fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern int dev_emerg(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int dev_alert(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int dev_crit(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int dev_err(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int dev_warn(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int dev_notice(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int _dev_info(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
+extern __printf(3, 4)
+int dev_printk(const char *level, const struct device *dev,
+	       const char *fmt, ...)
+	;
+extern __printf(2, 3)
+int dev_emerg(const struct device *dev, const char *fmt, ...);
+extern __printf(2, 3)
+int dev_alert(const struct device *dev, const char *fmt, ...);
+extern __printf(2, 3)
+int dev_crit(const struct device *dev, const char *fmt, ...);
+extern __printf(2, 3)
+int dev_err(const struct device *dev, const char *fmt, ...);
+extern __printf(2, 3)
+int dev_warn(const struct device *dev, const char *fmt, ...);
+extern __printf(2, 3)
+int dev_notice(const struct device *dev, const char *fmt, ...);
+extern __printf(2, 3)
+int _dev_info(const struct device *dev, const char *fmt, ...);
 
 #else
 
 static inline int __dev_printk(const char *level, const struct device *dev,
 			       struct va_format *vaf)
-	 { return 0; }
-static inline int dev_printk(const char *level, const struct device *dev,
-		      const char *fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
-static inline int dev_printk(const char *level, const struct device *dev,
-		      const char *fmt, ...)
-	 { return 0; }
-
-static inline int dev_emerg(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-static inline int dev_emerg(const struct device *dev, const char *fmt, ...)
-	{ return 0; }
-static inline int dev_crit(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-static inline int dev_crit(const struct device *dev, const char *fmt, ...)
-	{ return 0; }
-static inline int dev_alert(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-static inline int dev_alert(const struct device *dev, const char *fmt, ...)
-	{ return 0; }
-static inline int dev_err(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-static inline int dev_err(const struct device *dev, const char *fmt, ...)
-	{ return 0; }
-static inline int dev_warn(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-static inline int dev_warn(const struct device *dev, const char *fmt, ...)
-	{ return 0; }
-static inline int dev_notice(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-static inline int dev_notice(const struct device *dev, const char *fmt, ...)
-	{ return 0; }
-static inline int _dev_info(const struct device *dev, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-static inline int _dev_info(const struct device *dev, const char *fmt, ...)
-	{ return 0; }
+{ return 0; }
+static inline __printf(3, 4)
+int dev_printk(const char *level, const struct device *dev,
+	       const char *fmt, ...)
+{ return 0; }
+
+static inline __printf(2, 3)
+int dev_emerg(const struct device *dev, const char *fmt, ...)
+{ return 0; }
+static inline __printf(2, 3)
+int dev_crit(const struct device *dev, const char *fmt, ...)
+{ return 0; }
+static inline __printf(2, 3)
+int dev_alert(const struct device *dev, const char *fmt, ...)
+{ return 0; }
+static inline __printf(2, 3)
+int dev_err(const struct device *dev, const char *fmt, ...)
+{ return 0; }
+static inline __printf(2, 3)
+int dev_warn(const struct device *dev, const char *fmt, ...)
+{ return 0; }
+static inline __printf(2, 3)
+int dev_notice(const struct device *dev, const char *fmt, ...)
+{ return 0; }
+static inline __printf(2, 3)
+int _dev_info(const struct device *dev, const char *fmt, ...)
+{ return 0; }
 
 #endif
 
diff -puN include/linux/dynamic_debug.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/dynamic_debug.h
--- a/include/linux/dynamic_debug.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/dynamic_debug.h
@@ -37,22 +37,21 @@ int ddebug_add_module(struct _ddebug *ta
 
 #if defined(CONFIG_DYNAMIC_DEBUG)
 extern int ddebug_remove_module(const char *mod_name);
-extern int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
+extern __printf(2, 3)
+int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...);
 
 struct device;
 
-extern int __dynamic_dev_dbg(struct _ddebug *descriptor,
-			     const struct device *dev,
-			     const char *fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
+extern __printf(3, 4)
+int __dynamic_dev_dbg(struct _ddebug *descriptor, const struct device *dev,
+		      const char *fmt, ...);
 
 struct net_device;
 
-extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
-			     const struct net_device *dev,
-			     const char *fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
+extern __printf(3, 4)
+int __dynamic_netdev_dbg(struct _ddebug *descriptor,
+			 const struct net_device *dev,
+			 const char *fmt, ...);
 
 #define DEFINE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
 	static struct _ddebug __used __aligned(8)		\
diff -puN include/linux/ext3_fs.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/ext3_fs.h
--- a/include/linux/ext3_fs.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/ext3_fs.h
@@ -937,15 +937,15 @@ extern int ext3_group_extend(struct supe
 				ext3_fsblk_t n_blocks_count);
 
 /* super.c */
-extern void ext3_error (struct super_block *, const char *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
+extern __printf(3, 4)
+void ext3_error(struct super_block *, const char *, const char *, ...);
 extern void __ext3_std_error (struct super_block *, const char *, int);
-extern void ext3_abort (struct super_block *, const char *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern void ext3_warning (struct super_block *, const char *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern void ext3_msg(struct super_block *, const char *, const char *, ...)
-	__attribute__ ((format (printf, 3, 4)));
+extern __printf(3, 4)
+void ext3_abort(struct super_block *, const char *, const char *, ...);
+extern __printf(3, 4)
+void ext3_warning(struct super_block *, const char *, const char *, ...);
+extern __printf(3, 4)
+void ext3_msg(struct super_block *, const char *, const char *, ...);
 extern void ext3_update_dynamic_rev (struct super_block *sb);
 
 #define ext3_std_error(sb, errno)				\
diff -puN include/linux/fs.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/fs.h
--- a/include/linux/fs.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/fs.h
@@ -2635,8 +2635,8 @@ static const struct file_operations __fo
 	.llseek	 = generic_file_llseek,					\
 };
 
-static inline void __attribute__((format(printf, 1, 2)))
-__simple_attr_check_format(const char *fmt, ...)
+static inline __printf(1, 2)
+void __simple_attr_check_format(const char *fmt, ...)
 {
 	/* don't do anything, just let the compiler check the arguments; */
 }
diff -puN include/linux/fscache-cache.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/fscache-cache.h
--- a/include/linux/fscache-cache.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/fscache-cache.h
@@ -492,10 +492,10 @@ static inline void fscache_end_io(struct
 /*
  * out-of-line cache backend functions
  */
-extern void fscache_init_cache(struct fscache_cache *cache,
-			       const struct fscache_cache_ops *ops,
-			       const char *idfmt,
-			       ...) __attribute__ ((format (printf, 3, 4)));
+extern __printf(3, 4)
+void fscache_init_cache(struct fscache_cache *cache,
+			const struct fscache_cache_ops *ops,
+			const char *idfmt, ...);
 
 extern int fscache_add_cache(struct fscache_cache *cache,
 			     struct fscache_object *fsdef,
diff -puN include/linux/gameport.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/gameport.h
--- a/include/linux/gameport.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/gameport.h
@@ -78,8 +78,8 @@ static inline void gameport_register_por
 
 void gameport_unregister_port(struct gameport *gameport);
 
-void gameport_set_phys(struct gameport *gameport, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
+__printf(2, 3)
+void gameport_set_phys(struct gameport *gameport, const char *fmt, ...);
 
 #else
 
@@ -93,8 +93,8 @@ static inline void gameport_unregister_p
 	return;
 }
 
-static inline void gameport_set_phys(struct gameport *gameport,
-				     const char *fmt, ...)
+static inline __printf(2, 3)
+void gameport_set_phys(struct gameport *gameport, const char *fmt, ...)
 {
 	return;
 }
diff -puN include/linux/kallsyms.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/kallsyms.h
--- a/include/linux/kallsyms.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/kallsyms.h
@@ -101,9 +101,8 @@ static inline int lookup_symbol_attrs(un
 #endif /*CONFIG_KALLSYMS*/
 
 /* This macro allows us to keep printk typechecking */
-static void __check_printsym_format(const char *fmt, ...)
-__attribute__((format(printf,1,2)));
-static inline void __check_printsym_format(const char *fmt, ...)
+static __printf(1, 2)
+void __check_printsym_format(const char *fmt, ...)
 {
 }
 
diff -puN include/linux/kdb.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/kdb.h
--- a/include/linux/kdb.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/kdb.h
@@ -114,12 +114,9 @@ typedef enum {
 } kdb_reason_t;
 
 extern int kdb_trap_printk;
-extern int vkdb_printf(const char *fmt, va_list args)
-	    __attribute__ ((format (printf, 1, 0)));
-extern int kdb_printf(const char *, ...)
-	    __attribute__ ((format (printf, 1, 2)));
-typedef int (*kdb_printf_t)(const char *, ...)
-	     __attribute__ ((format (printf, 1, 2)));
+extern __printf(1, 0) int vkdb_printf(const char *fmt, va_list args);
+extern __printf(1, 2) int kdb_printf(const char *, ...);
+typedef __printf(1, 2) int (*kdb_printf_t)(const char *, ...);
 
 extern void kdb_init(int level);
 
diff -puN include/linux/kernel.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/kernel.h
--- a/include/linux/kernel.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/kernel.h
@@ -296,20 +296,18 @@ extern long long simple_strtoll(const ch
 #define strict_strtoull	kstrtoull
 #define strict_strtoll	kstrtoll
 
-extern int sprintf(char * buf, const char * fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int vsprintf(char *buf, const char *, va_list)
-	__attribute__ ((format (printf, 2, 0)));
-extern int snprintf(char * buf, size_t size, const char * fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
-	__attribute__ ((format (printf, 3, 0)));
-extern int scnprintf(char * buf, size_t size, const char * fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
-	__attribute__ ((format (printf, 3, 0)));
-extern char *kasprintf(gfp_t gfp, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
+extern __printf(2, 3) int sprintf(char *buf, const char * fmt, ...);
+extern __printf(2, 0) int vsprintf(char *buf, const char *, va_list);
+extern __printf(3, 4)
+int snprintf(char *buf, size_t size, const char *fmt, ...);
+extern __printf(3, 0)
+int vsnprintf(char *buf, size_t size, const char *fmt, va_list args);
+extern __printf(3, 4)
+int scnprintf(char *buf, size_t size, const char *fmt, ...);
+extern __printf(3, 0)
+int vscnprintf(char *buf, size_t size, const char *fmt, va_list args);
+extern __printf(2, 3)
+char *kasprintf(gfp_t gfp, const char *fmt, ...);
 extern char *kvasprintf(gfp_t gfp, const char *fmt, va_list args);
 
 extern int sscanf(const char *, const char *, ...)
@@ -427,8 +425,8 @@ extern void tracing_start(void);
 extern void tracing_stop(void);
 extern void ftrace_off_permanent(void);
 
-static inline void __attribute__ ((format (printf, 1, 2)))
-____trace_printk_check_format(const char *fmt, ...)
+static inline __printf(1, 2)
+void ____trace_printk_check_format(const char *fmt, ...)
 {
 }
 #define __trace_printk_check_format(fmt, args...)			\
@@ -467,13 +465,11 @@ do {									\
 		__trace_printk(_THIS_IP_, fmt, ##args);		\
 } while (0)
 
-extern int
-__trace_bprintk(unsigned long ip, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
+extern __printf(2, 3)
+int __trace_bprintk(unsigned long ip, const char *fmt, ...);
 
-extern int
-__trace_printk(unsigned long ip, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
+extern __printf(2, 3)
+int __trace_printk(unsigned long ip, const char *fmt, ...);
 
 extern void trace_dump_stack(void);
 
@@ -502,8 +498,8 @@ __ftrace_vprintk(unsigned long ip, const
 
 extern void ftrace_dump(enum ftrace_dump_mode oops_dump_mode);
 #else
-static inline int
-trace_printk(const char *fmt, ...) __attribute__ ((format (printf, 1, 2)));
+static inline __printf(1, 2)
+int trace_printk(const char *fmt, ...);
 
 static inline void tracing_start(void) { }
 static inline void tracing_stop(void) { }
diff -puN include/linux/kexec.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/kexec.h
--- a/include/linux/kexec.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/kexec.h
@@ -130,8 +130,8 @@ int kexec_should_crash(struct task_struc
 void crash_save_cpu(struct pt_regs *regs, int cpu);
 void crash_save_vmcoreinfo(void);
 void arch_crash_save_vmcoreinfo(void);
-void vmcoreinfo_append_str(const char *fmt, ...)
-	__attribute__ ((format (printf, 1, 2)));
+__printf(1, 2)
+void vmcoreinfo_append_str(const char *fmt, ...);
 unsigned long paddr_vmcoreinfo_note(void);
 
 #define VMCOREINFO_OSRELEASE(value) \
diff -puN include/linux/kmod.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/kmod.h
--- a/include/linux/kmod.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/kmod.h
@@ -32,8 +32,8 @@
 extern char modprobe_path[]; /* for sysctl */
 /* modprobe exit status on success, -ve on error.  Return value
  * usually useless though. */
-extern int __request_module(bool wait, const char *name, ...) \
-	__attribute__((format(printf, 2, 3)));
+extern __printf(2, 3)
+int __request_module(bool wait, const char *name, ...);
 #define request_module(mod...) __request_module(true, mod)
 #define request_module_nowait(mod...) __request_module(false, mod)
 #define try_then_request_module(x, mod...) \
diff -puN include/linux/kobject.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/kobject.h
--- a/include/linux/kobject.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/kobject.h
@@ -72,8 +72,8 @@ struct kobject {
 	unsigned int uevent_suppress:1;
 };
 
-extern int kobject_set_name(struct kobject *kobj, const char *name, ...)
-			    __attribute__((format(printf, 2, 3)));
+extern __printf(2, 3)
+int kobject_set_name(struct kobject *kobj, const char *name, ...);
 extern int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
 				  va_list vargs);
 
@@ -83,15 +83,13 @@ static inline const char *kobject_name(c
 }
 
 extern void kobject_init(struct kobject *kobj, struct kobj_type *ktype);
-extern int __must_check kobject_add(struct kobject *kobj,
-				    struct kobject *parent,
-				    const char *fmt, ...)
-	__attribute__((format(printf, 3, 4)));
-extern int __must_check kobject_init_and_add(struct kobject *kobj,
-					     struct kobj_type *ktype,
-					     struct kobject *parent,
-					     const char *fmt, ...)
-	__attribute__((format(printf, 4, 5)));
+extern __printf(3, 4) __must_check
+int kobject_add(struct kobject *kobj, struct kobject *parent,
+		const char *fmt, ...);
+extern __printf(4, 5) __must_check
+int kobject_init_and_add(struct kobject *kobj,
+			 struct kobj_type *ktype, struct kobject *parent,
+			 const char *fmt, ...);
 
 extern void kobject_del(struct kobject *kobj);
 
@@ -212,8 +210,8 @@ int kobject_uevent(struct kobject *kobj,
 int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 			char *envp[]);
 
-int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
-	__attribute__((format (printf, 2, 3)));
+__printf(2, 3)
+int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...);
 
 int kobject_action_type(const char *buf, size_t count,
 			enum kobject_action *type);
@@ -226,7 +224,7 @@ static inline int kobject_uevent_env(str
 				      char *envp[])
 { return 0; }
 
-static inline __attribute__((format(printf, 2, 3)))
+static inline __printf(2, 3)
 int add_uevent_var(struct kobj_uevent_env *env, const char *format, ...)
 { return 0; }
 
diff -puN include/linux/kthread.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/kthread.h
--- a/include/linux/kthread.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/kthread.h
@@ -4,11 +4,11 @@
 #include <linux/err.h>
 #include <linux/sched.h>
 
+__printf(4, 5)
 struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
 					   void *data,
 					   int node,
-					   const char namefmt[], ...)
-	__attribute__((format(printf, 4, 5)));
+					   const char namefmt[], ...);
 
 #define kthread_create(threadfn, data, namefmt, arg...) \
 	kthread_create_on_node(threadfn, data, -1, namefmt, ##arg)
diff -puN include/linux/libata.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/libata.h
--- a/include/linux/libata.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/libata.h
@@ -1256,13 +1256,13 @@ static inline int sata_srst_pmp(struct a
 /*
  * printk helpers
  */
-__attribute__((format (printf, 3, 4)))
+__printf(3, 4)
 int ata_port_printk(const struct ata_port *ap, const char *level,
 		    const char *fmt, ...);
-__attribute__((format (printf, 3, 4)))
+__printf(3, 4)
 int ata_link_printk(const struct ata_link *link, const char *level,
 		    const char *fmt, ...);
-__attribute__((format (printf, 3, 4)))
+__printf(3, 4)
 int ata_dev_printk(const struct ata_device *dev, const char *level,
 		   const char *fmt, ...);
 
@@ -1304,10 +1304,10 @@ void ata_print_version(const struct devi
 /*
  * ata_eh_info helpers
  */
-extern void __ata_ehi_push_desc(struct ata_eh_info *ehi, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern void ata_ehi_push_desc(struct ata_eh_info *ehi, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
+extern __printf(2, 3)
+void __ata_ehi_push_desc(struct ata_eh_info *ehi, const char *fmt, ...);
+extern __printf(2, 3)
+void ata_ehi_push_desc(struct ata_eh_info *ehi, const char *fmt, ...);
 extern void ata_ehi_clear_desc(struct ata_eh_info *ehi);
 
 static inline void ata_ehi_hotplugged(struct ata_eh_info *ehi)
@@ -1321,8 +1321,8 @@ static inline void ata_ehi_hotplugged(st
 /*
  * port description helpers
  */
-extern void ata_port_desc(struct ata_port *ap, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
+extern __printf(2, 3)
+void ata_port_desc(struct ata_port *ap, const char *fmt, ...);
 #ifdef CONFIG_PCI
 extern void ata_port_pbar_desc(struct ata_port *ap, int bar, ssize_t offset,
 			       const char *name);
diff -puN include/linux/mmiotrace.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/mmiotrace.h
--- a/include/linux/mmiotrace.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/mmiotrace.h
@@ -49,8 +49,7 @@ extern void mmiotrace_ioremap(resource_s
 extern void mmiotrace_iounmap(volatile void __iomem *addr);
 
 /* For anyone to insert markers. Remember trailing newline. */
-extern int mmiotrace_printk(const char *fmt, ...)
-				__attribute__ ((format (printf, 1, 2)));
+extern __printf(1, 2) int mmiotrace_printk(const char *fmt, ...);
 #else /* !CONFIG_MMIOTRACE: */
 static inline int is_kmmio_active(void)
 {
@@ -71,10 +70,7 @@ static inline void mmiotrace_iounmap(vol
 {
 }
 
-static inline int mmiotrace_printk(const char *fmt, ...)
-				__attribute__ ((format (printf, 1, 0)));
-
-static inline int mmiotrace_printk(const char *fmt, ...)
+static inline __printf(1, 2) int mmiotrace_printk(const char *fmt, ...)
 {
 	return 0;
 }
diff -puN include/linux/netdevice.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/netdevice.h
--- a/include/linux/netdevice.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/netdevice.h
@@ -2622,23 +2622,23 @@ static inline const char *netdev_name(co
 extern int __netdev_printk(const char *level, const struct net_device *dev,
 			struct va_format *vaf);
 
-extern int netdev_printk(const char *level, const struct net_device *dev,
-			 const char *format, ...)
-	__attribute__ ((format (printf, 3, 4)));
-extern int netdev_emerg(const struct net_device *dev, const char *format, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int netdev_alert(const struct net_device *dev, const char *format, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int netdev_crit(const struct net_device *dev, const char *format, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int netdev_err(const struct net_device *dev, const char *format, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int netdev_warn(const struct net_device *dev, const char *format, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int netdev_notice(const struct net_device *dev, const char *format, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int netdev_info(const struct net_device *dev, const char *format, ...)
-	__attribute__ ((format (printf, 2, 3)));
+extern __printf(3, 4)
+int netdev_printk(const char *level, const struct net_device *dev,
+		  const char *format, ...);
+extern __printf(2, 3)
+int netdev_emerg(const struct net_device *dev, const char *format, ...);
+extern __printf(2, 3)
+int netdev_alert(const struct net_device *dev, const char *format, ...);
+extern __printf(2, 3)
+int netdev_crit(const struct net_device *dev, const char *format, ...);
+extern __printf(2, 3)
+int netdev_err(const struct net_device *dev, const char *format, ...);
+extern __printf(2, 3)
+int netdev_warn(const struct net_device *dev, const char *format, ...);
+extern __printf(2, 3)
+int netdev_notice(const struct net_device *dev, const char *format, ...);
+extern __printf(2, 3)
+int netdev_info(const struct net_device *dev, const char *format, ...);
 
 #define MODULE_ALIAS_NETDEV(device) \
 	MODULE_ALIAS("netdev-" device)
diff -puN include/linux/printk.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/printk.h
--- a/include/linux/printk.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/printk.h
@@ -82,22 +82,22 @@ struct va_format {
  * Dummy printk for disabled debugging statements to use whilst maintaining
  * gcc's format and side-effect checking.
  */
-static inline __attribute__ ((format (printf, 1, 2)))
+static inline __printf(1, 2)
 int no_printk(const char *fmt, ...)
 {
 	return 0;
 }
 
-extern asmlinkage __attribute__ ((format (printf, 1, 2)))
+extern asmlinkage __printf(1, 2)
 void early_printk(const char *fmt, ...);
 
 extern int printk_needs_cpu(int cpu);
 extern void printk_tick(void);
 
 #ifdef CONFIG_PRINTK
-asmlinkage __attribute__ ((format (printf, 1, 0)))
+asmlinkage __printf(1, 0)
 int vprintk(const char *fmt, va_list args);
-asmlinkage __attribute__ ((format (printf, 1, 2))) __cold
+asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
 
 /*
@@ -117,12 +117,12 @@ extern int kptr_restrict;
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
 #else
-static inline __attribute__ ((format (printf, 1, 0)))
+static inline __printf(1, 0)
 int vprintk(const char *s, va_list args)
 {
 	return 0;
 }
-static inline __attribute__ ((format (printf, 1, 2))) __cold
+static inline __printf(1, 2) __cold
 int printk(const char *s, ...)
 {
 	return 0;
diff -puN include/linux/quotaops.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/quotaops.h
--- a/include/linux/quotaops.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/quotaops.h
@@ -31,7 +31,7 @@ static inline bool is_quota_modification
 #define quota_error(sb, fmt, args...) \
 	__quota_error((sb), __func__, fmt , ## args)
 
-extern __attribute__((format (printf, 3, 4)))
+extern __printf(3, 4)
 void __quota_error(struct super_block *sb, const char *func,
 		   const char *fmt, ...);
 
diff -puN include/linux/seq_file.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/seq_file.h
--- a/include/linux/seq_file.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/seq_file.h
@@ -84,8 +84,7 @@ int seq_putc(struct seq_file *m, char c)
 int seq_puts(struct seq_file *m, const char *s);
 int seq_write(struct seq_file *seq, const void *data, size_t len);
 
-int seq_printf(struct seq_file *, const char *, ...)
-	__attribute__ ((format (printf,2,3)));
+__printf(2, 3) int seq_printf(struct seq_file *, const char *, ...);
 
 int seq_path(struct seq_file *, struct path *, char *);
 int seq_dentry(struct seq_file *, struct dentry *, char *);
diff -puN include/linux/trace_seq.h~treewide-use-__printf-not-__attribute__formatprintf include/linux/trace_seq.h
--- a/include/linux/trace_seq.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/linux/trace_seq.h
@@ -29,10 +29,10 @@ trace_seq_init(struct trace_seq *s)
  * Currently only defined when tracing is enabled.
  */
 #ifdef CONFIG_TRACING
-extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3)));
-extern int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args)
-	__attribute__ ((format (printf, 2, 0)));
+extern __printf(2, 3)
+int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
+extern __printf(2, 0)
+int trace_seq_vprintf(struct trace_seq *s, const char *fmt, va_list args);
 extern int
 trace_seq_bprintf(struct trace_seq *s, const char *fmt, const u32 *binary);
 extern int trace_print_seq(struct seq_file *m, struct trace_seq *s);
diff -puN include/net/bluetooth/bluetooth.h~treewide-use-__printf-not-__attribute__formatprintf include/net/bluetooth/bluetooth.h
--- a/include/net/bluetooth/bluetooth.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/net/bluetooth/bluetooth.h
@@ -77,7 +77,7 @@ struct bt_power {
 #define BT_POWER_FORCE_ACTIVE_OFF 0
 #define BT_POWER_FORCE_ACTIVE_ON  1
 
-__attribute__((format (printf, 2, 3)))
+__printf(2, 3)
 int bt_printk(const char *level, const char *fmt, ...);
 
 #define BT_INFO(fmt, arg...)   bt_printk(KERN_INFO, pr_fmt(fmt), ##arg)
diff -puN include/net/netfilter/nf_log.h~treewide-use-__printf-not-__attribute__formatprintf include/net/netfilter/nf_log.h
--- a/include/net/netfilter/nf_log.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/net/netfilter/nf_log.h
@@ -53,12 +53,13 @@ int nf_log_bind_pf(u_int8_t pf, const st
 void nf_log_unbind_pf(u_int8_t pf);
 
 /* Calls the registered backend logging function */
+__printf(7, 8)
 void nf_log_packet(u_int8_t pf,
 		   unsigned int hooknum,
 		   const struct sk_buff *skb,
 		   const struct net_device *in,
 		   const struct net_device *out,
 		   const struct nf_loginfo *li,
-		   const char *fmt, ...) __attribute__ ((format(printf,7,8)));
+		   const char *fmt, ...);
 
 #endif /* _NF_LOG_H */
diff -puN include/net/sock.h~treewide-use-__printf-not-__attribute__formatprintf include/net/sock.h
--- a/include/net/sock.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/net/sock.h
@@ -76,8 +76,8 @@
 					printk(KERN_DEBUG msg); } while (0)
 #else
 /* Validate arguments and do nothing */
-static inline void __attribute__ ((format (printf, 2, 3)))
-SOCK_DEBUG(struct sock *sk, const char *msg, ...)
+static inline __printf(2, 3)
+void SOCK_DEBUG(struct sock *sk, const char *msg, ...)
 {
 }
 #endif
diff -puN include/sound/core.h~treewide-use-__printf-not-__attribute__formatprintf include/sound/core.h
--- a/include/sound/core.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/sound/core.h
@@ -326,9 +326,9 @@ void release_and_free_resource(struct re
 /* --- */
 
 #if defined(CONFIG_SND_DEBUG) || defined(CONFIG_SND_VERBOSE_PRINTK)
+__printf(4, 5)
 void __snd_printk(unsigned int level, const char *file, int line,
-		  const char *format, ...)
-     __attribute__ ((format (printf, 4, 5)));
+		  const char *format, ...);
 #else
 #define __snd_printk(level, file, line, format, args...) \
 	printk(format, ##args)
diff -puN include/sound/info.h~treewide-use-__printf-not-__attribute__formatprintf include/sound/info.h
--- a/include/sound/info.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/sound/info.h
@@ -110,8 +110,8 @@ void snd_card_info_read_oss(struct snd_i
 static inline void snd_card_info_read_oss(struct snd_info_buffer *buffer) {}
 #endif
 
-int snd_iprintf(struct snd_info_buffer *buffer, const char *fmt, ...) \
-				__attribute__ ((format (printf, 2, 3)));
+__printf(2, 3)
+int snd_iprintf(struct snd_info_buffer *buffer, const char *fmt, ...);
 int snd_info_init(void);
 int snd_info_done(void);
 
diff -puN include/sound/seq_kernel.h~treewide-use-__printf-not-__attribute__formatprintf include/sound/seq_kernel.h
--- a/include/sound/seq_kernel.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/sound/seq_kernel.h
@@ -75,9 +75,9 @@ struct snd_seq_port_callback {
 };
 
 /* interface for kernel client */
+__printf(3, 4)
 int snd_seq_create_kernel_client(struct snd_card *card, int client_index,
-				 const char *name_fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
+				 const char *name_fmt, ...);
 int snd_seq_delete_kernel_client(int client);
 int snd_seq_kernel_client_enqueue(int client, struct snd_seq_event *ev, int atomic, int hop);
 int snd_seq_kernel_client_dispatch(int client, struct snd_seq_event *ev, int atomic, int hop);
diff -puN include/xen/hvc-console.h~treewide-use-__printf-not-__attribute__formatprintf include/xen/hvc-console.h
--- a/include/xen/hvc-console.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/xen/hvc-console.h
@@ -6,12 +6,12 @@ extern struct console xenboot_console;
 #ifdef CONFIG_HVC_XEN
 void xen_console_resume(void);
 void xen_raw_console_write(const char *str);
-__attribute__((format(printf, 1, 2)))
+__printf(1, 2)
 void xen_raw_printk(const char *fmt, ...);
 #else
 static inline void xen_console_resume(void) { }
 static inline void xen_raw_console_write(const char *str) { }
-static inline __attribute__((format(printf, 1, 2)))
+static inline __printf(1, 2)
 void xen_raw_printk(const char *fmt, ...) { }
 #endif
 
diff -puN include/xen/xenbus.h~treewide-use-__printf-not-__attribute__formatprintf include/xen/xenbus.h
--- a/include/xen/xenbus.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/include/xen/xenbus.h
@@ -156,9 +156,9 @@ int xenbus_scanf(struct xenbus_transacti
 	__attribute__((format(scanf, 4, 5)));
 
 /* Single printf and write: returns -errno or 0. */
+__printf(4, 5)
 int xenbus_printf(struct xenbus_transaction t,
-		  const char *dir, const char *node, const char *fmt, ...)
-	__attribute__((format(printf, 4, 5)));
+		  const char *dir, const char *node, const char *fmt, ...);
 
 /* Generic read function: NULL-terminated triples of name,
  * sprintf-style type string, and pointer. Returns 0 or errno.*/
@@ -200,11 +200,11 @@ int xenbus_watch_path(struct xenbus_devi
 		      struct xenbus_watch *watch,
 		      void (*callback)(struct xenbus_watch *,
 				       const char **, unsigned int));
+__printf(4, 5)
 int xenbus_watch_pathfmt(struct xenbus_device *dev, struct xenbus_watch *watch,
 			 void (*callback)(struct xenbus_watch *,
 					  const char **, unsigned int),
-			 const char *pathfmt, ...)
-	__attribute__ ((format (printf, 4, 5)));
+			 const char *pathfmt, ...);
 
 int xenbus_switch_state(struct xenbus_device *dev, enum xenbus_state new_state);
 int xenbus_grant_ring(struct xenbus_device *dev, unsigned long ring_mfn);
@@ -223,9 +223,9 @@ int xenbus_free_evtchn(struct xenbus_dev
 
 enum xenbus_state xenbus_read_driver_state(const char *path);
 
-__attribute__((format(printf, 3, 4)))
+__printf(3, 4)
 void xenbus_dev_error(struct xenbus_device *dev, int err, const char *fmt, ...);
-__attribute__((format(printf, 3, 4)))
+__printf(3, 4)
 void xenbus_dev_fatal(struct xenbus_device *dev, int err, const char *fmt, ...);
 
 const char *xenbus_strstate(enum xenbus_state state);
diff -puN net/nfc/nfc.h~treewide-use-__printf-not-__attribute__formatprintf net/nfc/nfc.h
--- a/net/nfc/nfc.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/net/nfc/nfc.h
@@ -27,7 +27,7 @@
 #include <net/nfc/nfc.h>
 #include <net/sock.h>
 
-__attribute__((format (printf, 2, 3)))
+__printf(2, 3)
 int nfc_printk(const char *level, const char *fmt, ...);
 
 #define nfc_info(fmt, arg...) nfc_printk(KERN_INFO, fmt, ##arg)
diff -puN net/rds/rds.h~treewide-use-__printf-not-__attribute__formatprintf net/rds/rds.h
--- a/net/rds/rds.h~treewide-use-__printf-not-__attribute__formatprintf
+++ a/net/rds/rds.h
@@ -36,8 +36,8 @@
 #define rdsdebug(fmt, args...) pr_debug("%s(): " fmt, __func__ , ##args)
 #else
 /* sigh, pr_debug() causes unused variable warnings */
-static inline void __attribute__ ((format (printf, 1, 2)))
-rdsdebug(char *fmt, ...)
+static inline __printf(1, 2)
+void rdsdebug(char *fmt, ...)
 {
 }
 #endif
@@ -625,8 +625,8 @@ void rds_for_each_conn_info(struct socke
 			  struct rds_info_lengths *lens,
 			  int (*visitor)(struct rds_connection *, void *),
 			  size_t item_len);
-void __rds_conn_error(struct rds_connection *conn, const char *, ...)
-				__attribute__ ((format (printf, 2, 3)));
+__printf(2, 3)
+void __rds_conn_error(struct rds_connection *conn, const char *, ...);
 #define rds_conn_error(conn, fmt...) \
 	__rds_conn_error(conn, KERN_WARNING "RDS: " fmt)
 
diff -puN net/sunrpc/svc.c~treewide-use-__printf-not-__attribute__formatprintf net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~treewide-use-__printf-not-__attribute__formatprintf
+++ a/net/sunrpc/svc.c
@@ -971,9 +971,8 @@ static void svc_unregister(const struct 
 /*
  * Printk the given error with the address of the client that caused it.
  */
-static int
-__attribute__ ((format (printf, 2, 3)))
-svc_printk(struct svc_rqst *rqstp, const char *fmt, ...)
+static __printf(2, 3)
+int svc_printk(struct svc_rqst *rqstp, const char *fmt, ...)
 {
 	va_list args;
 	int 	r;
diff -puN sound/firewire/cmp.c~treewide-use-__printf-not-__attribute__formatprintf sound/firewire/cmp.c
--- a/sound/firewire/cmp.c~treewide-use-__printf-not-__attribute__formatprintf
+++ a/sound/firewire/cmp.c
@@ -32,7 +32,7 @@ enum bus_reset_handling {
 	SUCCEED_ON_BUS_RESET,
 };
 
-static __attribute__((format(printf, 2, 3)))
+static __printf(2, 3)
 void cmp_error(struct cmp_connection *c, const char *fmt, ...)
 {
 	va_list va;
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

