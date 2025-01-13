Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798F579E1
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 03:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737447; cv=none; b=swSVcAUF9YV7odTj5lo/rpvjcEdVH9+Nww9lV8VoX/8s0oqpf+SLsMYz8a9+ybcek+GreYkZaAuO45oBTOLIH3RkRXxl22GhYqmlMSeG+JwzKMSXXivWJM0vKeain89hEN+MBq2Y4hKzwXbs/AtKhuD+9pEJTln4uavxeoQpXfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737447; c=relaxed/simple;
	bh=ly7zV4ckfAc9HbAqxGhVD/ay5gwUWyhUxKWCQGGUFBU=;
	h=Date:To:From:Subject:Message-Id; b=jCkKk0Fi3393e9JBIklOcbafl/NAP/OgfKKlCfNKD1QNEKQ01kfRMIE+i/Zhw+0Mh76tNap4nr34PznKb47i7GZ1RZAoTgG+BgMUnRUFzhOJDR9kPTwnFzx3Q6ZDpztZkMUIAI1CiuicF617ezlos8AyJZBRL0yJlinwB1VvRxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=taQPMINM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="taQPMINM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEB3C4CEDF;
	Mon, 13 Jan 2025 03:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737446;
	bh=ly7zV4ckfAc9HbAqxGhVD/ay5gwUWyhUxKWCQGGUFBU=;
	h=Date:To:From:Subject:From;
	b=taQPMINMdYcPagEoVRme9xALHyC5VJJj8tsdR/R3KOdQZ1AtQIwabsWt4HK6M/D2Q
	 jPdYDIJ+kEjnLlkJHiszkM2fp1HbHsbpvFzsms41Fg41BXPkmVKpCymjyWIv+KieT0
	 YFAuytajNvnCakyRwlFjDA7PmccRXyjmFyV3mRb8=
Date: Sun, 12 Jan 2025 19:04:05 -0800
To: mm-commits@vger.kernel.org,thomas.petazzoni@bootlin.com,puranjay@kernel.org,mbenes@suse.cz,mark.rutland@arm.com,catalin.marinas@arm.com,broonie@kernel.org,luca.ceresoli@bootlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-decode_stacktracesh-fix-decoding-of-lines-with-an-additional-info.patch removed from -mm tree
Message-Id: <20250113030405.EAEB3C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh: fix decoding of lines with an additional info
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-fix-decoding-of-lines-with-an-additional-info.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


