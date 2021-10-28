Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5604C43219
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE267610D2
	for <mm-commits@archiver.kernel.org>; Thu, 28 Oct 2021 21:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhJ1Viv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Oct 2021 17:38:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231409AbhJ1Vit (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 28 Oct 2021 17:38:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8757B61100;
        Thu, 28 Oct 2021 21:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635456981;
        bh=IjMgySs6iaDJWIXfdPuYVV+8o6w8AxU6pCSF6E7pZbU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Y+ubBOHWBAJ3MqyHZ6igQYUL0wxSU65M7H/03SqKGe055VOsJCjE4dwLdXakT7aC8
         7on8tm9IXUJuco3dSAfhrldMIlMWCrhtasivVGZDaA24xuGAMDHsUMYiRbxWK+kUk2
         b8UeNAWUFqa5PenBkyXW6mcFDEq0KoykaTfODI/s=
Date:   Thu, 28 Oct 2021 14:36:21 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, dvyukov@google.com,
        jordy@pwning.systems, keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rppt@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 06/11] mm/secretmem: avoid letting secretmem_users
 drop to zero
Message-ID: <20211028213621.YTZcxbpZE%akpm@linux-foundation.org>
In-Reply-To: <20211028143506.5f5d5e2cd1f768a1da864844@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
