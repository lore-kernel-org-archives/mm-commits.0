From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 021/155] fs_parse: remove pr_notice() about each
 validation
Date: Wed, 01 Apr 2020 21:04:13 -0700
Message-ID: <20200402040413.Zgd4kZt3B%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBEEO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:04:14 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, keescook@chromium.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, seth.arnold@canonical.com, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk

From: Kees Cook <keescook@chromium.org>
Subject: fs_parse: remove pr_notice() about each validation

This notice fills my boot logs with scary-looking asterisks but doesn't
really tell me anything.  Let's just remove it; validation errors are
already reported separately, so this is just a redundant list of
filesystems.

$ dmesg | grep VALIDATE
[    0.306256] *** VALIDATE tmpfs ***
[    0.307422] *** VALIDATE proc ***
[    0.308355] *** VALIDATE cgroup ***
[    0.308741] *** VALIDATE cgroup2 ***
[    0.813256] *** VALIDATE bpf ***
[    0.815272] *** VALIDATE ramfs ***
[    0.815665] *** VALIDATE hugetlbfs ***
[    0.876970] *** VALIDATE nfs ***
[    0.877383] *** VALIDATE nfs4 ***

Link: http://lkml.kernel.org/r/202003061617.A8835CAAF@keescook
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Reviewed-by: Seth Arnold <seth.arnold@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs_parser.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/fs_parser.c~fs_parse-remove-pr_notice-about-each-validation
+++ a/fs/fs_parser.c
@@ -368,8 +368,6 @@ bool fs_validate_description(const char
 	const struct fs_parameter_spec *param, *p2;
 	bool good = true;
 
-	pr_notice("*** VALIDATE %s ***\n", name);
