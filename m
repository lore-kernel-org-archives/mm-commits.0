From: akpm@linux-foundation.org
Subject: + lib-scatterlist-add-sg-splitting-function.patch added to -mm
 tree
Date: Mon, 24 Aug 2015 12:50:58 -0700
Message-ID: <55db75a2.gITehXrHBuU+udfp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbbHXTu7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 24 Aug 2015 15:50:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: robert.jarzmik@free.fr, axboe@kernel.dk, g.liakhovetski@gmx.de, linux@arm.linux.org.uk, mchehab@osg.samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: scatterlist: add sg splitting function
has been added to the -mm tree.  Its filename is
     lib-scatterlist-add-sg-splitting-function.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-scatterlist-add-sg-splitting-function.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-scatterlist-add-sg-splitting-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: lib: scatterlist: add sg splitting function

Sometimes a scatter-gather has to be split into several chunks, or sub
scatter lists.  This happens for example if a scatter list will be handled
by multiple DMA channels, each one filling a part of it.

A concrete example comes with the media V4L2 API, where the scatter list
is allocated from userspace to hold an image, regardless of the
knowledge of how many DMAs will fill it :

 - in a simple RGB565 case, one DMA will pump data from the camera ISP
   to memory
 - in the trickier YUV422 case, 3 DMAs will pump data from the camera
   ISP pipes, one for pipe Y, one for pipe U and one for pipe V

For these cases, it is necessary to split the original scatter list into
multiple scatter lists, which is the purpose of this patch.

The guarantees that are required for this patch are :

 - the intersection of spans of any couple of resulting scatter lists is
   empty.
 - the union of spans of all resulting scatter lists is a subrange of
   the span of the original scatter list.
 - streaming DMA API operations (mapping, unmapping) should not happen
   both on both the resulting and the original scatter list. It's either
   the first or the later ones.
 - the caller is reponsible to call kfree() on the resulting
   scatterlists.

Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    5 
 lib/Kconfig                 |    7 +
 lib/Makefile                |    1 
 lib/sg_split.c              |  202 ++++++++++++++++++++++++++++++++++
 4 files changed, 215 insertions(+)

diff -puN include/linux/scatterlist.h~lib-scatterlist-add-sg-splitting-function include/linux/scatterlist.h
--- a/include/linux/scatterlist.h~lib-scatterlist-add-sg-splitting-function
+++ a/include/linux/scatterlist.h
@@ -251,6 +251,11 @@ struct scatterlist *sg_next(struct scatt
 struct scatterlist *sg_last(struct scatterlist *s, unsigned int);
 void sg_init_table(struct scatterlist *, unsigned int);
 void sg_init_one(struct scatterlist *, const void *, unsigned int);
+int sg_split(struct scatterlist *in, const int in_mapped_nents,
+	     const off_t skip, const int nb_splits,
+	     const size_t *split_sizes,
+	     struct scatterlist **out, int *out_mapped_nents,
+	     gfp_t gfp_mask);
 
 typedef struct scatterlist *(sg_alloc_fn)(unsigned int, gfp_t);
 typedef void (sg_free_fn)(struct scatterlist *, unsigned int);
diff -puN lib/Kconfig~lib-scatterlist-add-sg-splitting-function lib/Kconfig
--- a/lib/Kconfig~lib-scatterlist-add-sg-splitting-function
+++ a/lib/Kconfig
@@ -528,6 +528,13 @@ config UCS2_STRING
 
 source "lib/fonts/Kconfig"
 
+config SG_SPLIT
+	def_bool n
+	help
+	 Provides a heler to split scatterlists into chunks, each chunk being a
+	 scatterlist. This should be selected by a driver or an API which
+	 whishes to split a scatterlist amongst multiple DMA channel.
+
 #
 # sg chaining option
 #
diff -puN lib/Makefile~lib-scatterlist-add-sg-splitting-function lib/Makefile
--- a/lib/Makefile~lib-scatterlist-add-sg-splitting-function
+++ a/lib/Makefile
@@ -163,6 +163,7 @@ obj-$(CONFIG_GENERIC_STRNLEN_USER) += st
 
 obj-$(CONFIG_GENERIC_NET_UTILS) += net_utils.o
 
+obj-$(CONFIG_SG_SPLIT) += sg_split.o
 obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
 
 libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o \
diff -puN /dev/null lib/sg_split.c
--- /dev/null
+++ a/lib/sg_split.c
@@ -0,0 +1,202 @@
+/*
+ * Copyright (C) 2015 Robert Jarzmik <robert.jarzmik@free.fr>
+ *
+ * Scatterlist splitting helpers.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2. See the file COPYING for more details.
+ */
+
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+
+struct sg_splitter {
+	struct scatterlist *in_sg0;
+	int nents;
+	off_t skip_sg0;
+	unsigned int length_last_sg;
+
+	struct scatterlist *out_sg;
+};
+
+static int sg_calculate_split(struct scatterlist *in, int nents, int nb_splits,
+			      off_t skip, const size_t *sizes,
+			      struct sg_splitter *splitters, bool mapped)
+{
+	int i;
+	unsigned int sglen;
+	size_t size = sizes[0], len;
+	struct sg_splitter *curr = splitters;
+	struct scatterlist *sg;
+
+	for (i = 0; i < nb_splits; i++) {
+		splitters[i].in_sg0 = NULL;
+		splitters[i].nents = 0;
+	}
+
+	for_each_sg(in, sg, nents, i) {
+		sglen = mapped ? sg_dma_len(sg) : sg->length;
+		if (skip > sglen) {
+			skip -= sglen;
+			continue;
+		}
+
+		len = min_t(size_t, size, sglen - skip);
+		if (!curr->in_sg0) {
+			curr->in_sg0 = sg;
+			curr->skip_sg0 = skip;
+		}
+		size -= len;
+		curr->nents++;
+		curr->length_last_sg = len;
+
+		while (!size && (skip + len < sglen) && (--nb_splits > 0)) {
+			curr++;
+			size = *(++sizes);
+			skip += len;
+			len = min_t(size_t, size, sglen - skip);
+
+			curr->in_sg0 = sg;
+			curr->skip_sg0 = skip;
+			curr->nents = 1;
+			curr->length_last_sg = len;
+			size -= len;
+		}
+		skip = 0;
+
+		if (!size && --nb_splits > 0) {
+			curr++;
+			size = *(++sizes);
+		}
+
+		if (!nb_splits)
+			break;
+	}
+
+	return (size || !splitters[0].in_sg0) ? -EINVAL : 0;
+}
+
+static void sg_split_phys(struct sg_splitter *splitters, const int nb_splits)
+{
+	int i, j;
+	struct scatterlist *in_sg, *out_sg;
+	struct sg_splitter *split;
+
+	for (i = 0, split = splitters; i < nb_splits; i++, split++) {
+		in_sg = split->in_sg0;
+		out_sg = split->out_sg;
+		for (j = 0; j < split->nents; j++, out_sg++) {
+			*out_sg = *in_sg;
+			if (!j) {
+				out_sg->offset += split->skip_sg0;
+				out_sg->length -= split->skip_sg0;
+			} else {
+				out_sg->offset = 0;
+			}
+			sg_dma_address(out_sg) = 0;
+			sg_dma_len(out_sg) = 0;
+			in_sg = sg_next(in_sg);
+		}
+		out_sg[-1].length = split->length_last_sg;
+		sg_mark_end(out_sg - 1);
+	}
+}
+
+static void sg_split_mapped(struct sg_splitter *splitters, const int nb_splits)
+{
+	int i, j;
+	struct scatterlist *in_sg, *out_sg;
+	struct sg_splitter *split;
+
+	for (i = 0, split = splitters; i < nb_splits; i++, split++) {
+		in_sg = split->in_sg0;
+		out_sg = split->out_sg;
+		for (j = 0; j < split->nents; j++, out_sg++) {
+			sg_dma_address(out_sg) = sg_dma_address(in_sg);
+			sg_dma_len(out_sg) = sg_dma_len(in_sg);
+			if (!j) {
+				sg_dma_address(out_sg) += split->skip_sg0;
+				sg_dma_len(out_sg) -= split->skip_sg0;
+			}
+			in_sg = sg_next(in_sg);
+		}
+		sg_dma_len(--out_sg) = split->length_last_sg;
+	}
+}
+
+/**
+ * sg_split - split a scatterlist into several scatterlists
+ * @in: the input sg list
+ * @in_mapped_nents: the result of a dma_map_sg(in, ...), or 0 if not mapped.
+ * @skip: the number of bytes to skip in the input sg list
+ * @nb_splits: the number of desired sg outputs
+ * @split_sizes: the respective size of each output sg list in bytes
+ * @out: an array where to store the allocated output sg lists
+ * @out_mapped_nents: the resulting sg lists mapped number of sg entries. Might
+ *                    be NULL if sglist not already mapped (in_mapped_nents = 0)
+ * @gfp_mask: the allocation flag
+ *
+ * This function splits the input sg list into nb_splits sg lists, which are
+ * allocated and stored into out.
+ * The @in is split into :
+ *  - @out[0], which covers bytes [@skip .. @skip + @split_sizes[0] - 1] of @in
+ *  - @out[1], which covers bytes [@skip + split_sizes[0] ..
+ *                                 @skip + @split_sizes[0] + @split_sizes[1] -1]
+ * etc ...
+ * It will be the caller's duty to kfree() out array members.
+ *
+ * Returns 0 upon success, or error code
+ */
+int sg_split(struct scatterlist *in, const int in_mapped_nents,
+	     const off_t skip, const int nb_splits,
+	     const size_t *split_sizes,
+	     struct scatterlist **out, int *out_mapped_nents,
+	     gfp_t gfp_mask)
+{
+	int i, ret;
+	struct sg_splitter *splitters;
+
+	splitters = kcalloc(nb_splits, sizeof(*splitters), gfp_mask);
+	if (!splitters)
+		return -ENOMEM;
+
+	ret = sg_calculate_split(in, sg_nents(in), nb_splits, skip, split_sizes,
+			   splitters, false);
+	if (ret < 0)
+		goto err;
+
+	ret = -ENOMEM;
+	for (i = 0; i < nb_splits; i++) {
+		splitters[i].out_sg = kmalloc_array(splitters[i].nents,
+						    sizeof(struct scatterlist),
+						    gfp_mask);
+		if (!splitters[i].out_sg)
+			goto err;
+	}
+
+	/*
+	 * The order of these 3 calls is important and should be kept.
+	 */
+	sg_split_phys(splitters, nb_splits);
+	ret = sg_calculate_split(in, in_mapped_nents, nb_splits, skip,
+				 split_sizes, splitters, true);
+	if (ret < 0)
+		goto err;
+	sg_split_mapped(splitters, nb_splits);
+
+	for (i = 0; i < nb_splits; i++) {
+		out[i] = splitters[i].out_sg;
+		if (out_mapped_nents)
+			out_mapped_nents[i] = splitters[i].nents;
+	}
+
+	kfree(splitters);
+	return 0;
+
+err:
+	for (i = 0; i < nb_splits; i++)
+		kfree(splitters[i].out_sg);
+	kfree(splitters);
+	return ret;
+}
+EXPORT_SYMBOL(sg_split);
_

Patches currently in -mm which might be from robert.jarzmik@free.fr are

scripts-decode_stacktrace-fix-arm-architecture-decoding.patch
lib-scatterlist-add-sg-splitting-function.patch

