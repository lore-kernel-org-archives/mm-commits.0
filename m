From: akpm@linux-foundation.org
Subject: - v4l2-timberdale-add-timberdale-logiwin-driver.patch removed from -mm tree
Date: Tue, 09 Jun 2009 17:23:59 -0700
Message-ID: <200906100043.n5A0hs3m012558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440AbZFJAoL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 20:44:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.rojfors.ext@mocean-labs.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     v4l2: timberdale: add Timberdale Logiwin driver
has been removed from the -mm tree.  Its filename was
     v4l2-timberdale-add-timberdale-logiwin-driver.patch

This patch was dropped because of build problems due to the missing xil=
inx patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: v4l2: timberdale: add Timberdale Logiwin driver
=46rom: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>

V4L2 video capture driver for the logiwin IP on the Timberdale FPGA.

The driver uses the Timberdale DMA engine

Signed-off-by: Richard R=F6jfors <richard.rojfors.ext@mocean-labs.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/timblogiw.c |  949 ++++++++++++++++++++++++++++++
 drivers/media/video/timblogiw.h |   94 ++
 include/media/timb_video.h      |   30=20
 3 files changed, 1073 insertions(+)

diff -puN drivers/media/video/timblogiw.c~v4l2-timberdale-add-timberdal=
e-logiwin-driver drivers/media/video/timblogiw.c
--- a/drivers/media/video/timblogiw.c~v4l2-timberdale-add-timberdale-lo=
giwin-driver
+++ a/drivers/media/video/timblogiw.c
@@ -0,0 +1,949 @@
+/*
+ * timblogiw.c timberdale FPGA LogiWin Video In driver
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/* Supports:
+ * Timberdale FPGA LogiWin Video In
+ */
+
+#include <linux/list.h>
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <media/v4l2-common.h>
+#include <media/v4l2-ioctl.h>
+#include <media/v4l2-device.h>
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
+#include "timblogiw.h"
+#include <linux/mfd/timbdma.h>
+#include <linux/i2c.h>
+#include <media/timb_video.h>
+
+#define TIMBLOGIW_CTRL 0x40
+
+#define TIMBLOGIW_H_SCALE 0x20
+#define TIMBLOGIW_V_SCALE 0x28
+
+#define TIMBLOGIW_X_CROP 0x58
+#define TIMBLOGIW_Y_CROP 0x60
+
+#define TIMBLOGIW_W_CROP 0x00
+#define TIMBLOGIW_H_CROP 0x08
+
+#define TIMBLOGIW_VERSION_CODE 0x02
+
+#define TIMBLOGIW_BUF	0x04
+#define TIMBLOGIW_TBI	0x2c
+#define TIMBLOGIW_BPL	0x30
+
+#define dbg(...)
+
+#define DMA_BUFFER_SIZE (720 * 576 * 2)
+
+const struct timblogiw_tvnorm timblogiw_tvnorms[] =3D {
+	{
+		.std			=3D V4L2_STD_PAL,
+		.name			=3D "PAL",
+		.width			=3D 720,
+		.height			=3D 576
+	},
+	{
+		.std			=3D V4L2_STD_NTSC_M,
+		.name			=3D "NTSC",
+		.width			=3D 720,
+		.height			=3D 480
+	}
+};
+
+static int timblogiw_bytes_per_line(const struct timblogiw_tvnorm *nor=
m)
+{
+	return norm->width * 2;
+}
+
+
+static int timblogiw_frame_size(const struct timblogiw_tvnorm *norm)
+{
+	return norm->height * timblogiw_bytes_per_line(norm);
+}
+
+static const struct timblogiw_tvnorm *timblogiw_get_norm(const v4l2_st=
d_id std)
+{
+	int i;
+	for (i =3D 0; i < ARRAY_SIZE(timblogiw_tvnorms); i++)
+		if (timblogiw_tvnorms[i].std =3D=3D std)
+			return timblogiw_tvnorms + i;
+
+	/* default to first element */
+	return timblogiw_tvnorms;
+}
+
+static void timblogiw_handleframe(unsigned long arg)
+{
+	struct timblogiw_frame *f;
+	struct timblogiw *lw =3D (struct timblogiw *)arg;
+
+	spin_lock_bh(&lw->queue_lock);
+	if (lw->dma.filled && !list_empty(&lw->inqueue)) {
+		/* put the entry in the outqueue */
+		f =3D list_entry(lw->inqueue.next, struct timblogiw_frame, frame);
+
+		/* copy data from the DMA buffer */
+		memcpy(f->bufmem, lw->dma.filled->buf, f->buf.length);
+		/* buffer consumed */
+		lw->dma.filled =3D NULL;
+
+		do_gettimeofday(&f->buf.timestamp);
+		f->buf.sequence =3D ++lw->frame_count;
+		f->buf.field =3D V4L2_FIELD_NONE;
+		f->state =3D F_DONE;
+		f->buf.bytesused =3D f->buf.length;
+		list_move_tail(&f->frame, &lw->outqueue);
+		/* wake up any waiter */
+		wake_up(&lw->wait_frame);
+	} else {
+		/* No user buffer available, consume buffer anyway
+		 * who wants an old video frame?
+		 */
+		lw->dma.filled =3D NULL;
+	}
+	spin_unlock_bh(&lw->queue_lock);
+}
+
+static int timblogiw_isr(u32 flag, void *pdev)
+{
+	struct timblogiw *lw =3D (struct timblogiw *)pdev;
+
+	if (!lw->dma.filled && (flag & DMA_IRQ_VIDEO_RX)) {
+		/* Got a frame, store it, and flip to next DMA buffer */
+		lw->dma.filled =3D lw->dma.transfer + lw->dma.curr;
+		lw->dma.curr =3D !lw->dma.curr;
+	}
+
+	if (lw->stream =3D=3D STREAM_ON)
+		timb_start_dma(DMA_IRQ_VIDEO_RX,
+			lw->dma.transfer[lw->dma.curr].handle,
+			timblogiw_frame_size(lw->cur_norm),
+			timblogiw_bytes_per_line(lw->cur_norm));
+
+	if (flag & DMA_IRQ_VIDEO_DROP)
+		dbg("%s: frame dropped\n", __func__);
+	if (flag & DMA_IRQ_VIDEO_RX) {
+		dbg("%s: frame RX\n", __func__);
+		tasklet_schedule(&lw->tasklet);
+	}
+	return 0;
+}
+
+static void timblogiw_empty_framequeues(struct timblogiw *lw)
+{
+	u32 i;
+
+	dbg("%s\n", __func__);
+
+	INIT_LIST_HEAD(&lw->inqueue);
+	INIT_LIST_HEAD(&lw->outqueue);
+
+	for (i =3D 0; i < lw->num_frames; i++) {
+		lw->frame[i].state =3D F_UNUSED;
+		lw->frame[i].buf.bytesused =3D 0;
+	}
+}
+
+u32 timblogiw_request_buffers(struct timblogiw *lw, u32 count)
+{
+	/* needs to be page aligned cause the */
+	/* buffers can be mapped individually! */
+	const size_t imagesize =3D PAGE_ALIGN(timblogiw_frame_size(lw->cur_no=
rm));
+	void *buff =3D NULL;
+	u32 i;
+
+	dbg("%s - request of %i buffers of size %zi\n",
+		__func__, count, imagesize);
+
+	lw->dma.transfer[0].buf =3D pci_alloc_consistent(lw->dev, DMA_BUFFER_=
SIZE,
+		&lw->dma.transfer[0].handle);
+	lw->dma.transfer[1].buf =3D pci_alloc_consistent(lw->dev, DMA_BUFFER_=
SIZE,
+		&lw->dma.transfer[1].handle);
+	if ((lw->dma.transfer[0].buf =3D=3D NULL) ||
+		(lw->dma.transfer[1].buf =3D=3D NULL)) {
+		printk(KERN_ALERT "alloc failed\n");
+		if (lw->dma.transfer[0].buf !=3D NULL)
+			pci_free_consistent(lw->dev, DMA_BUFFER_SIZE,
+				lw->dma.transfer[0].buf,
+				lw->dma.transfer[0].handle);
+		if (lw->dma.transfer[1].buf !=3D NULL)
+			pci_free_consistent(lw->dev, DMA_BUFFER_SIZE,
+				lw->dma.transfer[1].buf,
+				lw->dma.transfer[1].handle);
+		return 0;
+	}
+
+	if (count > TIMBLOGIW_NUM_FRAMES)
+		count =3D TIMBLOGIW_NUM_FRAMES;
+
+	lw->num_frames =3D count;
+	while (lw->num_frames > 0) {
+		buff =3D vmalloc_32(lw->num_frames * imagesize);
+		if (buff) {
+			memset(buff, 0, lw->num_frames * imagesize);
+			break;
+		}
+		lw->num_frames--;
+	}
+
+	for (i =3D 0; i < lw->num_frames; i++) {
+		lw->frame[i].bufmem =3D buff + i * imagesize;
+		lw->frame[i].buf.index =3D i;
+		lw->frame[i].buf.m.offset =3D i * imagesize;
+		lw->frame[i].buf.length =3D timblogiw_frame_size(lw->cur_norm);
+		lw->frame[i].buf.type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
+		lw->frame[i].buf.sequence =3D 0;
+		lw->frame[i].buf.field =3D V4L2_FIELD_NONE;
+		lw->frame[i].buf.memory =3D V4L2_MEMORY_MMAP;
+		lw->frame[i].buf.flags =3D 0;
+	}
+
+	lw->dma.curr =3D 0;
+	lw->dma.filled =3D NULL;
+	return lw->num_frames;
+}
+
+void timblogiw_release_buffers(struct timblogiw *lw)
+{
+	dbg("%s\n", __func__);
+
+	if (lw->frame[0].bufmem !=3D NULL) {
+		vfree(lw->frame[0].bufmem);
+		lw->frame[0].bufmem =3D NULL;
+		lw->num_frames =3D TIMBLOGIW_NUM_FRAMES;
+		pci_free_consistent(lw->dev, DMA_BUFFER_SIZE,
+			lw->dma.transfer[0].buf, lw->dma.transfer[0].handle);
+		pci_free_consistent(lw->dev, DMA_BUFFER_SIZE,
+			lw->dma.transfer[1].buf, lw->dma.transfer[1].handle);
+	}
+}
+
+/* IOCTL functions */
+
+static int timblogiw_g_fmt(struct file *file, void  *priv,
+	struct v4l2_format *format)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+
+	dbg("%s\n",  __func__);
+
+	if (format->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	format->fmt.pix.width =3D lw->cur_norm->width;
+	format->fmt.pix.height =3D lw->cur_norm->height;
+	format->fmt.pix.pixelformat =3D V4L2_PIX_FMT_YUYV;
+	format->fmt.pix.bytesperline =3D timblogiw_bytes_per_line(lw->cur_nor=
m);
+	format->fmt.pix.sizeimage =3D timblogiw_frame_size(lw->cur_norm);
+	format->fmt.pix.colorspace =3D V4L2_COLORSPACE_SMPTE170M;
+	format->fmt.pix.field =3D V4L2_FIELD_NONE;
+	return 0;
+}
+
+static int timblogiw_try_fmt(struct file *file, void  *priv,
+	struct v4l2_format *format)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+	struct v4l2_pix_format *pix =3D &format->fmt.pix;
+
+	dbg("%s - width=3D%d, height=3D%d, pixelformat=3D%d, field=3D%d\n"
+		"bytes per line %d, size image: %d, colorspace: %d\n",
+		__func__,
+		pix->width, pix->height, pix->pixelformat, pix->field,
+		pix->bytesperline, pix->sizeimage, pix->colorspace);
+
+	if (format->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (format->fmt.pix.field !=3D V4L2_FIELD_NONE)
+		return -EINVAL;
+
+	if ((lw->cur_norm->height !=3D pix->height) ||
+		(lw->cur_norm->width !=3D pix->width)) {
+		pix->width =3D lw->cur_norm->width;
+		pix->height =3D lw->cur_norm->height;
+	}
+
+	return 0;
+}
+
+static int timblogiw_querycap(struct file *file, void  *priv,
+	struct v4l2_capability *cap)
+{
+	dbg("%s\n",  __func__);
+	memset(cap, 0, sizeof(*cap));
+	strncpy(cap->card, "Timberdale Video", sizeof(cap->card)-1);
+	strncpy(cap->driver, "Timblogiw", sizeof(cap->card)-1);
+	cap->version =3D TIMBLOGIW_VERSION_CODE;
+	cap->capabilities =3D V4L2_CAP_VIDEO_CAPTURE |
+		V4L2_CAP_STREAMING;
+
+	return 0;
+}
+
+static int timblogiw_enum_fmt(struct file *file, void  *priv,
+	struct v4l2_fmtdesc *fmt)
+{
+	dbg("%s, index: %d\n",  __func__, fmt->index);
+
+	if (fmt->index !=3D 0)
+		return -EINVAL;
+	memset(fmt, 0, sizeof(*fmt));
+	fmt->index =3D 0;
+	fmt->type =3D V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	strncpy(fmt->description, "4:2:2, packed, YUYV",
+		sizeof(fmt->description)-1);
+	fmt->pixelformat =3D V4L2_PIX_FMT_YUYV;
+	memset(fmt->reserved, 0, sizeof(fmt->reserved));
+
+	return 0;
+}
+
+static int timblogiw_reqbufs(struct file *file, void  *priv,
+	struct v4l2_requestbuffers *rb)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+
+	dbg("%s\n",  __func__);
+
+	if (rb->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+		rb->memory !=3D V4L2_MEMORY_MMAP)
+		return -EINVAL;
+
+	timblogiw_empty_framequeues(lw);
+
+	timblogiw_release_buffers(lw);
+	if (rb->count)
+		rb->count =3D timblogiw_request_buffers(lw, rb->count);
+
+	dbg("%s - VIDIOC_REQBUFS: io method is mmap. num bufs %i\n",
+		__func__, rb->count);
+
+	return 0;
+}
+
+static int timblogiw_querybuf(struct file *file, void  *priv,
+	struct v4l2_buffer *b)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+
+	dbg("%s\n",  __func__);
+
+	if (b->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+		b->index >=3D lw->num_frames)
+		return -EINVAL;
+
+	memcpy(b, &lw->frame[b->index].buf, sizeof(*b));
+
+	if (lw->frame[b->index].vma_use_count)
+		b->flags |=3D V4L2_BUF_FLAG_MAPPED;
+
+	if (lw->frame[b->index].state =3D=3D F_DONE)
+		b->flags |=3D V4L2_BUF_FLAG_DONE;
+	else if (lw->frame[b->index].state !=3D F_UNUSED)
+		b->flags |=3D V4L2_BUF_FLAG_QUEUED;
+
+	return 0;
+}
+
+static int timblogiw_qbuf(struct file *file, void  *priv, struct v4l2_=
buffer *b)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+	unsigned long lock_flags;
+
+	if (b->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+		b->index >=3D lw->num_frames)
+		return -EINVAL;
+
+	if (lw->frame[b->index].state !=3D F_UNUSED)
+		return -EAGAIN;
+
+	if (b->memory !=3D V4L2_MEMORY_MMAP)
+		return -EINVAL;
+
+	lw->frame[b->index].state =3D F_QUEUED;
+
+	spin_lock_irqsave(&lw->queue_lock, lock_flags);
+	list_add_tail(&lw->frame[b->index].frame, &lw->inqueue);
+	spin_unlock_irqrestore(&lw->queue_lock, lock_flags);
+
+	return 0;
+}
+
+static int timblogiw_dqbuf(struct file *file, void  *priv,
+	struct v4l2_buffer *b)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+	struct timblogiw_frame *f;
+	unsigned long lock_flags;
+	int ret =3D 0;
+
+	if (b->type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		dbg("%s - VIDIOC_DQBUF, illegal buf type!\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	if (list_empty(&lw->outqueue)) {
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		ret =3D wait_event_interruptible(lw->wait_frame,
+			!list_empty(&lw->outqueue));
+		if (ret)
+			return ret;
+	}
+
+	spin_lock_irqsave(&lw->queue_lock, lock_flags);
+	f =3D list_entry(lw->outqueue.next,
+			struct timblogiw_frame, frame);
+	list_del(lw->outqueue.next);
+	spin_unlock_irqrestore(&lw->queue_lock, lock_flags);
+
+	f->state =3D F_UNUSED;
+	memcpy(b, &f->buf, sizeof(*b));
+
+	if (f->vma_use_count)
+		b->flags |=3D V4L2_BUF_FLAG_MAPPED;
+
+	return 0;
+}
+
+static int timblogiw_g_std(struct file *file, void  *priv, v4l2_std_id=
 *std)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+
+	dbg("%s\n",  __func__);
+
+	*std =3D lw->cur_norm->std;
+	return 0;
+}
+
+static int timblogiw_s_std(struct file *file, void  *priv, v4l2_std_id=
 *std)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+
+	dbg("%s\n",  __func__);
+
+	if (!(*std & lw->cur_norm->std))
+		return -EINVAL;
+	return 0;
+}
+
+static int timblogiw_enuminput(struct file *file, void  *priv,
+	struct v4l2_input *inp)
+{
+	dbg("%s\n",  __func__);
+
+	if (inp->index !=3D 0)
+		return -EINVAL;
+
+	memset(inp, 0, sizeof(*inp));
+	inp->index =3D 0;
+
+	strncpy(inp->name, "Timb input 1", sizeof(inp->name) - 1);
+	inp->type =3D V4L2_INPUT_TYPE_CAMERA;
+	inp->std =3D V4L2_STD_ALL;
+
+	return 0;
+}
+
+static int timblogiw_g_input(struct file *file, void  *priv,
+	unsigned int *input)
+{
+	dbg("%s\n",  __func__);
+
+	*input =3D 0;
+
+	return 0;
+}
+
+static int timblogiw_s_input(struct file *file, void  *priv, unsigned =
int input)
+{
+	dbg("%s\n",  __func__);
+
+	if (input !=3D 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int timblogiw_streamon(struct file *file, void  *priv, unsigned=
 int type)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+	struct timblogiw_frame *f;
+
+	dbg("%s\n",  __func__);
+
+	if (type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		dbg("%s - No capture device\n", __func__);
+		return -EINVAL;
+	}
+
+	if (list_empty(&lw->inqueue)) {
+		dbg("%s - inqueue is empty\n", __func__);
+		return -EINVAL;
+	}
+
+	if (lw->stream =3D=3D STREAM_ON)
+		return 0;
+
+	lw->stream =3D STREAM_ON;
+
+	f =3D list_entry(lw->inqueue.next,
+		struct timblogiw_frame, frame);
+
+	dbg("%s - f size: %d, bpr: %d, dma addr: %x\n", __func__,
+		timblogiw_frame_size(lw->cur_norm),
+		timblogiw_bytes_per_line(lw->cur_norm),
+		(unsigned int)lw->dma.transfer[lw->dma.curr].handle);
+
+	timb_start_dma(DMA_IRQ_VIDEO_RX,
+		lw->dma.transfer[lw->dma.curr].handle,
+		timblogiw_frame_size(lw->cur_norm),
+		timblogiw_bytes_per_line(lw->cur_norm));
+
+	return 0;
+}
+
+static int timblogiw_streamoff(struct file *file, void  *priv,
+	unsigned int type)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+
+	dbg("%s\n",  __func__);
+
+	if (type !=3D V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (lw->stream =3D=3D STREAM_ON) {
+		unsigned long lock_flags;
+		spin_lock_irqsave(&lw->queue_lock, lock_flags);
+		timb_stop_dma(DMA_IRQ_VIDEO_RX);
+		lw->stream =3D STREAM_OFF;
+		spin_unlock_irqrestore(&lw->queue_lock, lock_flags);
+	}
+	timblogiw_empty_framequeues(lw);
+
+	return 0;
+}
+
+static int timblogiw_querystd(struct file *file, void  *priv, v4l2_std=
_id *std)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+
+	dbg("%s\n",  __func__);
+
+	return v4l2_subdev_call(lw->sd_enc, video, querystd, std);
+}
+
+static int timblogiw_enum_framesizes(struct file *file, void  *priv,
+	struct v4l2_frmsizeenum *fsize)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+
+	dbg("%s - index: %d, format: %d\n",  __func__,
+		fsize->index, fsize->pixel_format);
+
+	if ((fsize->index !=3D 0) ||
+		(fsize->pixel_format !=3D V4L2_PIX_FMT_YUYV))
+		return -EINVAL;
+
+	fsize->type =3D V4L2_FRMSIZE_TYPE_DISCRETE;
+	fsize->discrete.width =3D lw->cur_norm->width;
+	fsize->discrete.height =3D lw->cur_norm->height;
+
+	return 0;
+}
+
+/*******************************
+ * Device Operations functions *
+ *******************************/
+
+static int timblogiw_open(struct file *file)
+{
+	struct video_device *vdev =3D video_devdata(file);
+	struct timblogiw *lw =3D video_get_drvdata(vdev);
+	v4l2_std_id std =3D V4L2_STD_UNKNOWN;
+
+	dbg("%s -\n", __func__);
+
+	mutex_init(&lw->fileop_lock);
+	spin_lock_init(&lw->queue_lock);
+	init_waitqueue_head(&lw->wait_frame);
+
+	mutex_lock(&lw->lock);
+
+	timblogiw_querystd(file, NULL, &std);
+	lw->video_dev->tvnorms =3D std;
+	lw->cur_norm =3D timblogiw_get_norm(std);
+
+	file->private_data =3D lw;
+	lw->stream =3D STREAM_OFF;
+	lw->num_frames =3D TIMBLOGIW_NUM_FRAMES;
+
+	timblogiw_empty_framequeues(lw);
+	timb_set_dma_interruptcb(DMA_IRQ_VIDEO_RX | DMA_IRQ_VIDEO_DROP,
+		timblogiw_isr, (void *)lw);
+	mutex_unlock(&lw->lock);
+
+	return 0;
+}
+
+static int timblogiw_close(struct file *file)
+{
+	struct timblogiw *lw =3D file->private_data;
+
+	dbg("%s - entry\n", __func__);
+
+	mutex_lock(&lw->lock);
+
+	timb_stop_dma(DMA_IRQ_VIDEO_RX);
+	timb_set_dma_interruptcb(DMA_IRQ_VIDEO_RX | DMA_IRQ_VIDEO_DROP, NULL,
+		NULL);
+	timblogiw_release_buffers(lw);
+
+	mutex_unlock(&lw->lock);
+	return 0;
+}
+
+static ssize_t timblogiw_read(struct file *file, char __user *data,
+	size_t count, loff_t *ppos)
+{
+	dbg("%s - read request\n", __func__);
+	return -EINVAL;
+}
+
+static void timblogiw_vm_open(struct vm_area_struct *vma)
+{
+	struct timblogiw_frame *f =3D vma->vm_private_data;
+	f->vma_use_count++;
+}
+
+static void timblogiw_vm_close(struct vm_area_struct *vma)
+{
+	struct timblogiw_frame *f =3D vma->vm_private_data;
+	f->vma_use_count--;
+}
+
+static struct vm_operations_struct timblogiw_vm_ops =3D {
+	.open =3D timblogiw_vm_open,
+	.close =3D timblogiw_vm_close,
+};
+
+static int timblogiw_mmap(struct file *filp, struct vm_area_struct *vm=
a)
+{
+	unsigned long size =3D vma->vm_end - vma->vm_start, start =3D vma->vm=
_start;
+	void *pos;
+	u32 i;
+	int ret =3D -EINVAL;
+
+	struct timblogiw *lw =3D filp->private_data;
+	dbg("%s\n", __func__);
+
+	if (mutex_lock_interruptible(&lw->fileop_lock))
+		return -ERESTARTSYS;
+
+	if (!(vma->vm_flags & VM_WRITE) ||
+		size !=3D PAGE_ALIGN(lw->frame[0].buf.length))
+		goto error_unlock;
+
+	for (i =3D 0; i < lw->num_frames; i++)
+		if ((lw->frame[i].buf.m.offset >> PAGE_SHIFT) =3D=3D vma->vm_pgoff)
+			break;
+
+	if (i =3D=3D lw->num_frames) {
+		dbg("%s - user supplied mapping address is out of range\n",
+			__func__);
+		goto error_unlock;
+	}
+
+	vma->vm_flags |=3D VM_IO;
+	vma->vm_flags |=3D VM_RESERVED;	/* Do not swap out this VMA */
+
+	pos =3D lw->frame[i].bufmem;
+	while (size > 0) {		/* size is page-aligned */
+		if (vm_insert_page(vma, start, vmalloc_to_page(pos))) {
+			dbg("%s - vm_insert_page failed\n", __func__);
+			ret =3D -EAGAIN;
+			goto error_unlock;
+		}
+		start +=3D PAGE_SIZE;
+		pos +=3D PAGE_SIZE;
+		size -=3D PAGE_SIZE;
+	}
+
+	vma->vm_ops =3D &timblogiw_vm_ops;
+	vma->vm_private_data =3D &lw->frame[i];
+	timblogiw_vm_open(vma);
+	ret =3D 0;
+
+error_unlock:
+	mutex_unlock(&lw->fileop_lock);
+	return ret;
+}
+
+
+void timblogiw_vdev_release(struct video_device *vdev)
+{
+	kfree(vdev);
+}
+
+static const struct v4l2_ioctl_ops timblogiw_ioctl_ops =3D {
+	.vidioc_querycap      =3D timblogiw_querycap,
+	.vidioc_enum_fmt_vid_cap  =3D timblogiw_enum_fmt,
+	.vidioc_g_fmt_vid_cap     =3D timblogiw_g_fmt,
+	.vidioc_try_fmt_vid_cap   =3D timblogiw_try_fmt,
+	.vidioc_s_fmt_vid_cap     =3D timblogiw_try_fmt,
+	.vidioc_reqbufs       =3D timblogiw_reqbufs,
+	.vidioc_querybuf      =3D timblogiw_querybuf,
+	.vidioc_qbuf          =3D timblogiw_qbuf,
+	.vidioc_dqbuf         =3D timblogiw_dqbuf,
+	.vidioc_g_std         =3D timblogiw_g_std,
+	.vidioc_s_std         =3D timblogiw_s_std,
+	.vidioc_enum_input    =3D timblogiw_enuminput,
+	.vidioc_g_input       =3D timblogiw_g_input,
+	.vidioc_s_input       =3D timblogiw_s_input,
+	.vidioc_streamon      =3D timblogiw_streamon,
+	.vidioc_streamoff     =3D timblogiw_streamoff,
+	.vidioc_querystd      =3D timblogiw_querystd,
+	.vidioc_enum_framesizes =3D timblogiw_enum_framesizes,
+};
+
+static const struct v4l2_file_operations timblogiw_fops =3D {
+	.owner		=3D THIS_MODULE,
+	.open	 	=3D timblogiw_open,
+	.release	=3D timblogiw_close,
+	.ioctl		=3D video_ioctl2, /* V4L2 ioctl handler */
+	.mmap		=3D timblogiw_mmap,
+	.read		=3D timblogiw_read,
+};
+
+static const struct video_device timblogiw_template =3D {
+	.name		=3D TIMBLOGIWIN_NAME,
+	.fops		=3D &timblogiw_fops,
+	.ioctl_ops 	=3D &timblogiw_ioctl_ops,
+	.release	=3D &timblogiw_vdev_release,
+	.minor		=3D -1
+};
+
+
+struct find_addr_arg {
+	char const *name;
+	struct i2c_client *client;
+};
+
+static int find_name(struct device *dev, void *argp)
+{
+	struct find_addr_arg	*arg =3D (struct find_addr_arg *)argp;
+	struct i2c_client	*client =3D i2c_verify_client(dev);
+
+	if (client && !strcmp(arg->name, client->name) && client->driver)
+		arg->client =3D client;
+
+	return 0;
+}
+
+static int timblogiw_probe(struct platform_device *dev)
+{
+	int err;
+	struct timblogiw *lw;
+	struct resource *iomem;
+	struct timb_video_platform_data *pdata =3D dev->dev.platform_data;
+	struct i2c_adapter *adapt;
+	struct i2c_client *encoder;
+	struct find_addr_arg find_arg;
+
+	if (!pdata) {
+		printk(KERN_ERR "timblogiw: Platform data missing\n");
+		err =3D -EINVAL;
+		goto err_mem;
+	}
+
+	iomem =3D platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!iomem) {
+		err =3D -EINVAL;
+		goto err_mem;
+	}
+
+	lw =3D kzalloc(sizeof(*lw), GFP_KERNEL);
+	if (!lw) {
+		err =3D -EINVAL;
+		goto err_mem;
+	}
+
+	/* find the PCI device from the parent... */
+	if (!dev->dev.parent) {
+		printk(KERN_ERR "timblogiw: No parent device found??\n");
+		err =3D -ENODEV;
+		goto err_encoder;
+	}
+
+	lw->dev =3D container_of(dev->dev.parent, struct pci_dev, dev);
+
+	/* find the video decoder */
+	adapt =3D i2c_get_adapter(pdata->i2c_adapter);
+	if (!adapt) {
+		printk(KERN_ERR "timblogiw: No I2C bus\n");
+		err =3D -ENODEV;
+		goto err_encoder;
+	}
+
+	/* now find the encoder */
+#ifdef MODULE
+	request_module(pdata->encoder);
+#endif
+	/* Code for finding the I2C child */
+	find_arg.name =3D pdata->encoder;
+	find_arg.client =3D NULL;
+	device_for_each_child(&adapt->dev, &find_arg, find_name);
+	encoder =3D find_arg.client;
+	i2c_put_adapter(adapt);
+
+	if (!encoder) {
+		printk(KERN_ERR "timblogiw: Failed to get encoder\n");
+		err =3D -ENODEV;
+		goto err_encoder;
+	}
+
+	/* Lock the module */
+	if (!try_module_get(encoder->driver->driver.owner)) {
+		err =3D -ENODEV;
+		goto err_encoder;
+	}
+
+	lw->sd_enc =3D i2c_get_clientdata(encoder);
+
+	mutex_init(&lw->lock);
+
+	lw->video_dev =3D video_device_alloc();
+	if (!lw->video_dev) {
+		err =3D -ENOMEM;
+		goto err_video_req;
+	}
+	*lw->video_dev =3D timblogiw_template;
+
+	err =3D video_register_device(lw->video_dev, VFL_TYPE_GRABBER, 0);
+	if (err) {
+		video_device_release(lw->video_dev);
+		printk(KERN_ALERT "Error reg video\n");
+		goto err_video_req;
+	}
+
+	tasklet_init(&lw->tasklet, timblogiw_handleframe, (unsigned long)lw);
+
+	if (!request_mem_region(iomem->start, resource_size(iomem),
+		"timb-video")) {
+		err =3D -EBUSY;
+		goto err_request;
+	}
+
+	lw->membase =3D ioremap(iomem->start, resource_size(iomem));
+	if (!lw->membase) {
+		err =3D -ENOMEM;
+		goto err_ioremap;
+	}
+
+	platform_set_drvdata(dev, lw);
+	video_set_drvdata(lw->video_dev, lw);
+
+	return 0;
+
+err_ioremap:
+	release_mem_region(iomem->start, resource_size(iomem));
+err_request:
+	if (-1 !=3D lw->video_dev->minor)
+		video_unregister_device(lw->video_dev);
+	else
+		video_device_release(lw->video_dev);
+err_video_req:
+	module_put(lw->sd_enc->owner);
+err_encoder:
+	kfree(lw);
+err_mem:
+	printk(KERN_ERR
+		"timblogiw: Failed to register Timberdale Video In: %d\n", err);
+
+	return err;
+}
+
+static int timblogiw_remove(struct platform_device *dev)
+{
+	struct timblogiw *lw =3D platform_get_drvdata(dev);
+	struct resource *iomem =3D platform_get_resource(dev, IORESOURCE_MEM,=
 0);
+
+	if (-1 !=3D lw->video_dev->minor)
+		video_unregister_device(lw->video_dev);
+	else
+		video_device_release(lw->video_dev);
+
+	module_put(lw->sd_enc->owner);
+	tasklet_kill(&lw->tasklet);
+	iounmap(lw->membase);
+	release_mem_region(iomem->start, resource_size(iomem));
+	kfree(lw);
+
+	return 0;
+}
+
+static struct platform_driver timblogiw_platform_driver =3D {
+	.driver =3D {
+		.name	=3D "timb-video",
+		.owner	=3D THIS_MODULE,
+	},
+	.probe		=3D timblogiw_probe,
+	.remove		=3D timblogiw_remove,
+};
+
+/*--------------------------------------------------------------------=
------*/
+
+static int __init timblogiw_init(void)
+{
+	return platform_driver_register(&timblogiw_platform_driver);
+}
+
+static void __exit timblogiw_exit(void)
+{
+	platform_driver_unregister(&timblogiw_platform_driver);
+}
+
+module_init(timblogiw_init);
+module_exit(timblogiw_exit);
+
+MODULE_DESCRIPTION("Timberdale Video In driver");
+MODULE_AUTHOR("Mocean Laboratories <info@mocean-labs.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:timb-video");
+
diff -puN drivers/media/video/timblogiw.h~v4l2-timberdale-add-timberdal=
e-logiwin-driver drivers/media/video/timblogiw.h
--- a/drivers/media/video/timblogiw.h~v4l2-timberdale-add-timberdale-lo=
giwin-driver
+++ a/drivers/media/video/timblogiw.h
@@ -0,0 +1,94 @@
+/*
+ * timblogiw.h timberdale FPGA LogiWin Video In driver defines
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/* Supports:
+ * Timberdale FPGA LogiWin Video In
+ */
+
+#ifndef _TIMBLOGIW_H
+#define _TIMBLOGIW_H
+
+#include <linux/interrupt.h>
+
+#define TIMBLOGIWIN_NAME    "Timberdale Video-In"
+
+#define TIMBLOGIW_NUM_FRAMES	10
+
+
+enum timblogiw_stream_state {
+	STREAM_OFF,
+	STREAM_ON,
+};
+
+enum timblogiw_frame_state {
+	F_UNUSED =3D 0,
+	F_QUEUED,
+	F_GRABBING,
+	F_DONE,
+	F_ERROR,
+};
+
+struct timblogiw_frame {
+	void				*bufmem;
+	struct v4l2_buffer		buf;
+	enum timblogiw_frame_state	state;
+	struct list_head		frame;
+	unsigned long			vma_use_count;
+};
+
+struct timblogiw_tvnorm {
+	v4l2_std_id std;
+	char    *name;
+	u16     width;
+	u16     height;
+};
+
+
+
+struct timbdma_transfer {
+	dma_addr_t	handle;
+	void		*buf;
+};
+
+struct timbdma_control {
+	struct timbdma_transfer	transfer[2];
+	struct timbdma_transfer *filled;
+	int curr;
+};
+
+struct timblogiw {
+	struct i2c_client		*decoder;
+	struct timblogiw_frame		frame[TIMBLOGIW_NUM_FRAMES];
+	int				num_frames;
+	unsigned int			frame_count;
+	struct list_head		inqueue, outqueue;
+	spinlock_t			queue_lock; /* mutual exclusion */
+	enum timblogiw_stream_state	stream;
+	struct video_device		*video_dev;
+	struct mutex			lock, fileop_lock;
+	wait_queue_head_t		wait_frame;
+	struct timblogiw_tvnorm const	*cur_norm;
+	struct pci_dev			*dev;
+	struct timbdma_control		dma;
+	void __iomem			*membase;
+	struct tasklet_struct		tasklet;
+	struct v4l2_subdev *sd_enc;	/* encoder */
+};
+
+#endif /* _TIMBLOGIW_H */
+
diff -puN include/media/timb_video.h~v4l2-timberdale-add-timberdale-log=
iwin-driver include/media/timb_video.h
--- a/include/media/timb_video.h~v4l2-timberdale-add-timberdale-logiwin=
-driver
+++ a/include/media/timb_video.h
@@ -0,0 +1,30 @@
+/*
+ * timb_video.h Platform struct for the Timberdale video driver
+ * Copyright (c) 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _TIMB_VIDEO_
+#define _TIMB_VIDEO_ 1
+
+#include <linux/i2c.h>
+
+struct timb_video_platform_data {
+	int i2c_adapter; /* The I2C adapter where the encoder is attached */
+	char encoder[32];
+};
+
+#endif
+
_

Patches currently in -mm which might be from richard.rojfors.ext@mocean=
-labs.com are

linux-next.patch
v4l2-timberdale-add-timberdale-logiwin-driver.patch
v4l2-timberdale-add-timberdale-logiwin-driver-in-kconfig-and-makefile.p=
atch
mfd-timberdale-add-timberdale-driver.patch
serial-timberdale-add-timberdale-uart-driver.patch
gpio-timberdale-add-timbgpio.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
