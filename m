Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A83C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbiGRAcX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbiGRAcX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:32:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA6513CE1
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:32:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2AA5B80EBC
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C014C3411E;
        Mon, 18 Jul 2022 00:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658104339;
        bh=Tf1lZFSK7fSRAGAXXXyNA68ZAQ6v/W714wX2JLwDB3c=;
        h=Date:To:From:Subject:From;
        b=fQJrRDHKdsVwRjnUKfNjXojQKiVlix1nboEQ/qXtdEpI4qqZe6GVeUhOoF/rvPA7O
         YnFVL/naH/QI55W1fSjDf5/GhDr5nXkT/2SSVsrWMc9kOJ42WBI75FKUIRfCDw6dIy
         uLnXZQRSwGEN3Frec1SAlgbvGNjYFgsoVST6Po3w=
Date:   Sun, 17 Jul 2022 17:32:18 -0700
To:     mm-commits@vger.kernel.org, tglx@linutronix.de, corbet@lwn.net,
        dmoulding@me.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-add-hostname-kernel-parameter.patch removed from -mm tree
Message-Id: <20220718003219.5C014C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: init: add "hostname" kernel parameter
has been removed from the -mm tree.  Its filename was
     init-add-hostname-kernel-parameter.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Moulding <dmoulding@me.com>
Subject: init: add "hostname" kernel parameter

The gethostname system call returns the hostname for the current machine. 
However, the kernel has no mechanism to initially set the current
machine's name in such a way as to guarantee that the first userspace
process to call gethostname will receive a meaningful result.  It relies
on some unspecified userspace process to first call sethostname before
gethostname can produce a meaningful name.

Traditionally the machine's hostname is set from userspace by the init
system.  The init system, in turn, often relies on a configuration file
(say, /etc/hostname) to provide the value that it will supply in the call
to sethostname.  Consequently, the file system containing /etc/hostname
usually must be available before the hostname will be set.  There may,
however, be earlier userspace processes that could call gethostname before
the file system containing /etc/hostname is mounted.  Such a process will
get some other, likely meaningless, name from gethostname (such as
"(none)", "localhost", or "darkstar").

A real-world example where this can happen, and lead to undesirable
results, is with mdadm.  When assembling arrays, mdadm distinguishes
between "local" arrays and "foreign" arrays.  A local array is one that
properly belongs to the current machine, and a foreign array is one that
is (possibly temporarily) attached to the current machine, but properly
belongs to some other machine.  To determine if an array is local or
foreign, mdadm may compare the "homehost" recorded on the array with the
current hostname.  If mdadm is run before the root file system is mounted,
perhaps because the root file system itself resides on an md-raid array,
then /etc/hostname isn't yet available and the init system will not yet
have called sethostname, causing mdadm to incorrectly conclude that all of
the local arrays are foreign.

Solving this problem *could* be delegated to the init system.  It could be
left up to the init system (including any init system that starts within
an initramfs, if one is in use) to ensure that sethostname is called
before any other userspace process could possibly call gethostname. 
However, it may not always be obvious which processes could call
gethostname (for example, udev itself might not call gethostname, but it
could via udev rules invoke processes that do).  Additionally, the init
system has to ensure that the hostname configuration value is stored in
some place where it will be readily accessible during early boot. 
Unfortunately, every init system will attempt to (or has already attempted
to) solve this problem in a different, possibly incorrect, way.  This
makes getting consistently working configurations harder for users.

I believe it is better for the kernel to provide the means by which the
hostname may be set early, rather than making this a problem for the init
system to solve.  The option to set the hostname during early startup, via
a kernel parameter, provides a simple, reliable way to solve this problem.
It also could make system configuration easier for some embedded systems.

[dmoulding@me.com: v2]
  Link: https://lkml.kernel.org/r/20220506060310.7495-2-dmoulding@me.com
Link: https://lkml.kernel.org/r/20220505180651.22849-2-dmoulding@me.com
Signed-off-by: Dan Moulding <dmoulding@me.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   13 ++++++++++
 init/version.c                                  |   17 ++++++++++++++
 2 files changed, 30 insertions(+)

--- a/Documentation/admin-guide/kernel-parameters.txt~init-add-hostname-kernel-parameter
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1667,6 +1667,19 @@
 
 	hlt		[BUGS=ARM,SH]
 
+	hostname=	[KNL] Set the hostname (aka UTS nodename).
+			Format: <string>
+			This allows setting the system's hostname during early
+			startup. This sets the name returned by gethostname.
+			Using this parameter to set the hostname makes it
+			possible to ensure the hostname is correctly set before
+			any userspace processes run, avoiding the possibility
+			that a process may call gethostname before the hostname
+			has been explicitly set, resulting in the calling
+			process getting an incorrect result. The string must
+			not exceed the maximum allowed hostname length (usually
+			64 characters) and will be truncated otherwise.
+
 	hpet=		[X86-32,HPET] option to control HPET usage
 			Format: { enable (default) | disable | force |
 				verbose }
--- a/init/version.c~init-add-hostname-kernel-parameter
+++ a/init/version.c
@@ -11,6 +11,8 @@
 #include <linux/build-salt.h>
 #include <linux/elfnote-lto.h>
 #include <linux/export.h>
+#include <linux/init.h>
+#include <linux/printk.h>
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <generated/utsrelease.h>
@@ -35,6 +37,21 @@ struct uts_namespace init_uts_ns = {
 };
 EXPORT_SYMBOL_GPL(init_uts_ns);
 
+static int __init early_hostname(char *arg)
+{
+	size_t bufsize = sizeof(init_uts_ns.name.nodename);
+	size_t maxlen  = bufsize - 1;
+	size_t arglen;
+
+	arglen = strlcpy(init_uts_ns.name.nodename, arg, bufsize);
+	if (arglen > maxlen) {
+		pr_warn("hostname parameter exceeds %zd characters and will be truncated",
+			maxlen);
+	}
+	return 0;
+}
+early_param("hostname", early_hostname);
+
 /* FIXED STRINGS! Don't touch! */
 const char linux_banner[] =
 	"Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
_

Patches currently in -mm which might be from dmoulding@me.com are


