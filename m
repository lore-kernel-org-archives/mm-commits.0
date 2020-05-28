From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 4/5] fs/binfmt_elf.c: allocate initialized memory
 in fill_thread_core_info()
Date: Wed, 27 May 2020 22:20:52 -0700
Message-ID: <20200528052052.tLpI_z4pp%akpm@linux-foundation.org>
References: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbgE1FUx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 May 2020 01:20:53 -0400
In-Reply-To: <20200527222015.62ba8592af63dae12ab58ffe@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, akpm@linux-foundation.org, glider@google.com, keescook@chromium.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, stable@vger.kernel.org, sunhaoyl@outlook.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Alexander Potapenko <glider@google.com>
Subject: fs/binfmt_elf.c: allocate initialized memory in fill_thread_core_info()

KMSAN reported uninitialized data being written to disk when dumping core.
As a result, several kilobytes of kmalloc memory may be written to the
core file and then read by a non-privileged user.

Link: http://lkml.kernel.org/r/20200419100848.63472-1-glider@google.com
Link: https://github.com/google/kmsan/issues/76
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: sam <sunhaoyl@outlook.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_elf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/binfmt_elf.c~fs-binfmt_elfc-allocate-initialized-memory-in-fill_thread_core_info
+++ a/fs/binfmt_elf.c
@@ -1733,7 +1733,7 @@ static int fill_thread_core_info(struct
 		    (!regset->active || regset->active(t->task, regset) > 0)) {
 			int ret;
 			size_t size = regset_size(t->task, regset);
-			void *data = kmalloc(size, GFP_KERNEL);
+			void *data = kzalloc(size, GFP_KERNEL);
 			if (unlikely(!data))
 				return 0;
 			ret = regset->get(t->task, regset,
_
