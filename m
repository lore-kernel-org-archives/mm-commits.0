Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7386B21D3C0
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489963; cv=none; b=PurZcwk8FSp4RVC7rwMlBaR8mPDZ6AEkaYRCnCNonLorK30nGelKVfzaF9fo39KhEjWDMsXSYlOCzXEVT2eQTMdPc5g1znXrexfTg6ZBbhPrZ4N10OdlDKQwVUGmL5OEk2dlVsGCK8wnfdDnmqagbJZpFJMTV+8B5vKOuxz0D3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489963; c=relaxed/simple;
	bh=FrmjCWVQm6bhY60AkeQMcVlcz34CcIShjAQuISVtyYg=;
	h=Date:To:From:Subject:Message-Id; b=ErVz0JLzts3bJW3TgH0oMUkFwTXxfCyadcPqrPATdCekW4X2oJxw0C9UYH7byP8AeezuGSFwBlAVFt5wsihIbkFq2KOt4nsjGlCHzrfA3Z1VEgmFOMah9l6Z+Zw38XU2g9xwDT52sRu75VeYH7FWbX3xmpudpr3UUQbmRHlCe5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F6T6bp2J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F6T6bp2J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4110BC4CEE7;
	Sun, 21 Sep 2025 21:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489963;
	bh=FrmjCWVQm6bhY60AkeQMcVlcz34CcIShjAQuISVtyYg=;
	h=Date:To:From:Subject:From;
	b=F6T6bp2JVjUoFz2o2PjoYB+sI5XS00kQ6W+EkRS9qlOF5DLMxWmXW+g5l7CuB7at/
	 E7oEPdybsrGuezebnmw712yly14+d0x9ZCYzIFXluWP9D+PjB9fBEfL2tJR0/6TEHB
	 ywIo4EZbLVTL/UaKOr+JiVGYv1ERMtWdS3tHDLDc=
Date: Sun, 21 Sep 2025 14:26:02 -0700
To: mm-commits@vger.kernel.org,swboyd@chromium.org,quic_eberman@quicinc.com,luca.ceresoli@bootlin.com,leitao@debian.org,cmllamas@google.com,matttbe@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] scripts-decode_stacktracesh-symbol-preserve-alignment.patch removed from -mm tree
Message-Id: <20250921212603.4110BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh: symbol: preserve alignment
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-symbol-preserve-alignment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: scripts/decode_stacktrace.sh: symbol: preserve alignment
Date: Mon, 08 Sep 2025 17:41:58 +0200

With lines having a symbol to decode, the script was only trying to
preserve the alignment for the timestamps, but not the rest, nor when the
caller was set (CONFIG_PRINTK_CALLER=y).

With this sample ...

  [   52.080924] Call Trace:
  [   52.080926]  <TASK>
  [   52.080931]  dump_stack_lvl+0x6f/0xb0

... the script was producing the following output:

  [   52.080924] Call Trace:
  [   52.080926]  <TASK>
  [   52.080931] dump_stack_lvl (arch/x86/include/asm/irqflags.h:19)

  (dump_stack_lvl is no longer aligned with <TASK>: one missing space)

With this other sample ...

  [   52.080924][   T48] Call Trace:
  [   52.080926][   T48]  <TASK>
  [   52.080931][   T48]  dump_stack_lvl+0x6f/0xb0

... the script was producing the following output:

  [   52.080924][   T48] Call Trace:
  [   52.080926][   T48]  <TASK>
  [ 52.080931][ T48] dump_stack_lvl (arch/x86/include/asm/irqflags.h:19)

  (the misalignment is clearer here)

That's because the script had a workaround for CONFIG_PRINTK_TIME=y only,
see the previous comment called "Format timestamps with tabs".

To always preserve spaces, they need to be recorded along the words.  That
is what is now done with the new 'spaces' array.

Some notes:

- 'extglob' is needed only for this operation, and that's why it is set
  in a dedicated subshell.

- 'read' is used with '-r' not to treat a <backslash> character in any
  special way, e.g. when followed by a space.

- When a word is removed from the 'words' array, the corresponding space
  needs to be removed from the 'spaces' array as well.

With the last sample, we now have:

  [   52.080924][   T48] Call Trace:
  [   52.080926][   T48]  <TASK>
  [   52.080931][   T48]  dump_stack_lvl (arch/x86/include/asm/irqflags.h:19)

  (the alignment is preserved)

Link: https://lkml.kernel.org/r/20250908-decode_strace_indent-v1-2-28e5e4758080@kernel.org
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Tested-by: Carlos Llamas <cmllamas@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Elliot Berman <quic_eberman@quicinc.com>
Cc: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-symbol-preserve-alignment
+++ a/scripts/decode_stacktrace.sh
@@ -255,10 +255,11 @@ handle_line() {
 		basepath=${basepath%/init/main.c:*)}
 	fi
 
-	local words
+	local words spaces
 
-	# Tokenize
-	read -a words <<<"$1"
+	# Tokenize: words and spaces to preserve the alignment
+	read -ra words <<<"$1"
+	IFS='#' read -ra spaces <<<"$(shopt -s extglob; echo "${1//+([^[:space:]])/#}")"
 
 	# Remove hex numbers. Do it ourselves until it happens in the
 	# kernel
@@ -270,19 +271,13 @@ handle_line() {
 	for i in "${!words[@]}"; do
 		# Remove the address
 		if [[ ${words[$i]} =~ \[\<([^]]+)\>\] ]]; then
-			unset words[$i]
-		fi
-
-		# Format timestamps with tabs
-		if [[ ${words[$i]} == \[ && ${words[$i+1]} == *\] ]]; then
-			unset words[$i]
-			words[$i+1]=$(printf "[%13s\n" "${words[$i+1]}")
+			unset words[$i] spaces[$i]
 		fi
 	done
 
 	if [[ ${words[$last]} =~ ^[0-9a-f]+\] ]]; then
 		words[$last-1]="${words[$last-1]} ${words[$last]}"
-		unset words[$last]
+		unset words[$last] spaces[$last]
 		last=$(( $last - 1 ))
 	fi
 
@@ -294,7 +289,7 @@ handle_line() {
 	local info_str=""
 	if [[ ${words[$last]} =~ \([A-Z]*\) ]]; then
 		info_str=${words[$last]}
-		unset words[$last]
+		unset words[$last] spaces[$last]
 		last=$(( $last - 1 ))
 	fi
 
@@ -311,7 +306,7 @@ handle_line() {
 			modbuildid=
 		fi
 		symbol=${words[$last-1]}
-		unset words[$last-1]
+		unset words[$last-1] spaces[$last-1]
 	else
 		# The symbol is the last element, process it
 		symbol=${words[$last]}
@@ -323,7 +318,10 @@ handle_line() {
 	parse_symbol # modifies $symbol
 
 	# Add up the line number to the symbol
-	echo "${words[@]}" "${symbol}${module:+ ${module}}${info_str:+ ${info_str}}"
+	for i in "${!words[@]}"; do
+		echo -n "${spaces[i]}${words[i]}"
+	done
+	echo "${spaces[$last]}${symbol}${module:+ ${module}}${info_str:+ ${info_str}}"
 }
 
 while read line; do
_

Patches currently in -mm which might be from matttbe@kernel.org are


