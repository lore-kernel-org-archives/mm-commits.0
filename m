Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CC2C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 22:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242219AbhKXWMU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:12:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234403AbhKXWMU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Nov 2021 17:12:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF67860C4A;
        Wed, 24 Nov 2021 22:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637791749;
        bh=efxszxEKrtha7qwpQ1I2IkFFyfehLPB7eLFwoA1OZgw=;
        h=Date:From:To:Subject:From;
        b=12Mhpm900hzCsIXIZnbqYPzi2x5hItwDg/kwYgmYBIbsuDiQGH7TrL0jq7eXGiDkj
         iTr1EOfYPiLmlqj6onOVKn+FEb3JL9mDv3VawQOnyXtHYueoyL5Y4lYJao/wl1eH3w
         zWlrttmwQUbgF12kQoHxszZbBfTm4N3iKeqlZrZk=
Date:   Wed, 24 Nov 2021 14:09:09 -0800
From:   akpm@linux-foundation.org
To:     jack@suse.cz, mcgrof@kernel.org, mm-commits@vger.kernel.org
Subject:  +
 inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch
 added to -mm tree
Message-ID: <20211124220909.SFQ1gvukm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: inotify-simplify-subdirectory-registration-with-register_sysctl-fix
has been added to the -mm tree.  Its filename is
     inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: inotify-simplify-subdirectory-registration-with-register_sysctl-fix

remember to register fanotify_table

Link: https://lkml.kernel.org/r/YZ5A6iWLb0h3N3RC@bombadil.infradead.org
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/fanotify/fanotify_user.c |   10 +++++++++-
 include/linux/fanotify.h           |    2 --
 2 files changed, 9 insertions(+), 3 deletions(-)

--- a/fs/notify/fanotify/fanotify_user.c~inotify-simplify-subdirectory-registration-with-register_sysctl-fix
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -59,7 +59,7 @@ static int fanotify_max_queued_events __
 static long ft_zero = 0;
 static long ft_int_max = INT_MAX;
 
-struct ctl_table fanotify_table[] = {
+static struct ctl_table fanotify_table[] = {
 	{
 		.procname	= "max_user_groups",
 		.data	= &init_user_ns.ucount_max[UCOUNT_FANOTIFY_GROUPS],
@@ -88,6 +88,13 @@ struct ctl_table fanotify_table[] = {
 	},
 	{ }
 };
+
+static void __init fanotify_sysctls_init(void)
+{
+	register_sysctl("fs/fanotify", fanotify_table);
+}
+#else
+#define fanotify_sysctls_init() do { } while (0)
 #endif /* CONFIG_SYSCTL */
 
 /*
@@ -1685,6 +1692,7 @@ static int __init fanotify_user_setup(vo
 	init_user_ns.ucount_max[UCOUNT_FANOTIFY_GROUPS] =
 					FANOTIFY_DEFAULT_MAX_GROUPS;
 	init_user_ns.ucount_max[UCOUNT_FANOTIFY_MARKS] = max_marks;
+	fanotify_sysctls_init();
 
 	return 0;
 }
--- a/include/linux/fanotify.h~inotify-simplify-subdirectory-registration-with-register_sysctl-fix
+++ a/include/linux/fanotify.h
@@ -5,8 +5,6 @@
 #include <linux/sysctl.h>
 #include <uapi/linux/fanotify.h>
 
-extern struct ctl_table fanotify_table[]; /* for sysctl */
-
 #define FAN_GROUP_FLAG(group, flag) \
 	((group)->fanotify_data.flags & (flag))
 
_

Patches currently in -mm which might be from mcgrof@kernel.org are

zram-use-attribute_groups.patch
hpet-simplify-subdirectory-registration-with-register_sysctl.patch
i915-simplify-subdirectory-registration-with-register_sysctl.patch
macintosh-mac_hidc-simplify-subdirectory-registration-with-register_sysctl.patch
ocfs2-simplify-subdirectory-registration-with-register_sysctl.patch
test_sysctl-simplify-subdirectory-registration-with-register_sysctl.patch
inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch
cdrom-simplify-subdirectory-registration-with-register_sysctl.patch

