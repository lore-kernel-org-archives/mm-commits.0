Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BED4C433FE
	for <mm-commits@archiver.kernel.org>; Tue, 14 Dec 2021 18:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbhLNS3G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Dec 2021 13:29:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46522 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234236AbhLNS3F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Dec 2021 13:29:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 702E5616AC
        for <mm-commits@vger.kernel.org>; Tue, 14 Dec 2021 18:29:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9783EC34606;
        Tue, 14 Dec 2021 18:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639506544;
        bh=qUEwz2p9TMCgBCCl80zz5O8DebPbCzwh2wityBFuo80=;
        h=Date:From:To:Subject:From;
        b=vcn9k/FSZO1h+Hv9sfV+FmGZF0tmp5EYK670zUqeNAE5SfcIVwJqiGA5vqe8jghiG
         /RmUT+bK1abkeNuZLCHOQ+UA1MBVfZJsxvEW+c06FOZmEPZP+k9w/gjUVSIJ2DIw/p
         4NZsnrWVZ9pIGQNi4T3Y6sEOkSlMwFeTsZJWyOI8=
Date:   Tue, 14 Dec 2021 10:29:04 -0800
From:   akpm@linux-foundation.org
To:     feng.tang@intel.com, gpiccoli@igalia.com, keescook@chromium.org,
        mcgrof@kernel.org, mm-commits@vger.kernel.org,
        siglesias@igalia.com, yzaikin@google.com
Subject:  + docs-sysctl-kernel-add-missing-bit-to-panic_print.patch
 added to -mm tree
Message-ID: <20211214182904.kjV1gQWY9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: sysctl/kernel: add missing bit to panic_print
has been added to the -mm tree.  Its filename is
     docs-sysctl-kernel-add-missing-bit-to-panic_print.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-sysctl-kernel-add-missing-bit-to-panic_print.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-sysctl-kernel-add-missing-bit-to-panic_print.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: docs: sysctl/kernel: add missing bit to panic_print

Patch series "Some improvements on panic_print".

This is a mix of a documentation fix with some additions to the
"panic_print" syscall / parameter.  The goal here is being able to collect
all CPUs backtraces during a panic event and also to enable "panic_print"
in a kdump event - details of the reasoning and design choices in the
patches.


This patch (of 3):

Commit de6da1e8bcf0 ("panic: add an option to replay all the printk
message in buffer") added a new bit to the sysctl/kernel parameter
"panic_print", but the documentation was added only in
kernel-parameters.txt, not in the sysctl guide.

Fix it here by adding bit 5 to sysctl admin-guide documentation.

Link: https://lkml.kernel.org/r/20211109202848.610874-1-gpiccoli@igalia.com
Link: https://lkml.kernel.org/r/20211109202848.610874-2-gpiccoli@igalia.com
Fixes: de6da1e8bcf0 ("panic: add an option to replay all the printk message in buffer")
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/sysctl/kernel.rst |    1 +
 1 file changed, 1 insertion(+)

--- a/Documentation/admin-guide/sysctl/kernel.rst~docs-sysctl-kernel-add-missing-bit-to-panic_print
+++ a/Documentation/admin-guide/sysctl/kernel.rst
@@ -795,6 +795,7 @@ bit 1  print system memory info
 bit 2  print timer info
 bit 3  print locks info if ``CONFIG_LOCKDEP`` is on
 bit 4  print ftrace buffer
+bit 5: print all printk messages in buffer
 =====  ============================================
 
 So for example to print tasks and memory info on panic, user can::
_

Patches currently in -mm which might be from gpiccoli@igalia.com are

docs-sysctl-kernel-add-missing-bit-to-panic_print.patch
panic-add-option-to-dump-all-cpus-backtraces-in-panic_print.patch
panic-allow-printing-extra-panic-information-on-kdump.patch

