Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E6A0C76188
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 19:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjDCTZm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 15:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjDCTZl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 15:25:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CFEE7C
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 12:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 964F1628D3
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 19:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4C5C433D2;
        Mon,  3 Apr 2023 19:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680549940;
        bh=h2cIM/5Al57uPAVmP0iNnX+2BZfYllBENd5/dbE2da4=;
        h=Date:To:From:Subject:From;
        b=x4PlyfO+hMJRSsB4+Sj1yrfxfezRwwBGnF8D7s0ADD2B69/nwpeDivdr+TRBwL4I0
         8AH5Ne0sPWJ62tDMEGHqUELNljaHCn5npiuBF2C9Gj2G1L+wIWZPlCZrzNk2UBeLNl
         zeeiwta9dgkLpbVpBWxyaInagYmM4mD/7KTj7aZc=
Date:   Mon, 03 Apr 2023 12:25:39 -0700
To:     mm-commits@vger.kernel.org, tycho@tycho.pizza, shuah@kernel.org,
        rostedt@goodmis.org, quic_mojha@quicinc.com, pbonzini@redhat.com,
        mhiramat@kernel.org, me@tobin.cc, mark.rutland@arm.com,
        zwisler@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] leaking_addresses-also-skip-canonical-ftrace-path.patch removed from -mm tree
Message-Id: <20230403192539.EB4C5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: leaking_addresses: also skip canonical ftrace path
has been removed from the -mm tree.  Its filename was
     leaking_addresses-also-skip-canonical-ftrace-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 scripts/leaking_addresses.pl |    1 +
 1 file changed, 1 insertion(+)

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

tools-kvm_stat-use-canonical-ftrace-path.patch

