Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16504C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244356AbiCWXIh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345429AbiCWXIg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:08:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F03590CEC
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:07:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7EA4617C1
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C6AC340E8;
        Wed, 23 Mar 2022 23:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076824;
        bh=H2dPfd3XTMtkFe6pJ9g4Atn9PbMHvHVNfh5PXFKKuVE=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=M3UsBFI1raGgI8Slo7l6iiKzJdXOwfmRwUimeWAIbnJuHNgp5XykX4FDAJXL6K1WW
         om4UB8Bsh/UuM3Y5iRhk4Lo6fXVxSIUtmhplc4gUKCFqFTfXyos+XFFS3KbwK+pius
         89AEhdEGpuL/fXqmP42iewCPI96+DIif/rnDQO7w=
Date:   Wed, 23 Mar 2022 16:07:03 -0700
To:     yzaikin@google.com, siglesias@igalia.com, mcgrof@kernel.org,
        keescook@chromium.org, feng.tang@intel.com, gpiccoli@igalia.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 35/41] docs: sysctl/kernel: add missing bit to panic_print
Message-Id: <20220323230704.12C6AC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
