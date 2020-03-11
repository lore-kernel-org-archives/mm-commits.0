From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs_parse-remove-pr_notice-about-each-validation.patch
 added to -mm tree
Date: Wed, 11 Mar 2020 15:10:07 -0700
Message-ID: <20200311221007.masgN6jXJ%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729535AbgCKWKJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 11 Mar 2020 18:10:09 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, mm-commits@vger.kernel.org, seth.arnold@canonical.com


The patch titled
     Subject: fs_parse: Remove pr_notice() about each validation
has been added to the -mm tree.  Its filename is
     fs_parse-remove-pr_notice-about-each-validation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs_parse-remove-pr_notice-about-each-validation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs_parse-remove-pr_notice-about-each-validation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: fs_parse: Remove pr_notice() about each validation

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
Alexander Viro <viro@zeniv.linux.org.uk>
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
