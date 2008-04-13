From: akpm@linux-foundation.org
Subject: - xfs-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:39:16 -0700
Message-ID: <200804130239.m3D2dGKH032371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39587 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755435AbYDMCjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:39:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, dgc@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     xfs-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/kmem.c      |    6 +++---
 fs/xfs/linux-2.6/xfs_buf.c   |    6 +++---
 fs/xfs/linux-2.6/xfs_super.c |    2 +-
 fs/xfs/linux-2.6/xfs_vnode.h |    4 ++--
 fs/xfs/xfs_alloc.c           |   18 +++++++++---------
 fs/xfs/xfs_bmap.c            |   18 +++++++++---------
 fs/xfs/xfs_bmap.h            |    2 +-
 fs/xfs/xfs_bmap_btree.c      |   16 ++++++++--------
 fs/xfs/xfs_filestream.c      |    2 +-
 fs/xfs/xfs_log.c             |    2 +-
 fs/xfs/xfs_log_recover.c     |    4 ++--
 fs/xfs/xfs_trans_ail.c       |    2 +-
 12 files changed, 41 insertions(+), 41 deletions(-)

diff -puN fs/xfs/linux-2.6/kmem.c~xfs-replace-remaining-__function__-occurrences fs/xfs/linux-2.6/kmem.c
--- a/fs/xfs/linux-2.6/kmem.c~xfs-replace-remaining-__function__-occurrences
+++ a/fs/xfs/linux-2.6/kmem.c
@@ -37,7 +37,7 @@ kmem_alloc(size_t size, unsigned int __n
 #ifdef DEBUG
 	if (unlikely(!(flags & KM_LARGE) && (size > PAGE_SIZE))) {
 		printk(KERN_WARNING "Large %s attempt, size=%ld\n",
-			__FUNCTION__, (long)size);
+			__func__, (long)size);
 		dump_stack();
 	}
 #endif
@@ -52,7 +52,7 @@ kmem_alloc(size_t size, unsigned int __n
 		if (!(++retries % 100))
 			printk(KERN_ERR "XFS: possible memory allocation "
 					"deadlock in %s (mode:0x%x)\n",
-					__FUNCTION__, lflags);
+					__func__, lflags);
 		congestion_wait(WRITE, HZ/50);
 	} while (1);
 }
@@ -129,7 +129,7 @@ kmem_zone_alloc(kmem_zone_t *zone, unsig
 		if (!(++retries % 100))
 			printk(KERN_ERR "XFS: possible memory allocation "
 					"deadlock in %s (mode:0x%x)\n",
-					__FUNCTION__, lflags);
+					__func__, lflags);
 		congestion_wait(WRITE, HZ/50);
 	} while (1);
 }
diff -puN fs/xfs/linux-2.6/xfs_buf.c~xfs-replace-remaining-__function__-occurrences fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~xfs-replace-remaining-__function__-occurrences
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -400,7 +400,7 @@ _xfs_buf_lookup_pages(
 				printk(KERN_ERR
 					"XFS: possible memory allocation "
 					"deadlock in %s (mode:0x%x)\n",
-					__FUNCTION__, gfp_mask);
+					__func__, gfp_mask);
 
 			XFS_STATS_INC(xb_page_retries);
 			xfsbufd_wakeup(0, gfp_mask);
@@ -598,7 +598,7 @@ xfs_buf_get_flags(
 		error = _xfs_buf_map_pages(bp, flags);
 		if (unlikely(error)) {
 			printk(KERN_WARNING "%s: failed to map pages\n",
-					__FUNCTION__);
+					__func__);
 			goto no_buffer;
 		}
 	}
@@ -778,7 +778,7 @@ xfs_buf_get_noaddr(
 	error = _xfs_buf_map_pages(bp, XBF_MAPPED);
 	if (unlikely(error)) {
 		printk(KERN_WARNING "%s: failed to map pages\n",
-				__FUNCTION__);
+				__func__);
 		goto fail_free_mem;
 	}
 
diff -puN fs/xfs/linux-2.6/xfs_super.c~xfs-replace-remaining-__function__-occurrences fs/xfs/linux-2.6/xfs_super.c
--- a/fs/xfs/linux-2.6/xfs_super.c~xfs-replace-remaining-__function__-occurrences
+++ a/fs/xfs/linux-2.6/xfs_super.c
@@ -934,7 +934,7 @@ xfs_fs_clear_inode(
 		xfs_inactive(ip);
 		xfs_iflags_clear(ip, XFS_IMODIFIED);
 		if (xfs_reclaim(ip))
-			panic("%s: cannot reclaim 0x%p\n", __FUNCTION__, inode);
+			panic("%s: cannot reclaim 0x%p\n", __func__, inode);
 	}
 
 	ASSERT(XFS_I(inode) == NULL);
diff -puN fs/xfs/linux-2.6/xfs_vnode.h~xfs-replace-remaining-__function__-occurrences fs/xfs/linux-2.6/xfs_vnode.h
--- a/fs/xfs/linux-2.6/xfs_vnode.h~xfs-replace-remaining-__function__-occurrences
+++ a/fs/xfs/linux-2.6/xfs_vnode.h
@@ -303,9 +303,9 @@ extern void xfs_itrace_hold(struct xfs_i
 extern void _xfs_itrace_ref(struct xfs_inode *, char *, int, inst_t *);
 extern void xfs_itrace_rele(struct xfs_inode *, char *, int, inst_t *);
 #define xfs_itrace_entry(ip)	\
-	_xfs_itrace_entry(ip, __FUNCTION__, (inst_t *)__return_address)
+	_xfs_itrace_entry(ip, __func__, (inst_t *)__return_address)
 #define xfs_itrace_exit(ip)	\
-	_xfs_itrace_exit(ip, __FUNCTION__, (inst_t *)__return_address)
+	_xfs_itrace_exit(ip, __func__, (inst_t *)__return_address)
 #define xfs_itrace_exit_tag(ip, tag)	\
 	_xfs_itrace_exit(ip, tag, (inst_t *)__return_address)
 #define xfs_itrace_ref(ip)	\
diff -puN fs/xfs/xfs_alloc.c~xfs-replace-remaining-__function__-occurrences fs/xfs/xfs_alloc.c
--- a/fs/xfs/xfs_alloc.c~xfs-replace-remaining-__function__-occurrences
+++ a/fs/xfs/xfs_alloc.c
@@ -55,17 +55,17 @@ xfs_alloc_search_busy(xfs_trans_t *tp,
 ktrace_t *xfs_alloc_trace_buf;
 
 #define	TRACE_ALLOC(s,a)	\
-	xfs_alloc_trace_alloc(__FUNCTION__, s, a, __LINE__)
+	xfs_alloc_trace_alloc(__func__, s, a, __LINE__)
 #define	TRACE_FREE(s,a,b,x,f)	\
-	xfs_alloc_trace_free(__FUNCTION__, s, mp, a, b, x, f, __LINE__)
+	xfs_alloc_trace_free(__func__, s, mp, a, b, x, f, __LINE__)
 #define	TRACE_MODAGF(s,a,f)	\
-	xfs_alloc_trace_modagf(__FUNCTION__, s, mp, a, f, __LINE__)
-#define	TRACE_BUSY(__FUNCTION__,s,ag,agb,l,sl,tp)	\
-	xfs_alloc_trace_busy(__FUNCTION__, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSY, __LINE__)
-#define	TRACE_UNBUSY(__FUNCTION__,s,ag,sl,tp)	\
-	xfs_alloc_trace_busy(__FUNCTION__, s, mp, ag, -1, -1, sl, tp, XFS_ALLOC_KTRACE_UNBUSY, __LINE__)
-#define	TRACE_BUSYSEARCH(__FUNCTION__,s,ag,agb,l,sl,tp)	\
-	xfs_alloc_trace_busy(__FUNCTION__, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSYSEARCH, __LINE__)
+	xfs_alloc_trace_modagf(__func__, s, mp, a, f, __LINE__)
+#define	TRACE_BUSY(__func__,s,ag,agb,l,sl,tp)	\
+	xfs_alloc_trace_busy(__func__, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSY, __LINE__)
+#define	TRACE_UNBUSY(__func__,s,ag,sl,tp)	\
+	xfs_alloc_trace_busy(__func__, s, mp, ag, -1, -1, sl, tp, XFS_ALLOC_KTRACE_UNBUSY, __LINE__)
+#define	TRACE_BUSYSEARCH(__func__,s,ag,agb,l,sl,tp)	\
+	xfs_alloc_trace_busy(__func__, s, mp, ag, agb, l, sl, tp, XFS_ALLOC_KTRACE_BUSYSEARCH, __LINE__)
 #else
 #define	TRACE_ALLOC(s,a)
 #define	TRACE_FREE(s,a,b,x,f)
diff -puN fs/xfs/xfs_bmap.c~xfs-replace-remaining-__function__-occurrences fs/xfs/xfs_bmap.c
--- a/fs/xfs/xfs_bmap.c~xfs-replace-remaining-__function__-occurrences
+++ a/fs/xfs/xfs_bmap.c
@@ -323,13 +323,13 @@ xfs_bmap_trace_pre_update(
 	int		whichfork);	/* data or attr fork */
 
 #define	XFS_BMAP_TRACE_DELETE(d,ip,i,c,w)	\
-	xfs_bmap_trace_delete(__FUNCTION__,d,ip,i,c,w)
+	xfs_bmap_trace_delete(__func__,d,ip,i,c,w)
 #define	XFS_BMAP_TRACE_INSERT(d,ip,i,c,r1,r2,w)	\
-	xfs_bmap_trace_insert(__FUNCTION__,d,ip,i,c,r1,r2,w)
+	xfs_bmap_trace_insert(__func__,d,ip,i,c,r1,r2,w)
 #define	XFS_BMAP_TRACE_POST_UPDATE(d,ip,i,w)	\
-	xfs_bmap_trace_post_update(__FUNCTION__,d,ip,i,w)
+	xfs_bmap_trace_post_update(__func__,d,ip,i,w)
 #define	XFS_BMAP_TRACE_PRE_UPDATE(d,ip,i,w)	\
-	xfs_bmap_trace_pre_update(__FUNCTION__,d,ip,i,w)
+	xfs_bmap_trace_pre_update(__func__,d,ip,i,w)
 #else
 #define	XFS_BMAP_TRACE_DELETE(d,ip,i,c,w)
 #define	XFS_BMAP_TRACE_INSERT(d,ip,i,c,r1,r2,w)
@@ -6162,10 +6162,10 @@ xfs_check_block(
 			}
 			if (*thispa == *pp) {
 				cmn_err(CE_WARN, "%s: thispa(%d) == pp(%d) %Ld",
-					__FUNCTION__, j, i,
+					__func__, j, i,
 					(unsigned long long)be64_to_cpu(*thispa));
 				panic("%s: ptrs are equal in node\n",
-					__FUNCTION__);
+					__func__);
 			}
 		}
 	}
@@ -6325,13 +6325,13 @@ xfs_bmap_check_leaf_extents(
 	return;
 
 error0:
-	cmn_err(CE_WARN, "%s: at error0", __FUNCTION__);
+	cmn_err(CE_WARN, "%s: at error0", __func__);
 	if (bp_release)
 		xfs_trans_brelse(NULL, bp);
 error_norelse:
 	cmn_err(CE_WARN, "%s: BAD after btree leaves for %d extents",
-		__FUNCTION__, i);
-	panic("%s: CORRUPTED BTREE OR SOMETHING", __FUNCTION__);
+		__func__, i);
+	panic("%s: CORRUPTED BTREE OR SOMETHING", __func__);
 	return;
 }
 #endif
diff -puN fs/xfs/xfs_bmap.h~xfs-replace-remaining-__function__-occurrences fs/xfs/xfs_bmap.h
--- a/fs/xfs/xfs_bmap.h~xfs-replace-remaining-__function__-occurrences
+++ a/fs/xfs/xfs_bmap.h
@@ -151,7 +151,7 @@ xfs_bmap_trace_exlist(
 	xfs_extnum_t		cnt,		/* count of entries in list */
 	int			whichfork);	/* data or attr fork */
 #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)	\
-	xfs_bmap_trace_exlist(__FUNCTION__,ip,c,w)
+	xfs_bmap_trace_exlist(__func__,ip,c,w)
 #else
 #define	XFS_BMAP_TRACE_EXLIST(ip,c,w)
 #endif
diff -puN fs/xfs/xfs_bmap_btree.c~xfs-replace-remaining-__function__-occurrences fs/xfs/xfs_bmap_btree.c
--- a/fs/xfs/xfs_bmap_btree.c~xfs-replace-remaining-__function__-occurrences
+++ a/fs/xfs/xfs_bmap_btree.c
@@ -275,21 +275,21 @@ xfs_bmbt_trace_cursor(
 }
 
 #define	XFS_BMBT_TRACE_ARGBI(c,b,i)	\
-	xfs_bmbt_trace_argbi(__FUNCTION__, c, b, i, __LINE__)
+	xfs_bmbt_trace_argbi(__func__, c, b, i, __LINE__)
 #define	XFS_BMBT_TRACE_ARGBII(c,b,i,j)	\
-	xfs_bmbt_trace_argbii(__FUNCTION__, c, b, i, j, __LINE__)
+	xfs_bmbt_trace_argbii(__func__, c, b, i, j, __LINE__)
 #define	XFS_BMBT_TRACE_ARGFFFI(c,o,b,i,j)	\
-	xfs_bmbt_trace_argfffi(__FUNCTION__, c, o, b, i, j, __LINE__)
+	xfs_bmbt_trace_argfffi(__func__, c, o, b, i, j, __LINE__)
 #define	XFS_BMBT_TRACE_ARGI(c,i)	\
-	xfs_bmbt_trace_argi(__FUNCTION__, c, i, __LINE__)
+	xfs_bmbt_trace_argi(__func__, c, i, __LINE__)
 #define	XFS_BMBT_TRACE_ARGIFK(c,i,f,s)	\
-	xfs_bmbt_trace_argifk(__FUNCTION__, c, i, f, s, __LINE__)
+	xfs_bmbt_trace_argifk(__func__, c, i, f, s, __LINE__)
 #define	XFS_BMBT_TRACE_ARGIFR(c,i,f,r)	\
-	xfs_bmbt_trace_argifr(__FUNCTION__, c, i, f, r, __LINE__)
+	xfs_bmbt_trace_argifr(__func__, c, i, f, r, __LINE__)
 #define	XFS_BMBT_TRACE_ARGIK(c,i,k)	\
-	xfs_bmbt_trace_argik(__FUNCTION__, c, i, k, __LINE__)
+	xfs_bmbt_trace_argik(__func__, c, i, k, __LINE__)
 #define	XFS_BMBT_TRACE_CURSOR(c,s)	\
-	xfs_bmbt_trace_cursor(__FUNCTION__, c, s, __LINE__)
+	xfs_bmbt_trace_cursor(__func__, c, s, __LINE__)
 #else
 #define	XFS_BMBT_TRACE_ARGBI(c,b,i)
 #define	XFS_BMBT_TRACE_ARGBII(c,b,i,j)
diff -puN fs/xfs/xfs_filestream.c~xfs-replace-remaining-__function__-occurrences fs/xfs/xfs_filestream.c
--- a/fs/xfs/xfs_filestream.c~xfs-replace-remaining-__function__-occurrences
+++ a/fs/xfs/xfs_filestream.c
@@ -73,7 +73,7 @@ xfs_filestreams_trace(
 #define TRACE4(mp,t,a0,a1,a2,a3)	TRACE6(mp,t,a0,a1,a2,a3,0,0)
 #define TRACE5(mp,t,a0,a1,a2,a3,a4)	TRACE6(mp,t,a0,a1,a2,a3,a4,0)
 #define TRACE6(mp,t,a0,a1,a2,a3,a4,a5) \
-	xfs_filestreams_trace(mp, t, __FUNCTION__, __LINE__, \
+	xfs_filestreams_trace(mp, t, __func__, __LINE__, \
 				(__psunsigned_t)a0, (__psunsigned_t)a1, \
 				(__psunsigned_t)a2, (__psunsigned_t)a3, \
 				(__psunsigned_t)a4, (__psunsigned_t)a5)
diff -puN fs/xfs/xfs_log.c~xfs-replace-remaining-__function__-occurrences fs/xfs/xfs_log.c
--- a/fs/xfs/xfs_log.c~xfs-replace-remaining-__function__-occurrences
+++ a/fs/xfs/xfs_log.c
@@ -2241,7 +2241,7 @@ xlog_state_do_callback(
 			repeats = 0;
 			xfs_fs_cmn_err(CE_WARN, log->l_mp,
 				"%s: possible infinite loop (%d iterations)",
-				__FUNCTION__, flushcnt);
+				__func__, flushcnt);
 		}
 	} while (!ioerrors && loopdidcallbacks);
 
diff -puN fs/xfs/xfs_log_recover.c~xfs-replace-remaining-__function__-occurrences fs/xfs/xfs_log_recover.c
--- a/fs/xfs/xfs_log_recover.c~xfs-replace-remaining-__function__-occurrences
+++ a/fs/xfs/xfs_log_recover.c
@@ -191,7 +191,7 @@ xlog_header_check_dump(
 {
 	int			b;
 
-	cmn_err(CE_DEBUG, "%s:  SB : uuid = ", __FUNCTION__);
+	cmn_err(CE_DEBUG, "%s:  SB : uuid = ", __func__);
 	for (b = 0; b < 16; b++)
 		cmn_err(CE_DEBUG, "%02x", ((uchar_t *)&mp->m_sb.sb_uuid)[b]);
 	cmn_err(CE_DEBUG, ", fmt = %d\n", XLOG_FMT);
@@ -3445,7 +3445,7 @@ xlog_valid_rec_header(
 	    (!rhead->h_version ||
 	    (be32_to_cpu(rhead->h_version) & (~XLOG_VERSION_OKBITS))))) {
 		xlog_warn("XFS: %s: unrecognised log version (%d).",
-			__FUNCTION__, be32_to_cpu(rhead->h_version));
+			__func__, be32_to_cpu(rhead->h_version));
 		return XFS_ERROR(EIO);
 	}
 
diff -puN fs/xfs/xfs_trans_ail.c~xfs-replace-remaining-__function__-occurrences fs/xfs/xfs_trans_ail.c
--- a/fs/xfs/xfs_trans_ail.c~xfs-replace-remaining-__function__-occurrences
+++ a/fs/xfs/xfs_trans_ail.c
@@ -440,7 +440,7 @@ xfs_trans_delete_ail(
 		else {
 			xfs_cmn_err(XFS_PTAG_AILDELETE, CE_ALERT, mp,
 		"%s: attempting to delete a log item that is not in the AIL",
-					__FUNCTION__);
+					__func__);
 			spin_unlock(&mp->m_ail_lock);
 			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 		}
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

git-x86.patch
git-alsa-tiwai.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
git-powerpc.patch
power-replace-remaining-__function__-occurrences.patch
git-dvb.patch
v4l-common-replace-remaining-__function__-occurences.patch
v4l-dvb-replace-remaining-__function__-occurences.patch
v4l-video-replace-remaining-__function__-occurences.patch
git-dlm.patch
git-ieee1394.patch
git-infiniband.patch
input-replace-remaining-__function__-occurrences.patch
git-jfs.patch
git-libata-all.patch
git-mips.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
mtd-replace-remaining-__function__-occurrences.patch
git-net.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
git-selinux.patch
git-s390.patch
git-scsi-misc.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
block-replace-remaining-__function__-occurrences.patch
git-watchdog.patch
mac80211-tkipcc-michaelc-use-kernel-bit-rotation-helpers.patch
mac80211-tkipc-remove-opencoded-swab16-in-tkip_s.patch
mac80211-tkipc-eliminate-the-hi16-lo16-functions.patch
mac80211-tkipc-remove-mk16-hi8-lo8-helpers.patch
mac80211-michaelc-replace-macro-with-function.patch
mac80211-michaelc-use-unaligned-byteorder-helpers.patch
mac80211-michaelc-fold-initial-xor-into-block-helper.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
alpha-replace-__inline-with-inline.patch
m68k-replace-remaining-__function__-occurences.patch
uml-replace-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
char-make-functions-static-in-synclinkmpc.patch
spi-replace-remaining-__function__-occurrences.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
isdn-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
rtc-replace-remaining-__function__-occurrences.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
video-replace-remaining-__function__-occurrences.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
md-replace-remaining-__function__-occurrences.patch
ext2-replace-remaining-__function__-occurrences.patch
ext3-replace-remaining-__function__-occurrences.patch
jbd-replace-remaining-__function__-occurrences.patch
ufs-replace-remaining-__function__-occurrences.patch
ufs-replace-__inline-with-inline.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
reiserfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

