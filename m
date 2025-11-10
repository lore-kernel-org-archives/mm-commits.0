Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902332E8DE6;
	Mon, 10 Nov 2025 05:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762752037; cv=none; b=InCrv6qLqU/0BnRWuBGKHg1YXfniC5F4zJPR8PhvOIM6dfv3l8sTuS3p1DYcqXOcDCZkd7hPkXp3LdtiEqquuqLNIuSViCmtnE/WzOLF44yXSgarBWy8Xhl4E/6Qm2rLt3qCYHojIy0mBwG91XCT/exAPtPYDtnYQip9uq/hfl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762752037; c=relaxed/simple;
	bh=F4aqhcY2A+GKF42StoObFb4dSIrTJHjJhfLjxfjNNPk=;
	h=Date:To:From:Subject:Message-Id; b=eyWE97fJySKIwiJvfVrtP3R1rR7Y0gqIe0YIwfsvgfVYNwIbX0Cr2XNV+7vRPJmi2kry66XBymwcADWZVaxZuFpRzlm9PmEmvo5rQ5bglLRZ/4owcUzxxD3IxrkDVvYuu3UzO6BiOET01wqKZStAZ0H4oBcwVP4bwdSsHo1jUF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fDiSjRWc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fDiSjRWc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F017C4CEF5;
	Mon, 10 Nov 2025 05:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762752037;
	bh=F4aqhcY2A+GKF42StoObFb4dSIrTJHjJhfLjxfjNNPk=;
	h=Date:To:From:Subject:From;
	b=fDiSjRWcnL2NMeLKBJO7pm59OPsycaKVMljA+Bl1cbEnDvcAExRQfuhDH7S91/XMF
	 m0kxUDrAxY5YLPyygj5vIas+3ERam75rW/Sx9CdPlMRVoLJ6gkmSHaU2ltpIdIDr3L
	 c0A58+z0YJthE2eFULTUnTtRfwgQwv15vwzXP9wo=
Date: Sun, 09 Nov 2025 21:20:36 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,puranjay@kernel.org,mbenes@suse.cz,matttbe@kernel.org,mark.rutland@arm.com,luca.ceresoli@bootlin.com,leitao@debian.org,catalin.marinas@arm.com,broonie@kernel.org,cmllamas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] scripts-decode_stacktracesh-fix-build-id-and-pc-source-parsing.patch removed from -mm tree
Message-Id: <20251110052037.1F017C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh: fix build ID and PC source parsing
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-fix-build-id-and-pc-source-parsing.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Carlos Llamas <cmllamas@google.com>
Subject: scripts/decode_stacktrace.sh: fix build ID and PC source parsing
Date: Thu, 30 Oct 2025 01:03:33 +0000

Support for parsing PC source info in stacktraces (e.g.  '(P)') was added
in commit 2bff77c665ed ("scripts/decode_stacktrace.sh: fix decoding of
lines with an additional info").  However, this logic was placed after the
build ID processing.  This incorrect order fails to parse lines containing
both elements, e.g.:

  drm_gem_mmap_obj+0x114/0x200 [drm 03d0564e0529947d67bb2008c3548be77279fd27] (P)

This patch fixes the problem by extracting the PC source info first and
then processing the module build ID.  With this change, the line above is
now properly parsed as such:

  drm_gem_mmap_obj (./include/linux/mmap_lock.h:212 ./include/linux/mm.h:811 drivers/gpu/drm/drm_gem.c:1177) drm (P)

While here, also add a brief explanation the build ID section.

Link: https://lkml.kernel.org/r/20251030010347.2731925-1-cmllamas@google.com
Fixes: 2bff77c665ed ("scripts/decode_stacktrace.sh: fix decoding of lines with an additional info")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Puranjay Mohan <puranjay@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-fix-build-id-and-pc-source-parsing
+++ a/scripts/decode_stacktrace.sh
@@ -277,12 +277,6 @@ handle_line() {
 		fi
 	done
 
-	if [[ ${words[$last]} =~ ^[0-9a-f]+\] ]]; then
-		words[$last-1]="${words[$last-1]} ${words[$last]}"
-		unset words[$last] spaces[$last]
-		last=$(( $last - 1 ))
-	fi
-
 	# Extract info after the symbol if present. E.g.:
 	# func_name+0x54/0x80 (P)
 	#                     ^^^
@@ -294,6 +288,14 @@ handle_line() {
 		unset words[$last] spaces[$last]
 		last=$(( $last - 1 ))
 	fi
+
+	# Join module name with its build id if present, as these were
+	# split during tokenization (e.g. "[module" and "modbuildid]").
+	if [[ ${words[$last]} =~ ^[0-9a-f]+\] ]]; then
+		words[$last-1]="${words[$last-1]} ${words[$last]}"
+		unset words[$last] spaces[$last]
+		last=$(( $last - 1 ))
+	fi
 
 	if [[ ${words[$last]} =~ \[([^]]+)\] ]]; then
 		module=${words[$last]}
_

Patches currently in -mm which might be from cmllamas@google.com are


