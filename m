From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch
 added to -mm tree
Date: Thu, 12 Mar 2020 15:29:43 -0700
Message-ID: <20200312222943.O1sOXgoTP%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbgCLW3p (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 18:29:45 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ast@kernel.org, ebiggers@google.com, gregkh@linuxfoundation.org, jeffv@google.com, jeyu@kernel.org, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, neilb@suse.com, stable@vger.kernel.org


The patch titled
     Subject: fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_once()
has been added to the -mm tree.  Its filename is
     fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Eric Biggers <ebiggers@google.com>
Subject: fs/filesystems.c: downgrade user-reachable WARN_ONCE() to pr_warn_once()

After request_module(), nothing is stopping the module from being unloaded
until someone takes a reference to it via try_get_module().

The WARN_ONCE() in get_fs_type() is thus user-reachable, via userspace
running 'rmmod' concurrently.

Since WARN_ONCE() is for kernel bugs only, not for user-reachable
situations, downgrade this warning to pr_warn_once().

Link: http://lkml.kernel.org/r/20200312202552.241885-3-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jeff Vander Stoep <jeffv@google.com>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: NeilBrown <neilb@suse.com>
Cc: <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/filesystems.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/filesystems.c~fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once
+++ a/fs/filesystems.c
@@ -272,7 +272,9 @@ struct file_system_type *get_fs_type(con
 	fs = __get_fs_type(name, len);
 	if (!fs && (request_module("fs-%.*s", len, name) == 0)) {
 		fs = __get_fs_type(name, len);
-		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n", len, name);
+		if (!fs)
+			pr_warn_once("request_module fs-%.*s succeeded, but still no fs?\n",
+				     len, name);
 	}
 
 	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {
_

Patches currently in -mm which might be from ebiggers@google.com are

kmod-make-request_module-return-an-error-when-autoloading-is-disabled.patch
fs-filesystemsc-downgrade-user-reachable-warn_once-to-pr_warn_once.patch
docs-admin-guide-document-the-kernelmodprobe-sysctl.patch
selftests-kmod-test-disabling-module-autoloading.patch
