Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789A61A9FA8
	for <mm-commits@vger.kernel.org>; Sat, 28 Mar 2026 04:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774671950; cv=none; b=ONc15jybOpiQ8IbtWDqE0VaSeix2OVMhD70k8i/xlwe/u8V/Y6JDH3wD0az2kwsMhsGBdf+xU5HC49eQpQKR+dXtCQs+z0zmK33vBYkAKEhSa2qpUYi0i+BhMqPQmkQblyG0LfaEKJaGCoctv0IEqv4dfJM3nAzwkHK3JXF5vvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774671950; c=relaxed/simple;
	bh=CWKLmH71H5jCTiAxaY/0YVVEDihnEYguGxjo5/e623o=;
	h=Date:To:From:Subject:Message-Id; b=iGbFcj8WM5tSnLf4ZYhtOu6FbdR+l8cqUWH7A1p5ENoLRCB9qdOEw7xbMrWjob2o7fsZaN++0lBD3WLAE3N8FE5kxmCUCsGdzUBmxO9FNIsvdSfFlacXTkpg6x6yNooUBBhhS7BhxJPPGU4S/ms4IN+K1805PUmu4cRzF3swhH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bS0IKWcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bS0IKWcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511E0C4CEF7;
	Sat, 28 Mar 2026 04:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774671950;
	bh=CWKLmH71H5jCTiAxaY/0YVVEDihnEYguGxjo5/e623o=;
	h=Date:To:From:Subject:From;
	b=bS0IKWcsmDlKKps10c+H3v1zvRePLZZO0KMb64B6npjPl3bJAQ11o7KycGWIiTV0G
	 VBjpvtdvU+vPuE8xSgPeza4whOIvuFyEaAGTFyvJXwPWSXAcR1dqn2QScML6oCIEgg
	 Z02RMnAMJtBSjrqUkPrnYZKSRKUdKFFdXqEbP8jY=
Date: Fri, 27 Mar 2026 21:25:49 -0700
To: mm-commits@vger.kernel.org,sashal@kernel.org,matttbe@kernel.org,luca.ceresoli@bootlin.com,cmllamas@google.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] decode_stacktrace-decode-caller-address.patch removed from -mm tree
Message-Id: <20260328042550.511E0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: decode_stacktrace: decode caller address
has been removed from the -mm tree.  Its filename was
     decode_stacktrace-decode-caller-address.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: decode_stacktrace: decode caller address
Date: Fri, 6 Mar 2026 09:50:16 +0900

Decode the caller address instead of the return address by default.  This
also introduced -R option to provide return address decoding mode.

This changes the decode_stacktrace.sh to decode the line info 1byte before
the return address which will be the call(branch) instruction address.  If
the return address is a symbol address (zero offset from it), it falls
back to decoding the return address.

This improves results especially when optimizations have changed the order
of the lines around the return address, or when the return address does
not have the actual line information.

With this change;
 Call Trace:
  <TASK>
  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
  lockdep_rcu_suspicious (kernel/locking/lockdep.c:6876)
  event_filter_pid_sched_process_fork (kernel/trace/trace_events.c:1057)
  kernel_clone (include/trace/events/sched.h:396 include/trace/events/sched.h:396 kernel/fork.c:2664)
  __x64_sys_clone (kernel/fork.c:2795 kernel/fork.c:2779 kernel/fork.c:2779)
  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
  ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
  ? trace_irq_disable (include/trace/events/preemptirq.h:36)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)

Without this (or give -R option);
 Call Trace:
  <TASK>
  dump_stack_lvl (lib/dump_stack.c:122)
  lockdep_rcu_suspicious (kernel/locking/lockdep.c:6877)
  event_filter_pid_sched_process_fork (kernel/trace/trace_events.c:?)
  kernel_clone (include/trace/events/sched.h:? include/trace/events/sched.h:396 kernel/fork.c:2664)
  __x64_sys_clone (kernel/fork.c:2779)
  do_syscall_64 (arch/x86/entry/syscall_64.c:?)
  ? entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
  ? trace_irq_disable (include/trace/events/preemptirq.h:36)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

[akpm@linux-foundation.org: fix spello]
Link: https://lkml.kernel.org/r/177275821652.1557019.18367881408364381866.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>	[arm64]
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Sasha Levin (Microsoft) <sashal@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/scripts/decode_stacktrace.sh~decode_stacktrace-decode-caller-address
+++ a/scripts/decode_stacktrace.sh
@@ -5,9 +5,11 @@
 
 usage() {
 	echo "Usage:"
-	echo "	$0 -r <release>"
-	echo "	$0 [<vmlinux> [<base_path>|auto [<modules_path>]]]"
+	echo "	$0 [-R] -r <release>"
+	echo "	$0 [-R] [<vmlinux> [<base_path>|auto [<modules_path>]]]"
 	echo "	$0 -h"
+	echo "Options:"
+	echo "  -R: decode return address instead of caller address."
 }
 
 # Try to find a Rust demangler
@@ -33,11 +35,17 @@ fi
 READELF=${UTIL_PREFIX}readelf${UTIL_SUFFIX}
 ADDR2LINE=${UTIL_PREFIX}addr2line${UTIL_SUFFIX}
 NM=${UTIL_PREFIX}nm${UTIL_SUFFIX}
+decode_retaddr=false
 
 if [[ $1 == "-h" ]] ; then
 	usage
 	exit 0
-elif [[ $1 == "-r" ]] ; then
+elif [[ $1 == "-R" ]] ; then
+	decode_retaddr=true
+	shift 1
+fi
+
+if [[ $1 == "-r" ]] ; then
 	vmlinux=""
 	basepath="auto"
 	modpath=""
@@ -176,13 +184,23 @@ parse_symbol() {
 	# Let's start doing the math to get the exact address into the
 	# symbol. First, strip out the symbol total length.
 	local expr=${symbol%/*}
+	# Also parse the offset from symbol.
+	local offset=${expr#*+}
+	offset=$((offset))
 
 	# Now, replace the symbol name with the base address we found
 	# before.
 	expr=${expr/$name/0x$base_addr}
 
 	# Evaluate it to find the actual address
-	expr=$((expr))
+	# The stack trace shows the return address, which is the next
+	# instruction after the actual call, so as long as it's in the same
+	# symbol, subtract one from that to point the call instruction.
+	if [[ $decode_retaddr == false && $offset != 0 ]]; then
+		expr=$((expr-1))
+	else
+		expr=$((expr))
+	fi
 	local address=$(printf "%x\n" "$expr")
 
 	# Pass it to addr2line to get filename and line number
_

Patches currently in -mm which might be from mhiramat@kernel.org are


