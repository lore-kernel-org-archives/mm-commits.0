Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC714C15505
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93DF264F25
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235496AbhCDA7P (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:35848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1451325AbhCDAgl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:36:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DE3064EE4;
        Thu,  4 Mar 2021 00:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614818161;
        bh=JPlIvl7URYSnIAZFV0aZfKXIU5Ck6jf/Pr3oiShkUGU=;
        h=Date:From:To:Subject:From;
        b=E+Bpgj2BiMIIF7j+kcJnmvoqO7ZvPjLtqEesOt61XU9I5nHHqNiNOOvFZp80ZJAOv
         pfUMurerQVoPZ0I8YrOJ4/+8qh+7UFfkPj+xhdMe8n6di/IzW2joPiQb4t7jNVgf4e
         wMymJX3ooO2SoWm0JQO9hwkF50zkZDWan/PX//JQ=
Date:   Wed, 03 Mar 2021 16:35:59 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, bhe@redhat.com,
        christian.brauner@ubuntu.com, colin.king@canonical.com,
        corbet@lwn.net, dyoung@redhat.com, frederic@kernel.org,
        gpiccoli@canonical.com, john.p.donnelly@oracle.com,
        jpoimboe@redhat.com, keescook@chromium.org, masahiroy@kernel.org,
        mchehab+huawei@kernel.org, mike.kravetz@oracle.com,
        mingo@kernel.org, mm-commits@vger.kernel.org, paulmck@kernel.org,
        peterz@infradead.org, rdunlap@infradead.org, rostedt@goodmis.org,
        rppt@kernel.org, saeed.mirzamohammadi@oracle.com,
        samitolvanen@google.com, sboyd@kernel.org, tglx@linutronix.de,
        vgoyal@redhat.com, yifeifz2@illinois.edu
Subject:  +
 kernel-crash_core-add-crashkernel=auto-for-vmcore-creation.patch added to
 -mm tree
Message-ID: <20210304003559.ZchAywVJv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/crash_core: add crashkernel=auto for vmcore creation
has been added to the -mm tree.  Its filename is
     kernel-crash_core-add-crashkernel=auto-for-vmcore-creation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/kernel-crash_core-add-crashkernel%3Dauto-for-vmcore-creation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/kernel-crash_core-add-crashkernel%3Dauto-for-vmcore-creation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Subject: kernel/crash_core: add crashkernel=auto for vmcore creation

This adds crashkernel=auto feature to configure reserved memory for vmcore
creation.  CONFIG_CRASH_AUTO_STR is defined to be set for different kernel
distributions and different archs based on their needs.

Link: https://lkml.kernel.org/r/20210223174153.72802-1-saeed.mirzamohammadi@oracle.com
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Signed-off-by: John Donnelly <john.p.donnelly@oracle.com>
Tested-by: John Donnelly <john.p.donnelly@oracle.com>
ed-by: Dave Young <dyoung@redhat.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Cc: YiFei Zhu <yifeifz2@illinois.edu>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst       |    3 +-
 Documentation/admin-guide/kernel-parameters.txt |    6 ++++
 arch/Kconfig                                    |   20 ++++++++++++++
 kernel/crash_core.c                             |    7 ++++
 4 files changed, 35 insertions(+), 1 deletion(-)

--- a/arch/Kconfig~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
+++ a/arch/Kconfig
@@ -14,6 +14,26 @@ menu "General architecture-dependent opt
 config CRASH_CORE
 	bool
 
+config CRASH_AUTO_STR
+	string "Memory reserved for crash kernel"
+	depends on CRASH_CORE
+	default "1G-64G:128M,64G-1T:256M,1T-:512M"
+	help
+	  This configures the reserved memory dependent
+	  on the value of System RAM. The syntax is:
+	  crashkernel=<range1>:<size1>[,<range2>:<size2>,...][@offset]
+	              range=start-[end]
+
+	  For example:
+	      crashkernel=512M-2G:64M,2G-:128M
+
+	  This would mean:
+
+	      1) if the RAM is smaller than 512M, then don't reserve anything
+	         (this is the "rescue" case)
+	      2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
+	      3) if the RAM size is larger than 2G, then reserve 128M
+
 config KEXEC_CORE
 	select CRASH_CORE
 	bool
--- a/Documentation/admin-guide/kdump/kdump.rst~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -285,7 +285,8 @@ This would mean:
     2) if the RAM size is between 512M and 2G (exclusive), then reserve 64M
     3) if the RAM size is larger than 2G, then reserve 128M
 
-
+Or you can use crashkernel=auto to choose the crash kernel memory size
+based on the recommended configuration set for each arch.
 
 Boot into System Kernel
 =======================
--- a/Documentation/admin-guide/kernel-parameters.txt~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -753,6 +753,12 @@
 			a memory unit (amount[KMG]). See also
 			Documentation/admin-guide/kdump/kdump.rst for an example.
 
+	crashkernel=auto
+			[KNL] This parameter will set the reserved memory for
+			the crash kernel based on the value of the CRASH_AUTO_STR
+			that is the best effort estimation for each arch. See also
+			arch/Kconfig for further details.
+
 	crashkernel=size[KMG],high
 			[KNL, X86-64] range could be above 4G. Allow kernel
 			to allocate physical memory region from top, so could
--- a/kernel/crash_core.c~kernel-crash_core-add-crashkernel=auto-for-vmcore-creation
+++ a/kernel/crash_core.c
@@ -7,6 +7,7 @@
 #include <linux/crash_core.h>
 #include <linux/utsname.h>
 #include <linux/vmalloc.h>
+#include <linux/kexec.h>
 
 #include <asm/page.h>
 #include <asm/sections.h>
@@ -250,6 +251,12 @@ static int __init __parse_crashkernel(ch
 	if (suffix)
 		return parse_crashkernel_suffix(ck_cmdline, crash_size,
 				suffix);
+#ifdef CONFIG_CRASH_AUTO_STR
+	if (strncmp(ck_cmdline, "auto", 4) == 0) {
+		ck_cmdline = CONFIG_CRASH_AUTO_STR;
+		pr_info("Using crashkernel=auto, the size chosen is a best effort estimation.\n");
+	}
+#endif
 	/*
 	 * if the commandline contains a ':', then that's the extended
 	 * syntax -- if not, it must be the classic syntax
_

Patches currently in -mm which might be from saeed.mirzamohammadi@oracle.com are

kernel-crash_core-add-crashkernel=auto-for-vmcore-creation.patch

