Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD6E8634E
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189094; cv=none; b=hvGD5uSR/vN8+2hpdcWAUDFY3k08qDByQkEReR7S2iHTHnci/vG/bckdbLAfmhrTsHpeXHq0nSPB5XmOtCo6PmCHvg/M5g82k8hzzalBRAK25pg9/sV4gecL3qlJuDDPfXIxkl2/+6aLn6CwA1OmI23mF8HQx9LJsyQe7yAoqvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189094; c=relaxed/simple;
	bh=wCFQFGyv7sO01NKAQ0rLGbFxjL9B2wPA0EkAKxVOXG8=;
	h=Date:To:From:Subject:Message-Id; b=Q0SA8PveAX9AGH+cLuelcAjYwEu4y3XXHicY+G4ncgVpYP5IlPSrI+HUlzVr/ff9PdsXpJb/K5ZbC65TOWjP44CPnGTEq8/WpcJyE2o73kC8QbrqE7LusYoQIgTwqL6HqEX/FroRZqt/oHHxomeet9eWHDRTnzraMceDyc2gwVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OCZ25g6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OCZ25g6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D0DC4CEEC;
	Mon, 17 Mar 2025 05:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189094;
	bh=wCFQFGyv7sO01NKAQ0rLGbFxjL9B2wPA0EkAKxVOXG8=;
	h=Date:To:From:Subject:From;
	b=OCZ25g6CzKNEJqLi5pvb2so/ewxuxIyd7VfHEjWkHoR4jv/Ri9+PbFrcmmB3WhRUX
	 EsyNiYDO85p59TVaj0qszuZ9K/nOgFDGUQRZIgY+w1WA+AnjBUJC32NJvi8zh7Kmuh
	 B33Zcfdo/oO2Fq9ZsYPB61yF41BZlraU80DZwM8w=
Date: Sun, 16 Mar 2025 22:24:53 -0700
To: mm-commits@vger.kernel.org,tytso@mit.edu,lorenzo.stoakes@oracle.com,linux@leemhuis.info,kees@kernel.org,joe@perches.com,bryan.odonoghue@linaro.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] get_maintainer-add-substatus-for-reporting-subsystem-status-fix.patch removed from -mm tree
Message-Id: <20250317052454.31D0DC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: get_maintainer: add --substatus for reporting subsystem status - fix
has been removed from the -mm tree.  Its filename was
     get_maintainer-add-substatus-for-reporting-subsystem-status-fix.patch

This patch was dropped because it was folded into get_maintainer-add-substatus-for-reporting-subsystem-status.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: get_maintainer: add --substatus for reporting subsystem status - fix
Date: Tue, 11 Feb 2025 16:16:11 +0100

The automatically enabled --substatus can break existing scripts that do
not disable --rolestats.  Require that script output goes to a terminal to
enable it automatically.

Link: https://lkml.kernel.org/r/66c2bf7a-9119-4850-b6b8-ac8f426966e1@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Thorsten Leemhuis <linux@leemhuis.info>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/scripts/get_maintainer.pl~get_maintainer-add-substatus-for-reporting-subsystem-status-fix
+++ a/scripts/get_maintainer.pl
@@ -317,7 +317,7 @@ $output_rolestats = 1 if ($interactive);
 $output_roles = 1 if ($output_rolestats);
 
 if (!defined $output_substatus) {
-    $output_substatus = $email && $output_roles;
+    $output_substatus = $email && $output_roles && -t STDOUT;
 }
 
 if ($sections || $letters ne "") {
@@ -1086,7 +1086,7 @@ MAINTAINER field selection options:
     --remove-duplicates => minimize duplicate email names/addresses
     --roles => show roles (status:subsystem, git-signer, list, etc...)
     --rolestats => show roles and statistics (commits/total_commits, %)
-    --substatus => show subsystem status if not Maintained (default: match --roles)"
+    --substatus => show subsystem status if not Maintained (default: match --roles when output is tty)"
     --file-emails => add email addresses found in -f file (default: 0 (off))
     --fixes => for patches, add signatures of commits with 'Fixes: <commit>' (default: 1 (on))
   --scm => print SCM tree(s) if any
_

Patches currently in -mm which might be from vbabka@suse.cz are

get_maintainer-add-substatus-for-reporting-subsystem-status.patch
get_maintainer-stop-reporting-subsystem-status-as-maintainer-role.patch

