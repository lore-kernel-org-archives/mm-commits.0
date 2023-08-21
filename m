Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE781EE49AF
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjHUUoE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbjHUUnT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:43:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0331997;
        Mon, 21 Aug 2023 13:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2FE664B13;
        Mon, 21 Aug 2023 20:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FC9C433C8;
        Mon, 21 Aug 2023 20:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650515;
        bh=bgpsESSruLHl+d6Hv2kmcqUKFut8lyKCrvSDOkIu1Fs=;
        h=Date:To:From:Subject:From;
        b=wahdVVXQX5UixLg+7ba2tilUJ/dX6ql56hJGfOCynWPg1ANMz3xvcwu8TCDAI6Jx+
         uPN7Nvq9la5Mr52196DQuigVgvE9vNaN/U4wtoAupI5e12G7hjtlZYO493O43aYvm1
         XjceeFb9j4qzL0U53F4O+GZS8r7uY0mpD8/wzXOM=
Date:   Mon, 21 Aug 2023 13:41:54 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shuah@kernel.org, keescook@chromium.org, dverkamp@chromium.org,
        brauner@kernel.org, asmadeus@codewreck.org, cyphar@cyphar.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memfd-improve-userspace-warnings-for-missing-exec-related-flags.patch removed from -mm tree
Message-Id: <20230821204155.52FC9C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: memfd: improve userspace warnings for missing exec-related flags
has been removed from the -mm tree.  Its filename was
     memfd-improve-userspace-warnings-for-missing-exec-related-flags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Aleksa Sarai <cyphar@cyphar.com>
Subject: memfd: improve userspace warnings for missing exec-related flags
Date: Mon, 14 Aug 2023 18:40:59 +1000

In order to incentivise userspace to switch to passing MFD_EXEC and
MFD_NOEXEC_SEAL, we need to provide a warning on each attempt to call
memfd_create() without the new flags.  pr_warn_once() is not useful
because on most systems the one warning is burned up during the boot
process (on my system, systemd does this within the first second of boot)
and thus userspace will in practice never see the warnings to push them to
switch to the new flags.

The original patchset[1] used pr_warn_ratelimited(), however there were
concerns about the degree of spam in the kernel log[2,3].  The resulting
inability to detect every case was flagged as an issue at the time[4].

While we could come up with an alternative rate-limiting scheme such as
only outputting the message if vm.memfd_noexec has been modified, or only
outputting the message once for a given task, these alternatives have
downsides that don't make sense given how low-stakes a single kernel
warning message is.  Switching to pr_info_ratelimited() instead should be
fine -- it's possible some monitoring tool will be unhappy with a stream
of warning-level messages but there's already plenty of info-level message
spam in dmesg.

[1]: https://lore.kernel.org/20221215001205.51969-4-jeffxu@google.com/
[2]: https://lore.kernel.org/202212161233.85C9783FB@keescook/
[3]: https://lore.kernel.org/Y5yS8wCnuYGLHMj4@x1n/
[4]: https://lore.kernel.org/f185bb42-b29c-977e-312e-3349eea15383@linuxfoundation.org/

Link: https://lkml.kernel.org/r/20230814-memfd-vm-noexec-uapi-fixes-v2-3-7ff9e3e10ba6@cyphar.com
Fixes: 105ff5339f49 ("mm/memfd: add MFD_NOEXEC_SEAL and MFD_EXEC")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: Dominique Martinet <asmadeus@codewreck.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memfd.c~memfd-improve-userspace-warnings-for-missing-exec-related-flags
+++ a/mm/memfd.c
@@ -315,7 +315,7 @@ SYSCALL_DEFINE2(memfd_create,
 		return -EINVAL;
 
 	if (!(flags & (MFD_EXEC | MFD_NOEXEC_SEAL))) {
-		pr_warn_once(
+		pr_info_ratelimited(
 			"%s[%d]: memfd_create() called without MFD_EXEC or MFD_NOEXEC_SEAL set\n",
 			current->comm, task_pid_nr(current));
 	}
_

Patches currently in -mm which might be from cyphar@cyphar.com are


