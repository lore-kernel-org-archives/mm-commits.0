Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32646457E72;
	Thu, 10 Sep 2026 21:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789075664; cv=none; b=FG2+ugNobtF+XdcEIYVjS0RBGs6SebXIFX+HTOVyWRwgRT1t0pjLRqUkteZIN3Mlh73tieZQuRROlwBezPAP2dt7DdVVDn4UouliJB4WIxsC5Xfy10Q8/JId9Z3qjKhtFyfTgi3gnhI0s3SsJqln2XacrrUwX8VshzV09YNvrd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789075664; c=relaxed/simple;
	bh=dFIzst35MERHABkuU+MLX0RKDi+7ulpeKwmPqelxdK0=;
	h=Date:To:From:Subject:Message-Id; b=vCPNXq50NAv8O8zBKdN17p83VYNhcFM6khcB6vw+ymND2IDMjjluwdbc5gr4ROye/2mpCjuLSYNtAQVDO5nkHU2hKavVMPVLElSHZuaz+raxJba10FGhu1a+I1jokWSomx+9wf9vGF3tyBvMq4ZZvKEY+pKWWpjVZvYFQi4xtww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X19Ov3ud; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X19Ov3ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D6A1F000FF;
	Thu, 10 Sep 2026 21:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789075662;
	bh=SEBXreW/ftBwCyZs5fdXJFQvSLeiDtZf/AJR4XqKPAM=;
	h=Date:To:From:Subject;
	b=X19Ov3udny+3faMC2vhKIO+OPkJ2qwGtgz7cB2vcZMP49sORb+pC1u9Np2/9jiMn9
	 irFvTQxxSanZ+YqOW3frPkDCiDBSlshGPJmXGaKxVo5YzetHM1YB5gO4GID1hzv//r
	 /teDxL+kHhFg+XNcTo49PVkUf7Ed9wf83ZVuv8hA=
Date: Thu, 10 Sep 2026 14:27:42 -0700
To: mm-commits@vger.kernel.org,thomas.weissschuh@linutronix.de,stable@vger.kernel.org,sashiko-bot@kernel.org,ryan.roberts@arm.com,mark.rutland@arm.com,leitao@debian.org,ekffu200098@gmail.com,dianders@chromium.org,chenhuacai@kernel.org,brauner@kernel.org,mhiramat@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks.patch added to mm-nonmm-unstable branch
Message-Id: <20260910212742.B1D6A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/bootconfig: fix integer overflow and truncation in size checks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Subject: tools/bootconfig: fix integer overflow and truncation in size checks
Date: Fri, 11 Sep 2026 00:15:24 +0900

Sashiko reported that on 32-bit systems, if an attacker crafts size in the
bootconfig footer such that adding BOOTCONFIG_FOOTER_SIZE wraps around
(for instance, if size is 0xFFFFFFFF), the size check in
load_xbc_from_initrd() can be bypassed:

    if (stat.st_size < size + BOOTCONFIG_FOOTER_SIZE) {
        pr_err("bootconfig size is too big\n");
        return -E2BIG;
    }

Furthermore, on 64-bit systems with an initrd > 4.29 GB, comparing a
corrupted 32-bit size (e.g.  0xFFFFFFFF) against stat.st_size -
BOOTCONFIG_FOOTER_SIZE can also bypass the check if size is not bounded. 
Similarly, load_xbc_file() passes 64-bit stat.st_size directly into the
32-bit int size parameter of load_xbc_fd(), truncating large standalone
files (>= 2GB).

In both cases, passing 0xFFFFFFFF to load_xbc_fd() truncates to -1,
resulting in malloc(0), an integer overflow in read(), and an
out-of-bounds null-byte write.

Fix this by:
1. Rejecting size > XBC_DATA_MAX or
   size > stat.st_size - BOOTCONFIG_FOOTER_SIZE in load_xbc_from_initrd().
2. Rejecting stat.st_size > XBC_DATA_MAX in load_xbc_file() before passing
   it to load_xbc_fd().
3. Checking size < 0 || size > XBC_DATA_MAX defensively in load_xbc_fd().

Link: https://lore.kernel.org/178905332413.213925.3179977110281463499.stgit@devnote2
Fixes: 950313ebf79c ("tools: bootconfig: Add bootconfig command")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260909161113.16C691F00A3A@smtp.kernel.org/
Closes: https://lore.kernel.org/all/20260910010137.EE0431F000FF@smtp.kernel.org/
Assisted-by: Antigravity:gemini-3.8-flash
Reviewed-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Doug Anderson <dianders@chromium.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Marc Rutland <mark.rutland@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/bootconfig/main.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/tools/bootconfig/main.c~tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks
+++ a/tools/bootconfig/main.c
@@ -181,6 +181,9 @@ static int load_xbc_fd(int fd, char **bu
 {
 	int ret;
 
+	if (size < 0 || size > XBC_DATA_MAX)
+		return -EINVAL;
+
 	*buf = malloc(size + 1);
 	if (!*buf)
 		return -ENOMEM;
@@ -209,6 +212,13 @@ static int load_xbc_file(const char *pat
 		return ret;
 	}
 
+	if (stat.st_size > XBC_DATA_MAX) {
+		pr_err("%s size is too big\n", path);
+		ret = -E2BIG;
+		close(fd);
+		return ret;
+	}
+
 	ret = load_xbc_fd(fd, buf, stat.st_size);
 
 	close(fd);
@@ -258,7 +268,8 @@ static int load_xbc_from_initrd(int fd,
 	csum = le32toh(csum);
 
 	/* Wrong size error  */
-	if (stat.st_size < size + BOOTCONFIG_FOOTER_SIZE) {
+	if (size > XBC_DATA_MAX ||
+	    size > stat.st_size - BOOTCONFIG_FOOTER_SIZE) {
 		pr_err("bootconfig size is too big\n");
 		return -E2BIG;
 	}
_

Patches currently in -mm which might be from mhiramat@kernel.org are

bootconfig-reject-unexpected-data-after-null-character.patch
tools-bootconfig-consolidate-xbc_init-to-error-message-wrapper.patch
bootconfig-skip-internal-tree-sanity-checks-in-kernel.patch
tools-bootconfig-fix-integer-overflow-and-truncation-in-size-checks.patch
bootconfig-fix-integer-overflow-in-initrd-size-check.patch

