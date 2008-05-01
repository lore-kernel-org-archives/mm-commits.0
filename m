From: akpm@linux-foundation.org
Subject: - remove-ifdef-__kernel__-checks-from-unexported-headers.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:21 -0700
Message-ID: <200805010933.m419XLf8031136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758070AbYEAJdv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, dwmw2@infradead.org, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     Remove "#ifdef __KERNEL__" checks from unexported headers
has been removed from the -mm tree.  Its filename was
     remove-ifdef-__kernel__-checks-from-unexported-headers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Remove "#ifdef __KERNEL__" checks from unexported headers
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Remove the "#ifdef __KERNEL__" tests from unexported header files in
linux/include whose entire contents are wrapped in that preprocessor
test.

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/agp_backend.h      |    3 ---
 include/linux/cdev.h             |    2 --
 include/linux/coda_fs_i.h        |    2 --
 include/linux/concap.h           |    3 +--
 include/linux/configfs.h         |    4 ----
 include/linux/crc-ccitt.h        |    2 --
 include/linux/dcache.h           |    4 ----
 include/linux/device-mapper.h    |    3 ---
 include/linux/eventfd.h          |    5 -----
 include/linux/fsl_devices.h      |    2 --
 include/linux/fsnotify.h         |    4 ----
 include/linux/hw_random.h        |    2 --
 include/linux/i2o.h              |    3 ---
 include/linux/if_macvlan.h       |    3 ---
 include/linux/inet.h             |    2 --
 include/linux/isicom.h           |    7 -------
 include/linux/kfifo.h            |    5 -----
 include/linux/kobj_map.h         |    4 ----
 include/linux/kobject.h          |    3 ---
 include/linux/kref.h             |    3 ---
 include/linux/list.h             |    5 -----
 include/linux/mmzone.h           |    2 --
 include/linux/mount.h            |    2 --
 include/linux/ncp_fs_i.h         |    4 ----
 include/linux/of_device.h        |    2 --
 include/linux/pm.h               |    4 ----
 include/linux/pnp.h              |    4 ----
 include/linux/profile.h          |    4 ----
 include/linux/rcuclassic.h       |    3 ---
 include/linux/rcupdate.h         |    3 ---
 include/linux/rcupreempt.h       |    3 ---
 include/linux/rcupreempt_trace.h |    2 --
 include/linux/rio.h              |    3 ---
 include/linux/rio_drv.h          |    3 ---
 include/linux/rwsem.h            |    3 ---
 include/linux/seq_file.h         |    2 --
 include/linux/slab.h             |    3 ---
 include/linux/smb_fs_i.h         |    2 --
 include/linux/smb_fs_sb.h        |    4 ----
 include/linux/svga.h             |    3 ---
 include/linux/textsearch.h       |    4 ----
 41 files changed, 1 insertion(+), 130 deletions(-)

diff -puN include/linux/agp_backend.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/agp_backend.h
--- a/include/linux/agp_backend.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/agp_backend.h
@@ -30,8 +30,6 @@
 #ifndef _AGP_BACKEND_H
 #define _AGP_BACKEND_H 1
 
-#ifdef __KERNEL__
-
 #ifndef TRUE
 #define TRUE 1
 #endif
@@ -111,5 +109,4 @@ extern struct agp_bridge_data *agp_backe
 extern void agp_backend_release(struct agp_bridge_data *);
 extern void agp_flush_chipset(struct agp_bridge_data *);
 
-#endif				/* __KERNEL__ */
 #endif				/* _AGP_BACKEND_H */
diff -puN include/linux/cdev.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/cdev.h
--- a/include/linux/cdev.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/cdev.h
@@ -1,6 +1,5 @@
 #ifndef _LINUX_CDEV_H
 #define _LINUX_CDEV_H
-#ifdef __KERNEL__
 
 #include <linux/kobject.h>
 #include <linux/kdev_t.h>
@@ -34,4 +33,3 @@ void cd_forget(struct inode *);
 extern struct backing_dev_info directly_mappable_cdev_bdi;
 
 #endif
-#endif
diff -puN include/linux/coda_fs_i.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/coda_fs_i.h
--- a/include/linux/coda_fs_i.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/coda_fs_i.h
@@ -8,7 +8,6 @@
 #ifndef _LINUX_CODA_FS_I
 #define _LINUX_CODA_FS_I
 
-#ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/coda.h>
@@ -52,4 +51,3 @@ struct inode *coda_fid_to_inode(struct C
 void coda_replace_fid(struct inode *, struct CodaFid *, struct CodaFid *);
 
 #endif
-#endif
diff -puN include/linux/concap.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/concap.h
--- a/include/linux/concap.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/concap.h
@@ -8,7 +8,7 @@
 
 #ifndef _LINUX_CONCAP_H
 #define _LINUX_CONCAP_H
-#ifdef __KERNEL__
+
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
 
@@ -110,4 +110,3 @@ extern int concap_nop(struct concap_prot
  */
 extern int concap_drop_skb(struct concap_proto *cprot, struct sk_buff *skb);
 #endif
-#endif
diff -puN include/linux/configfs.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/configfs.h
--- a/include/linux/configfs.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/configfs.h
@@ -35,8 +35,6 @@
 #ifndef _CONFIGFS_H_
 #define _CONFIGFS_H_
 
-#ifdef __KERNEL__
-
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/list.h>
@@ -194,6 +192,4 @@ void configfs_unregister_subsystem(struc
 int configfs_depend_item(struct configfs_subsystem *subsys, struct config_item *target);
 void configfs_undepend_item(struct configfs_subsystem *subsys, struct config_item *target);
 
-#endif  /* __KERNEL__ */
-
 #endif /* _CONFIGFS_H_ */
diff -puN include/linux/crc-ccitt.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/crc-ccitt.h
--- a/include/linux/crc-ccitt.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/crc-ccitt.h
@@ -1,6 +1,5 @@
 #ifndef _LINUX_CRC_CCITT_H
 #define _LINUX_CRC_CCITT_H
-#ifdef __KERNEL__
 
 #include <linux/types.h>
 
@@ -13,5 +12,4 @@ static inline u16 crc_ccitt_byte(u16 crc
 	return (crc >> 8) ^ crc_ccitt_table[(crc ^ c) & 0xff];
 }
 
-#endif /* __KERNEL__ */
 #endif /* _LINUX_CRC_CCITT_H */
diff -puN include/linux/dcache.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/dcache.h
--- a/include/linux/dcache.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/dcache.h
@@ -1,8 +1,6 @@
 #ifndef __LINUX_DCACHE_H
 #define __LINUX_DCACHE_H
 
-#ifdef __KERNEL__
-
 #include <asm/atomic.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -365,6 +363,4 @@ extern struct dentry *lookup_create(stru
 
 extern int sysctl_vfs_cache_pressure;
 
-#endif /* __KERNEL__ */
-
 #endif	/* __LINUX_DCACHE_H */
diff -puN include/linux/device-mapper.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/device-mapper.h
--- a/include/linux/device-mapper.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/device-mapper.h
@@ -8,8 +8,6 @@
 #ifndef _LINUX_DEVICE_MAPPER_H
 #define _LINUX_DEVICE_MAPPER_H
 
-#ifdef __KERNEL__
-
 #include <linux/bio.h>
 
 struct dm_target;
@@ -344,5 +342,4 @@ static inline unsigned long to_bytes(sec
 	return (n << SECTOR_SHIFT);
 }
 
-#endif	/* __KERNEL__ */
 #endif	/* _LINUX_DEVICE_MAPPER_H */
diff -puN include/linux/eventfd.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/eventfd.h
--- a/include/linux/eventfd.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/eventfd.h
@@ -8,9 +8,6 @@
 #ifndef _LINUX_EVENTFD_H
 #define _LINUX_EVENTFD_H
 
-
-#ifdef __KERNEL__
-
 #ifdef CONFIG_EVENTFD
 
 struct file *eventfd_fget(int fd);
@@ -24,7 +21,5 @@ static inline int eventfd_signal(struct 
 
 #endif /* CONFIG_EVENTFD */
 
-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_EVENTFD_H */
 
diff -puN include/linux/fsl_devices.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/fsl_devices.h
--- a/include/linux/fsl_devices.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/fsl_devices.h
@@ -14,7 +14,6 @@
  * option) any later version.
  */
 
-#ifdef __KERNEL__
 #ifndef _FSL_DEVICE_H_
 #define _FSL_DEVICE_H_
 
@@ -127,4 +126,3 @@ struct mpc8xx_pcmcia_ops {
 };
 
 #endif /* _FSL_DEVICE_H_ */
-#endif /* __KERNEL__ */
diff -puN include/linux/fsnotify.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/fsnotify.h
--- a/include/linux/fsnotify.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/fsnotify.h
@@ -11,8 +11,6 @@
  * (C) Copyright 2005 Robert Love
  */
 
-#ifdef __KERNEL__
-
 #include <linux/dnotify.h>
 #include <linux/inotify.h>
 #include <linux/audit.h>
@@ -296,6 +294,4 @@ static inline void fsnotify_oldname_free
 
 #endif	/* ! CONFIG_INOTIFY */
 
-#endif	/* __KERNEL__ */
-
 #endif	/* _LINUX_FS_NOTIFY_H */
diff -puN include/linux/hw_random.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/hw_random.h
--- a/include/linux/hw_random.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/hw_random.h
@@ -11,7 +11,6 @@
 
 #ifndef LINUX_HWRANDOM_H_
 #define LINUX_HWRANDOM_H_
-#ifdef __KERNEL__
 
 #include <linux/types.h>
 #include <linux/list.h>
@@ -46,5 +45,4 @@ extern int hwrng_register(struct hwrng *
 /** Unregister a Hardware Random Number Generator driver. */
 extern void hwrng_unregister(struct hwrng *rng);
 
-#endif /* __KERNEL__ */
 #endif /* LINUX_HWRANDOM_H_ */
diff -puN include/linux/i2o.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/i2o.h
--- a/include/linux/i2o.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/i2o.h
@@ -18,8 +18,6 @@
 #ifndef _I2O_H
 #define _I2O_H
 
-#ifdef __KERNEL__		/* This file to be included by kernel only */
-
 #include <linux/i2o-dev.h>
 
 /* How many different OSM's are we allowing */
@@ -1255,5 +1253,4 @@ extern void i2o_dump_message(struct i2o_
 extern void i2o_dump_hrt(struct i2o_controller *c);
 extern void i2o_debug_state(struct i2o_controller *c);
 
-#endif				/* __KERNEL__ */
 #endif				/* _I2O_H */
diff -puN include/linux/if_macvlan.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/if_macvlan.h
--- a/include/linux/if_macvlan.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/if_macvlan.h
@@ -1,9 +1,6 @@
 #ifndef _LINUX_IF_MACVLAN_H
 #define _LINUX_IF_MACVLAN_H
 
-#ifdef __KERNEL__
-
 extern struct sk_buff *(*macvlan_handle_frame_hook)(struct sk_buff *);
 
-#endif /* __KERNEL__ */
 #endif /* _LINUX_IF_MACVLAN_H */
diff -puN include/linux/inet.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/inet.h
--- a/include/linux/inet.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/inet.h
@@ -42,11 +42,9 @@
 #ifndef _LINUX_INET_H
 #define _LINUX_INET_H
 
-#ifdef __KERNEL__
 #include <linux/types.h>
 
 extern __be32 in_aton(const char *str);
 extern int in4_pton(const char *src, int srclen, u8 *dst, int delim, const char **end);
 extern int in6_pton(const char *src, int srclen, u8 *dst, int delim, const char **end);
-#endif
 #endif	/* _LINUX_INET_H */
diff -puN include/linux/isicom.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/isicom.h
--- a/include/linux/isicom.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/isicom.h
@@ -1,11 +1,6 @@
 #ifndef _LINUX_ISICOM_H
 #define _LINUX_ISICOM_H
 
-/*#define		ISICOM_DEBUG*/
-/*#define		ISICOM_DEBUG_DTR_RTS*/
-
-#ifdef __KERNEL__
-
 #define		YES	1
 #define		NO	0
 
@@ -85,6 +80,4 @@
 
 #define		ISI_TXOK		0x0001
 
-#endif	/*	__KERNEL__	*/
-
 #endif	/*	ISICOM_H	*/
diff -puN include/linux/kfifo.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/kfifo.h
--- a/include/linux/kfifo.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/kfifo.h
@@ -21,8 +21,6 @@
 #ifndef _LINUX_KFIFO_H
 #define _LINUX_KFIFO_H
 
-#ifdef __KERNEL__
-
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 
@@ -151,7 +149,4 @@ static inline unsigned int kfifo_len(str
 	return ret;
 }
 
-#else
-#warning "don't include kernel headers in userspace"
-#endif /* __KERNEL__ */
 #endif
diff -puN include/linux/kobj_map.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/kobj_map.h
--- a/include/linux/kobj_map.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/kobj_map.h
@@ -1,5 +1,3 @@
-#ifdef __KERNEL__
-
 #include <linux/mutex.h>
 
 typedef struct kobject *kobj_probe_t(dev_t, int *, void *);
@@ -10,5 +8,3 @@ int kobj_map(struct kobj_map *, dev_t, u
 void kobj_unmap(struct kobj_map *, dev_t, unsigned long);
 struct kobject *kobj_lookup(struct kobj_map *, dev_t, int *);
 struct kobj_map *kobj_map_init(kobj_probe_t *, struct mutex *);
-
-#endif
diff -puN include/linux/kobject.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/kobject.h
--- a/include/linux/kobject.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/kobject.h
@@ -16,8 +16,6 @@
 #ifndef _KOBJECT_H_
 #define _KOBJECT_H_
 
-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/sysfs.h>
@@ -224,5 +222,4 @@ static inline int kobject_action_type(co
 { return -EINVAL; }
 #endif
 
-#endif /* __KERNEL__ */
 #endif /* _KOBJECT_H_ */
diff -puN include/linux/kref.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/kref.h
--- a/include/linux/kref.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/kref.h
@@ -15,8 +15,6 @@
 #ifndef _KREF_H_
 #define _KREF_H_
 
-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <asm/atomic.h>
 
@@ -29,5 +27,4 @@ void kref_init(struct kref *kref);
 void kref_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));
 
-#endif /* __KERNEL__ */
 #endif /* _KREF_H_ */
diff -puN include/linux/list.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/list.h
--- a/include/linux/list.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/list.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_LIST_H
 #define _LINUX_LIST_H
 
-#ifdef __KERNEL__
-
 #include <linux/stddef.h>
 #include <linux/poison.h>
 #include <linux/prefetch.h>
@@ -983,7 +981,4 @@ static inline void hlist_add_after_rcu(s
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = rcu_dereference(pos->next))
 
-#else
-#warning "don't include kernel headers in userspace"
-#endif /* __KERNEL__ */
 #endif
diff -puN include/linux/mmzone.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/mmzone.h
--- a/include/linux/mmzone.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/mmzone.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_MMZONE_H
 #define _LINUX_MMZONE_H
 
-#ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 #ifndef __GENERATING_BOUNDS_H
 
@@ -1005,5 +1004,4 @@ unsigned long __init node_memmap_size_by
 
 #endif /* !__GENERATING_BOUNDS.H */
 #endif /* !__ASSEMBLY__ */
-#endif /* __KERNEL__ */
 #endif /* _LINUX_MMZONE_H */
diff -puN include/linux/mount.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/mount.h
--- a/include/linux/mount.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/mount.h
@@ -10,7 +10,6 @@
  */
 #ifndef _LINUX_MOUNT_H
 #define _LINUX_MOUNT_H
-#ifdef __KERNEL__
 
 #include <linux/types.h>
 #include <linux/list.h>
@@ -114,5 +113,4 @@ extern void mark_mounts_for_expiry(struc
 extern spinlock_t vfsmount_lock;
 extern dev_t name_to_dev_t(char *name);
 
-#endif
 #endif /* _LINUX_MOUNT_H */
diff -puN include/linux/ncp_fs_i.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/ncp_fs_i.h
--- a/include/linux/ncp_fs_i.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/ncp_fs_i.h
@@ -8,8 +8,6 @@
 #ifndef _LINUX_NCP_FS_I
 #define _LINUX_NCP_FS_I
 
-#ifdef __KERNEL__
-
 /*
  * This is the ncpfs part of the inode structure. This must contain
  * all the information we need to work with an inode after creation.
@@ -28,6 +26,4 @@ struct ncp_inode_info {
 	struct inode vfs_inode;
 };
 
-#endif	/* __KERNEL__ */
-
 #endif	/* _LINUX_NCP_FS_I */
diff -puN include/linux/of_device.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/of_device.h
--- a/include/linux/of_device.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/of_device.h
@@ -1,6 +1,5 @@
 #ifndef _LINUX_OF_DEVICE_H
 #define _LINUX_OF_DEVICE_H
-#ifdef __KERNEL__
 
 #include <linux/device.h>
 #include <linux/of.h>
@@ -25,5 +24,4 @@ static inline void of_device_free(struct
 	of_release_dev(&dev->dev);
 }
 
-#endif /* __KERNEL__ */
 #endif /* _LINUX_OF_DEVICE_H */
diff -puN include/linux/pm.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/pm.h
--- a/include/linux/pm.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/pm.h
@@ -21,8 +21,6 @@
 #ifndef _LINUX_PM_H
 #define _LINUX_PM_H
 
-#ifdef __KERNEL__
-
 #include <linux/list.h>
 #include <asm/atomic.h>
 #include <asm/errno.h>
@@ -225,6 +223,4 @@ extern unsigned int	pm_flags;
 #define PM_APM	1
 #define PM_ACPI	2
 
-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_PM_H */
diff -puN include/linux/pnp.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/pnp.h
--- a/include/linux/pnp.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/pnp.h
@@ -6,8 +6,6 @@
 #ifndef _LINUX_PNP_H
 #define _LINUX_PNP_H
 
-#ifdef __KERNEL__
-
 #include <linux/device.h>
 #include <linux/list.h>
 #include <linux/errno.h>
@@ -466,6 +464,4 @@ static inline void pnp_unregister_driver
 #define pnp_dbg(format, arg...) do {} while (0)
 #endif
 
-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_PNP_H */
diff -puN include/linux/profile.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/profile.h
--- a/include/linux/profile.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/profile.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_PROFILE_H
 #define _LINUX_PROFILE_H
 
-#ifdef __KERNEL__
-
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/cpumask.h>
@@ -118,6 +116,4 @@ static inline void unregister_timer_hook
 
 #endif /* CONFIG_PROFILING */
 
-#endif /* __KERNEL__ */
-
 #endif /* _LINUX_PROFILE_H */
diff -puN include/linux/rcuclassic.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/rcuclassic.h
--- a/include/linux/rcuclassic.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/rcuclassic.h
@@ -33,8 +33,6 @@
 #ifndef __LINUX_RCUCLASSIC_H
 #define __LINUX_RCUCLASSIC_H
 
-#ifdef __KERNEL__
-
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
@@ -163,5 +161,4 @@ extern long rcu_batches_completed_bh(voi
 #define rcu_enter_nohz()	do { } while (0)
 #define rcu_exit_nohz()		do { } while (0)
 
-#endif /* __KERNEL__ */
 #endif /* __LINUX_RCUCLASSIC_H */
diff -puN include/linux/rcupdate.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/rcupdate.h
--- a/include/linux/rcupdate.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/rcupdate.h
@@ -33,8 +33,6 @@
 #ifndef __LINUX_RCUPDATE_H
 #define __LINUX_RCUPDATE_H
 
-#ifdef __KERNEL__
-
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
@@ -245,5 +243,4 @@ extern long rcu_batches_completed_bh(voi
 extern void rcu_init(void);
 extern int rcu_needs_cpu(int cpu);
 
-#endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPDATE_H */
diff -puN include/linux/rcupreempt.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/rcupreempt.h
--- a/include/linux/rcupreempt.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/rcupreempt.h
@@ -33,8 +33,6 @@
 #ifndef __LINUX_RCUPREEMPT_H
 #define __LINUX_RCUPREEMPT_H
 
-#ifdef __KERNEL__
-
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
@@ -104,5 +102,4 @@ static inline void rcu_exit_nohz(void)
 #define rcu_exit_nohz()		do { } while (0)
 #endif /* CONFIG_NO_HZ */
 
-#endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPREEMPT_H */
diff -puN include/linux/rcupreempt_trace.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/rcupreempt_trace.h
--- a/include/linux/rcupreempt_trace.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/rcupreempt_trace.h
@@ -32,7 +32,6 @@
 #ifndef __LINUX_RCUPREEMPT_TRACE_H
 #define __LINUX_RCUPREEMPT_TRACE_H
 
-#ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/kernel.h>
 
@@ -95,5 +94,4 @@ extern void rcupreempt_trace_done_remove
 extern void rcupreempt_trace_invoke(struct rcupreempt_trace *trace);
 extern void rcupreempt_trace_next_add(struct rcupreempt_trace *trace);
 
-#endif /* __KERNEL__ */
 #endif /* __LINUX_RCUPREEMPT_TRACE_H */
diff -puN include/linux/rio.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/rio.h
--- a/include/linux/rio.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/rio.h
@@ -14,8 +14,6 @@
 #ifndef LINUX_RIO_H
 #define LINUX_RIO_H
 
-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/ioport.h>
 #include <linux/list.h>
@@ -331,5 +329,4 @@ extern void rio_close_inb_mbox(struct ri
 extern int rio_open_outb_mbox(struct rio_mport *, void *, int, int);
 extern void rio_close_outb_mbox(struct rio_mport *, int);
 
-#endif				/* __KERNEL__ */
 #endif				/* LINUX_RIO_H */
diff -puN include/linux/rio_drv.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/rio_drv.h
@@ -13,8 +13,6 @@
 #ifndef LINUX_RIO_DRV_H
 #define LINUX_RIO_DRV_H
 
-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/ioport.h>
 #include <linux/list.h>
@@ -465,5 +463,4 @@ extern struct rio_dev *rio_get_device(u1
 extern struct rio_dev *rio_get_asm(u16 vid, u16 did, u16 asm_vid, u16 asm_did,
 				   struct rio_dev *from);
 
-#endif				/* __KERNEL__ */
 #endif				/* LINUX_RIO_DRV_H */
diff -puN include/linux/rwsem.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/rwsem.h
--- a/include/linux/rwsem.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/rwsem.h
@@ -9,8 +9,6 @@
 
 #include <linux/linkage.h>
 
-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <asm/system.h>
@@ -90,5 +88,4 @@ extern void up_read_non_owner(struct rw_
 # define up_read_non_owner(sem)			up_read(sem)
 #endif
 
-#endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_H */
diff -puN include/linux/seq_file.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/seq_file.h
--- a/include/linux/seq_file.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/seq_file.h
@@ -1,6 +1,5 @@
 #ifndef _LINUX_SEQ_FILE_H
 #define _LINUX_SEQ_FILE_H
-#ifdef __KERNEL__
 
 #include <linux/types.h>
 #include <linux/string.h>
@@ -69,4 +68,3 @@ extern struct list_head *seq_list_next(v
 		loff_t *ppos);
 
 #endif
-#endif
diff -puN include/linux/slab.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/slab.h
--- a/include/linux/slab.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/slab.h
@@ -9,8 +9,6 @@
 #ifndef _LINUX_SLAB_H
 #define	_LINUX_SLAB_H
 
-#ifdef __KERNEL__
-
 #include <linux/gfp.h>
 #include <linux/types.h>
 
@@ -283,5 +281,4 @@ extern const struct seq_operations slabi
 ssize_t slabinfo_write(struct file *, const char __user *, size_t, loff_t *);
 #endif
 
-#endif	/* __KERNEL__ */
 #endif	/* _LINUX_SLAB_H */
diff -puN include/linux/smb_fs_i.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/smb_fs_i.h
--- a/include/linux/smb_fs_i.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/smb_fs_i.h
@@ -9,7 +9,6 @@
 #ifndef _LINUX_SMB_FS_I
 #define _LINUX_SMB_FS_I
 
-#ifdef __KERNEL__
 #include <linux/types.h>
 #include <linux/fs.h>
 
@@ -36,4 +35,3 @@ struct smb_inode_info {
 };
 
 #endif
-#endif
diff -puN include/linux/smb_fs_sb.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/smb_fs_sb.h
--- a/include/linux/smb_fs_sb.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/smb_fs_sb.h
@@ -9,8 +9,6 @@
 #ifndef _SMB_FS_SB
 #define _SMB_FS_SB
 
-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/smb.h>
 
@@ -96,6 +94,4 @@ smb_unlock_server(struct smb_sb_info *se
 	up(&(server->sem));
 }
 
-#endif /* __KERNEL__ */
-
 #endif
diff -puN include/linux/svga.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/svga.h
--- a/include/linux/svga.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/svga.h
@@ -1,8 +1,6 @@
 #ifndef _LINUX_SVGA_H
 #define _LINUX_SVGA_H
 
-#ifdef __KERNEL__
-
 #include <linux/pci.h>
 #include <video/vga.h>
 
@@ -122,6 +120,5 @@ void svga_set_timings(const struct svga_
 
 int svga_match_format(const struct svga_fb_format *frm, struct fb_var_screeninfo *var, struct fb_fix_screeninfo *fix);
 
-#endif /* __KERNEL__  */
 #endif /* _LINUX_SVGA_H */
 
diff -puN include/linux/textsearch.h~remove-ifdef-__kernel__-checks-from-unexported-headers include/linux/textsearch.h
--- a/include/linux/textsearch.h~remove-ifdef-__kernel__-checks-from-unexported-headers
+++ a/include/linux/textsearch.h
@@ -1,8 +1,6 @@
 #ifndef __LINUX_TEXTSEARCH_H
 #define __LINUX_TEXTSEARCH_H
 
-#ifdef __KERNEL__
-
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
@@ -177,6 +175,4 @@ static inline void *ts_config_priv(struc
 	return ((u8 *) conf + TS_PRIV_ALIGN(sizeof(struct ts_config)));
 }
 
-#endif /* __KERNEL__ */
