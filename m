Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79BAE165EED
	for <mm-commits@vger.kernel.org>; Mon, 11 Nov 2024 08:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313726; cv=none; b=uJndPokt/Etr8KwcpLm8dNimzoiHrToGomugzT1sSJPt9B1lYZLcLjq7TUnd7xGvY0BEaiouMgMvPVk6m7NHqxzg3KdfcL1lSuNsLogP0BkB55TpO8Y4S+uTKO4pNydDzyAHuINgZbSqC1Hkg+xzwRQN62wpEc/mKhYWEtPOolA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313726; c=relaxed/simple;
	bh=4co7rzw6JDrEOnJEkk0iw7CUXhFCLeMkscFNTc1kzHE=;
	h=Date:To:From:Subject:Message-Id; b=lTvEoZZprTqVugkMxwSu1AFo+KX/AA8bzvdalp3BMZda0Q60T6ws1tXT9k2AhXdpWXtr/xCUo58H85I04w7/fGlI7YXfTXITnvZU3oI60jbnn+LyYnoe8C0qo2uOjOmT1/lHgwvp/+HeivXj042vzsBKJNh1u+QraQ1/ZATSudc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FgxL9+m3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FgxL9+m3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473CAC4CED0;
	Mon, 11 Nov 2024 08:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731313726;
	bh=4co7rzw6JDrEOnJEkk0iw7CUXhFCLeMkscFNTc1kzHE=;
	h=Date:To:From:Subject:From;
	b=FgxL9+m3pBzAoYM0erFuQj+dWBTddf/EsdYRa64CSZP+dTNneSDrYTNw9cQkwrrBV
	 1az/p/8peHQ8aA/nQscDI72tyK4tebq6tqNgoB6RIMUIXrIkZBNXPMe9Z67li/VuBl
	 1JfTMytmnZlxuA1gWKvFYWfrWh7YwkgYfILVBdds=
Date: Mon, 11 Nov 2024 00:28:45 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,marc.dionne@auristor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] tools-mm-fix-slabinfo-crash-when-max_slabs-is-exceeded.patch removed from -mm tree
Message-Id: <20241111082846.473CAC4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm: fix slabinfo crash when MAX_SLABS is exceeded
has been removed from the -mm tree.  Its filename was
     tools-mm-fix-slabinfo-crash-when-max_slabs-is-exceeded.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: Vlastimil Babka <vbabka@suse.cz>
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


