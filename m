Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB36153565
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248847; cv=none; b=HX7qZmu9FacMaGalrInnjB5ta6xk2DDCQ8N1ECXfzbV2CxGh8BkBl/aOv5DlNFBO3ywFSmoIKsI4YNRlCCGMbb6AhHzu8JRJROm4p+IdpgGnRP69mQpdI5Bq74JBi5bfX86Xn2zAY4kh8G3Vg9JuMNraqvsPiWJiEfIP6aNXOtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248847; c=relaxed/simple;
	bh=SntEYMMvkj5excuONsulyCRMAhTaeKBsHMI4/ePsbcs=;
	h=Date:To:From:Subject:Message-Id; b=DXPR+vm5zQZIT1WAEzRL03Ry4JjRJlBq4xCbtPXeG98eovObY6geGCfJxOY80jEnV7Jjght/TIJe7/b9JOyrWlPRHai8IV+sguZS9lkD3A0Ut3mlQyw6EtsTFpF2D1yUJJefovC/TQzop1L1m+BJ66BxrTAq3UsQSR9yWytpL84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mDH5dxns; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mDH5dxns"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF638C4CEC2;
	Mon,  2 Sep 2024 03:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248846;
	bh=SntEYMMvkj5excuONsulyCRMAhTaeKBsHMI4/ePsbcs=;
	h=Date:To:From:Subject:From;
	b=mDH5dxnsYy01bZyPFEryS8xlJ2KO8t03gA2rA7IFGgVWhk5ADypyhrsFlGxCEXnaw
	 JK7qn8b2PExq5JyRhEBK1mL0YZ3gBJ9Ng0ntjaPhPxLeRFE1UuzLAxlsvAlM6yRcYN
	 jYmmUvWs95Cs71UY3xgzAf3umPdE/iBVaMj8bII8=
Date: Sun, 01 Sep 2024 20:47:25 -0700
To: mm-commits@vger.kernel.org,thomas.petazzoni@bootlin.com,swboyd@chromium.org,sashal@kernel.org,koct9i@gmail.com,alexis.lothore@bootlin.com,luca.ceresoli@bootlin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scripts-decode_stacktracesh-add-h-flag.patch removed from -mm tree
Message-Id: <20240902034725.DF638C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scripts/decode_stacktrace.sh: add '-h' flag
has been removed from the -mm tree.  Its filename was
     scripts-decode_stacktracesh-add-h-flag.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Luca Ceresoli <luca.ceresoli@bootlin.com>
Subject: scripts/decode_stacktrace.sh: add '-h' flag
Date: Fri, 23 Aug 2024 10:27:44 +0200

When no parameters are passed, the usage instructions are presented only
when debuginfod-find is not found.  This makes sense because with
debuginfod none of the positional parameters are needed.  However it means
that users having debuginfod-find installed will have no chance of reading
the usage text without opening the file.

Many programs have a '-h' flag to get the usage, so add such a flag. 
Invoking 'scripts/decode_stacktrace.sh -h' will now show the usage text
and exit.

Link: https://lkml.kernel.org/r/20240823-decode_stacktrace-find_module-improvements-v2-3-d7a57d35558b@bootlin.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Cc: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/decode_stacktrace.sh |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/scripts/decode_stacktrace.sh~scripts-decode_stacktracesh-add-h-flag
+++ a/scripts/decode_stacktrace.sh
@@ -7,6 +7,7 @@ usage() {
 	echo "Usage:"
 	echo "	$0 -r <release>"
 	echo "	$0 [<vmlinux> [<base_path>|auto [<modules_path>]]]"
+	echo "	$0 -h"
 }
 
 # Try to find a Rust demangler
@@ -33,7 +34,10 @@ READELF=${UTIL_PREFIX}readelf${UTIL_SUFF
 ADDR2LINE=${UTIL_PREFIX}addr2line${UTIL_SUFFIX}
 NM=${UTIL_PREFIX}nm${UTIL_SUFFIX}
 
-if [[ $1 == "-r" ]] ; then
+if [[ $1 == "-h" ]] ; then
+	usage
+	exit 0
+elif [[ $1 == "-r" ]] ; then
 	vmlinux=""
 	basepath="auto"
 	modpath=""
_

Patches currently in -mm which might be from luca.ceresoli@bootlin.com are


