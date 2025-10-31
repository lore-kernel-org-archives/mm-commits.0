Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86DA2874FE;
	Fri, 31 Oct 2025 03:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761883095; cv=none; b=ssbxL1vPZqUVGC1ufmZbSrWkMBmNGmTjmiRf3It3me+zrOR+R0MV1cNhngcabKTL3UCL9CpznfiydbDMckChO2UKi+nrtayPd6QWju2d3kzk5Sw252IOKOo3GXLSr+BQ74ucTe4xCAkacCzgjCaKgkEuICrHRtp+JO+jCynlNe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761883095; c=relaxed/simple;
	bh=5ptLrko7cS9PrR0eDUTQB6Xu5jFMePHdFl0fqx5QAQc=;
	h=Date:To:From:Subject:Message-Id; b=kRr6y7owUvOsjpV40yW3OFnHWbIkv4Wbkd25lFPGaZNaEWD1FxI7qmYSuTighd7YS1EwFW9uGA9v2SsPopWqMWjhPJTWPRSYfESumsRakvh+51Sgeh/mwcDQXjTW2/CtVQc4iEeAGSKjubFJ8ryqB9s1wa5y12t7SjeOqnPx6qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CVw/3pel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CVw/3pel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9034FC4CEE7;
	Fri, 31 Oct 2025 03:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761883093;
	bh=5ptLrko7cS9PrR0eDUTQB6Xu5jFMePHdFl0fqx5QAQc=;
	h=Date:To:From:Subject:From;
	b=CVw/3pelECb4TXCXP5iyr571VIt3LZjmNLQZNslWl4xYLblM3IgiKQZa5DsbAqLad
	 3374xpv57xDteJNdum++PRNW2X7dyLo/dXalXtYeUL3UnAf8djgxY3AqOcsmpkajPd
	 xRiaSUmjVY74/arejy2hi1Mpy2u5YVVhyM8CkxkY=
Date: Thu, 30 Oct 2025 20:58:13 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,puranjay@kernel.org,mbenes@suse.cz,matttbe@kernel.org,mark.rutland@arm.com,luca.ceresoli@bootlin.com,leitao@debian.org,catalin.marinas@arm.com,broonie@kernel.org,cmllamas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + scripts-decode_stacktracesh-fix-build-id-and-pc-source-parsing.patch added to mm-hotfixes-unstable branch
Message-Id: <20251031035813.9034FC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: scripts/decode_stacktrace.sh: fix build ID and PC source parsing
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     scripts-decode_stacktracesh-fix-build-id-and-pc-source-parsing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/scripts-decode_stacktracesh-fix-build-id-and-pc-source-parsing.patch

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
Fixes: bdf8eafbf7f5 ("arm64: stacktrace: report source of unwind data")
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

scripts-decode_stacktracesh-fix-build-id-and-pc-source-parsing.patch

