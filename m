Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AF1383BF
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855601; cv=none; b=agmRziZid4rEKT2k93wC0gOkRPUkXkj12OUUkzVK0oedrJwhUbdb7BPQpe2n3kYJqM+UArLrWlSlXM5jKpcwNUb1tsg2NmKQsxXOvymF4HVKlKgpxpCeNG2Hlm5KqtrnS9UzHmoSwkpzdQ4jxe1mZXcwDIEZ1VidWJrsWQfXXT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855601; c=relaxed/simple;
	bh=jTsA9hNjfKHgR9Kaj7n3ACGSSksl+tIxlVJE6y2emQM=;
	h=Date:To:From:Subject:Message-Id; b=Mi2ncLCS4Uuzo9kqyKYeR6Lonz/tF5h/7a1oaJ9jGOX00MWXnf8ZXkSV9W48gIexjbQz8bFYh9OaHZUSS0jDsmYK+FeZCnVZPWp2GyiRRATAvm78vzks+nUXMoTAwADHczIKOVYzz//EKOnQOcDEvPxbdnMIZr3crEOiVnvKHwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h4ZinLb8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h4ZinLb8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67859C4CECF;
	Wed,  6 Nov 2024 01:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855601;
	bh=jTsA9hNjfKHgR9Kaj7n3ACGSSksl+tIxlVJE6y2emQM=;
	h=Date:To:From:Subject:From;
	b=h4ZinLb8+CjnXaLDMRUIPlS3LKBY29h7QP4YtroMdekVC6uhAECmuPegQQcyzwtOm
	 MGwEUcjoky6D7vj82j5UY8tK0W2uRG5odrppLGXiG6U1mx8HiRqI6D53kEDV7LbQPE
	 xKNbH4YIBHwkriSjzto2zmrdmm5+lpFBXQ6sm4Ik=
Date: Tue, 05 Nov 2024 17:13:20 -0800
To: mm-commits@vger.kernel.org,sachinpb@linux.vnet.ibm.com,mpe@ellerman.id.au,hbathini@linux.ibm.com,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kexec-crash-no-crash-update-when-kexec-in-progress.patch removed from -mm tree
Message-Id: <20241106011321.67859C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kexec/crash: no crash update when kexec in progress
has been removed from the -mm tree.  Its filename was
     kexec-crash-no-crash-update-when-kexec-in-progress.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


