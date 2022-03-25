Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3E57C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357501AbiCYBhP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357526AbiCYBf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147E73B2B4
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5D1960A1C
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D7A0C340ED;
        Fri, 25 Mar 2022 01:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172055;
        bh=Ow/Uq2bkt6acNpsSWTwafwc8sULcXxyGTak2Bnidv0k=;
        h=Date:To:From:Subject:From;
        b=Zer1RnV7hXOZGID5pL8U8MdE6tnGW7bKSzWi2UVaaTM3UQOJULJI1glaD5LlbVF1G
         snRtGaA7KDrde4eBQ8EW3a87bdhYuDwotjXi+0GaeVdwj4MK5VacqHru/OebvgUw2a
         uoIFiaJGSrUKKedhD9vgk/xnuAa+fzqaIigD/wbA=
Date:   Thu, 24 Mar 2022 18:34:14 -0700
To:     mm-commits@vger.kernel.org, yzaikin@google.com,
        siglesias@igalia.com, mcgrof@kernel.org, keescook@chromium.org,
        feng.tang@intel.com, gpiccoli@igalia.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] docs-sysctl-kernel-add-missing-bit-to-panic_print.patch removed from -mm tree
Message-Id: <20220325013415.0D7A0C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: docs: sysctl/kernel: add missing bit to panic_print
has been removed from the -mm tree.  Its filename was
     docs-sysctl-kernel-add-missing-bit-to-panic_print.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[rdunlap@infradead.org: fix table format warning]
  Link: https://lkml.kernel.org/r/20220109055635.6999-1-rdunlap@infradead.org
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
@@ -806,6 +806,7 @@ bit 1  print system memory info
 bit 2  print timer info
 bit 3  print locks info if ``CONFIG_LOCKDEP`` is on
 bit 4  print ftrace buffer
+bit 5  print all printk messages in buffer
 =====  ============================================
 
 So for example to print tasks and memory info on panic, user can::
_

Patches currently in -mm which might be from gpiccoli@igalia.com are


