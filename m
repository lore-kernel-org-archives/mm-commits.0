From: akpm@linux-foundation.org
Subject: + fs-compat_ioctlc-video_set_spu_palette-missing-error-check.patch added to -mm tree
Date: Wed, 24 Oct 2012 14:09:11 -0700
Message-ID: <20121024210912.23A4C5C0065@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:55522 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2JXVJP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 17:09:15 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so61416eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 14:09:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, davem@davemloft.net, pageexec@freemail.hu, spender@grsecurity.net, stable@vger.kernel.org


The patch titled
     Subject: fs/compat_ioctl.c: VIDEO_SET_SPU_PALETTE missing error check
has been added to the -mm tree.  Its filename is
     fs-compat_ioctlc-video_set_spu_palette-missing-error-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

gen_init_cpio-avoid-stack-overflow-when-expanding.patch
fs-compat_ioctlc-video_set_spu_palette-missing-error-check.patch
linux-next.patch
fs-pstore-ramc-fix-up-section-annotations.patch
proc-dont-show-nonexistent-capabilities.patch

