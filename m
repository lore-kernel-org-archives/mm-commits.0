Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAF37493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IagEkMNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFE4C433CA;
	Mon, 11 Dec 2023 01:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257782;
	bh=3CorcGpjPjsFTSv8MyeuwN9UNshpUmGBXRPp6ODwiP8=;
	h=Date:To:From:Subject:From;
	b=IagEkMNr03OV/+MkgoZRJvIrz9/VUUJSjmwCzxMa2HVmEk/MiSC0ftzjeeJk4qhLk
	 f/YQLM9050aoxOFI5bXMVJbGxDb6VwioX/wAKByKwBP8gFNhohV0jAPe3p7SbCgUdo
	 SMvNSsvLXlvKzWglYl9kW5ZvVJMR/wyZLgpzKtCM=
Date: Sun, 10 Dec 2023 17:23:01 -0800
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-do-not-require-an-empty-line-before-error-injection.patch removed from -mm tree
Message-Id: <20231211012301.DFFE4C433CA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: do not require an empty line before error injection
has been removed from the -mm tree.  Its filename was
     checkpatch-do-not-require-an-empty-line-before-error-injection.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: checkpatch: do not require an empty line before error injection
Date: Thu, 9 Nov 2023 16:51:38 +0900

ALLOW_ERROR_INJECTION macro (just like EXPORT_SYMBOL) can immediately
follow a function it annotates.

Link: https://lkml.kernel.org/r/20231109075147.2779461-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com> (maintainer:CHECKPATCH)
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com> (reviewer:CHECKPATCH)
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-do-not-require-an-empty-line-before-error-injection
+++ a/scripts/checkpatch.pl
@@ -4054,7 +4054,7 @@ sub process {
 		if ($prevline =~ /^[\+ ]};?\s*$/ &&
 		    $line =~ /^\+/ &&
 		    !($line =~ /^\+\s*$/ ||
-		      $line =~ /^\+\s*(?:EXPORT_SYMBOL|early_param)/ ||
+		      $line =~ /^\+\s*(?:EXPORT_SYMBOL|early_param|ALLOW_ERROR_INJECTION)/ ||
 		      $line =~ /^\+\s*MODULE_/i ||
 		      $line =~ /^\+\s*\#\s*(?:end|elif|else)/ ||
 		      $line =~ /^\+[a-z_]*init/ ||
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


