Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78DB1C7618B
	for <mm-commits@archiver.kernel.org>; Tue, 14 Mar 2023 21:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjCNVy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Mar 2023 17:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbjCNVyZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2023 17:54:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D010225B92
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 14:54:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C1CF6197E
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 21:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A1DC433EF;
        Tue, 14 Mar 2023 21:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678830863;
        bh=L7nbYQH2rJrTnfgd1Lpti4Tp2DSlLtU8oTZ7gOjUB3Q=;
        h=Date:To:From:Subject:From;
        b=upH4W/s/gUSs3BK0lubbL3bnGSP0N86bo2/lA5+8L9P0l+eE1pRlhjjDW66IoW84B
         2ZQtolnPKDtX4hNMEWZcDxzFwFqResvb4nR2EV0X081pbYRMeRypmiHiUJiyGzpLy1
         xMuklJ/Poqhto7ZplBf2pCm/krHXOsyvnYsrGUB4=
Date:   Tue, 14 Mar 2023 14:54:23 -0700
To:     mm-commits@vger.kernel.org, tycho@tycho.pizza, shuah@kernel.org,
        rostedt@goodmis.org, quic_mojha@quicinc.com, pbonzini@redhat.com,
        mhiramat@kernel.org, me@tobin.cc, mark.rutland@arm.com,
        zwisler@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + leaking_addresses-also-skip-canonical-ftrace-path.patch added to mm-nonmm-unstable branch
Message-Id: <20230314215423.C6A1DC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: leaking_addresses: also skip canonical ftrace path
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     leaking_addresses-also-skip-canonical-ftrace-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/leaking_addresses-also-skip-canonical-ftrace-path.patch

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
From: Ross Zwisler <zwisler@google.com>
Subject: leaking_addresses: also skip canonical ftrace path
Date: Mon, 13 Mar 2023 15:17:44 -0600

The canonical location for the tracefs filesystem is at /sys/kernel/tracing.

But, from Documentation/trace/ftrace.rst:

  Before 4.1, all ftrace tracing control files were within the debugfs
  file system, which is typically located at /sys/kernel/debug/tracing.
  For backward compatibility, when mounting the debugfs file system,
  the tracefs file system will be automatically mounted at:

  /sys/kernel/debug/tracing

scripts/leaking_addresses.pl only skipped this older debugfs path, so
let's add the canonical path as well.

Link: https://lkml.kernel.org/r/20230313211746.1541525-2-zwisler@kernel.org
Signed-off-by: Ross Zwisler <zwisler@google.com>
Acked-by: Tycho Andersen <tycho@tycho.pizza>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mukesh Ojha <quic_mojha@quicinc.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Tobin C. Harding" <me@tobin.cc>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/scripts/leaking_addresses.pl~leaking_addresses-also-skip-canonical-ftrace-path
+++ a/scripts/leaking_addresses.pl
@@ -61,6 +61,7 @@ my @skip_abs = (
 	'/proc/device-tree',
 	'/proc/1/syscall',
 	'/sys/firmware/devicetree',
+	'/sys/kernel/tracing/trace_pipe',
 	'/sys/kernel/debug/tracing/trace_pipe',
 	'/sys/kernel/security/apparmor/revision');
 
_

Patches currently in -mm which might be from zwisler@google.com are

selftests-use-canonical-ftrace-path.patch
leaking_addresses-also-skip-canonical-ftrace-path.patch
tools-kvm_stat-use-canonical-ftrace-path.patch

