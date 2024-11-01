Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F98537B
	for <mm-commits@vger.kernel.org>; Fri,  1 Nov 2024 01:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730423620; cv=none; b=geot/ZdY9GGi8LHI0NmGwG96SRFTUwxe9zYtFXX49M//2/A1f9F2Yc0n7ao/ohgKyt8Cs9TcEnNLqZbTE+Fog0w2sO+Q9oAM/2SVsmo0+/fzxLuzn602TCtG09wUKY2AezeHbNlxKzJoAfW8edh/mB00SvvuRcyypbAyoAhhgC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730423620; c=relaxed/simple;
	bh=cF1FPefCipOdstP16AJVailpPA5CNfNKQPoJR2y8qos=;
	h=Date:To:From:Subject:Message-Id; b=toHb7AAfBClvdATcBPHylHZOAP8hDuzZzQZHCmWxPOf7rnVmD7ReZkogzNe8PXiwBh3YTrn3nMo0r0tXHbdJZkxO+aVrkVvJGgBwpzWgXmtVSeNNOowCIjH3TtaMW9ZzB21qsETOte2bAMFzD3UyeB1OfQ+kMFZrsSBhxK7yjd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a6qcaLKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a6qcaLKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E218C4CEC3;
	Fri,  1 Nov 2024 01:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730423620;
	bh=cF1FPefCipOdstP16AJVailpPA5CNfNKQPoJR2y8qos=;
	h=Date:To:From:Subject:From;
	b=a6qcaLKuV7+7egWUfumSl086VVoKe/FPJKsYvBwG+PQWqfITWM+O6gxKKqbd4aKDo
	 hMuVV+ezImzgfGzTV3cfMCcJUultlDvXw3d/j/Gs+q7RrdHaFvTTa/WTAuuwhirgMb
	 8vgb63nycjMYzl00wXlL3ZIByWuPx7bJwpSCh/rw=
Date: Thu, 31 Oct 2024 18:13:39 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,marc.dionne@auristor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-mm-fix-slabinfo-crash-when-max_slabs-is-exceeded.patch added to mm-unstable branch
Message-Id: <20241101011340.3E218C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/mm: fix slabinfo crash when MAX_SLABS is exceeded
has been added to the -mm mm-unstable branch.  Its filename is
     tools-mm-fix-slabinfo-crash-when-max_slabs-is-exceeded.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-mm-fix-slabinfo-crash-when-max_slabs-is-exceeded.patch

This patch will later appear in the mm-unstable branch at
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
From: Marc Dionne <marc.dionne@auristor.com>
Subject: tools/mm: fix slabinfo crash when MAX_SLABS is exceeded
Date: Thu, 31 Oct 2024 07:55:34 -0300

The number of slabs can easily exceed the hard coded MAX_SLABS in the
slabinfo tool, causing it to overwrite memory and crash.

Increase the value of MAX_SLABS, and check if that has been exceeded for
each new slab, instead of at the end when it's already too late.  Also
move the check for MAX_ALIASES into the loop body.

Link: https://lkml.kernel.org/r/20241031105534.565533-1-marc.c.dionne@gmail.com
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/slabinfo.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/tools/mm/slabinfo.c~tools-mm-fix-slabinfo-crash-when-max_slabs-is-exceeded
+++ a/tools/mm/slabinfo.c
@@ -21,7 +21,7 @@
 #include <regex.h>
 #include <errno.h>
 
-#define MAX_SLABS 500
+#define MAX_SLABS 2000
 #define MAX_ALIASES 500
 #define MAX_NODES 1024
 
@@ -1228,6 +1228,8 @@ static void read_slab_dir(void)
 				continue;
 		switch (de->d_type) {
 		   case DT_LNK:
+			if (alias - aliasinfo == MAX_ALIASES)
+				fatal("Too many aliases\n");
 			alias->name = strdup(de->d_name);
 			count = readlink(de->d_name, buffer, sizeof(buffer)-1);
 
@@ -1242,6 +1244,8 @@ static void read_slab_dir(void)
 			alias++;
 			break;
 		   case DT_DIR:
+			if (slab - slabinfo == MAX_SLABS)
+				fatal("Too many slabs\n");
 			if (chdir(de->d_name))
 				fatal("Unable to access slab %s\n", slab->name);
 			slab->name = strdup(de->d_name);
@@ -1312,10 +1316,6 @@ static void read_slab_dir(void)
 	slabs = slab - slabinfo;
 	actual_slabs = slabs;
 	aliases = alias - aliasinfo;
-	if (slabs > MAX_SLABS)
-		fatal("Too many slabs\n");
-	if (aliases > MAX_ALIASES)
-		fatal("Too many aliases\n");
 }
 
 static void output_slabs(void)
_

Patches currently in -mm which might be from marc.dionne@auristor.com are

tools-mm-fix-slabinfo-crash-when-max_slabs-is-exceeded.patch

