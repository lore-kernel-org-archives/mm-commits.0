Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56EB175A7B
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 18:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773168498; cv=none; b=ALSnyfUtwCzUD2UXblAF6XlBK1s8SMflCT9VA72d/hOrH6GNGkFolpZuvYjOYRtIbSRBUAngz13cPViKlBU7IwSLM7+jATYvLO2J7+Y/Lv6psrKsozGYQusxH8yIVOaPJRPV7dNSKc38SpTeCsAdsUwykCcprlwSDqjrNnPzlAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773168498; c=relaxed/simple;
	bh=elf4UsgT9xSUlxplRbwMzl7POmSeihiqhc6fKQUz1Ts=;
	h=Date:To:From:Subject:Message-Id; b=h1gpsdIQhnwix9FjjlULpYGG/hSSyl/MBqxWT3zoBcUrWYtGKjv02cJWxmHP7JrH1r4M55e6CE5VqU6bs4Opgu+n92iEe2wXLMVi26DFlQ6zuhsRF3Uv0VlihRXHE03M+5O9lQ+PbjoT8N+Bg2h2mX407YGqEOfFlhExOZ7s6jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eESpnNjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eESpnNjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E0DC19423;
	Tue, 10 Mar 2026 18:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773168498;
	bh=elf4UsgT9xSUlxplRbwMzl7POmSeihiqhc6fKQUz1Ts=;
	h=Date:To:From:Subject:From;
	b=eESpnNjJciA9LRzck2pGRGpZNy7GX56xR9oWcibXeWXnRWjwdjPmaAKyviFFrezwE
	 IROgLptxzPBD2RvgXfgynmBBRAp9thRC+SHED4GJBsJQ6TNQcwhQf+qPxrGMRKGeI6
	 8Xc4H1Fupao7aDu85niPKWo2CCV6wGppWAXnrwKw=
Date: Tue, 10 Mar 2026 11:48:17 -0700
To: mm-commits@vger.kernel.org,sashal@kernel.org,matttbe@kernel.org,luca.ceresoli@bootlin.com,cmllamas@google.com,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + decode_stacktrace-decode-caller-address.patch added to mm-nonmm-unstable branch
Message-Id: <20260310184818.35E0DC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: decode_stacktrace: Decode caller address
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     decode_stacktrace-decode-caller-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/decode_stacktrace-decode-caller-address.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: decode_stacktrace: Decode caller address
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
+	# symbol, substract one from that to point the call instruction.
+	if [[ $decode_retaddr == false && $offset != 0 ]]; then
+		expr=$((expr-1))
+	else
+		expr=$((expr))
+	fi
 	local address=$(printf "%x\n" "$expr")
 
 	# Pass it to addr2line to get filename and line number
_

Patches currently in -mm which might be from mhiramat@kernel.org are

decode_stacktrace-decode-caller-address.patch

