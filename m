Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29C8140E30
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189503; cv=none; b=P9ecj/Gnf0Fe7vA8M9QsIS8xJdR9hnYIOf4ScRTfpRoa4WictDY9KS5B1y/85ko4a7QJuhzFor33a9PkJL8xZvLMXoSf3ycuCbzwZfCs0iAo/u8mXz5bsAb7iUkOeDydaIt+uH8NhkDWPLMcGb4fjbvC95/2m2Amn7QtMhyySFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189503; c=relaxed/simple;
	bh=6RnwL+6ABYg0MQusQcJRAZcorxRa5kzQDoRfxd2L+Ts=;
	h=Date:To:From:Subject:Message-Id; b=E80ivLvrTnNLHXpZBeLIUscTYOlqIN6w2LnvGKqtRJTe5lnQFGOZcH5Rp6t5UOqgedZOH5HLPYIJ5mqpE46fPABT1T/KLCoei6nXjo/fh1ap5hJCVbEG4HIlL6WViNhpPRGBkTVxXnD0JXHVAe3PwvHQ6dJxGojCp4PVt0E98iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SavFgXxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SavFgXxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3C8C4CEEC;
	Mon, 17 Mar 2025 05:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189503;
	bh=6RnwL+6ABYg0MQusQcJRAZcorxRa5kzQDoRfxd2L+Ts=;
	h=Date:To:From:Subject:From;
	b=SavFgXxiJB2EP0PFbxQb17weUVznEMsnfcXNPSbTqLo2wQUIAZ5PjIpSjdrBJ3loW
	 7AFPL6zJj5s7KqytnN8AdIClXv7ODrrCs7wrGTojuieIHahTI2sovaFBDjA6nxJzps
	 oA+aZPtXdJCu4x5n+LkJeIh+WngAiaJ09/bJUN9c=
Date: Sun, 16 Mar 2025 22:31:42 -0700
To: mm-commits@vger.kernel.org,tytso@mit.edu,lorenzo.stoakes@oracle.com,linux@leemhuis.info,kees@kernel.org,joe@perches.com,bryan.odonoghue@linaro.org,vbabka@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] get_maintainer-stop-reporting-subsystem-status-as-maintainer-role.patch removed from -mm tree
Message-Id: <20250317053143.0F3C8C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: get_maintainer: stop reporting subsystem status as maintainer role
has been removed from the -mm tree.  Its filename was
     get_maintainer-stop-reporting-subsystem-status-as-maintainer-role.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
     --substatus => show subsystem status if not Maintained (default: match --roles when output is tty)"
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


