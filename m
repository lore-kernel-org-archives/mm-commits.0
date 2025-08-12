Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8092356DA
	for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2025 06:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754978484; cv=none; b=LRyvoqM2Jr3Fv6cLLjgW+yKXBc9/lEpzy4WRan9NJrAFtPsz2qmuwG9vzik/FCorKT3bQIhOtniFEdzZardKXQrLCwVC9IZdq7RtLk7N/STfoyWA/Ok4dHN2DA+tQ8Q3IRvkfFrZiQFn94mydX0DHSe2adT7OR49vzLYnCT+iJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754978484; c=relaxed/simple;
	bh=d6du8wmE5JoCA8ixFerTe74eQUiIYskS3sGokOV+iHI=;
	h=Date:To:From:Subject:Message-Id; b=NZfYdSDAdn1v8FrsJJ+MpBrD+fwJ0XmVO9YGDQvSM/xGlHB7uTjG0aWlRL2XgFBUWDBOnxGXq5HzvdT+CSY9ose0IBajIdGts5EgixTDgaYLGEgUp5frugSvAyGXtTcYV/NtaAuAkindXupH3erSD8dAKSKN7hyWWiQXZYnJTsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UC/UB9Gt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UC/UB9Gt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2AAC4CEF0;
	Tue, 12 Aug 2025 06:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754978483;
	bh=d6du8wmE5JoCA8ixFerTe74eQUiIYskS3sGokOV+iHI=;
	h=Date:To:From:Subject:From;
	b=UC/UB9Gt4BVKTviKTk1FDzpMtFTc3WmYncq2JcW2W9uiwqOq42wWI9RutQpTnWdBz
	 /yRhPfi5FOvfosMejjLL+kwnTjFsbo2qju8slBUJynD2D633+frXHD/VUuMfCNg6Qu
	 uzKN+YYGjrNV+uEZhirdLD0NqZS7sYgRSxdZ903g=
Date: Mon, 11 Aug 2025 23:01:22 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,david.hunter.linux@gmail.com,hsukrut3@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-proc-fix-string-literal-warning-in-proc-maps-racec.patch removed from -mm tree
Message-Id: <20250812060123.5D2AAC4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/proc: fix string literal warning in proc-maps-race.c
has been removed from the -mm tree.  Its filename was
     selftests-proc-fix-string-literal-warning-in-proc-maps-racec.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


