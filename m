Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2170E2FD69E
	for <mm-commits@vger.kernel.org>; Mon, 29 Jun 2026 23:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782777566; cv=none; b=HdvgbIoR3521ixIIUsvPKLVsfROfyb0PDkx76yJv5nJJJh6A81BpOk9bgSdS3Hsl2GK3nngBh38vjEK9F5qOokFgIhPYnLQjFDpoFt4iFtYvBHitFd4x2TiSDil4Vp7BQrq118y5sHpxrNNAR5p3uQRBoXsJkNF/nRW4PxmmwjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782777566; c=relaxed/simple;
	bh=yPvGQ+GVV6JM6qlTjipgfnFRiygY+6YU5RsUtI9eg/o=;
	h=Date:To:From:Subject:Message-Id; b=C7fE7otdf2CQrxbYhBLLwenejGhjWMhqCEQ9J3BRK0SGmCAqbyo1//xcF+HoXsRJCHHk2tGf/Y5cKui8sYehBtztqvb8s1nNZKx/QsAUTNla8LzBh+RD/00IN+E0tVKzOtiiz0QZIRFaio4ObqH9CW3EgPZqYc8ETOUkNectjTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rh4SIJQY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rh4SIJQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DFE1F000E9;
	Mon, 29 Jun 2026 23:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782777564;
	bh=DSrgcNAsx4IxsnZUcGfsaVYIj12piQ4r1/4Zjj5Pn3Y=;
	h=Date:To:From:Subject;
	b=rh4SIJQYx3uX868ZsMRuqHe5/aLGoffjgpyrZVa7OzXh6ygdlC+JGjudAMoeNyI92
	 PSOzdj7rvyA3JqmPgqRMWTNk2tg3kVUWGhZK5D9REiMvWsDTFfRMli+jNMNh44jKfm
	 /cpFi+aT/H0d1owFg1ijC21q5bEOFI8rA20+wYeU=
Date: Mon, 29 Jun 2026 16:59:24 -0700
To: mm-commits@vger.kernel.org,xuanzhuo@linux.alibaba.com,rppt@kernel.org,pabeni@redhat.com,mst@redhat.com,ljs@kernel.org,jasowang@redhat.com,eperezma@redhat.com,chenyichong@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-virtio-add-missing-compat-definitions-for-vhost_net_test.patch added to mm-hotfixes-unstable branch
Message-Id: <20260629235924.93DFE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/virtio: add missing compat definitions for vhost_net_test
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     tools-virtio-add-missing-compat-definitions-for-vhost_net_test.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-virtio-add-missing-compat-definitions-for-vhost_net_test.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Yichong Chen <chenyichong@uniontech.com>
Subject: tools/virtio: add missing compat definitions for vhost_net_test
Date: Mon, 29 Jun 2026 10:21:23 +0800

Patch series "tools: Fix tools/virtio test build", v2.

This series fixes build failures hit by:

  make -C tools/virtio test

Patch 1 adds tools/virtio compatibility definitions needed by current
virtio headers when building the tools/virtio tests.  Patch 2 makes
tools/include/linux/overflow.h include stdint.h for SIZE_MAX, which is
used by its size helper functions.

With the series applied, make -C tools/virtio test builds virtio_test,
vringh_test and vhost_net_test successfully.

Tested on x86_64 and arm64 with:

  make -C tools/virtio clean
  make -C tools/virtio test


This patch (of 2):

vhost_net_test builds virtio_ring.c in userspace.

Recent virtio headers pull in helper headers that are not provided by the
tools/virtio compatibility layer, including asm/percpu_types.h,
linux/completion.h, linux/mod_devicetable.h and linux/virtio_features.h.

Add the missing compat definitions and the DMA attribute used by the
current virtio ring code.

Link: https://lore.kernel.org/20260629022124.131894-1-chenyichong@uniontech.com
Link: https://lore.kernel.org/20260629022124.131894-2-chenyichong@uniontech.com
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Cc: chenyichong <chenyichong@uniontech.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/virtio/asm/percpu_types.h      |    7 ++
 tools/virtio/linux/completion.h      |    9 ++
 tools/virtio/linux/device.h          |    1 
 tools/virtio/linux/dma-mapping.h     |    1 
 tools/virtio/linux/mod_devicetable.h |   14 ++++
 tools/virtio/linux/virtio_features.h |   79 +++++++++++++++++++++++++
 6 files changed, 111 insertions(+)

diff --git a/tools/virtio/asm/percpu_types.h a/tools/virtio/asm/percpu_types.h
new file mode 100644
--- /dev/null
+++ a/tools/virtio/asm/percpu_types.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_PERCPU_TYPES_H
+#define _ASM_PERCPU_TYPES_H
+
+#define __percpu_qual
+
+#endif /* _ASM_PERCPU_TYPES_H */
diff --git a/tools/virtio/linux/completion.h a/tools/virtio/linux/completion.h
new file mode 100644
--- /dev/null
+++ a/tools/virtio/linux/completion.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_COMPLETION_H
+#define _LINUX_COMPLETION_H
+
+struct completion {
+	unsigned int done;
+};
+
+#endif /* _LINUX_COMPLETION_H */
--- a/tools/virtio/linux/device.h~tools-virtio-add-missing-compat-definitions-for-vhost_net_test
+++ a/tools/virtio/linux/device.h
@@ -1,4 +1,5 @@
 #ifndef LINUX_DEVICE_H
+#define LINUX_DEVICE_H
 
 struct device {
 	void *parent;
--- a/tools/virtio/linux/dma-mapping.h~tools-virtio-add-missing-compat-definitions-for-vhost_net_test
+++ a/tools/virtio/linux/dma-mapping.h
@@ -61,5 +61,6 @@ enum dma_data_direction {
 #define DMA_MAPPING_ERROR		(~(dma_addr_t)0)
 
 #define DMA_ATTR_CPU_CACHE_CLEAN	(1UL << 11)
+#define DMA_ATTR_DEBUGGING_IGNORE_CACHELINES	0
 
 #endif
diff --git a/tools/virtio/linux/mod_devicetable.h a/tools/virtio/linux/mod_devicetable.h
new file mode 100644
--- /dev/null
+++ a/tools/virtio/linux/mod_devicetable.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MOD_DEVICETABLE_H
+#define _LINUX_MOD_DEVICETABLE_H
+
+#include <linux/types.h>
+
+struct virtio_device_id {
+	__u32 device;
+	__u32 vendor;
+};
+
+#define VIRTIO_DEV_ANY_ID	0xffffffff
+
+#endif /* _LINUX_MOD_DEVICETABLE_H */
diff --git a/tools/virtio/linux/virtio_features.h a/tools/virtio/linux/virtio_features.h
new file mode 100644
--- /dev/null
+++ a/tools/virtio/linux/virtio_features.h
@@ -0,0 +1,79 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_VIRTIO_FEATURES_H
+#define _LINUX_VIRTIO_FEATURES_H
+
+#include <linux/bug.h>
+#include <linux/string.h>
+#include <linux/types.h>
+
+#define VIRTIO_FEATURES_U64S	2
+#define VIRTIO_FEATURES_BITS	(VIRTIO_FEATURES_U64S * 64)
+
+#define VIRTIO_BIT(b)		(1ULL << ((b) & 0x3f))
+#define VIRTIO_U64(b)		((b) >> 6)
+
+#define VIRTIO_DECLARE_FEATURES(name)			\
+	union {						\
+		u64 name;					\
+		u64 name##_array[VIRTIO_FEATURES_U64S];\
+	}
+
+static inline bool virtio_features_chk_bit(unsigned int bit)
+{
+	return bit < VIRTIO_FEATURES_BITS;
+}
+
+static inline bool virtio_features_test_bit(const u64 *features,
+					    unsigned int bit)
+{
+	return virtio_features_chk_bit(bit) &&
+	       !!(features[VIRTIO_U64(bit)] & VIRTIO_BIT(bit));
+}
+
+static inline void virtio_features_set_bit(u64 *features, unsigned int bit)
+{
+	if (virtio_features_chk_bit(bit))
+		features[VIRTIO_U64(bit)] |= VIRTIO_BIT(bit);
+}
+
+static inline void virtio_features_clear_bit(u64 *features, unsigned int bit)
+{
+	if (virtio_features_chk_bit(bit))
+		features[VIRTIO_U64(bit)] &= ~VIRTIO_BIT(bit);
+}
+
+static inline void virtio_features_zero(u64 *features)
+{
+	memset(features, 0, sizeof(features[0]) * VIRTIO_FEATURES_U64S);
+}
+
+static inline void virtio_features_from_u64(u64 *features, u64 from)
+{
+	virtio_features_zero(features);
+	features[0] = from;
+}
+
+static inline bool virtio_features_equal(const u64 *f1, const u64 *f2)
+{
+	int i;
+
+	for (i = 0; i < VIRTIO_FEATURES_U64S; ++i)
+		if (f1[i] != f2[i])
+			return false;
+	return true;
+}
+
+static inline void virtio_features_copy(u64 *to, const u64 *from)
+{
+	memcpy(to, from, sizeof(to[0]) * VIRTIO_FEATURES_U64S);
+}
+
+static inline void virtio_features_andnot(u64 *to, const u64 *f1, const u64 *f2)
+{
+	int i;
+
+	for (i = 0; i < VIRTIO_FEATURES_U64S; i++)
+		to[i] = f1[i] & ~f2[i];
+}
+
+#endif /* _LINUX_VIRTIO_FEATURES_H */
_

Patches currently in -mm which might be from chenyichong@uniontech.com are

tools-virtio-add-missing-compat-definitions-for-vhost_net_test.patch
tools-include-include-stdinth-for-size_max-in-overflowh.patch
tools-mm-page_owner_sort-return-explicit-filter-results.patch
tools-mm-page_owner_sort-free-per-record-allocations.patch
tools-mm-page_owner_sort-bound-pattern-output-copies.patch

