Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E82BC6FD1F
	for <mm-commits@archiver.kernel.org>; Tue, 14 Mar 2023 21:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjCNVya (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 14 Mar 2023 17:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjCNVy3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Mar 2023 17:54:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DC724C90
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 14:54:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFEB2B81A58
        for <mm-commits@vger.kernel.org>; Tue, 14 Mar 2023 21:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67062C433EF;
        Tue, 14 Mar 2023 21:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678830865;
        bh=kCrKE7dMh+PK+EtP2iIaVe07a5RCuo/XT+QH/Qm7yc0=;
        h=Date:To:From:Subject:From;
        b=MeVCncOdXTkg3LgwcevO2JdRrOtYmuVszUJVBsK/VVYWI3/OlcHS/5voPxDZzKdoh
         ODl9PWKc79pTQUiSd/qnR5Cb1ZkYQlgfK3XDemQhDIKpC2r71JJ9XY9HRYiBbBFGz7
         Hfzq7Xc7rpWock1d9gX87mCGl4uxvsA8bhEQUUmU=
Date:   Tue, 14 Mar 2023 14:54:24 -0700
To:     mm-commits@vger.kernel.org, tycho@tycho.pizza, shuah@kernel.org,
        rostedt@goodmis.org, quic_mojha@quicinc.com, pbonzini@redhat.com,
        mhiramat@kernel.org, me@tobin.cc, mark.rutland@arm.com,
        zwisler@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-kvm_stat-use-canonical-ftrace-path.patch added to mm-nonmm-unstable branch
Message-Id: <20230314215425.67062C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: tools/kvm_stat: use canonical ftrace path
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-kvm_stat-use-canonical-ftrace-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-kvm_stat-use-canonical-ftrace-path.patch

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
Subject: tools/kvm_stat: use canonical ftrace path
Date: Mon, 13 Mar 2023 15:17:45 -0600

The canonical location for the tracefs filesystem is at /sys/kernel/tracing.

But, from Documentation/trace/ftrace.rst:

  Before 4.1, all ftrace tracing control files were within the debugfs
  file system, which is typically located at /sys/kernel/debug/tracing.
  For backward compatibility, when mounting the debugfs file system,
  the tracefs file system will be automatically mounted at:

  /sys/kernel/debug/tracing

A comment in kvm_stat still refers to this older debugfs path, so let's
update it to avoid confusion.

Link: https://lkml.kernel.org/r/20230313211746.1541525-3-zwisler@kernel.org
Signed-off-by: Ross Zwisler <zwisler@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Tobin C. Harding" <me@tobin.cc>
Cc: Tycho Andersen <tycho@tycho.pizza>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/tools/kvm/kvm_stat/kvm_stat~tools-kvm_stat-use-canonical-ftrace-path
+++ a/tools/kvm/kvm_stat/kvm_stat
@@ -627,7 +627,7 @@ class TracepointProvider(Provider):
         name)'.
 
         All available events have directories under
-        /sys/kernel/debug/tracing/events/ which export information
+        /sys/kernel/tracing/events/ which export information
         about the specific event. Therefore, listing the dirs gives us
         a list of all available events.
 
_

Patches currently in -mm which might be from zwisler@google.com are

selftests-use-canonical-ftrace-path.patch
leaking_addresses-also-skip-canonical-ftrace-path.patch
tools-kvm_stat-use-canonical-ftrace-path.patch

