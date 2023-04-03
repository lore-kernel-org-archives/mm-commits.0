Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2F0C76196
	for <mm-commits@archiver.kernel.org>; Mon,  3 Apr 2023 19:25:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjDCTZm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Apr 2023 15:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjDCTZl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Apr 2023 15:25:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AF419B6
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 12:25:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71744628C2
        for <mm-commits@vger.kernel.org>; Mon,  3 Apr 2023 19:25:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4B2C433EF;
        Mon,  3 Apr 2023 19:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680549938;
        bh=fbIG0wjZcdTtQiovk+HM1uSJk+AX/jMIxO4bFPDaW6g=;
        h=Date:To:From:Subject:From;
        b=EC6bjzSME0e9xfwEb3vETMq32j2t9EsjCnVJffxyFmtKUbfcnzWBMYW6teBwnTCjj
         1tGLJ3sKdtgbIDYvjyNyOnNg6FlihxN1hfDqootwurEi6W+m3A0WHKBbO+VQ9cBjLV
         ak5vnt6ZsFFrhSuED24JBh5xrwjPEcYVip3EtVhA=
Date:   Mon, 03 Apr 2023 12:25:38 -0700
To:     mm-commits@vger.kernel.org, tycho@tycho.pizza, shuah@kernel.org,
        rostedt@goodmis.org, quic_mojha@quicinc.com, pbonzini@redhat.com,
        mhiramat@kernel.org, me@tobin.cc, mark.rutland@arm.com,
        zwisler@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-use-canonical-ftrace-path.patch removed from -mm tree
Message-Id: <20230403192538.BD4B2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: selftests: use canonical ftrace path
has been removed from the -mm tree.  Its filename was
     selftests-use-canonical-ftrace-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <zwisler@google.com>
Subject: selftests: use canonical ftrace path
Date: Mon, 13 Mar 2023 15:17:43 -0600

The canonical location for the tracefs filesystem is at /sys/kernel/tracing.

But, from Documentation/trace/ftrace.rst:

  Before 4.1, all ftrace tracing control files were within the debugfs
  file system, which is typically located at /sys/kernel/debug/tracing.
  For backward compatibility, when mounting the debugfs file system,
  the tracefs file system will be automatically mounted at:

  /sys/kernel/debug/tracing

A few spots in tools/testing/selftests still refer to this older debugfs
path, so let's update them to avoid confusion.

Link: https://lkml.kernel.org/r/20230313211746.1541525-1-zwisler@kernel.org
Signed-off-by: Ross Zwisler <zwisler@google.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Tobin C. Harding" <me@tobin.cc>
Cc: Tycho Andersen <tycho@tycho.pizza>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/protection_keys.c      |    4 ++--
 tools/testing/selftests/user_events/dyn_test.c    |    2 +-
 tools/testing/selftests/user_events/ftrace_test.c |   10 +++++-----
 tools/testing/selftests/user_events/perf_test.c   |    8 ++++----
 4 files changed, 12 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/mm/protection_keys.c~selftests-use-canonical-ftrace-path
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -98,7 +98,7 @@ int tracing_root_ok(void)
 void tracing_on(void)
 {
 #if CONTROL_TRACING > 0
-#define TRACEDIR "/sys/kernel/debug/tracing"
+#define TRACEDIR "/sys/kernel/tracing"
 	char pidstr[32];
 
 	if (!tracing_root_ok())
@@ -124,7 +124,7 @@ void tracing_off(void)
 #if CONTROL_TRACING > 0
 	if (!tracing_root_ok())
 		return;
-	cat_into_file("0", "/sys/kernel/debug/tracing/tracing_on");
+	cat_into_file("0", "/sys/kernel/tracing/tracing_on");
 #endif
 }
 
--- a/tools/testing/selftests/user_events/dyn_test.c~selftests-use-canonical-ftrace-path
+++ a/tools/testing/selftests/user_events/dyn_test.c
@@ -16,7 +16,7 @@
 
 #include "../kselftest_harness.h"
 
-const char *dyn_file = "/sys/kernel/debug/tracing/dynamic_events";
+const char *dyn_file = "/sys/kernel/tracing/dynamic_events";
 const char *clear = "!u:__test_event";
 
 static int Append(const char *value)
--- a/tools/testing/selftests/user_events/ftrace_test.c~selftests-use-canonical-ftrace-path
+++ a/tools/testing/selftests/user_events/ftrace_test.c
@@ -16,11 +16,11 @@
 
 #include "../kselftest_harness.h"
 
-const char *data_file = "/sys/kernel/debug/tracing/user_events_data";
-const char *status_file = "/sys/kernel/debug/tracing/user_events_status";
-const char *enable_file = "/sys/kernel/debug/tracing/events/user_events/__test_event/enable";
-const char *trace_file = "/sys/kernel/debug/tracing/trace";
-const char *fmt_file = "/sys/kernel/debug/tracing/events/user_events/__test_event/format";
+const char *data_file = "/sys/kernel/tracing/user_events_data";
+const char *status_file = "/sys/kernel/tracing/user_events_status";
+const char *enable_file = "/sys/kernel/tracing/events/user_events/__test_event/enable";
+const char *trace_file = "/sys/kernel/tracing/trace";
+const char *fmt_file = "/sys/kernel/tracing/events/user_events/__test_event/format";
 
 static inline int status_check(char *status_page, int status_bit)
 {
--- a/tools/testing/selftests/user_events/perf_test.c~selftests-use-canonical-ftrace-path
+++ a/tools/testing/selftests/user_events/perf_test.c
@@ -18,10 +18,10 @@
 
 #include "../kselftest_harness.h"
 
-const char *data_file = "/sys/kernel/debug/tracing/user_events_data";
-const char *status_file = "/sys/kernel/debug/tracing/user_events_status";
-const char *id_file = "/sys/kernel/debug/tracing/events/user_events/__test_event/id";
-const char *fmt_file = "/sys/kernel/debug/tracing/events/user_events/__test_event/format";
+const char *data_file = "/sys/kernel/tracing/user_events_data";
+const char *status_file = "/sys/kernel/tracing/user_events_status";
+const char *id_file = "/sys/kernel/tracing/events/user_events/__test_event/id";
+const char *fmt_file = "/sys/kernel/tracing/events/user_events/__test_event/format";
 
 struct event {
 	__u32 index;
_

Patches currently in -mm which might be from zwisler@google.com are

leaking_addresses-also-skip-canonical-ftrace-path.patch
tools-kvm_stat-use-canonical-ftrace-path.patch

