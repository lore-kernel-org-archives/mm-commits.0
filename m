Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3607E20E316
	for <mm-commits@vger.kernel.org>; Wed,  5 Feb 2025 03:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738725029; cv=none; b=Uo6OQDXkjIsbSC2rKPyV9YnYSeKiLCAJQUMNxePJgYOR04r2KjEssdYX8zLJwoC4HgLofQyOyaFBtQKkpaFWVznfgIThFlTbpAmcKyXHTJnEuVw3TdztOUMvMOdSzOBRg7+MZRBliyBVG4OPKnhMkxuwDBLTRvUaNvS8sxFo+CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738725029; c=relaxed/simple;
	bh=prUb+JboBbFFwFxg7cAX4NhSUzLGyUfNNOSXUqZDoNs=;
	h=Date:To:From:Subject:Message-Id; b=aZfRqBroyUsL8yHL001m05BAdYACuDR5JuM4w4Ti6AMdWy8fdRgSpxbp//YRWJq/WX3D6UdP/tTOGceRkYWie0HJhuL09KI5IuPkx6faPdhdiAN2Nculxi8Z35nUYePHoz+Y+3ldygyzRiamo/jm9PXvwjSkKmpBugSHInnLmUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K2e2aK+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K2e2aK+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86569C4CEDF;
	Wed,  5 Feb 2025 03:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738725028;
	bh=prUb+JboBbFFwFxg7cAX4NhSUzLGyUfNNOSXUqZDoNs=;
	h=Date:To:From:Subject:From;
	b=K2e2aK+SYJwxvs6I6RwvId4eZk6RVHqBazoyVtZzc8iCUn+8gG8G+J9MJRRkc5efw
	 NBNK14s5Abbow9jLEH6QG7LhWbvVea3+FxW8ZMbdAztPVsV3uLezNCg9ovVZXBFnZ/
	 uiT8gKRF5yiLyFL88J/ox62ETvWQUpGaHJ3EafZ0=
Date: Tue, 04 Feb 2025 19:10:27 -0800
To: mm-commits@vger.kernel.org,tytso@mit.edu,lorenzo.stoakes@oracle.com,linux@leemhuis.info,kees@kernel.org,joe@perches.com,bryan.odonoghue@linaro.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + get_maintainer-stop-reporting-subsystem-status-as-maintainer-role.patch added to mm-nonmm-unstable branch
Message-Id: <20250205031028.86569C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: get_maintainer: stop reporting subsystem status as maintainer role
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     get_maintainer-stop-reporting-subsystem-status-as-maintainer-role.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/get_maintainer-stop-reporting-subsystem-status-as-maintainer-role.patch

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
From: Vlastimil Babka <vbabka@suse.cz>
Subject: get_maintainer: stop reporting subsystem status as maintainer role
Date: Mon, 03 Feb 2025 12:13:17 +0100

After introducing the --substatus option, we can stop adjusting the
reported maintainer role by the subsystem's status.

For compatibility with the --git-chief-penguins option, keep the "chief
penguin" role.

Link: https://lkml.kernel.org/r/20250203-b4-get_maintainer-v2-2-83ba008b491f@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc: Joe Perches <joe@perches.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Ted Ts'o <tytso@mit.edu>
Cc: Thorsten Leemhuis <linux@leemhuis.info>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/scripts/get_maintainer.pl~get_maintainer-stop-reporting-subsystem-status-as-maintainer-role
+++ a/scripts/get_maintainer.pl
@@ -1084,7 +1084,7 @@ MAINTAINER field selection options:
     --moderated => include moderated lists(s) if any (default: true)
     --s => include subscriber only list(s) if any (default: false)
     --remove-duplicates => minimize duplicate email names/addresses
-    --roles => show roles (status:subsystem, git-signer, list, etc...)
+    --roles => show roles (role:subsystem, git-signer, list, etc...)
     --rolestats => show roles and statistics (commits/total_commits, %)
     --substatus => show subsystem status if not Maintained (default: match --roles)"
     --file-emails => add email addresses found in -f file (default: 0 (off))
@@ -1298,8 +1298,9 @@ sub get_maintainer_role {
     my $start = find_starting_index($index);
     my $end = find_ending_index($index);
 
-    my $role = "unknown";
+    my $role = "maintainer";
     my $subsystem = get_subsystem_name($index);
+    my $status = "unknown";
 
     for ($i = $start + 1; $i < $end; $i++) {
 	my $tv = $typevalue[$i];
@@ -1307,23 +1308,13 @@ sub get_maintainer_role {
 	    my $ptype = $1;
 	    my $pvalue = $2;
 	    if ($ptype eq "S") {
-		$role = $pvalue;
+		$status = $pvalue;
 	    }
 	}
     }
 
-    $role = lc($role);
-    if      ($role eq "supported") {
-	$role = "supporter";
-    } elsif ($role eq "maintained") {
-	$role = "maintainer";
-    } elsif ($role eq "odd fixes") {
-	$role = "odd fixer";
-    } elsif ($role eq "orphan") {
-	$role = "orphan minder";
-    } elsif ($role eq "obsolete") {
-	$role = "obsolete minder";
-    } elsif ($role eq "buried alive in reporters") {
+    $status = lc($status);
+    if ($status eq "buried alive in reporters") {
 	$role = "chief penguin";
     }
 
_

Patches currently in -mm which might be from vbabka@suse.cz are

get_maintainer-add-substatus-for-reporting-subsystem-status.patch
get_maintainer-stop-reporting-subsystem-status-as-maintainer-role.patch

