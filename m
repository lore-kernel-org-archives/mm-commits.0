Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0E8B674
	for <mm-commits@vger.kernel.org>; Thu,  1 May 2025 20:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746131808; cv=none; b=YEDkhFLkFmyUlQrpN06A6EVwz3odOvqXg8IMs2RZQCdeIvRPVIO9Vm0KaakNUX2yaYK0AirAh5k4n5RTyM674phymwNAhVj4F5p00gUISTFTOVWi7x6cdmd7Oiyad+4d/pgw1bsS5BrIDzn8dzYnK4SlUHtLuU4El3WUEBw0myI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746131808; c=relaxed/simple;
	bh=Jbn1EOcf5tRvzUnC+P2G1CxrE2dR8gzNJ0GgONTQaSc=;
	h=Date:To:From:Subject:Message-Id; b=F+gShu3n/zV9Xz7W/m0L0UNrfO+aAN6Q17hvt4u+Zb8dF3mav0Mam9zJlEo7eOU7jLkP7bKZ/VM+V7QDnK4ZPzipzHpALQeR2srsdwKcxQEEIw7wksUTZxg/Fadyycrf9OWlQJijdhsCxnGZvFL9G4QMfnRWxedIUG14iqajyK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fYNXg8bN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fYNXg8bN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93A2C4CEE3;
	Thu,  1 May 2025 20:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746131807;
	bh=Jbn1EOcf5tRvzUnC+P2G1CxrE2dR8gzNJ0GgONTQaSc=;
	h=Date:To:From:Subject:From;
	b=fYNXg8bNIwtYum2VUONmFm78zY1KSphtT6RtsQzgkqi1qxJ0cM7rYD1ovufZOQTMb
	 UEwgvls53G3FdDNSzyIyz3TjijFG21YkEQ2Hcjut8aismjc0cBITjVfOWdLbwWfDud
	 I+XXdmkZIPItw9Wl429MJVvLO7bQ3JBR957XJYbk=
Date: Thu, 01 May 2025 13:36:47 -0700
To: mm-commits@vger.kernel.org,linux@treblig.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-oid_registryc-remove-unused-sprint_oid.patch added to mm-nonmm-unstable branch
Message-Id: <20250501203647.A93A2C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/oid_registry.c: remove unused sprint_OID
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-oid_registryc-remove-unused-sprint_oid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-oid_registryc-remove-unused-sprint_oid.patch

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
From: "Dr. David Alan Gilbert" <linux@treblig.org>
Subject: lib/oid_registry.c: remove unused sprint_OID
Date: Thu, 1 May 2025 02:05:02 +0100

sprint_OID() was added as part of 2012's commit 4f73175d0375 ("X.509: Add
utility functions to render OIDs as strings") but it hasn't been used. 
Remove it.

Note that there's also 'sprint_oid' (lower case) which is used in a lot of
places; that's left as is except for fixing its case in a comment.

Link: https://lkml.kernel.org/r/20250501010502.326472-1-linux@treblig.org
Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oid_registry.h |    1 -
 lib/oid_registry.c           |   25 +------------------------
 2 files changed, 1 insertion(+), 25 deletions(-)

--- a/include/linux/oid_registry.h~lib-oid_registryc-remove-unused-sprint_oid
+++ a/include/linux/oid_registry.h
@@ -151,6 +151,5 @@ enum OID {
 extern enum OID look_up_OID(const void *data, size_t datasize);
 extern int parse_OID(const void *data, size_t datasize, enum OID *oid);
 extern int sprint_oid(const void *, size_t, char *, size_t);
-extern int sprint_OID(enum OID, char *, size_t);
 
 #endif /* _LINUX_OID_REGISTRY_H */
--- a/lib/oid_registry.c~lib-oid_registryc-remove-unused-sprint_oid
+++ a/lib/oid_registry.c
@@ -117,7 +117,7 @@ int parse_OID(const void *data, size_t d
 EXPORT_SYMBOL_GPL(parse_OID);
 
 /*
- * sprint_OID - Print an Object Identifier into a buffer
+ * sprint_oid - Print an Object Identifier into a buffer
  * @data: The encoded OID to print
  * @datasize: The size of the encoded OID
  * @buffer: The buffer to render into
@@ -173,26 +173,3 @@ bad:
 	return -EBADMSG;
 }
 EXPORT_SYMBOL_GPL(sprint_oid);
-
-/**
- * sprint_OID - Print an Object Identifier into a buffer
- * @oid: The OID to print
- * @buffer: The buffer to render into
- * @bufsize: The size of the buffer
- *
- * The OID is rendered into the buffer in "a.b.c.d" format and the number of
- * bytes is returned.
- */
-int sprint_OID(enum OID oid, char *buffer, size_t bufsize)
-{
-	int ret;
-
-	BUG_ON(oid >= OID__NR);
-
-	ret = sprint_oid(oid_data + oid_index[oid],
-			 oid_index[oid + 1] - oid_index[oid],
-			 buffer, bufsize);
-	BUG_ON(ret == -EBADMSG);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(sprint_OID);
_

Patches currently in -mm which might be from linux@treblig.org are

rapidio-remove-some-dead-defines.patch
rapidio-remove-unused-functions.patch
relay-remove-unused-relay_late_setup_files.patch
lib-oid_registryc-remove-unused-sprint_oid.patch

