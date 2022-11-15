Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5261C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbiKOWcZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238351AbiKOWb7 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:31:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327115F5C
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:31:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCB75B81B79
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84157C433C1;
        Tue, 15 Nov 2022 22:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551515;
        bh=fO+vXgQSJjrZwRsgvCiWx6G3A7F7Z8j4I71ySgAaH6U=;
        h=Date:To:From:Subject:From;
        b=dNwPoWipZZ7rFfSrtUlo4EkvFKCl3ZPCse1+dj96fAP5mpb7mjlj1xpJoeCAGkYnP
         Cj5HFAEajFcbD7w6Xf9lsAJdD5aj5fA4vg5UeT3vv9cPEFvoYit5tYhR8zF+toJmqu
         hLvPzILcUrHrJFiu+U0EYEy/75jBIc2pfJIpWGuU=
Date:   Tue, 15 Nov 2022 14:31:55 -0800
To:     mm-commits@vger.kernel.org, ying.huang@intel.com, will@kernel.org,
        viro@zeniv.linux.org.uk, steve@sk2.org, robh@kernel.org,
        rmetrich@redhat.com, oleg@redhat.com, nixiaoming@huawei.com,
        mcgrof@kernel.org, ldufour@linux.ibm.com, keescook@chromium.org,
        jsavitz@redhat.com, Jason@zx2c4.com, gpiccoli@igalia.com,
        ghalat@redhat.com, ebiederm@xmission.com, corbet@lwn.net,
        oleksandr@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] core_pattern-add-cpu-specifier.patch removed from -mm tree
Message-Id: <20221115223155.84157C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: core_pattern: add CPU specifier
has been removed from the -mm tree.  Its filename was
     core_pattern-add-cpu-specifier.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleksandr Natalenko <oleksandr@redhat.com>
Subject: core_pattern: add CPU specifier
Date: Sat, 3 Sep 2022 08:43:30 +0200

Statistically, in a large deployment regular segfaults may indicate a CPU
issue.

Currently, it is not possible to find out what CPU the segfault happened
on.  There are at least two attempts to improve segfault logging with this
regard, but they do not help in case the logs rotate.

Hence, lets make sure it is possible to permanently record a CPU the task
ran on using a new core_pattern specifier.

Link: https://lkml.kernel.org/r/20220903064330.20772-1-oleksandr@redhat.com
Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
Suggested-by: Renaud Métrich <rmetrich@redhat.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Grzegorz Halat <ghalat@redhat.com>
Cc: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Joel Savitz <jsavitz@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Laurent Dufour <ldufour@linux.ibm.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Will Deacon <will@kernel.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    1 +
 fs/coredump.c                               |    5 +++++
 include/linux/coredump.h                    |    1 +
 3 files changed, 7 insertions(+)

--- a/Documentation/admin-guide/sysctl/kernel.rst~core_pattern-add-cpu-specifier
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -174,6 +174,7 @@ core_pattern
 	%f      	executable filename
 	%E		executable path
 	%c		maximum size of core file by resource limit RLIMIT_CORE
+	%C		CPU the task ran on
 	%<OTHER>	both are dropped
 	========	==========================================
 
--- a/fs/coredump.c~core_pattern-add-cpu-specifier
+++ a/fs/coredump.c
@@ -325,6 +325,10 @@ static int format_corename(struct core_n
 				err = cn_printf(cn, "%lu",
 					      rlimit(RLIMIT_CORE));
 				break;
+			/* CPU the task ran on */
+			case 'C':
+				err = cn_printf(cn, "%d", cprm->cpu);
+				break;
 			default:
 				break;
 			}
@@ -534,6 +538,7 @@ void do_coredump(const kernel_siginfo_t
 		 */
 		.mm_flags = mm->flags,
 		.vma_meta = NULL,
+		.cpu = raw_smp_processor_id(),
 	};
 
 	audit_core_dumps(siginfo->si_signo);
--- a/include/linux/coredump.h~core_pattern-add-cpu-specifier
+++ a/include/linux/coredump.h
@@ -22,6 +22,7 @@ struct coredump_params {
 	struct file *file;
 	unsigned long limit;
 	unsigned long mm_flags;
+	int cpu;
 	loff_t written;
 	loff_t pos;
 	loff_t to_skip;
_

Patches currently in -mm which might be from oleksandr@redhat.com are


