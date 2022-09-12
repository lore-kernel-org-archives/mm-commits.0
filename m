Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347A6ECAAD5
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 04:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiILE6j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 00:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbiILE5L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 00:57:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A646A28E19
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 21:57:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9045B802BD
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 04:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EDF0C433D6;
        Mon, 12 Sep 2022 04:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662958626;
        bh=WvYOi4fiEvJWikAqWp47QBZ+d/m/gf0w21nkHiku6Jw=;
        h=Date:To:From:Subject:From;
        b=Gxokr+Dcc4Z4rp41jGPS0yI6MSnJ6zWb/w/gdcmFfqemSuoIomfpH76mNVLWfqCyQ
         9I7QpUaGBLunqrCQ2ZRMwb76zUdr0Ltx4WAASrHrch+Q56AJXTJNrZr/TJ4NtskzDr
         bWWBcOcA6buS7hK8nDhyaIlyrpFUywO+f5bvZN5Q=
Date:   Sun, 11 Sep 2022 21:57:05 -0700
To:     mm-commits@vger.kernel.org, rafael@kernel.org,
        gregkh@linuxfoundation.org, ebiederm@xmission.com,
        dsterba@suse.com, pvorel@suse.cz, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kernel-utsname_sysctlc-print-kernel-arch.patch removed from -mm tree
Message-Id: <20220912045706.8EDF0C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kernel/utsname_sysctl.c: print kernel arch
has been removed from the -mm tree.  Its filename was
     kernel-utsname_sysctlc-print-kernel-arch.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


