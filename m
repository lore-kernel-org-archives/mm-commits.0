From: akpm@linux-foundation.org
Subject: [merged]
 firmware-support-loading-into-a-pre-allocated-buffer.patch removed from -mm tree
Date: Wed, 03 Aug 2016 11:12:32 -0700
Message-ID: <57a23410.otGpqH+AtRVBE02k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbcHCSNf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 14:13:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: stephen.boyd@linaro.org, broonie@kernel.org, gregkh@linuxfoundation.org, markivx@codeaurora.org, ming.lei@canonical.com, zohar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: firmware: support loading into a pre-allocated buffer
has been removed from the -mm tree.  Its filename was
     firmware-support-loading-into-a-pre-allocated-buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <stephen.boyd@linaro.org>
Subject: firmware: support loading into a pre-allocated buffer

Some systems are memory constrained but they need to load very large
firmwares.  The firmware subsystem allows drivers to request this firmware
be loaded from the filesystem, but this requires that the entire firmware
be loaded into kernel memory first before it's provided to the driver. 
This can lead to a situation where we map the firmware twice, once to load
the firmware into kernel memory and once to copy the firmware into the
final resting place.

This creates needless memory pressure and delays loading because we have
to copy from kernel memory to somewhere else.  Let's add a
request_firmware_into_buf() API that allows drivers to request firmware be
loaded directly into a pre-allocated buffer.  This skips the intermediate
step of allocating a buffer in kernel memory to hold the firmware image
while it's read from the filesystem.  It also requires that drivers know
how much memory they'll require before requesting the firmware and negates
any benefits of firmware caching because the firmware layer doesn't manage
the buffer lifetime.

For a 16MB buffer, about half the time is spent performing a memcpy from
the buffer to the final resting place.  I see loading times go from
0.081171 seconds to 0.047696 seconds after applying this patch.  Plus the
vmalloc pressure is reduced.

This is based on a patch from Vikram Mulukutla on codeaurora.org:
https://www.codeaurora.org/cgit/quic/la/kernel/msm-3.18/commit/drivers/base/firmware_class.c?h=rel/msm-3.18&id=0a328c5f6cd999f5c591f172216835636f39bcb5

Link: http://lkml.kernel.org/r/20160607164741.31849-4-stephen.boyd@linaro.org
Signed-off-by: Stephen Boyd <stephen.boyd@linaro.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Vikram Mulukutla <markivx@codeaurora.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_class.c |  125 +++++++++++++++++++++++++-------
 fs/exec.c                     |    9 +-
 include/linux/firmware.h      |    8 ++
 include/linux/fs.h            |    1 
 4 files changed, 114 insertions(+), 29 deletions(-)

diff -puN drivers/base/firmware_class.c~firmware-support-loading-into-a-pre-allocated-buffer drivers/base/firmware_class.c
--- a/drivers/base/firmware_class.c~firmware-support-loading-into-a-pre-allocated-buffer
+++ a/drivers/base/firmware_class.c
@@ -46,7 +46,8 @@ MODULE_LICENSE("GPL");
 extern struct builtin_fw __start_builtin_fw[];
 extern struct builtin_fw __end_builtin_fw[];
 
-static bool fw_get_builtin_firmware(struct firmware *fw, const char *name)
+static bool fw_get_builtin_firmware(struct firmware *fw, const char *name,
+				    void *buf, size_t size)
 {
 	struct builtin_fw *b_fw;
 
@@ -54,6 +55,9 @@ static bool fw_get_builtin_firmware(stru
 		if (strcmp(name, b_fw->name) == 0) {
 			fw->size = b_fw->size;
 			fw->data = b_fw->data;
+
+			if (buf && fw->size <= size)
+				memcpy(buf, fw->data, fw->size);
 			return true;
 		}
 	}
@@ -74,7 +78,9 @@ static bool fw_is_builtin_firmware(const
 
 #else /* Module case - no builtin firmware support */
 
-static inline bool fw_get_builtin_firmware(struct firmware *fw, const char *name)
+static inline bool fw_get_builtin_firmware(struct firmware *fw,
+					   const char *name, void *buf,
+					   size_t size)
 {
 	return false;
 }
@@ -144,6 +150,7 @@ struct firmware_buf {
 	unsigned long status;
 	void *data;
 	size_t size;
+	size_t allocated_size;
 #ifdef CONFIG_FW_LOADER_USER_HELPER
 	bool is_paged_buf;
 	bool need_uevent;
@@ -179,7 +186,8 @@ static DEFINE_MUTEX(fw_lock);
 static struct firmware_cache fw_cache;
 
 static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
-					      struct firmware_cache *fwc)
+					      struct firmware_cache *fwc,
+					      void *dbuf, size_t size)
 {
 	struct firmware_buf *buf;
 
@@ -195,6 +203,8 @@ static struct firmware_buf *__allocate_f
 
 	kref_init(&buf->ref);
 	buf->fwc = fwc;
+	buf->data = dbuf;
+	buf->allocated_size = size;
 	init_completion(&buf->completion);
 #ifdef CONFIG_FW_LOADER_USER_HELPER
 	INIT_LIST_HEAD(&buf->pending_list);
@@ -218,7 +228,8 @@ static struct firmware_buf *__fw_lookup_
 
 static int fw_lookup_and_allocate_buf(const char *fw_name,
 				      struct firmware_cache *fwc,
-				      struct firmware_buf **buf)
+				      struct firmware_buf **buf, void *dbuf,
+				      size_t size)
 {
 	struct firmware_buf *tmp;
 
@@ -230,7 +241,7 @@ static int fw_lookup_and_allocate_buf(co
 		*buf = tmp;
 		return 1;
 	}
-	tmp = __allocate_fw_buf(fw_name, fwc);
+	tmp = __allocate_fw_buf(fw_name, fwc, dbuf, size);
 	if (tmp)
 		list_add(&tmp->list, &fwc->head);
 	spin_unlock(&fwc->lock);
@@ -262,6 +273,7 @@ static void __fw_free_buf(struct kref *r
 		vfree(buf->pages);
 	} else
 #endif
+	if (!buf->allocated_size)
 		vfree(buf->data);
 	kfree_const(buf->fw_id);
 	kfree(buf);
@@ -302,13 +314,21 @@ static void fw_finish_direct_load(struct
 	mutex_unlock(&fw_lock);
 }
 
-static int fw_get_filesystem_firmware(struct device *device,
-				       struct firmware_buf *buf)
+static int
+fw_get_filesystem_firmware(struct device *device, struct firmware_buf *buf)
 {
 	loff_t size;
 	int i, len;
 	int rc = -ENOENT;
 	char *path;
+	enum kernel_read_file_id id = READING_FIRMWARE;
+	size_t msize = INT_MAX;
+
+	/* Already populated data member means we're loading into a buffer */
+	if (buf->data) {
+		id = READING_FIRMWARE_PREALLOC_BUFFER;
+		msize = buf->allocated_size;
+	}
 
 	path = __getname();
 	if (!path)
@@ -327,8 +347,8 @@ static int fw_get_filesystem_firmware(st
 		}
 
 		buf->size = 0;
-		rc = kernel_read_file_from_path(path, &buf->data, &size,
-						INT_MAX, READING_FIRMWARE);
+		rc = kernel_read_file_from_path(path, &buf->data, &size, msize,
+						id);
 		if (rc) {
 			if (rc == -ENOENT)
 				dev_dbg(device, "loading %s failed with error %d\n",
@@ -692,6 +712,15 @@ out:
 
 static DEVICE_ATTR(loading, 0644, firmware_loading_show, firmware_loading_store);
 
+static void firmware_rw_buf(struct firmware_buf *buf, char *buffer,
+			   loff_t offset, size_t count, bool read)
+{
+	if (read)
+		memcpy(buffer, buf->data + offset, count);
+	else
+		memcpy(buf->data + offset, buffer, count);
+}
+
 static void firmware_rw(struct firmware_buf *buf, char *buffer,
 			loff_t offset, size_t count, bool read)
 {
@@ -739,7 +768,10 @@ static ssize_t firmware_data_read(struct
 
 	ret_count = count;
 
-	firmware_rw(buf, buffer, offset, count, true);
+	if (buf->data)
+		firmware_rw_buf(buf, buffer, offset, count, true);
+	else
+		firmware_rw(buf, buffer, offset, count, true);
 
 out:
 	mutex_unlock(&fw_lock);
@@ -815,12 +847,21 @@ static ssize_t firmware_data_write(struc
 		goto out;
 	}
 
-	retval = fw_realloc_buffer(fw_priv, offset + count);
-	if (retval)
-		goto out;
+	if (buf->data) {
+		if (offset + count > buf->allocated_size) {
+			retval = -ENOMEM;
+			goto out;
+		}
+		firmware_rw_buf(buf, buffer, offset, count, false);
+		retval = count;
+	} else {
+		retval = fw_realloc_buffer(fw_priv, offset + count);
+		if (retval)
+			goto out;
 
-	retval = count;
-	firmware_rw(buf, buffer, offset, count, false);
+		retval = count;
+		firmware_rw(buf, buffer, offset, count, false);
+	}
 
 	buf->size = max_t(size_t, offset + count, buf->size);
 out:
@@ -890,7 +931,8 @@ static int _request_firmware_load(struct
 	struct firmware_buf *buf = fw_priv->buf;
 
 	/* fall back on userspace loading */
-	buf->is_paged_buf = true;
+	if (!buf->data)
+		buf->is_paged_buf = true;
 
 	dev_set_uevent_suppress(f_dev, true);
 
@@ -925,7 +967,7 @@ static int _request_firmware_load(struct
 
 	if (is_fw_load_aborted(buf))
 		retval = -EAGAIN;
-	else if (!buf->data)
+	else if (buf->is_paged_buf && !buf->data)
 		retval = -ENOMEM;
 
 	device_del(f_dev);
@@ -1008,7 +1050,7 @@ static int sync_cached_firmware_buf(stru
  */
 static int
 _request_firmware_prepare(struct firmware **firmware_p, const char *name,
-			  struct device *device)
+			  struct device *device, void *dbuf, size_t size)
 {
 	struct firmware *firmware;
 	struct firmware_buf *buf;
@@ -1021,12 +1063,12 @@ _request_firmware_prepare(struct firmwar
 		return -ENOMEM;
 	}
 
-	if (fw_get_builtin_firmware(firmware, name)) {
+	if (fw_get_builtin_firmware(firmware, name, dbuf, size)) {
 		dev_dbg(device, "using built-in %s\n", name);
 		return 0; /* assigned */
 	}
 
-	ret = fw_lookup_and_allocate_buf(name, &fw_cache, &buf);
+	ret = fw_lookup_and_allocate_buf(name, &fw_cache, &buf, dbuf, size);
 
 	/*
 	 * bind with 'buf' now to avoid warning in failure path
@@ -1089,7 +1131,8 @@ static int assign_firmware_buf(struct fi
 /* called from request_firmware() and request_firmware_work_func() */
 static int
 _request_firmware(const struct firmware **firmware_p, const char *name,
-		  struct device *device, unsigned int opt_flags)
+		  struct device *device, void *buf, size_t size,
+		  unsigned int opt_flags)
 {
 	struct firmware *fw = NULL;
 	long timeout;
@@ -1103,7 +1146,7 @@ _request_firmware(const struct firmware
 		goto out;
 	}
 
-	ret = _request_firmware_prepare(&fw, name, device);
+	ret = _request_firmware_prepare(&fw, name, device, buf, size);
 	if (ret <= 0) /* error or already assigned */
 		goto out;
 
@@ -1182,7 +1225,7 @@ request_firmware(const struct firmware *
 
 	/* Need to pin this module until return */
 	__module_get(THIS_MODULE);
-	ret = _request_firmware(firmware_p, name, device,
+	ret = _request_firmware(firmware_p, name, device, NULL, 0,
 				FW_OPT_UEVENT | FW_OPT_FALLBACK);
 	module_put(THIS_MODULE);
 	return ret;
@@ -1206,7 +1249,7 @@ int request_firmware_direct(const struct
 	int ret;
 
 	__module_get(THIS_MODULE);
-	ret = _request_firmware(firmware_p, name, device,
+	ret = _request_firmware(firmware_p, name, device, NULL, 0,
 				FW_OPT_UEVENT | FW_OPT_NO_WARN);
 	module_put(THIS_MODULE);
 	return ret;
@@ -1214,6 +1257,36 @@ int request_firmware_direct(const struct
 EXPORT_SYMBOL_GPL(request_firmware_direct);
 
 /**
+ * request_firmware_into_buf - load firmware into a previously allocated buffer
+ * @firmware_p: pointer to firmware image
+ * @name: name of firmware file
+ * @device: device for which firmware is being loaded and DMA region allocated
+ * @buf: address of buffer to load firmware into
+ * @size: size of buffer
+ *
+ * This function works pretty much like request_firmware(), but it doesn't
+ * allocate a buffer to hold the firmware data. Instead, the firmware
+ * is loaded directly into the buffer pointed to by @buf and the @firmware_p
+ * data member is pointed at @buf.
+ *
+ * This function doesn't cache firmware either.
+ */
+int
+request_firmware_into_buf(const struct firmware **firmware_p, const char *name,
+			  struct device *device, void *buf, size_t size)
+{
+	int ret;
+
+	__module_get(THIS_MODULE);
+	ret = _request_firmware(firmware_p, name, device, buf, size,
+				FW_OPT_UEVENT | FW_OPT_FALLBACK |
+				FW_OPT_NOCACHE);
+	module_put(THIS_MODULE);
+	return ret;
+}
+EXPORT_SYMBOL(request_firmware_into_buf);
+
+/**
  * release_firmware: - release the resource associated with a firmware image
  * @fw: firmware resource to release
  **/
@@ -1245,7 +1318,7 @@ static void request_firmware_work_func(s
 
 	fw_work = container_of(work, struct firmware_work, work);
 
-	_request_firmware(&fw, fw_work->name, fw_work->device,
+	_request_firmware(&fw, fw_work->name, fw_work->device, NULL, 0,
 			  fw_work->opt_flags);
 	fw_work->cont(fw, fw_work->context);
 	put_device(fw_work->device); /* taken in request_firmware_nowait() */
@@ -1378,7 +1451,7 @@ static int uncache_firmware(const char *
 
 	pr_debug("%s: %s\n", __func__, fw_name);
 
-	if (fw_get_builtin_firmware(&fw, fw_name))
+	if (fw_get_builtin_firmware(&fw, fw_name, NULL, 0))
 		return 0;
 
 	buf = fw_lookup_buf(fw_name);
diff -puN fs/exec.c~firmware-support-loading-into-a-pre-allocated-buffer fs/exec.c
--- a/fs/exec.c~firmware-support-loading-into-a-pre-allocated-buffer
+++ a/fs/exec.c
@@ -866,7 +866,8 @@ int kernel_read_file(struct file *file,
 		goto out;
 	}
 
-	*buf = vmalloc(i_size);
+	if (id != READING_FIRMWARE_PREALLOC_BUFFER)
+		*buf = vmalloc(i_size);
 	if (!*buf) {
 		ret = -ENOMEM;
 		goto out;
@@ -897,8 +898,10 @@ int kernel_read_file(struct file *file,
 
 out_free:
 	if (ret < 0) {
-		vfree(*buf);
-		*buf = NULL;
+		if (id != READING_FIRMWARE_PREALLOC_BUFFER) {
+			vfree(*buf);
+			*buf = NULL;
+		}
 	}
 
 out:
diff -puN include/linux/firmware.h~firmware-support-loading-into-a-pre-allocated-buffer include/linux/firmware.h
--- a/include/linux/firmware.h~firmware-support-loading-into-a-pre-allocated-buffer
+++ a/include/linux/firmware.h
@@ -47,6 +47,8 @@ int request_firmware_nowait(
 	void (*cont)(const struct firmware *fw, void *context));
 int request_firmware_direct(const struct firmware **fw, const char *name,
 			    struct device *device);
+int request_firmware_into_buf(const struct firmware **firmware_p,
+	const char *name, struct device *device, void *buf, size_t size);
 
 void release_firmware(const struct firmware *fw);
 #else
@@ -74,6 +76,12 @@ static inline int request_firmware_direc
 {
 	return -EINVAL;
 }
+
+static inline int request_firmware_into_buf(const struct firmware **firmware_p,
+	const char *name, struct device *device, void *buf, size_t size)
+{
+	return -EINVAL;
+}
 
 #endif
 #endif
diff -puN include/linux/fs.h~firmware-support-loading-into-a-pre-allocated-buffer include/linux/fs.h
--- a/include/linux/fs.h~firmware-support-loading-into-a-pre-allocated-buffer
+++ a/include/linux/fs.h
@@ -2652,6 +2652,7 @@ extern int do_pipe_flags(int *, int);
 #define __kernel_read_file_id(id) \
 	id(UNKNOWN, unknown)		\
 	id(FIRMWARE, firmware)		\
+	id(FIRMWARE_PREALLOC_BUFFER, firmware)	\
 	id(MODULE, kernel-module)		\
 	id(KEXEC_IMAGE, kexec-image)		\
 	id(KEXEC_INITRAMFS, kexec-initramfs)	\
_

Patches currently in -mm which might be from stephen.boyd@linaro.org are


