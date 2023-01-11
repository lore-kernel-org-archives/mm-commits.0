Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 201C2C46467
	for <mm-commits@archiver.kernel.org>; Wed, 11 Jan 2023 00:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbjAKATL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 Jan 2023 19:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbjAKATE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2023 19:19:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D42E8AE52
        for <mm-commits@vger.kernel.org>; Tue, 10 Jan 2023 16:19:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 707E7617EF
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2023 00:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78DCC433D2;
        Wed, 11 Jan 2023 00:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1673396342;
        bh=qEDsL24DajpLjV5bf964I6fZsPhxdO8gLTBrzq8mFKA=;
        h=Date:To:From:Subject:From;
        b=YwUlXMgENn4k8FhJyf13WT9dKHKjE+n2Qq4VMDRIsYyzaXiRA4eVPD95J3TdFnNZB
         lB3HkQlrQijw8aQkeby8AjRVDBz2xT550/tGWNjw+0YuMM/H6J9zgvmlGKsAz0X9ls
         Qn0cYapdoBuMF2VBm07iesNnGilLy8dU5gZ1VceU=
Date:   Tue, 10 Jan 2023 16:19:01 -0800
To:     mm-commits@vger.kernel.org, zwisler@kernel.org,
        senozhatsky@chromium.org, rostedt@goodmis.org, prudo@redhat.com,
        joel@joelfernandes.org, gpiccoli@igalia.com, ebiederm@xmission.com,
        corbet@lwn.net, bhe@redhat.com, bagasdotme@gmail.com,
        ribalda@chromium.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-sysctl-correct-kexec_load_disabled.patch added to mm-nonmm-unstable branch
Message-Id: <20230111001902.B78DCC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation: sysctl: correct kexec_load_disabled
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     documentation-sysctl-correct-kexec_load_disabled.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-sysctl-correct-kexec_load_disabled.patch

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

 Documentation/admin-guide/sysctl/kernel.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

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

scripts-spellingtxt-add-permitted.patch
kvm-x86-fix-trivial-typo.patch
documentation-sysctl-correct-kexec_load_disabled.patch
kexec-factor-out-kexec_load_permitted.patch
kexec-introduce-sysctl-parameters-kexec_load_limit_.patch

