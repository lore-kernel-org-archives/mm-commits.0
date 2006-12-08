From: akpm@osdl.org
Subject: - struct-path-convert-drm.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:02:59 -0800
Message-ID: <200612082002.kB8K2xno002026@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:57100 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1426247AbWLHUDG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:03:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jsipek@fsl.cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     struct path: convert drm
has been removed from the -mm tree.  Its filename was
     struct-path-convert-drm.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: struct path: convert drm
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>

Signed-off-by: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/drm/drm_ioc32.c    |   56 +++++++++++++++---------------
 drivers/char/drm/i915_ioc32.c   |   12 +++---
 drivers/char/drm/mga_ioc32.c    |    8 ++--
 drivers/char/drm/r128_ioc32.c   |   10 ++---
 drivers/char/drm/radeon_ioc32.c |   20 +++++-----
 5 files changed, 53 insertions(+), 53 deletions(-)

diff -puN drivers/char/drm/drm_ioc32.c~struct-path-convert-drm drivers/char/drm/drm_ioc32.c
--- a/drivers/char/drm/drm_ioc32.c~struct-path-convert-drm
+++ a/drivers/char/drm/drm_ioc32.c
@@ -102,7 +102,7 @@ static int compat_drm_version(struct fil
 			  &version->desc))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_VERSION, (unsigned long)version);
 	if (err)
 		return err;
@@ -143,7 +143,7 @@ static int compat_drm_getunique(struct f
 			  &u->unique))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_GET_UNIQUE, (unsigned long)u);
 	if (err)
 		return err;
@@ -172,7 +172,7 @@ static int compat_drm_setunique(struct f
 			  &u->unique))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_SET_UNIQUE, (unsigned long)u);
 }
 
@@ -203,7 +203,7 @@ static int compat_drm_getmap(struct file
 	if (__put_user(idx, &map->offset))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_GET_MAP, (unsigned long)map);
 	if (err)
 		return err;
@@ -244,7 +244,7 @@ static int compat_drm_addmap(struct file
 	    || __put_user(m32.flags, &map->flags))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_ADD_MAP, (unsigned long)map);
 	if (err)
 		return err;
@@ -282,7 +282,7 @@ static int compat_drm_rmmap(struct file 
 	if (__put_user((void *)(unsigned long)handle, &map->handle))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_RM_MAP, (unsigned long)map);
 }
 
@@ -312,7 +312,7 @@ static int compat_drm_getclient(struct f
 	if (__put_user(idx, &client->idx))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_GET_CLIENT, (unsigned long)client);
 	if (err)
 		return err;
@@ -349,7 +349,7 @@ static int compat_drm_getstats(struct fi
 	if (!access_ok(VERIFY_WRITE, stats, sizeof(*stats)))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_GET_STATS, (unsigned long)stats);
 	if (err)
 		return err;
@@ -393,7 +393,7 @@ static int compat_drm_addbufs(struct fil
 	    || __put_user(agp_start, &buf->agp_start))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_ADD_BUFS, (unsigned long)buf);
 	if (err)
 		return err;
@@ -425,7 +425,7 @@ static int compat_drm_markbufs(struct fi
 	    || __put_user(b32.high_mark, &buf->high_mark))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_MARK_BUFS, (unsigned long)buf);
 }
 
@@ -467,7 +467,7 @@ static int compat_drm_infobufs(struct fi
 	    || __put_user(list, &request->list))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_INFO_BUFS, (unsigned long)request);
 	if (err)
 		return err;
@@ -529,7 +529,7 @@ static int compat_drm_mapbufs(struct fil
 	    || __put_user(list, &request->list))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_MAP_BUFS, (unsigned long)request);
 	if (err)
 		return err;
@@ -576,7 +576,7 @@ static int compat_drm_freebufs(struct fi
 			  &request->list))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_FREE_BUFS, (unsigned long)request);
 }
 
@@ -603,7 +603,7 @@ static int compat_drm_setsareactx(struct
 			  &request->handle))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_SET_SAREA_CTX, (unsigned long)request);
 }
 
@@ -626,7 +626,7 @@ static int compat_drm_getsareactx(struct
 	if (__put_user(ctx_id, &request->ctx_id))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_GET_SAREA_CTX, (unsigned long)request);
 	if (err)
 		return err;
@@ -662,7 +662,7 @@ static int compat_drm_resctx(struct file
 			  &res->contexts))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_RES_CTX, (unsigned long)res);
 	if (err)
 		return err;
@@ -716,7 +716,7 @@ static int compat_drm_dma(struct file *f
 			  &d->request_sizes))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_DMA, (unsigned long)d);
 	if (err)
 		return err;
@@ -749,7 +749,7 @@ static int compat_drm_agp_enable(struct 
 	if (put_user(m32.mode, &mode->mode))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_AGP_ENABLE, (unsigned long)mode);
 }
 
@@ -779,7 +779,7 @@ static int compat_drm_agp_info(struct fi
 	if (!access_ok(VERIFY_WRITE, info, sizeof(*info)))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_AGP_INFO, (unsigned long)info);
 	if (err)
 		return err;
@@ -825,7 +825,7 @@ static int compat_drm_agp_alloc(struct f
 	    || __put_user(req32.type, &request->type))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_AGP_ALLOC, (unsigned long)request);
 	if (err)
 		return err;
@@ -833,7 +833,7 @@ static int compat_drm_agp_alloc(struct f
 	if (__get_user(req32.handle, &request->handle)
 	    || __get_user(req32.physical, &request->physical)
 	    || copy_to_user(argp, &req32, sizeof(req32))) {
-		drm_ioctl(file->f_dentry->d_inode, file,
+		drm_ioctl(file->f_path.dentry->d_inode, file,
 			  DRM_IOCTL_AGP_FREE, (unsigned long)request);
 		return -EFAULT;
 	}
@@ -854,7 +854,7 @@ static int compat_drm_agp_free(struct fi
 	    || __put_user(handle, &request->handle))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_AGP_FREE, (unsigned long)request);
 }
 
@@ -879,7 +879,7 @@ static int compat_drm_agp_bind(struct fi
 	    || __put_user(req32.offset, &request->offset))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_AGP_BIND, (unsigned long)request);
 }
 
@@ -896,7 +896,7 @@ static int compat_drm_agp_unbind(struct 
 	    || __put_user(handle, &request->handle))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_AGP_UNBIND, (unsigned long)request);
 }
 #endif				/* __OS_HAS_AGP */
@@ -921,7 +921,7 @@ static int compat_drm_sg_alloc(struct fi
 	    || __put_user(x, &request->size))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_SG_ALLOC, (unsigned long)request);
 	if (err)
 		return err;
@@ -948,7 +948,7 @@ static int compat_drm_sg_free(struct fil
 	    || __put_user(x << PAGE_SHIFT, &request->handle))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_SG_FREE, (unsigned long)request);
 }
 
@@ -988,7 +988,7 @@ static int compat_drm_wait_vblank(struct
 	    || __put_user(req32.request.signal, &request->request.signal))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_WAIT_VBLANK, (unsigned long)request);
 	if (err)
 		return err;
@@ -1060,7 +1060,7 @@ long drm_compat_ioctl(struct file *filp,
 	if (fn != NULL)
 		ret = (*fn) (filp, cmd, arg);
 	else
-		ret = drm_ioctl(filp->f_dentry->d_inode, filp, cmd, arg);
+		ret = drm_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
 	unlock_kernel();
 
 	return ret;
diff -puN drivers/char/drm/i915_ioc32.c~struct-path-convert-drm drivers/char/drm/i915_ioc32.c
--- a/drivers/char/drm/i915_ioc32.c~struct-path-convert-drm
+++ a/drivers/char/drm/i915_ioc32.c
@@ -66,7 +66,7 @@ static int compat_i915_batchbuffer(struc
 			  &batchbuffer->cliprects))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_I915_BATCHBUFFER,
 			 (unsigned long)batchbuffer);
 }
@@ -102,7 +102,7 @@ static int compat_i915_cmdbuffer(struct 
 			  &cmdbuffer->cliprects))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_I915_CMDBUFFER, (unsigned long)cmdbuffer);
 }
 
@@ -125,7 +125,7 @@ static int compat_i915_irq_emit(struct f
 			  &request->irq_seq))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_I915_IRQ_EMIT, (unsigned long)request);
 }
 typedef struct drm_i915_getparam32 {
@@ -149,7 +149,7 @@ static int compat_i915_getparam(struct f
 			  &request->value))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_I915_GETPARAM, (unsigned long)request);
 }
 
@@ -178,7 +178,7 @@ static int compat_i915_alloc(struct file
 			  &request->region_offset))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_I915_ALLOC, (unsigned long)request);
 }
 
@@ -215,7 +215,7 @@ long i915_compat_ioctl(struct file *filp
 	if (fn != NULL)
 		ret = (*fn) (filp, cmd, arg);
 	else
-		ret = drm_ioctl(filp->f_dentry->d_inode, filp, cmd, arg);
+		ret = drm_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
 	unlock_kernel();
 
 	return ret;
diff -puN drivers/char/drm/mga_ioc32.c~struct-path-convert-drm drivers/char/drm/mga_ioc32.c
--- a/drivers/char/drm/mga_ioc32.c~struct-path-convert-drm
+++ a/drivers/char/drm/mga_ioc32.c
@@ -100,7 +100,7 @@ static int compat_mga_init(struct file *
 	if (err)
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_MGA_INIT, (unsigned long)init);
 }
 
@@ -125,7 +125,7 @@ static int compat_mga_getparam(struct fi
 			  &getparam->value))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_MGA_GETPARAM, (unsigned long)getparam);
 }
 
@@ -166,7 +166,7 @@ static int compat_mga_dma_bootstrap(stru
 	    || __put_user(dma_bootstrap32.agp_size, &dma_bootstrap->agp_size))
 		return -EFAULT;
 
-	err = drm_ioctl(file->f_dentry->d_inode, file,
+	err = drm_ioctl(file->f_path.dentry->d_inode, file,
 			DRM_IOCTL_MGA_DMA_BOOTSTRAP,
 			(unsigned long)dma_bootstrap);
 	if (err)
@@ -224,7 +224,7 @@ long mga_compat_ioctl(struct file *filp,
 	if (fn != NULL)
 		ret = (*fn) (filp, cmd, arg);
 	else
-		ret = drm_ioctl(filp->f_dentry->d_inode, filp, cmd, arg);
+		ret = drm_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
 	unlock_kernel();
 
 	return ret;
diff -puN drivers/char/drm/r128_ioc32.c~struct-path-convert-drm drivers/char/drm/r128_ioc32.c
--- a/drivers/char/drm/r128_ioc32.c~struct-path-convert-drm
+++ a/drivers/char/drm/r128_ioc32.c
@@ -95,7 +95,7 @@ static int compat_r128_init(struct file 
 			  &init->agp_textures_offset))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_R128_INIT, (unsigned long)init);
 }
 
@@ -129,7 +129,7 @@ static int compat_r128_depth(struct file
 			  &depth->mask))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_R128_DEPTH, (unsigned long)depth);
 
 }
@@ -153,7 +153,7 @@ static int compat_r128_stipple(struct fi
 			  &stipple->mask))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_R128_STIPPLE, (unsigned long)stipple);
 }
 
@@ -178,7 +178,7 @@ static int compat_r128_getparam(struct f
 			  &getparam->value))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_R128_GETPARAM, (unsigned long)getparam);
 }
 
@@ -214,7 +214,7 @@ long r128_compat_ioctl(struct file *filp
 	if (fn != NULL)
 		ret = (*fn) (filp, cmd, arg);
 	else
-		ret = drm_ioctl(filp->f_dentry->d_inode, filp, cmd, arg);
+		ret = drm_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
 	unlock_kernel();
 
 	return ret;
diff -puN drivers/char/drm/radeon_ioc32.c~struct-path-convert-drm drivers/char/drm/radeon_ioc32.c
--- a/drivers/char/drm/radeon_ioc32.c~struct-path-convert-drm
+++ a/drivers/char/drm/radeon_ioc32.c
@@ -92,7 +92,7 @@ static int compat_radeon_cp_init(struct 
 			  &init->gart_textures_offset))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_RADEON_CP_INIT, (unsigned long)init);
 }
 
@@ -125,7 +125,7 @@ static int compat_radeon_cp_clear(struct
 			  &clr->depth_boxes))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_RADEON_CLEAR, (unsigned long)clr);
 }
 
@@ -149,7 +149,7 @@ static int compat_radeon_cp_stipple(stru
 			  &request->mask))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_RADEON_STIPPLE, (unsigned long)request);
 }
 
@@ -204,7 +204,7 @@ static int compat_radeon_cp_texture(stru
 			  &image->data))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_RADEON_TEXTURE, (unsigned long)request);
 }
 
@@ -238,7 +238,7 @@ static int compat_radeon_cp_vertex2(stru
 			  &request->prim))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_RADEON_VERTEX2, (unsigned long)request);
 }
 
@@ -268,7 +268,7 @@ static int compat_radeon_cp_cmdbuf(struc
 			  &request->boxes))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_RADEON_CMDBUF, (unsigned long)request);
 }
 
@@ -293,7 +293,7 @@ static int compat_radeon_cp_getparam(str
 			  &request->value))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_RADEON_GETPARAM, (unsigned long)request);
 }
 
@@ -322,7 +322,7 @@ static int compat_radeon_mem_alloc(struc
 			  &request->region_offset))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_RADEON_ALLOC, (unsigned long)request);
 }
 
@@ -345,7 +345,7 @@ static int compat_radeon_irq_emit(struct
 			  &request->irq_seq))
 		return -EFAULT;
 
-	return drm_ioctl(file->f_dentry->d_inode, file,
+	return drm_ioctl(file->f_path.dentry->d_inode, file,
 			 DRM_IOCTL_RADEON_IRQ_EMIT, (unsigned long)request);
 }
 
@@ -386,7 +386,7 @@ long radeon_compat_ioctl(struct file *fi
 	if (fn != NULL)
 		ret = (*fn) (filp, cmd, arg);
 	else
-		ret = drm_ioctl(filp->f_dentry->d_inode, filp, cmd, arg);
+		ret = drm_ioctl(filp->f_path.dentry->d_inode, filp, cmd, arg);
 	unlock_kernel();
 
 	return ret;
_

Patches currently in -mm which might be from jsipek@fsl.cs.sunysb.edu are

struct-path-convert-drm.patch
struct-path-convert-efs.patch
struct-path-convert-freevxfs.patch
struct-path-convert-frv.patch
struct-path-convert-fuse.patch
struct-path-convert-gfs2.patch
struct-path-convert-hfs.patch
struct-path-convert-hfsplus.patch
struct-path-convert-hostfs.patch
struct-path-convert-hpfs.patch
struct-path-convert-hppfs.patch
struct-path-convert-hugetlbfs.patch
struct-path-convert-i2c-drivers.patch
struct-path-convert-ia64.patch
struct-path-convert-ieee1394.patch
struct-path-convert-infiniband.patch
struct-path-convert-ipc.patch
struct-path-convert-ipmi.patch
struct-path-convert-isapnp.patch
struct-path-convert-isdn.patch
struct-path-convert-ixj.patch
struct-path-convert-jffs.patch
struct-path-convert-jffs2.patch
struct-path-convert-jfs.patch
struct-path-convert-kernel.patch
struct-path-convert-lockd.patch
struct-path-convert-md.patch
struct-path-convert-minix.patch
struct-path-convert-mips.patch
struct-path-convert-mm.patch
struct-path-convert-nbd.patch
struct-path-convert-ncpfs.patch
struct-path-convert-net.patch
struct-path-convert-netfilter.patch
struct-path-convert-netlink.patch
struct-path-convert-ocfs2.patch
struct-path-convert-openpromfs.patch
struct-path-convert-oprofile.patch
struct-path-convert-parisc.patch
struct-path-convert-pci.patch
struct-path-convert-pcmcia.patch
struct-path-convert-powerpc.patch
struct-path-convert-ppc.patch
struct-path-convert-qnx4.patch
struct-path-convert-ramfs.patch
struct-path-convert-reiserfs.patch
struct-path-convert-romfs.patch
struct-path-convert-s390-drivers.patch
struct-path-convert-s390.patch
struct-path-convert-sbus.patch
struct-path-convert-scsi.patch
struct-path-convert-selinux.patch
struct-path-convert-sh.patch
struct-path-convert-smbfs.patch
struct-path-convert-sound.patch
struct-path-convert-sparc.patch
struct-path-convert-sparc64.patch
struct-path-convert-sunrpc.patch
struct-path-convert-sysv.patch
struct-path-convert-udf.patch
struct-path-convert-ufs.patch
struct-path-convert-unix.patch
struct-path-convert-usb.patch
struct-path-convert-v4l.patch
struct-path-convert-video.patch
struct-path-convert-zorro.patch

