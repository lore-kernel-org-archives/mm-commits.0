Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F303546FC
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338696; cv=none; b=mwODAgFSTEXgsxEDqbuzS7U2702/DAyBc6/QuKjOWKzrCE42/hXk0pDkRQSA3jEh9WQ2mF4/8QYKzlTeduCtB2evFnG/J4Q0KO/Lk+G4tUfKQj2aATTA+dThQ7eeXVtjrjznZfWKsFx8o/2obPwi+ZS1qYThIC3QLJAew0k64ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338696; c=relaxed/simple;
	bh=ZNBrgvssguhH4ur7MVp2V+yuXMeoL5xsjIH9+S2eMxA=;
	h=Date:To:From:Subject:Message-Id; b=jWFCfakAqviB17qnqKbUmS0nm3lL2O5vW+MOXdhnRsYAzDNPCp4x32mHjb3g/7+62mT6fnpJ1P/ALokaQlc1Z4pEOOA9Ww0WvLmNWG8OOGijNXbAIevn4r5fwP38IY8Rsu2SELG7ehEjM9EZncPqLoX8TICg8r09hGRrN7eZyTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kg8+EJzV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kg8+EJzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5BD1F0089C;
	Wed,  7 Oct 2026 02:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338695;
	bh=43V0c9cYkAFLdeVIfm5mXn/Q/FPTD+niXUmCm2t19/8=;
	h=Date:To:From:Subject;
	b=kg8+EJzV1+4tWVcENoLsGeU0DRntp16/EOa5bmniiZj8q4ZnxArAW5jX/7a1sqI5T
	 K5Hk1oYyO73eK3FOcgrcUHxJvvs8FSOSMQfdeZ1hiH4UDcUesuREFqWJI15DUEobe7
	 ifoIh+KtPdGyNIKGW1wAv2OgAJpSuUeE55+eOf8U=
Date: Tue, 06 Oct 2026 19:04:54 -0700
To: mm-commits@vger.kernel.org,lukas.bulwahn@gmail.com,joe@perches.com,dwaipayanray1@gmail.com,apw@canonical.com,pvorel@suse.cz,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] checkpatch-add-more-userspace-directories-to-is_userspace.patch removed from -mm tree
Message-Id: <20261007020455.0C5BD1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: checkpatch: add more userspace directories to is_userspace()
has been removed from the -mm tree.  Its filename was
     checkpatch-add-more-userspace-directories-to-is_userspace.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Petr Vorel <pvorel@suse.cz>
Subject: checkpatch: add more userspace directories to is_userspace()
Date: Fri, 4 Sep 2026 13:02:27 +0200

Patch series "checkpatch: userspace improvements", v6.

Few improvements for user space code + --userspace option for projects
which vendored checkpatch.pl.

There could be probably more checks which are kernel space only.


This patch (of 4):

arch/ directory contains subdirectories with userspace tools (at least
arch/*/tools/ and arch/*/boot/tools/).  Add check to consider any
arch/.*/tools/ subdirectory as userspace tools directory.

This helps not only to strscpy() checks but also to CamelCase checks in
the next commit to be more precise.

This is a follow-up to 99b70ece33d8 ("checkpatch: suppress strscpy
warnings for userspace tools").

Link: https://lore.kernel.org/20260904110230.1219037-1-pvorel@suse.cz
Link: https://lore.kernel.org/20260904110230.1219037-2-pvorel@suse.cz
Signed-off-by: Petr Vorel <pvorel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-more-userspace-directories-to-is_userspace
+++ a/scripts/checkpatch.pl
@@ -2667,7 +2667,9 @@ sub exclude_global_initialisers {
 
 sub is_userspace {
     my ($realfile) = @_;
-    return ($realfile =~ m@^tools/@ || $realfile =~ m@^scripts/@);
+    return ($realfile =~ m@^tools/@ ||
+		$realfile =~ m@^scripts/@ ||
+		$realfile =~ m@^arch/.*/tools/@);
 }
 
 sub process {
_

Patches currently in -mm which might be from pvorel@suse.cz are


