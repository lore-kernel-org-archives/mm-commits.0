Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D69D4438F
	for <mm-commits@vger.kernel.org>; Mon, 29 Jan 2024 06:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706508112; cv=none; b=DrdnEpJuv0NM3cE5eqK3Oghpy2pAZGwPDcySIpToWlXttykJJuc5AoLC1IqNHbra1zwUKJp1kxoauo7ILqim0jIk0dhyl1kDpb/wUcYpaABGn3c+GCZaxv5PWos91SwMr45olSH4cJI9hP/vXIO09C/sTbmMqJZL59BtQq4JKrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706508112; c=relaxed/simple;
	bh=bKC/hA5fHmRXjT4HWKgn7EEI7Z2x/lTHqRrjE6Q+vMQ=;
	h=Date:To:From:Subject:Message-Id; b=FlUFS6uCYn9X1I1Zc1KkYfcagvjsOj1hWiQD7UQkqVmyO/nu7u7yHNvIyH9k7x8B1Qbe4r9E09ijuhOy85hg8gp4/uGOVNx2pGbmHhRCXlJz+6T4gt/IJjug3Z1EYE8VmPdI0xRypcgbDSnxhbPVzUoaMu9t/hgipoEHwWgAfMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YnDm6CO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YnDm6CO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18917C433F1;
	Mon, 29 Jan 2024 06:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706508111;
	bh=bKC/hA5fHmRXjT4HWKgn7EEI7Z2x/lTHqRrjE6Q+vMQ=;
	h=Date:To:From:Subject:From;
	b=YnDm6CO29YrHgjLJi/xxsLfj9h/5r1/5XZ8g1/72NdTStSLC/lYe9JUbd5aPLlwa2
	 MOkFhFIb+ignqtKyhtJ+7Oww1oPAbCP+Oai2ACLDMcJsPl2m/RxKTC+t0/4aWJI4CA
	 Eik1qBZ9xQvJvW5FCkJmoSEj4h1ambioawIo1hzg=
Date: Sun, 28 Jan 2024 22:01:48 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,piliu@redhat.com,klarasmodin@gmail.com,hbathini@linux.ibm.com,ebiederm@xmission.com,bhe@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch added to mm-unstable branch
Message-Id: <20240129060151.18917C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix
has been added to the -mm mm-unstable branch.  Its filename is
     kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix
Date: Sun Jan 28 10:00:15 PM PST 2024

s/CRASH_RESEERVE/CRASH_RESERVE/, per Klara Modin

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baoquan He <bhe@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Pingfan Liu <piliu@redhat.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig~kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix
+++ a/arch/x86/Kconfig
@@ -2106,7 +2106,7 @@ config ARCH_SUPPORTS_CRASH_HOTPLUG
 	def_bool y
 
 config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
-	def_bool CRASH_RESEERVE
+	def_bool CRASH_RESERVE
 
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EXPERT || CRASH_DUMP)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kexec-split-crashkernel-reservation-code-out-from-crash_corec-fix.patch
mm-memory_hotplug-export-mhp_supports_memmap_on_memory-fix.patch
kprobes-use-synchronize_rcu_tasks_rude-in-kprobe_optimizer-fix.patch

