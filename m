Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EBD188598
	for <mm-commits@vger.kernel.org>; Tue, 24 Sep 2024 23:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727220505; cv=none; b=Bln/KRQHUpCl5INTvkmo+O5jNGV1qJd5WFu8r6AsTzyDw8QEXRixjkojSyeeG1TBCRXvfjsaPVMIINBh7mp8uEI2Mgvk9slwrdB9YE3Ke0taFTyKtoGYw8V/1p4s9s76TY6TAxwJqJbjbCe+cyoLrl8i9Y8Cn4V3LpgbRkLHN58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727220505; c=relaxed/simple;
	bh=Ezh8zwAi6a0ONLx9Z17Webl4oRqyPMpJu8wVjOcdH7U=;
	h=Date:To:From:Subject:Message-Id; b=vC2TyVxfhK0kJ+GOGx+lJ3UydMd5ibf8uWf9V8ACPGWWewm1bWH2ZCMO4VAuLWVQ5avbHqlw8BtqaxvNQqfCmlXAg9F0WcxiVkMbfHVXcNCVy5t5QbEPcy33EQtaiqTTkYmjIiubuCZmE/6213B3+Jugb7gm0tGUyW4391fu+Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jrR8SWWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jrR8SWWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79B9C4CEC6;
	Tue, 24 Sep 2024 23:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1727220504;
	bh=Ezh8zwAi6a0ONLx9Z17Webl4oRqyPMpJu8wVjOcdH7U=;
	h=Date:To:From:Subject:From;
	b=jrR8SWWVMHYO2bCfgtW+nGU0RkS7uAqpbjc6tYc1vt3cWublSXSmxiNxFrkl2DG1p
	 sJaxkt6CKZDAgN3FDxljyZKq1TqIHbn5Z+6x9NhEydCbOoP3QPE1JkGcSrJUQEMgcr
	 M+AH8+DC4AcJwM3qq/PpAb8H4xXKvrTmdBC+YNIM=
Date: Tue, 24 Sep 2024 16:28:24 -0700
To: mm-commits@vger.kernel.org,sachinpb@linux.vnet.ibm.com,mpe@ellerman.id.au,hbathini@linux.ibm.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-crash-no-crash-update-when-kexec-in-progress.patch added to mm-nonmm-unstable branch
Message-Id: <20240924232824.C79B9C4CEC6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec/crash: no crash update when kexec in progress
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kexec-crash-no-crash-update-when-kexec-in-progress.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-crash-no-crash-update-when-kexec-in-progress.patch

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
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: kexec/crash: no crash update when kexec in progress
Date: Sat, 21 Sep 2024 16:07:45 +0530

The following errors are observed when kexec is done with SMT=off on
powerpc.

[  358.458385] Removing IBM Power 842 compression device
[  374.795734] kexec_core: Starting new kernel
[  374.795748] kexec: Waking offline cpu 1.
[  374.875695] crash hp: kexec_trylock() failed, elfcorehdr may be inaccurate
[  374.935833] kexec: Waking offline cpu 2.
[  375.015664] crash hp: kexec_trylock() failed, elfcorehdr may be inaccurate
snip..
[  375.515823] kexec: Waking offline cpu 6.
[  375.635667] crash hp: kexec_trylock() failed, elfcorehdr may be inaccurate
[  375.695836] kexec: Waking offline cpu 7.

To avoid kexec kernel boot failure on PowerPC, all the present CPUs that
are offline are brought online during kexec.  For more information, refer
to commit e8e5c2155b00 ("powerpc/kexec: Fix orphaned offline CPUs across
kexec").  Bringing the CPUs online triggers the crash hotplug handler,
crash_handle_hotplug_event(), to update the kdump image.  Since the system
is on the kexec kernel boot path and the kexec lock is held, the
crash_handle_hotplug_event() function fails to acquire the same lock to
update the kdump image, resulting in the error messages mentioned above.

To fix this, return from crash_handle_hotplug_event() without printing the
error message if kexec is in progress.

The same applies to the crash_check_hotplug_support() function.  Return 0
if kexec is in progress because kernel is not in a position to update the
kdump image.

Link: https://lkml.kernel.org/r/20240921103745.560430-1-sourabhjain@linux.ibm.com
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Acked-by: Baoquan he <bhe@redhat.com>
Reported-by: Sachin P Bappalige <sachinpb@linux.vnet.ibm.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/crash_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/crash_core.c~kexec-crash-no-crash-update-when-kexec-in-progress
+++ a/kernel/crash_core.c
@@ -505,7 +505,8 @@ int crash_check_hotplug_support(void)
 	crash_hotplug_lock();
 	/* Obtain lock while reading crash information */
 	if (!kexec_trylock()) {
-		pr_info("kexec_trylock() failed, kdump image may be inaccurate\n");
+		if (!kexec_in_progress)
+			pr_info("kexec_trylock() failed, kdump image may be inaccurate\n");
 		crash_hotplug_unlock();
 		return 0;
 	}
@@ -547,7 +548,8 @@ static void crash_handle_hotplug_event(u
 	crash_hotplug_lock();
 	/* Obtain lock while changing crash information */
 	if (!kexec_trylock()) {
-		pr_info("kexec_trylock() failed, kdump image may be inaccurate\n");
+		if (!kexec_in_progress)
+			pr_info("kexec_trylock() failed, kdump image may be inaccurate\n");
 		crash_hotplug_unlock();
 		return;
 	}
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are

kexec-crash-no-crash-update-when-kexec-in-progress.patch

