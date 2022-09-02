Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3ECC6FA82
	for <mm-commits@archiver.kernel.org>; Fri,  2 Sep 2022 19:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiIBTDE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Sep 2022 15:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiIBTDD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2022 15:03:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD3B4622C
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 12:03:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2A1EB82AD1
        for <mm-commits@vger.kernel.org>; Fri,  2 Sep 2022 19:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6A7C433D6;
        Fri,  2 Sep 2022 19:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662145379;
        bh=w+yj1GTnSa/0ZQc8A+F02QtcGvI+5k7LvgBdsBY1hJI=;
        h=Date:To:From:Subject:From;
        b=NXktdZh6P9J+elY48M3Lz8y6aA9Wobi1YtXDzLT2t3bb9jTPRYltyYBWsSI+yF983
         zsBe/yRtBa5M6V/i7ctxGAzx3nL9pjhAH6g0G0feF6Q5KLxJ6lqd1clItZcPIONWz0
         sW68YoxZxVLyl0iV3B8jQrZRLIiFf1ZkhjSRl/pc=
Date:   Fri, 02 Sep 2022 12:02:58 -0700
To:     mm-commits@vger.kernel.org, rafael@kernel.org,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        dsterba@suse.com, pvorel@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kernel-utsname_sysctlc-print-kernel-arch.patch added to mm-nonmm-unstable branch
Message-Id: <20220902190259.4C6A7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/utsname_sysctl.c: print kernel arch
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernel-utsname_sysctlc-print-kernel-arch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernel-utsname_sysctlc-print-kernel-arch.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Petr Vorel <pvorel@suse.cz>
Subject: kernel/utsname_sysctl.c: print kernel arch
Date: Thu, 1 Sep 2022 21:44:03 +0200

Print the machine hardware name (UTS_MACHINE) in /proc/sys/kernel/arch.

This helps people who debug kernel with initramfs with minimal environment
(i.e.  without coreutils or even busybox) or allow to open sysfs file
instead of run 'uname -m' in high level languages.

Link: https://lkml.kernel.org/r/20220901194403.3819-1-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Sterba <dsterba@suse.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    5 +++++
 kernel/utsname_sysctl.c                     |    7 +++++++
 2 files changed, 12 insertions(+)

--- a/Documentation/admin-guide/sysctl/kernel.rst~kernel-utsname_sysctlc-print-kernel-arch
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -65,6 +65,11 @@ combining the following values:
 4 s3_beep
 = =======
 
+arch
+====
+
+The machine hardware name, the same output as ``uname -m``
+(e.g. ``x86_64`` or ``aarch64``).
 
 auto_msgmni
 ===========
--- a/kernel/utsname_sysctl.c~kernel-utsname_sysctlc-print-kernel-arch
+++ a/kernel/utsname_sysctl.c
@@ -74,6 +74,13 @@ static DEFINE_CTL_TABLE_POLL(domainname_
 
 static struct ctl_table uts_kern_table[] = {
 	{
+		.procname	= "arch",
+		.data		= init_uts_ns.name.machine,
+		.maxlen		= sizeof(init_uts_ns.name.machine),
+		.mode		= 0444,
+		.proc_handler	= proc_do_uts_string,
+	},
+	{
 		.procname	= "ostype",
 		.data		= init_uts_ns.name.sysname,
 		.maxlen		= sizeof(init_uts_ns.name.sysname),
_

Patches currently in -mm which might be from pvorel@suse.cz are

kernel-utsname_sysctlc-print-kernel-arch.patch

