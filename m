Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6788AC433EF
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 18:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A66F61053
	for <mm-commits@archiver.kernel.org>; Mon,  1 Nov 2021 18:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhKAS0t (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 1 Nov 2021 14:26:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231922AbhKAS0r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 1 Nov 2021 14:26:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8490760F46;
        Mon,  1 Nov 2021 18:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635791053;
        bh=w0CzaxBhpoKlB1Hv84IrlmT4NLqiTnpZMxlANkpYUag=;
        h=Date:From:To:Subject:From;
        b=h4My28gezIvjp7o/SBXn7fzcazVwIoNPeFqdYSgY596Ij4GERRA+jZwyhF7gQdOUm
         d9OsYZLBlkaMi0TuWmbya3r5hpyW5BWocHqbrYIMiEbKjSruDliz8wJGZ0+8hB58JJ
         E3rkbw0rdfqCXzwqbKIewd7MVRrdqgKHRVEkJfyA=
Date:   Mon, 01 Nov 2021 11:24:13 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, dvyukov@google.com, jordy@pwning.systems,
        keescook@chromium.org, mm-commits@vger.kernel.org, rppt@kernel.org
Subject:  [merged]
 mm-secretmem-avoid-letting-secretmem_users-drop-to-zero.patch removed from
 -mm tree
Message-ID: <20211101182413.VFpaRjK21%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/secretmem: avoid letting secretmem_users drop to zero
has been removed from the -mm tree.  Its filename was
     mm-secretmem-avoid-letting-secretmem_users-drop-to-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm/secretmem: avoid letting secretmem_users drop to zero

Quoting Dmitry: "refcount_inc() needs to be done before fd_install(). 
After fd_install() finishes, the fd can be used by userspace and we can
have secret data in memory before the refcount_inc().

A straightforward misuse where a user will predict the returned fd in
another thread before the syscall returns and will use it to store secret
data is somewhat dubious because such a user just shoots themself in the
foot.

But a more interesting misuse would be to close the predicted fd and
decrement the refcount before the corresponding refcount_inc, this way one
can briefly drop the refcount to zero while there are other users of
secretmem."

Move fd_install() after refcount_inc().

Link: https://lkml.kernel.org/r/20211021154046.880251-1-keescook@chromium.org
Link: https://lore.kernel.org/lkml/CACT4Y+b1sW6-Hkn8HQYw_SsT7X3tp-CJNh2ci0wG3ZnQz9jjig@mail.gmail.com
Fixes: 9a436f8ff631 ("PM: hibernate: disable when there are active secretmem users")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jordy Zomer <jordy@pwning.systems>
Cc: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/secretmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/secretmem.c~mm-secretmem-avoid-letting-secretmem_users-drop-to-zero
+++ a/mm/secretmem.c
@@ -218,8 +218,8 @@ SYSCALL_DEFINE1(memfd_secret, unsigned i
 
 	file->f_flags |= O_LARGEFILE;
 
-	fd_install(fd, file);
 	atomic_inc(&secretmem_users);
+	fd_install(fd, file);
 	return fd;
 
 err_put_fd:
_

Patches currently in -mm which might be from keescook@chromium.org are

kasan-test-bypass-__alloc_size-checks.patch
rapidio-avoid-bogus-__alloc_size-warning.patch
compiler-attributes-add-__alloc_size-for-better-bounds-checking.patch
slab-clean-up-function-prototypes.patch
slab-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-kvmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-vmalloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
mm-page_alloc-add-__alloc_size-attributes-for-better-bounds-checking.patch
percpu-add-__alloc_size-attributes-for-better-bounds-checking.patch
kasan-test-consolidate-workarounds-for-unwanted-__alloc_size-protection.patch
maintainers-add-exec-binfmt-section-with-myself-and-eric.patch
binfmt_elf-reintroduce-using-map_fixed_noreplace.patch

