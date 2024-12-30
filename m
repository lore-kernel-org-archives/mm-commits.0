Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA7419AD90
	for <mm-commits@vger.kernel.org>; Mon, 30 Dec 2024 23:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735602884; cv=none; b=kevtwT7ysO5/aAAladGTeFFoX4OFOnqtnKPtwIrCs3+NxDVlIGB7M2J2GPoLPva01Q6Tl6Fk7Pnos0EFWfOQ/GCUVcUSTFJCIxHMpxiKIYtmmGy2EWhsaQES+RTRd/qQU3ag7kDH4jAKyyPDsmOUVAAWBIpgbEFzAwae3NKcsh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735602884; c=relaxed/simple;
	bh=XcsBKdrsoI5JwTABSQnaDfwaTZfQhtXSucKrqh2IrUY=;
	h=Date:To:From:Subject:Message-Id; b=h8y7vvM3JSg3Xxk4sewmrZTs8mt72G/BV8rRn6DEJE5tYY6zMnrtnoRik27wwUljOtJ8pIe/PaRnClE1gxfu6IcoIiM+wjq/YitmRmxscwY4w9GRBv0kV7eF+DB5ar3dzX8CVISP4K7e8YSaN7nv9RqCz1mV3NfIwrHXESDJTRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CqhH7ZQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CqhH7ZQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D8CC4CED0;
	Mon, 30 Dec 2024 23:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735602883;
	bh=XcsBKdrsoI5JwTABSQnaDfwaTZfQhtXSucKrqh2IrUY=;
	h=Date:To:From:Subject:From;
	b=CqhH7ZQxLzgf7wzCViaBM95bVVBL6UFdzeDw/od27AfrfEQjhRTcLrR1bd/2ow24o
	 UXFZk7aEUSBTWiJJBReaYpWcIkDJdsaHvLbSnY+GejbHRUl2QtaEWLd8GAJn8Yi/2D
	 rG0+/Vq02utzOFgND3K/afPIapCGhTLyQQCYycvA=
Date: Mon, 30 Dec 2024 15:54:42 -0800
To: mm-commits@vger.kernel.org,thomas.petazzoni@bootlin.com,puranjay@kernel.org,mbenes@suse.cz,mark.rutland@arm.com,catalin.marinas@arm.com,broonie@kernel.org,luca.ceresoli@bootlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-fix-decoding-of-lines-with-an-additional-info.patch added to mm-hotfixes-unstable branch
Message-Id: <20241230235443.58D8CC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decode_stacktrace.sh: fix decoding of lines with an additional info
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-decode_stacktracesh-fix-decoding-of-lines-with-an-additional-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktracesh-fix-decoding-of-lines-with-an-additional-info.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: scripts/decode_stacktrace.sh: fix decoding of lines with an additional info
Date: Mon, 30 Dec 2024 22:55:10 +0100

Since commit bdf8eafbf7f5 ("arm64: stacktrace: report source of unwind
data") a stack trace line can contain an additional info field that was not
present before, in the form of one or more letters in parentheses. E.g.:

  [  504.517915]  led_sysfs_enable+0x54/0x80 (P)
                                             ^^^

When this is present, decode_stacktrace decodes the line incorrectly:

  [  504.517915] led_sysfs_enable+0x54/0x80 P

Extend parsing to decode it correctly:

  [  504.517915] led_sysfs_enable (drivers/leds/led-core.c:455 (discriminator 7)) (P)

The regex to match such lines assumes the info can be extended in the
future to other uppercase characters, and will need to be extended in case
other characters will be used. Using a much more generic regex might incur
in false positives, so this looked like a good tradeoff.

Link: https://lkml.kernel.org/r/20241230-decode_stacktrace-fix-info-v1-1-984910659173@bootlin.com
Fixes: bdf8eafbf7f5 ("arm64: stacktrace: report source of unwind data")
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Puranjay Mohan <puranjay@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-fix-decoding-of-lines-with-an-additional-info
+++ a/scripts/decode_stacktrace.sh
@@ -286,6 +286,18 @@ handle_line() {
 		last=$(( $last - 1 ))
 	fi
 
+	# Extract info after the symbol if present. E.g.:
+	# func_name+0x54/0x80 (P)
+	#                     ^^^
+	# The regex assumes only uppercase letters will be used. To be
+	# extended if needed.
+	local info_str=""
+	if [[ ${words[$last]} =~ \([A-Z]*\) ]]; then
+		info_str=${words[$last]}
+		unset words[$last]
+		last=$(( $last - 1 ))
+	fi
+
 	if [[ ${words[$last]} =~ \[([^]]+)\] ]]; then
 		module=${words[$last]}
 		# some traces format is "(%pS)", which like "(foo+0x0/0x1 [bar])"
@@ -313,9 +325,9 @@ handle_line() {
 	# Add up the line number to the symbol
 	if [[ -z ${module} ]]
 	then
-		echo "${words[@]}" "$symbol"
+		echo "${words[@]}" "$symbol ${info_str}"
 	else
-		echo "${words[@]}" "$symbol $module"
+		echo "${words[@]}" "$symbol $module ${info_str}"
 	fi
 }
 
_

Patches currently in -mm which might be from luca.ceresoli@bootlin.com are

scripts-decode_stacktracesh-fix-decoding-of-lines-with-an-additional-info.patch

