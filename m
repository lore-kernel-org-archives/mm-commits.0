From: akpm@linux-foundation.org
Subject: [merged] fs-compat_ioctlc-video_set_spu_palette-missing-error-check.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:50:39 -0700
Message-ID: <20121029195040.267515C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:47906 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2J2Tum (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:50:42 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so341712fae.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:50:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, davem@davemloft.net, pageexec@freemail.hu, spender@grsecurity.net, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check
has been removed from the -mm tree.  Its filename was
     fs-compat_ioctlc-video_set_spu_palette-missing-error-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check

The compat ioctl for VIDEO_SET_SPU_PALETTE was missing an error check
while converting ioctl arguments.  This could lead to leaking kernel stack
contents into userspace.

Patch extracted from existing fix in grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: David Miller <davem@davemloft.net>
Cc: Brad Spengler <spender@grsecurity.net>
Cc: PaX Team <pageexec@freemail.hu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/compat_ioctl.c~fs-compat_ioctlc-video_set_spu_palette-missing-error-check fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~fs-compat_ioctlc-video_set_spu_palette-missing-error-check
+++ a/fs/compat_ioctl.c
@@ -210,6 +210,8 @@ static int do_video_set_spu_palette(unsi
 
 	err  = get_user(palp, &up->palette);
 	err |= get_user(length, &up->length);
+	if (err)
+		return -EFAULT;
 
 	up_native = compat_alloc_user_space(sizeof(struct video_spu_palette));
 	err  = put_user(compat_ptr(palp), &up_native->palette);
_

Patches currently in -mm which might be from keescook@chromium.org are

linux-next.patch
fs-pstore-ramc-fix-up-section-annotations.patch
proc-dont-show-nonexistent-capabilities.patch

