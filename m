Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDF23145336
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 05:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719293218; cv=none; b=ZbcDJO3jDjpmtIfCcKPq7+DqGd4uz/OWwq/eF9QFVfixa7nc+pNjVOaarBy9WBTL6vEfffxAmNfnUOixkoKEXzUZNMLDG/FX74n/U6WScAzLL2SXLSIUqeLVMTIjrmB4q/4GiA0jvJKXblBKbuD6drt95Ah4CwP3xpi48YJQuVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719293218; c=relaxed/simple;
	bh=ldIgCdGN0iPZprG7IAHlG5M0fDQ5QiarAiMGLOt+7BE=;
	h=Date:To:From:Subject:Message-Id; b=GPelK3c4bSytjGG0FG6epxsICljuVTyoiQdZmujlhyUpNc9S3qvK484uvPnrQTKX8stx57F3BGE6TzDaTw30T3OC1OWHfhzWZaqEmAYrwLFyi8Df0wenLWyCZfYQ0vye7dqMSvooCtMpCKOMLFx7tKnpkQ0qQfBHL6HnGC5XFCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RD9o7hxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RD9o7hxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FAAC32782;
	Tue, 25 Jun 2024 05:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719293218;
	bh=ldIgCdGN0iPZprG7IAHlG5M0fDQ5QiarAiMGLOt+7BE=;
	h=Date:To:From:Subject:From;
	b=RD9o7hxPf7qnAVrT3kkGZKZ28KW/MVspQ4PbItQ6nXYfgqMQ4LFk6JaJazUshqmHX
	 yKQwWXFgGhLd5YJ9iT+dUnH8Gs/zWpa99jB919pj28KRvyH+4cHNL+QaRxGcqmLEZh
	 H2jgbMERlxe++SyhkLDOKxTjFuel/6X7Pb/qP60U=
Date: Mon, 24 Jun 2024 22:26:58 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,wsa+renesas@sang-engineering.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-really-skip-long_line_-when-long_line-is-ignored.patch removed from -mm tree
Message-Id: <20240625052658.B3FAAC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: really skip LONG_LINE_* when LONG_LINE is ignored
has been removed from the -mm tree.  Its filename was
     checkpatch-really-skip-long_line_-when-long_line-is-ignored.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
Subject: checkpatch: really skip LONG_LINE_* when LONG_LINE is ignored
Date: Mon, 10 Jun 2024 17:02:09 +0200

For a printout to happen, all types must be set to "show".  So, AND is
needed for the flags, not OR, if we want to ignore something.

Link: https://lkml.kernel.org/r/20240610150420.2279-2-wsa+renesas@sang-engineering.com
Fixes: 47e0c88b37a5 ("checkpatch: categorize some long line length checks")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-really-skip-long_line_-when-long_line-is-ignored
+++ a/scripts/checkpatch.pl
@@ -3858,7 +3858,7 @@ sub process {
 			}
 
 			if ($msg_type ne "" &&
-			    (show_type("LONG_LINE") || show_type($msg_type))) {
+			    show_type("LONG_LINE") && show_type($msg_type)) {
 				my $msg_level = \&WARN;
 				$msg_level = \&CHK if ($file);
 				&{$msg_level}($msg_type,
_

Patches currently in -mm which might be from wsa+renesas@sang-engineering.com are


