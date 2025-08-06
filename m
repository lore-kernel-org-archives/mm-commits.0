Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B2A23CE
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 02:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754448416; cv=none; b=fDVbjrOUV3P44H0ZmatW5FVzsfriEb2ai84EWNuEd+WpeewOt796V+pLTqwsfp3jdTPzqXY6M4GXCo88AmNmRJUhdffC+9prUEPlqRy8BntZL66FcTIkUhzoxWhdwJ7m2lLX+5yS7LzAB7jBYM4JHIdfUwS18lYs+EMnsPCbeu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754448416; c=relaxed/simple;
	bh=+NGPnx+6tHZau6tEpPs9IPRQNV6L9bovPjsS1c+Rjk8=;
	h=Date:To:From:Subject:Message-Id; b=h+5OI9E5VIoE4aZbDVOQXO2agPkUR/IiCSMfHvySAEH5egAEgeHDXSu7UvVGihYDS/ODCX3xktxixg3XJqRzZ6vsQLySBNE/ZZRHvJPBt6IXMYOczojaCqW2QuxvrYSnLNCFbi1JRSIPqutfSNbbgm50HigjLvIVZlXjDa2OKsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jUhYseh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jUhYseh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51EAC4CEF0;
	Wed,  6 Aug 2025 02:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754448415;
	bh=+NGPnx+6tHZau6tEpPs9IPRQNV6L9bovPjsS1c+Rjk8=;
	h=Date:To:From:Subject:From;
	b=jUhYseh2u3eOz3hYy9A9eRzQt2TKe86/QpQE0Yl31Rgy9dCOi+aS4TP1Oh8I8hmbT
	 xPWdostDf6Em/c5eXcELFfuDrBm5hrPjVmnXs3Lb+Wk9k9TOuGrXYQvFwWRAcQRFby
	 lYfsEodIEI023AOpxv22e+zZDWnbzWfJUjfnDDDE=
Date: Tue, 05 Aug 2025 19:46:55 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,david.hunter.linux@gmail.com,hsukrut3@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-proc-fix-string-literal-warning-in-proc-maps-racec.patch added to mm-hotfixes-unstable branch
Message-Id: <20250806024655.B51EAC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/proc: fix string literal warning in proc-maps-race.c
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     selftests-proc-fix-string-literal-warning-in-proc-maps-racec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-proc-fix-string-literal-warning-in-proc-maps-racec.patch

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
From: Sukrut Heroorkar <hsukrut3@gmail.com>
Subject: selftests/proc: fix string literal warning in proc-maps-race.c
Date: Tue, 5 Aug 2025 00:56:14 +0200

This change resolves non literal string format warning invoked for
proc-maps-race.c while compiling.

proc-maps-race.c:205:17: warning: format not a string literal and no format arguments [-Wformat-security]
 205 |                 printf(text);
     |                 ^~~~~~
proc-maps-race.c:209:17: warning: format not a string literal and no format arguments [-Wformat-security]
 209 |                 printf(text);
     |                 ^~~~~~
proc-maps-race.c: In function `print_last_lines':
proc-maps-race.c:224:9: warning: format not a string literal and no format arguments [-Wformat-security]
 224 |         printf(start);
     |         ^~~~~~

Add string format specifier %s for the printf calls in both
print_first_lines() and print_last_lines() thus resolving the warnings.

The test executes fine after this change thus causing no effect to the
functional behavior of the test.

Link: https://lkml.kernel.org/r/20250804225633.841777-1-hsukrut3@gmail.com
Fixes: aadc099c480f ("selftests/proc: add verbose mode for /proc/pid/maps tearing tests")
Signed-off-by: Sukrut Heroorkar <hsukrut3@gmail.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Cc: David Hunter <david.hunter.linux@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/proc/proc-maps-race.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/proc/proc-maps-race.c~selftests-proc-fix-string-literal-warning-in-proc-maps-racec
+++ a/tools/testing/selftests/proc/proc-maps-race.c
@@ -202,11 +202,11 @@ static void print_first_lines(char *text
 		int offs = end - text;
 
 		text[offs] = '\0';
-		printf(text);
+		printf("%s", text);
 		text[offs] = '\n';
 		printf("\n");
 	} else {
-		printf(text);
+		printf("%s", text);
 	}
 }
 
@@ -221,7 +221,7 @@ static void print_last_lines(char *text,
 		nr--;
 		start--;
 	}
-	printf(start);
+	printf("%s", start);
 }
 
 static void print_boundaries(const char *title, FIXTURE_DATA(proc_maps_race) *self)
_

Patches currently in -mm which might be from hsukrut3@gmail.com are

selftests-proc-fix-string-literal-warning-in-proc-maps-racec.patch

