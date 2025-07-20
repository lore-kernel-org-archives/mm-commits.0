Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF936157E6B
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977364; cv=none; b=Qb724laSYUnMqISUsqVbswf7+gNHr4soKAzD9rbsH9IslvD03rrOfPiShII4SxxjzCDe65Ts1B5M2aFkoEtIP9j7tPxj/Af11q32iXfwu0QpMF+/KWLDanpTvn4pX1pYV6F1OPUCiZl820FYxptFHGUn9bwXNXZ9Bk/QzE/nqOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977364; c=relaxed/simple;
	bh=7ANlbXGXyckBQ7T9A+r9EGZCsTJPBFLh/C11i/h++Qs=;
	h=Date:To:From:Subject:Message-Id; b=jAai6QOngj6786NfcUZciLYPfLOzHvM/f2jAeq51m7DZs6NLnxQiarLcHnVTgMj9pqgyrXD9y8/Fi0fkpAyZst5bjcBG+W7bIgaNRq4MNxDSl63yK29KQchJ+qj3oC9OO8uh2lPyqlr4/DOUu8wNpil/4ns0CE81fyAWSyKXNbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2F+aG4/M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2F+aG4/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C534CC4CEE3;
	Sun, 20 Jul 2025 02:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977363;
	bh=7ANlbXGXyckBQ7T9A+r9EGZCsTJPBFLh/C11i/h++Qs=;
	h=Date:To:From:Subject:From;
	b=2F+aG4/M8PbTtKcP3PTLk6uCMr/VonNWlOAZ/nJmxLwQMSP+QqiOtqmGOAIwCoFle
	 oU14DOOXQxQJMFHmfRIH2wsJvfz+/LTnvdH94ruve3Tue/3P2OO2NuEwlz7nh+BVgM
	 x12yKuhbvN+j9uitRgO4uBRtFN6d8MCpkIfVdqm8=
Date: Sat, 19 Jul 2025 19:09:23 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,lillian@star-ark.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] init-mainc-add-warning-when-file-specified-in-rdinit-is-inaccessible.patch removed from -mm tree
Message-Id: <20250720020923.C534CC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: init/main.c: add warning when file specified in rdinit is inaccessible
has been removed from the -mm tree.  Its filename was
     init-mainc-add-warning-when-file-specified-in-rdinit-is-inaccessible.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lillian Berry <lillian@star-ark.net>
Subject: init/main.c: add warning when file specified in rdinit is inaccessible
Date: Mon, 7 Jul 2025 09:14:11 +0000

Avoid silently ignoring the initramfs when the file specified in rdinit is
not usable.  This prints an error that clearly explains the issue (file
was not found, vs initramfs was not found).

Link: https://lkml.kernel.org/r/20250707091411.1412681-1-lillian@star-ark.net
Signed-off-by: Lillian Berry <lillian@star-ark.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/init/main.c~init-mainc-add-warning-when-file-specified-in-rdinit-is-inaccessible
+++ a/init/main.c
@@ -1592,7 +1592,11 @@ static noinline void __init kernel_init_
 	 * check if there is an early userspace init.  If yes, let it do all
 	 * the work
 	 */
-	if (init_eaccess(ramdisk_execute_command) != 0) {
+	int ramdisk_command_access;
+	ramdisk_command_access = init_eaccess(ramdisk_execute_command);
+	if (ramdisk_command_access != 0) {
+		pr_warn("check access for rdinit=%s failed: %i, ignoring\n",
+			ramdisk_execute_command, ramdisk_command_access);
 		ramdisk_execute_command = NULL;
 		prepare_namespace();
 	}
_

Patches currently in -mm which might be from lillian@star-ark.net are


