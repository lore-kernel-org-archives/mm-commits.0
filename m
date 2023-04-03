Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE791C761A6
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 19:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjDCTZo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 15:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbjDCTZm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 15:25:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BA7E7C
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 12:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0CF7628C2
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 19:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB79C433EF;
        Mon,  3 Apr 2023 19:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680549941;
        bh=VuSba1uQYT+nbulMZlkkfRwz/stJ3L9Q2mKK9sEIUCM=;
        h=Date:To:From:Subject:From;
        b=v87/s/wfF3y1wrJbA1ljA0glFENbJIkJj0Szt+svPIVCzu60zht9kMRu3M4k/uqSG
         EJyjm3PUNUUuabABI7JATJafcBivYiKo8gYyKAWGnYoUAuqXoh38Mh+mBgrfin3aW2
         xLjHcI4NxAlGJ6Hi6amd1dIose7NfjhbiIqWEBKQ=
Date:   Mon, 03 Apr 2023 12:25:40 -0700
To:     mm-commits@vger.kernel.org, tycho@tycho.pizza, shuah@kernel.org,
        rostedt@goodmis.org, quic_mojha@quicinc.com, pbonzini@redhat.com,
        mhiramat@kernel.org, me@tobin.cc, mark.rutland@arm.com,
        zwisler@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] tools-kvm_stat-use-canonical-ftrace-path.patch removed from -mm tree
Message-Id: <20230403192541.1BB79C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: tools/kvm_stat: use canonical ftrace path
has been removed from the -mm tree.  Its filename was
     tools-kvm_stat-use-canonical-ftrace-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <zwisler@google.com>
Subject: tools/kvm_stat: use canonical ftrace path
Date: Mon, 13 Mar 2023 15:17:45 -0600

The canonical location for the tracefs filesystem is at
/sys/kernel/tracing.

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

 tools/kvm/kvm_stat/kvm_stat |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


