Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975132F9C2C
	for <mm-commits@vger.kernel.org>; Mon,  8 Sep 2025 23:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757372553; cv=none; b=caP58Z+nxWRkaYnJ5hf8QhWUZ/PHocAkShUAOKr4lRNdQolfsp6aBZ8bDsBYiDzodxL1RIIOilOO0efzLZSEDg+ZCLh21IXtDYORxcA6mJVXeOruhyr6z2kFeR7QQiprDBYiooOwAgkAUl/jkmmL7djrNEOWVsHOpgTUxJwt9qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757372553; c=relaxed/simple;
	bh=HK/nH7p2rjEYdQocF2TyRL9qCX1nOO+uUH/pqVjFDTI=;
	h=Date:To:From:Subject:Message-Id; b=rilNrlC19rySPxPsh0bUloh+FbsW6/VVyQV6n1TImIjjjz/Jqy8Ff0FY4ta6D0xJztraRwVkMpeN5q+Up98g8eg7RObLXKX+2OntbhuNZp3wQgqBtdokgGVz3WJ+la3cGimB7EVMEvmhGmgOtA1qVfRiEYnicg+3fwJrR7UErWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GGVoKVAX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GGVoKVAX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C866C4CEF1;
	Mon,  8 Sep 2025 23:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757372553;
	bh=HK/nH7p2rjEYdQocF2TyRL9qCX1nOO+uUH/pqVjFDTI=;
	h=Date:To:From:Subject:From;
	b=GGVoKVAXWj6oeCy24dyPWljM73X+QPTaQDWzLg8oFRAgteBVaWyYMH8jmJbOMaszz
	 KPTFOLWV2oNsO8KWi8+Uwj75buOhx7EI/3hz9gMeO8Am6RZ6mMJxtuzLqoAKlxSgnh
	 bDZvV3Op5GH4WAaI9qjS5Uu79cXt4riuQYP0ZQZ0=
Date: Mon, 08 Sep 2025 16:02:32 -0700
To: mm-commits@vger.kernel.org,swboyd@chromium.org,quic_eberman@quicinc.com,luca.ceresoli@bootlin.com,leitao@debian.org,cmllamas@google.com,matttbe@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-symbol-preserve-alignment.patch added to mm-new branch
Message-Id: <20250908230233.0C866C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decode_stacktrace.sh: symbol: preserve alignment
has been added to the -mm mm-new branch.  Its filename is
     scripts-decode_stacktracesh-symbol-preserve-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktracesh-symbol-preserve-alignment.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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

scripts-decode_stacktracesh-symbol-avoid-trailing-whitespaces.patch
scripts-decode_stacktracesh-symbol-preserve-alignment.patch
scripts-decode_stacktracesh-code-preserve-alignment.patch

