Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5D91E8339
	for <mm-commits@vger.kernel.org>; Mon, 10 Mar 2025 22:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741645581; cv=none; b=LwPDD7PCAhurX1GZFAuLoGPhUpF6APxmkSTY5UJgV+Do2Cw/kbMdUzV38Q8/OS2BUptzKrYYsAjEBOOkWDFEY40SkaIhBejvo2Rk/yNQSgRc8KGBb2KABa3E4AB23oMVLrcP4qOQtTN20sgjaVozgDOzbRH30d4xFUrkm39kmzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741645581; c=relaxed/simple;
	bh=JIV42gawoY8w4E416Bsc0tD4DxWlfOn/dgQ2ecy43Sk=;
	h=Date:To:From:Subject:Message-Id; b=r0iepIcHwVQZGK+AQZU4ZMwMzOSzxZncnp+mJRv0LZQo3v7WRf76I9uZHDev9CJK4a5ZElG30z/68RknodkL5EjtVDJxZtvfDkeeUHvsu/LHI7ISiaCwuI5B7/p+Vh08ZI0bIFsGPHRuij3iwFy/U8MC/Wj632rgIIl+vpBEaro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uFHASJvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uFHASJvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7722C4CEE5;
	Mon, 10 Mar 2025 22:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741645580;
	bh=JIV42gawoY8w4E416Bsc0tD4DxWlfOn/dgQ2ecy43Sk=;
	h=Date:To:From:Subject:From;
	b=uFHASJvXjCav2zTpISbyExT0gZDUJ8TxAP6qH1qCJ2cHpnaZhGpTHtil0IrbE363B
	 Duv5mJ0JJGO63G3V8lGAevhV+YFMHGP3bA7RgR4Q1gjk85AY4ukwZsi+ccY0TR/xkZ
	 4jdekSLe9P7EKrlpSZlYDslpmKVua4iQ+Jst9nRM=
Date: Mon, 10 Mar 2025 15:26:20 -0700
To: mm-commits@vger.kernel.org,p.hahn@avm.de,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,phahn-oss@avm.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + checkpatch-describe-min-conf-desc-length.patch added to mm-nonmm-unstable branch
Message-Id: <20250310222620.A7722C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: checkpatch: describe --min-conf-desc-length
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     checkpatch-describe-min-conf-desc-length.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/checkpatch-describe-min-conf-desc-length.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Philipp Hahn <phahn-oss@avm.de>
Subject: checkpatch: describe --min-conf-desc-length
Date: Mon, 10 Mar 2025 12:22:27 +0100

Neither the warning nor the help message gives any hint on the unit for
length: Could be meters, inches, bytes, characters or ...  lines.

Extend the output of `--help` to name the unit "lines" and the default:
-  --min-conf-desc-length=n   set the min description length, if shorter, warn
+  --min-conf-desc-length=n   set the minimum description length for config symbols
+                             in lines, if shorter, warn (default 4)

Include the minimum number of lines as other error messages already do:
- WARNING: please write a help paragraph that fully describes the config symbol
+ WARNING: please write a help paragraph that fully describes the config symbol with at least 4 lines

Link: https://lkml.kernel.org/r/c71c170c90eba26265951e248adfedd3245fe575.1741605695.git.p.hahn@avm.de
Signed-off-by: Philipp Hahn <p.hahn@avm.de>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-describe-min-conf-desc-length
+++ a/scripts/checkpatch.pl
@@ -115,7 +115,8 @@ Options:
   --max-line-length=n        set the maximum line length, (default $max_line_length)
                              if exceeded, warn on patches
                              requires --strict for use with --file
-  --min-conf-desc-length=n   set the min description length, if shorter, warn
+  --min-conf-desc-length=n   set the minimum description length for config symbols
+                             in lines, if shorter, warn (default $min_conf_desc_length)
   --tab-size=n               set the number of spaces for tab (default $tabsize)
   --root=PATH                PATH to the kernel tree root
   --no-summary               suppress the per-file summary
@@ -3647,7 +3648,7 @@ sub process {
 			    $help_length < $min_conf_desc_length) {
 				my $stat_real = get_stat_real($linenr, $ln - 1);
 				WARN("CONFIG_DESCRIPTION",
-				     "please write a help paragraph that fully describes the config symbol\n" . "$here\n$stat_real\n");
+				     "please write a help paragraph that fully describes the config symbol with at least $min_conf_desc_length lines\n" . "$here\n$stat_real\n");
 			}
 		}
 
_

Patches currently in -mm which might be from phahn-oss@avm.de are

checkpatch-describe-min-conf-desc-length.patch

