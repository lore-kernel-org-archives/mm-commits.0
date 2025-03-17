Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87386218AA5
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189574; cv=none; b=otIr51Szt9xeZOt5l1HrlVdokAnN/SyesIc+8LOFiZk+6+gCpBPropc95AkTJlZGoyvqueGHqmCiC+Nnxwr2d6SX6tAAon8MK0D++DiEZnNrnmUQNsmI+5AHcT0FkEjfdk9mBiewk7lOrxUIJRQqMn4xW0zl266xqlQkgV6CIXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189574; c=relaxed/simple;
	bh=Rre8trNa1OOS/8C9zpazJxLkiv8WmcemxuwnxSQ1S10=;
	h=Date:To:From:Subject:Message-Id; b=lzYbpJQ2FHU/4WHgRhpIMHOun1EHgHe8ZJmNAcvXGU/abHRvnzmjyqSsfgELJbIYyGVbEB2uuWM34gj46mnD4PHWA4sBXIqZuD4dsKPYtExhQK8zrmH0tmY861FtnV7HYGTa40UGZmuC0Ndo9JOKgNSEyGpS1DTMuG/tJndd9kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HueCQ6eZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HueCQ6eZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAE4C4CEEC;
	Mon, 17 Mar 2025 05:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189574;
	bh=Rre8trNa1OOS/8C9zpazJxLkiv8WmcemxuwnxSQ1S10=;
	h=Date:To:From:Subject:From;
	b=HueCQ6eZjYC6FLMv2Kw6PdpZVmUcs1Pa0Yv1V2q83+hX0rcI0GMzKU3bswivjV1zK
	 6aXO2BX/X6O0eyN0g4pq2QVhrDqdHAWm6rKqfz6L+EJloI5dR0B/i8AcBRO1HEKTgg
	 ucdzlD936EyomsTQT/qRlwQoyfTfkmImqdk9ruy0=
Date: Sun, 16 Mar 2025 22:32:53 -0700
To: mm-commits@vger.kernel.org,p.hahn@avm.de,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,phahn-oss@avm.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-describe-min-conf-desc-length.patch removed from -mm tree
Message-Id: <20250317053254.5DAE4C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: describe --min-conf-desc-length
has been removed from the -mm tree.  Its filename was
     checkpatch-describe-min-conf-desc-length.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


