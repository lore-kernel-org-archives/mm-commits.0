Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052471E231E
	for <mm-commits@vger.kernel.org>; Mon,  7 Jul 2025 23:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751932749; cv=none; b=ep2izH3f/cHqgnCHpU7oJ5MN1FcJ0psze1/ixrqeOZ3gAeVuIgaT1IjxeuD6LffA3V51BPPFNAdocEH2UEAW9LW29Tz/yw54fA83qzojksEQpq9LacCWGGZILBPc4h7zuu/lcN7vqQ1Ptn3LLgSFieO42lPNp5qJgkIFYO6duUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751932749; c=relaxed/simple;
	bh=bsD1rvu0IqCggtzCVX6/2tBktfl6te+QTg6OEB3ptIo=;
	h=Date:To:From:Subject:Message-Id; b=UDwqWyqbz5pJIk5mAlokapOkGRqC6IQG5v7KuAgSbhF0B7FBkIkLm/sWSjOY6iVyqHF+N9veYWHIdDNgXmphzcFKkOVboM1VcE41iCnBYX4QWjhr4IOYGutI/XRuaEPFt7UHKR0jFEuP0MCh3hjcY0ECX3P5r4Y78qW/Y9oVYkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=skpCDCl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="skpCDCl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76312C4CEE3;
	Mon,  7 Jul 2025 23:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751932748;
	bh=bsD1rvu0IqCggtzCVX6/2tBktfl6te+QTg6OEB3ptIo=;
	h=Date:To:From:Subject:From;
	b=skpCDCl8iUb2zFCXcS2KZJKo6sFMJTf6BOPNBPxcW16YIJEL0igoHnPKRTCu/g+87
	 OzfedFSyKbNB5p0ZI1RwAft0dx1qWHY/RbqpFWOGoQWAJnB46MUc3LI+2yaVPtjMYX
	 mO+udwsIESJCKDRbGJlnCzkc06Gh0lVURSr7gIoo=
Date: Mon, 07 Jul 2025 16:59:07 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,lillian@star-ark.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + init-mainc-add-warning-when-file-specified-in-rdinit-is-inaccessible.patch added to mm-nonmm-unstable branch
Message-Id: <20250707235908.76312C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: init/main.c: add warning when file specified in rdinit is inaccessible
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     init-mainc-add-warning-when-file-specified-in-rdinit-is-inaccessible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/init-mainc-add-warning-when-file-specified-in-rdinit-is-inaccessible.patch

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

init-mainc-add-warning-when-file-specified-in-rdinit-is-inaccessible.patch

