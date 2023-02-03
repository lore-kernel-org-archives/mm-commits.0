Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E08C4C61DA4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjBCGvc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbjBCGvO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C86193FD
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:51:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D4B161DBF
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E03C4339C;
        Fri,  3 Feb 2023 06:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407067;
        bh=Mx4zAbBAgs6rFejWA1xoTgswTOGpPsqrKpijekM/WP0=;
        h=Date:To:From:Subject:From;
        b=b+EuCLnpnswdubcjbLjVeN7Qa8/evxVaqYzec6mkWBBxg4aubdgg/kXN1y7H2K+bP
         qPQV7tOJBcCH2w9pTtUn2nl/6aAR2vHsJOoTnWO9fkR9TOnEQbx6eQaBMJUf3fADJ9
         wysuSTDqlvwDSK/hG99tVyE6zdRMMdso4xuLnuTs=
Date:   Thu, 02 Feb 2023 22:51:06 -0800
To:     mm-commits@vger.kernel.org, zwisler@kernel.org,
        senozhatsky@chromium.org, rostedt@goodmis.org, prudo@redhat.com,
        joel@joelfernandes.org, gpiccoli@igalia.com, ebiederm@xmission.com,
        corbet@lwn.net, bhe@redhat.com, bagasdotme@gmail.com,
        ribalda@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] documentation-sysctl-correct-kexec_load_disabled.patch removed from -mm tree
Message-Id: <20230203065106.E7E03C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Documentation: sysctl: correct kexec_load_disabled
has been removed from the -mm tree.  Its filename was
     documentation-sysctl-correct-kexec_load_disabled.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ricardo Ribalda <ribalda@chromium.org>
Subject: Documentation: sysctl: correct kexec_load_disabled
Date: Wed, 04 Jan 2023 15:38:46 +0100

Patch series "kexec: Add new parameter to limit the access to kexec", v6.

Add two parameter to specify how many times a kexec kernel can be loaded.

These parameter allow hardening the system.

While we are at it, fix a documentation issue and refactor some code.


This patch (of 3):

kexec_load_disabled affects both ``kexec_load`` and ``kexec_file_load``
syscalls. Make it explicit.

Link: https://lkml.kernel.org/r/20221114-disable-kexec-reset-v6-0-6a8531a09b9a@chromium.org
Link: https://lkml.kernel.org/r/20221114-disable-kexec-reset-v6-1-6a8531a09b9a@chromium.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Guilherme G. Piccoli <gpiccoli@igalia.com>
Cc: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Philipp Rudo <prudo@redhat.com>
Cc: Ross Zwisler <zwisler@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/Documentation/admin-guide/sysctl/kernel.rst~documentation-sysctl-correct-kexec_load_disabled
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -453,9 +453,10 @@ this allows system administrators to ove
 kexec_load_disabled
 ===================
 
-A toggle indicating if the ``kexec_load`` syscall has been disabled.
-This value defaults to 0 (false: ``kexec_load`` enabled), but can be
-set to 1 (true: ``kexec_load`` disabled).
+A toggle indicating if the syscalls ``kexec_load`` and
+``kexec_file_load`` have been disabled.
+This value defaults to 0 (false: ``kexec_*load`` enabled), but can be
+set to 1 (true: ``kexec_*load`` disabled).
 Once true, kexec can no longer be used, and the toggle cannot be set
 back to false.
 This allows a kexec image to be loaded before disabling the syscall,
_

Patches currently in -mm which might be from ribalda@chromium.org are


