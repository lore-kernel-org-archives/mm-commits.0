Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E5F2E8B9F
	for <mm-commits@vger.kernel.org>; Thu,  4 Sep 2025 23:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757029970; cv=none; b=mpXIbc6oIQttse4hpwp4YjRLDOvf2HCz7wmgE+gGZmqt/1Wtm6UuRn+G3DZrR8EgwvaFCQ5NqTaYyiW/ThKOimNiC7fIAaWg+M1EPOhvQwZkx/4ejVfsR0/LzId+4xb/pNxmTj5HHeM0mwyhnbwCymxh/zahxxD/FtEBc0NRQMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757029970; c=relaxed/simple;
	bh=dYgcxk+DnfKht8jSgUwgn1lT8Dw5JTg1RqV2wIuOXGA=;
	h=Date:To:From:Subject:Message-Id; b=uPnJY9quSllaLyzw6UZAEQMkZ0PTs21zfuUZAdm5WcymoziCrylU+IRpptyB2p/3KeRCcSc9PmucCdz5lp3Z6I/+Xuf7MbG8v+JZbzqUkMxVjW5PIdeeGKtWhW9g64G+XfFTwcbyz1Ka+JEcoUq6RiNINIl2yHP+FeBEN1kwjFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X9K5KMBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X9K5KMBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F07C4CEF0;
	Thu,  4 Sep 2025 23:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757029965;
	bh=dYgcxk+DnfKht8jSgUwgn1lT8Dw5JTg1RqV2wIuOXGA=;
	h=Date:To:From:Subject:From;
	b=X9K5KMBd80n2rGlN3lnet7vfnbFI4zW828MkQKfleme/isc4PQ8wUpXbt3bCqzKSi
	 GYDTJDuEdv+GlCzk4LXv1p3rmFOw7gdiTn6d1VeHy+yj6QpufqkrM97BP4pWQeaUeA
	 eVKUg4QMqAybclbRHbucRFslwWOUgevdyK5AzSHs=
Date: Thu, 04 Sep 2025 16:52:42 -0700
To: mm-commits@vger.kernel.org,rafael@kernel.org,pavel@ucw.cz,mchehab@kernel.org,len.brown@intel.com,james.bottomley@HansenPartnership.com,gregkh@linuxfoundation.org,corbet@lwn.net,rdunlap@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kernelh-add-comments-for-system_states.patch added to mm-nonmm-unstable branch
Message-Id: <20250904235245.81F07C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kernel.h: add comments for system_states
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kernelh-add-comments-for-system_states.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kernelh-add-comments-for-system_states.patch

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
From: Randy Dunlap <rdunlap@infradead.org>
Subject: kernel.h: add comments for system_states
Date: Wed, 3 Sep 2025 23:36:31 -0700

Provide some basic comments about the system_states and what they imply. 
Also convert the comments to kernel-doc format.

However, kernel-doc does not support kernel-doc notation on extern
struct/union/typedef/enum/etc.  So I made this a DOC: block so that I can
use (insert) it into a Documentation (.rst) file and have it look decent.

Link: https://lkml.kernel.org/r/20250904063631.2364995-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Rafael J. Wysocki <rafael@kernel.org>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: James Bottomley <james.bottomley@HansenPartnership.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/driver-api/pm/devices.rst |    8 ++++++++
 include/linux/kernel.h                  |   18 ++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

--- a/Documentation/driver-api/pm/devices.rst~kernelh-add-comments-for-system_states
+++ a/Documentation/driver-api/pm/devices.rst
@@ -241,6 +241,14 @@ before reactivating its class I/O queues
 More power-aware drivers might prepare the devices for triggering system wakeup
 events.
 
+System states available for drivers
+-----------------------------------
+
+These system states are available for drivers to help them determine how to
+handle state transitions.
+
+.. kernel-doc:: include/linux/kernel.h
+   :doc: General system_states available for drivers
 
 Call Sequence Guarantees
 ------------------------
--- a/include/linux/kernel.h~kernelh-add-comments-for-system_states
+++ a/include/linux/kernel.h
@@ -164,8 +164,22 @@ extern int root_mountflags;
 
 extern bool early_boot_irqs_disabled;
 
-/*
- * Values used for system_state. Ordering of the states must not be changed
+/**
+ * DOC: General system_states available for drivers
+ *
+ * enum system_states - Values used for system_state.
+ *
+ * * @SYSTEM_BOOTING:	%0, no init needed
+ * * @SYSTEM_SCHEDULING:	system is ready for scheduling; OK to use RCU
+ * * @SYSTEM_FREEING_INITMEM: system is freeing all of initmem; almost running
+ * * @SYSTEM_RUNNING:	system is up and running
+ * * @SYSTEM_HALT:	system entered clean system halt state
+ * * @SYSTEM_POWER_OFF:	system entered shutdown/clean power off state
+ * * @SYSTEM_RESTART:	system entered emergency power off or normal restart
+ * * @SYSTEM_SUSPEND:	system entered suspend or hibernate state
+ *
+ * Note:
+ * Ordering of the states must not be changed
  * as code checks for <, <=, >, >= STATE.
  */
 extern enum system_states {
_

Patches currently in -mm which might be from rdunlap@infradead.org are

listh-add-missing-kernel-doc-for-basic-macros.patch
kernelh-add-comments-for-system_states.patch

