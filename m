From: akpm@linux-foundation.org
Subject: [merged]
 fs_parse-remove-pr_notice-about-each-validation.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:35:44 -0700
Message-ID: <20200403203544.GPo6GAO1U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgDCUfp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:35:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mm-commits@vger.kernel.org, seth.arnold@canonical.com, viro@zeniv.linux.org.uk


The patch titled
     Subject: fs_parse: remove pr_notice() about each validation
has been removed from the -mm tree.  Its filename was
     fs_parse-remove-pr_notice-about-each-validation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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
